#!/bin/bash
source /usr/local/apache2/htdocs/lib/shared.sh

print_header


echo """<html>
<head>
<title>Hello World</title>
<style>
body { display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
h1 { font-family: Arial, sans-serif; }
</style>
</head>
<body>
<h1>Hello World</h1>
</body>
</html>"""

