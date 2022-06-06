import compilerTools.Token;

%%
%class Lexer
%type Token
%line
%column
%{
    private Token token(String lexeme, String lexicalComp, int line, int column){
        return new Token(lexeme, lexicalComp, line+1, column+1);
    }
%}
/* Variables básicas de comentarios y espacios */
TerminadorDeLinea = \r|\n|\r\n
EntradaDeCaracter = [^\r\n]
EspacioEnBlanco = {TerminadorDeLinea} | [ \t\f]
ComentarioTradicional = "/*" [^*] ~"*/" | "/*" "*"+ "/"
FinDeLineaComentario = "//" {EntradaDeCaracter}* {TerminadorDeLinea}?
ContenidoComentario = ( [^*] | \*+ [^/*] )*
ComentarioDeDocumentacion = "/**" {ContenidoComentario} "*"+ "/"

/* Comentario */
Comentario = {ComentarioTradicional} | {FinDeLineaComentario} | {ComentarioDeDocumentacion}

/* Identificador */
Letra = [A-Za-zÑñ_ÁÉÍÓÚáéíóúÜü]
Digito = [0-9]
Identificador = {Letra}({Letra}|{Digito})*

/* Número */
Numero = 0 | [1-9][0-9]*
%%
/* Comentarios o espacios en blanco */
{Comentario}|{EspacioEnBlanco} { /*Ignorar*/ }


/* PALABRAS RESERVADAS */
select | SELECT {return token(yytext(), "VERBO", yyline, yycolumn);}
from | FROM {return token(yytext(), "CLAUSULA", yyline, yycolumn);}
where | WHERE {return token(yytext(),"PALABRA_RESERVADA", yyline, yycolumn);}
"," {return token(yytext(),"COMA", yyline, yycolumn);}
"=" {return token(yytext(),"SIGNO_IGUAL", yyline, yycolumn);}
"." {return token(yytext(),"PUNTO", yyline, yycolumn);}
"*" {return token(yytext(),"TODO", yyline, yycolumn);}
{Numero} {return token(yytext(), "NUMERO", yyline, yycolumn);}

/* Identificadores */
{Identificador} {return token(yytext(), "IDENTIFICADOR", yyline, yycolumn);}


. { return token(yytext(), "ERROR", yyline, yycolumn); }

