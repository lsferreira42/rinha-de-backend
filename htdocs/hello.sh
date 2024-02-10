#!/bin/bash
source /usr/local/apache2/htdocs/lib/shared.sh

print_header


echo """<html>
<head>
<title>Hello World</title>
<style>
body { display: flex; flex-direction: column; justify-content: center; align-items: center; height: 100vh; margin: 0; }
h1, p, a { font-family: Arial, sans-serif; text-align: center;  margin: 0; }
a { text-decoration: none; color: inherit; }
p { margin-top: 20px; }
</style>
</head>
<body>
<h1>Rinha de Backend 2024</h1>
<a href="https://github.com/lsferreira42/">
<p>Por Leandro Ferreira</p>
</a>
</body>
</html>
"""

