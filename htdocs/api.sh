#!/bin/bash
source /usr/local/apache2/htdocs/lib/shared.sh

METHOD=$REQUEST_METHOD
URI=$REQUEST_URI

ID_CLIENTE=$(echo $URI | cut -d'/' -f3)


if [[ "$METHOD" == "POST" && "$URI" =~ ^/clientes/([1-5])/transacoes$ ]]; then
    #Pega o body da requisicao
    if [ ! -z "$CONTENT_LENGTH" ]; then
        read -n "$CONTENT_LENGTH" REQUEST_BODY
    fi

    tipo=$(echo $REQUEST_BODY | jq -r .tipo)
    valor=$(echo $REQUEST_BODY | jq -r .valor)
    descricao=$(echo $REQUEST_BODY | jq -r .descricao)
    data=$(date +"%Y-%m-%dT%H:%M:%S.%6NZ")

    if [ "$tipo" = "d" ]; then
        ts=$(sqlite3 $DATABASE_PATH "SELECT saldo, limite FROM clientes WHERE id = $ID_CLIENTE;")
        saldo=$(echo $ts | cut -d'|' -f1)
        limite=$(echo $ts | cut -d'|' -f2)
        novo_saldo=$((saldo - valor))

        if [ "$novo_saldo" -lt "$((-limite))" ]; then
            print_header 422
            exit 0
        fi

        sqlite3 $DATABASE_PATH  "UPDATE clientes SET saldo = $novo_saldo WHERE id = $ID_CLIENTE;"
        sqlite3 $DATABASE_PATH  "INSERT INTO transacoes (cliente_id, tipo, valor, descricao, realizada_em) VALUES ($ID_CLIENTE, '$tipo', $valor, '$descricao', '$data');"

        print_header
        echo "{\"limite\": $limite, \"saldo\": $novo_saldo}"
    elif [ "$tipo" = "c" ]; then
        ts=$(sqlite3 $DATABASE_PATH "SELECT saldo, limite FROM clientes WHERE id = $ID_CLIENTE;")
        saldo=$(echo $ts | cut -d'|' -f1)
        limite=$(echo $ts | cut -d'|' -f2)
        novo_saldo=$((saldo + valor))
        sqlite3 $DATABASE_PATH  "UPDATE clientes SET saldo = $novo_saldo WHERE id = $ID_CLIENTE;"
        sqlite3 $DATABASE_PATH  "INSERT INTO transacoes (cliente_id, tipo, valor, descricao, realizada_em) VALUES ($ID_CLIENTE, '$tipo', $valor, '$descricao', '$data');"

        print_header
        echo "{\"limite\": $limite, \"saldo\": $novo_saldo}"
    fi

elif [[ "$METHOD" == "GET" && "$URI" =~ ^/clientes/([1-5])/extrato$ ]]; then
    print_header
    sqlite3 $DATABASE_PATH -separator "|" "SELECT id, cliente_id, valor, tipo, descricao, realizada_em FROM transacoes WHERE cliente_id = $ID_CLIENTE;" | \
    jq -R -s -c 'split("\n") | map(select(length > 0) | split("|") | {id: .[0], cliente_id: .[1], valor: .[2] | tonumber, tipo: .[3], descricao: .[4], realizada_em: .[5]}) | {transacoes: .}'

else
    print_header 404
    echo "URL incorreta, metodo incorreto ou cliente inexistente"
fi
