#!/bin/bash
source /usr/local/apache2/htdocs/lib/shared.sh

METHOD=$REQUEST_METHOD
URI=$REQUEST_URI

ID_CLIENTE=$(echo $URI | cut -d'/' -f3)

execute_sql() {
    local SQL="$1"
    echo "$SQL" | sqlite3 $DATABASE_PATH
}

if [[ "$METHOD" == "POST" && "$URI" =~ ^/clientes/([1-5])/transacoes$ ]]; then
    if [ ! -z "$CONTENT_LENGTH" ]; then
        read -n "$CONTENT_LENGTH" REQUEST_BODY
    fi

    tipo=$(echo $REQUEST_BODY | jq -r .tipo)
    valor=$(echo $REQUEST_BODY | jq -r .valor)
    descricao=$(echo $REQUEST_BODY | jq -r .descricao)
    data=$(date +"%Y-%m-%dT%H:%M:%S.%6NZ")

    IFS='|' read saldo limite <<< $(execute_sql "SELECT saldo, limite FROM clientes WHERE id = $ID_CLIENTE;")


    TRANSACTION_SQL="BEGIN TRANSACTION;"
    if [ "$tipo" = "d" ]; then
        novo_saldo=$((saldo - valor))
        if [ "$novo_saldo" -lt "$((-limite))" ]; then
            print_header 422
            echo "{\"error\": \"Insufficient funds\"}"
            exit 0
        fi
        TRANSACTION_SQL+="UPDATE clientes SET saldo = $novo_saldo WHERE id = $ID_CLIENTE;"
    elif [ "$tipo" = "c" ]; then
        novo_saldo=$((saldo + valor))
        TRANSACTION_SQL+="UPDATE clientes SET saldo = $novo_saldo WHERE id = $ID_CLIENTE;"
    fi
    TRANSACTION_SQL+="INSERT INTO transacoes (cliente_id, tipo, valor, descricao, realizada_em) VALUES ($ID_CLIENTE, '$tipo', $valor, '$descricao', '$data'); COMMIT;"

    execute_sql "$TRANSACTION_SQL"

    print_header
    echo "{\"limite\": $limite, \"saldo\": $novo_saldo}"
elif [[ "$METHOD" == "GET" && "$URI" =~ ^/clientes/([1-5])/extrato$ ]]; then
    print_header
    IFS='|' read saldo limite <<< $(execute_sql "SELECT saldo, limite FROM clientes WHERE id = $ID_CLIENTE;")
    data_extrato=$(date +"%Y-%m-%dT%H:%M:%S.%6NZ")
    RESULT=$(execute_sql "SELECT id, cliente_id, valor, tipo, descricao, realizada_em FROM transacoes WHERE cliente_id = $ID_CLIENTE;" | jq -R -s -c 'split("\n") | map(select(length > 0) | split("|") | {id: .[0], cliente_id: .[1], valor: .[2] | tonumber, tipo: .[3], descricao: .[4], realizada_em: .[5]}) | {ultimas_transacoes: .}')
    FINAL_JSON=$(jq -n --argjson transacoes "$RESULT" --arg saldo "$saldo" --arg limite "$limite" --arg data_extrato "$data_extrato" \
    '{
        saldo: {total: ($saldo | tonumber), data_extrato: $data_extrato, limite: ($limite | tonumber)},
        ultimas_transacoes: $transacoes.ultimas_transacoes
    }')

    echo $FINAL_JSON
else
    print_header 404
    echo "URL incorreta, metodo incorreto ou cliente inexistente"
fi
