<html>

<script type="text/javascript" src="../js/MathJax/MathJax.js?config=default"></script>
<!--
<h3>Weighted matching problem</h3>

Given a set of N points along with the distances between each pair of points, find an optimal pairing of the points such that the total length of the distances of the pairs is minimum.<br>

<h3>Example:</h3> 
Consider N=4 points as shown in Fig.1a. The distances between each pair of points is given in Fig.1b.

<table>
<tr>
<td><img width=250 src="figures/prob.png"></td>
<td><img width=250 src="figures/wgraph.png"></td>
</tr>
<tr>
<td align=center>Fig.1a</td>
<td align=center>Fig.1b</td>
</tr>
</table>

The various possible pairing of points are given in Figs.2a to 2c. 
<table>
<tr>
<td><img width=250 src="figures/sol1.png"></td>
<td><img width=250 src="figures/sol2.png"></td>
<td><img width=250 src="figures/sol3.png"></td>
</tr>
<tr>
<td align=center>Fig.2a: L=7.2 </td>
<td align=center>Fig.2b: L=12.8 </td>
<td align=center>Fig.2c: L=14.6 </td>
</tr>
</table>
The total length of the paired links (\( L=\sum\limits_{i\lt j}d_{ij}n_{ij} \)) are 7.2, 12.8 and 14.6, respectively. <br>
<font color=#FF0000>Therefore, Fig.2a is the solution to the weighted matching problem</font>.
-->
<h3>Solution to weighted matching problem using a Hopfield model</h3>

<ul>
<li><a href=weightedmatching_det.php>Deterministic relaxation</a></li><br>
<li><a href=weightedmatching_sto.php>Stochastic relaxation</li><br>
<li><a href=weightedmatching_mean.php>Mean-field relaxation</li><br>
</ul>

</html>
