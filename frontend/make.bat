if not exist bin mkdir bin 

elm-make src\Main.elm --output bin\main.js

copy *.css bin
copy *.js bin
copy index-dist.html bin\index.html