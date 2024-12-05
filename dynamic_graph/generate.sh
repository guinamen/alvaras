#!/bin/bash


echo "graph {"
echo 'graph ['
echo 'overlap = false'
echo 'outputorder = edgesfirst'
echo  'splines=true'
echo  ']'

#echo '{'
#echo 'Q[label="Q", pos="9.555728057861407,2.947551744109042!", shape = "box"];'
#echo 'R[label="R", pos="8.262387743159948,5.63320058063622!", shape = "box"];'
#echo 'S[label="S", pos="6.2348980185873355,7.818314824680298!", shape = "box"];'
#echo 'T[label="T", pos="3.65341024366395,9.308737486442043!", shape = "box"];'
#echo 'U[label="U", pos="0.7473009358642417,9.972037971811801!", shape = "box"];'
#echo 'A[label="A", pos="-2.2252093395631434,9.749279121818237!", shape = "box"];'
#echo 'B[label="B", pos="-5.000000000000002,8.660254037844386!", shape = "box"];'
#echo 'C[label="C", pos="-7.330518718298263,6.801727377709193!", shape = "box"];'
#echo 'D[label="D", pos="-9.00968867902419,4.338837391175582!", shape = "box"];'
#echo 'E[label="E", pos="-9.888308262251286,1.4904226617617429!", shape = "box"];'
#echo 'F[label="F", pos="-9.888308262251286,-1.4904226617617446!", shape = "box"];'
#echo 'G[label="G", pos="-9.009688679024192,-4.33883739117558!", shape = "box"];'
#echo 'H[label="H", pos="-7.330518718298262,-6.801727377709195!", shape = "box"];'
#echo 'I[label="I", pos="-4.9999999999999964,-8.660254037844389!", shape = "box"];'
#echo 'J[label="J", pos="-2.225209339563146,-9.749279121818237!", shape = "box"];'
#echo 'K[label="K", pos="0.7473009358642436,-9.972037971811801!", shape = "box"];'
#echo 'L[label="L", pos="3.653410243663954,-9.308737486442041!", shape = "box"];'
#echo 'M[label="M", pos="6.234898018587334,-7.818314824680299!", shape = "box"];'
#echo 'N[label="N", pos="8.262387743159948,-5.6332005806362195!", shape = "box"];'
#echo 'O[label="O", pos="9.555728057861408,-2.9475517441090386!", shape = "box"];'
#echo 'P[label="P", pos="10.0,-2.4492935982947065e-15!", shape = "box"];'
#echo '}'

while IFS= read -r line
do
	IFS='|'
	read -ra arrIN <<< "$line"
	echo "  ${arrIN[0]}--${arrIN[1]} [label="${arrIN[2]}"];"

done < <(echo "select no1, no2, total from secao where ano_mes = '$1';" | sqlite3 graph.db)

echo "}"
