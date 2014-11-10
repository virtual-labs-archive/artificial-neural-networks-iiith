<html>
<?php

session_start();
$sessionID = session_id();

if (empty($_SESSION['count'])) {
	$_SESSION['count'] = 1;
}
else {
	$_SESSION['count']++;
}

$inactive = 600;
$session_inactive_flag = 0;
// check to see if $_SESSION['timeout'] is set
if(isset($_SESSION['timeout']) ) {
	$session_life = time() - $_SESSION['timeout'];
	if($session_life > $inactive)
	{
		exec("rm -rf tmp/$sessionID");
		session_unset();
		session_destroy();
		$session_inactive_flag = 1;
	}
}
$_SESSION['timeout'] = time();

//echo "Pageviews=". $_SESSION['count'];

//echo "<br>Session ID = $sessionID</br>";
//echo "Inactive = $session_inactive_flag";

 $Nnodes= $_POST["Nnodes"];
 $Nedges = $_POST["Nedges"];
 $edgestring = $_POST["edgestring"];
 $alpha = $_POST["alpha"];
 $deltaT = $_POST["deltaT"];
 $initflag = $_POST["initflag"];
 $annealflag = $_POST["annealflag"];
 $graph = $_POST["graph"];

/*
echo $Nnodes.'<br>';
echo $Nedges.'<br>';
echo $edgestring.'<br>';
echo $alpha.'<br>';
echo $deltaT.'<br>';
echo $initflag.'<br>';
echo $annealflag.'<br>';
echo $graph.'<br>';
*/

if($Nnodes=='') {$Nnodes=4;}
if($Nedges=='') $Nedges=4;
if($edgestring=='') $edgestring='[1 2; 1 3; 2 3; 3 4;]';
if($alpha=='') $alpha=0.4;
if($deltaT=='') $deltaT=0.1;
if($initflag=='') {$initflag=0;}
if($annealflag=='') {$annealflag=0;}
if($graph=='') $graph='g4';

function InitGraph(){
global $Nnodes, $edgestring, $sessionID;

$out=exec("rm -f tmp/$sessionID/input.png tmp/$sessionID/output.png");
//exec("mkdir -p tmp/$sessionID");
$cmd="cd tmp/$sessionID; octave --eval 'addpath ../../ ;initgraph(".$Nnodes.",".$edgestring.");cd ../../ ;quit;' 1> log.txt 2>&1 ";
//sleep(1);
$out=exec($cmd,$results,$status);
//echo $cmd.':'.$out.':'.$result.':'.$status;
}

function StartAnnealing(){
global $Nnodes, $edgestring, $alpha, $deltaT, $sessionID;

$cmd="cd tmp/$sessionID; octave --eval 'addpath ../../ ;startannealing(".$Nnodes.",".$edgestring.",".$alpha.",".$deltaT.");cd ../../ ;quit;' 1> log.txt 2>&1 ";
$out=exec($cmd,$results,$status);
//echo $cmd.':'.$out.':'.$result.':'.$status;
}

?>

<script type="text/javascript">

function jsinit(){
	document.myform.initflag.value=1;
	//alert("I am here " + document.myform.graph.value);
}

function jsanneal(){
	document.myform.annealflag.value=1;
	document.myform.output.style.visibility='visible';
	//document.myform.currimage.src = 'images/g8bp.png';
}

function jsreset(){
	document.myform.initflag.value=0;
	document.myform.annealflag.value=0;
}

function jschangegraph(){
switch (document.myform.graph.value){
	case "new":
		document.myform.Nnodes.removeAttribute('readonly');
		document.myform.Nedges.removeAttribute('readonly');
		document.myform.edgestring.removeAttribute('readonly');
		document.myform.Nnodes.value='';
		document.myform.Nedges.value='';
		document.myform.edgestring.value='';
		break;
	case "g4": 
		document.myform.Nnodes.setAttribute('readonly','readonly');
		document.myform.Nedges.setAttribute('readonly','readonly');
		document.myform.edgestring.setAttribute('readonly','readonly');
		document.myform.Nnodes.value=4;
		document.myform.Nedges.value=4;
		document.myform.edgestring.value='[1 2; 1 3; 2 3; 3 4;]';
		break;
	case "g6":
		document.myform.Nnodes.setAttribute('readonly','readonly');
		document.myform.Nedges.setAttribute('readonly','readonly');
		document.myform.edgestring.setAttribute('readonly','readonly');
		document.myform.Nnodes.value=6;
		document.myform.Nedges.value=9;
		document.myform.edgestring.value='[1 2; 1 3; 2 3; 2 5; 3 4; 3 5; 3 6; 4 5; 5 6;]';
		break;
	case "g12":
		document.myform.Nnodes.setAttribute('readonly','readonly');
		document.myform.Nedges.setAttribute('readonly','readonly');
		document.myform.edgestring.setAttribute('readonly','readonly');
		document.myform.Nnodes.value=12;
		document.myform.Nedges.value=18;
		document.myform.edgestring.value='[1 2;1 3;2 3;3 4;4 5;3 6;5 6;2 7;6 7;2 8;7 8;2 9;8 10;9 10;8 11;10 11;7 12;11 12;]';
		break;
	case "g14":
		document.myform.Nnodes.setAttribute('readonly','readonly');
		document.myform.Nedges.setAttribute('readonly','readonly');
		document.myform.edgestring.setAttribute('readonly','readonly');
		document.myform.Nnodes.value=14;
		document.myform.Nedges.value=22;
		document.myform.edgestring.value='[1 2;2 3;2 4;3 4;1 5;4 5;1 6;5 7;6 7;4 8;7 8;3 9;8 9;3 10;9 10;3 11;10 12;11 12;10 13;12 13;9 14;13 14;]';
		break;
	case "g16":
		document.myform.Nnodes.setAttribute('readonly','readonly');
		document.myform.Nedges.setAttribute('readonly','readonly');
		document.myform.edgestring.setAttribute('readonly','readonly');
		document.myform.Nnodes.value=16;
		document.myform.Nedges.value=27;
		document.myform.edgestring.value='[1 2;2 3;2 4;3 4;1 5;4 5;1 6;5 7;6 7;4 8;7 8;3 9;8 9;3 10;9 10;3 11;10 12;11 12;10 13;12 13;9 14;13 14;7 15;8 15;14 15;7 16;15 16;]';
		break;
	}
}

</script>

<form name="myform" action="<?php echo $_SERVER['PHP_SELF'];?>" method="post">

<h3> Graph bipartition problem</h3>

<table>
<tr><td width=200>Select a graph:</td><td>
<select name=graph onchange="jschangegraph();" >
  <option value="g4" <?php if($graph=='g4') echo 'selected=selected';?> >Sample graph 1: 4 nodes</option>
  <option value="g6"  <?php if($graph=='g6') echo 'selected=selected';?> >Sample graph 2: 6 nodes</option>
<!--
  <option value="g8">Sample graph 3: 8 nodes</option>
  <option value="g10">Sample graph 4: 10 nodes</option>
  <option value="g12">Sample graph 5: 12 nodes</option>
  <option value="g14">Sample graph 6: 14 nodes</option>
-->
  <option value="g12" <?php if($graph=='g12') echo 'selected=selected';?>>Sample graph 5: 12 nodes</option>
  <option value="g14" <?php if($graph=='g14') echo 'selected=selected';?>>Sample graph 6: 14 nodes</option>
  <option value="g16" <?php if($graph=='g16') echo 'selected=selected';?>>Sample graph 7: 16 nodes</option>
  <option value="new" <?php if($graph=='new') echo 'selected=selected';?>>Create your own graph</option>
</select>
</td></tr>
<tr><td>No. of nodes:</td>
<td><input type=text name=Nnodes readonly value="<?php echo $Nnodes;?>"></td></tr>

<tr><td>No. of edges:</td>
<td><input type=text name=Nedges readonly value= "<?php echo $Nedges;?>"></td></tr>

<tr><td>Edges:</td>
<td><input type=text size=80 name=edgestring readonly value="<?php echo $edgestring;?>"></td></tr>

<tr><td>Alpha:</td>
<td> <input type=text name=alpha value='<?php echo $alpha; ?>'></td></tr>
<tr><td>DeltaT:</td>
<td> <input type=text name=deltaT value='<?php echo $deltaT ?>'></td></tr>

</table>
<input type=submit value="Init" onclick="jsinit();">
<input type=submit value='Reset' onclick='jsreset();'>
<!--
<input type=hidden name=Anneal value="Anneal" onclick='jsanneal();'>
<br>

<table><tr>
<td><img name=input width=400 src=tmp/input.png style="visibility:hidden"></td>
<td><img name=output width=400 src=tmp/output.png style="visibility:hidden"></td>
-->
</tr></table>

<?php
//echo $initflag . ' ' . $annealflag;

if($initflag | $annealflag){
//	echo "<input type=submit name=Anneal value=Anneal onclick='jsanneal();'>";
//	echo '<table><tr align=center><td>';
//	echo 'Input graph<br>';
//	echo "<img name=inputimage id=inputimage width=500 src=tmp/$sessionID/input.png >";
	if($initflag){
		exec("mkdir -p tmp/$sessionID");
		echo "<input type=submit name=Anneal value=Anneal onclick='jsanneal();'>";
		echo '<table><tr align=center><td>';
		echo 'Input graph<br>';
		echo "<img name=inputimage id=inputimage width=500 src=tmp/$sessionID/input.png >";
		InitGraph();
	}
	if($annealflag){
		echo "<input type=submit name=Anneal value=Anneal onclick='jsanneal();'>";
		echo '<table><tr align=center><td>';
		echo 'Input graph<br>';
		echo "<img name=inputimage id=inputimage width=500 src=tmp/$sessionID/input.png >";
		StartAnnealing();
		echo '<td>';
		echo 'Bipartitioned graph<br>';
		echo "<img name=outputimage id=outputimage width=500 src=tmp/$sessionID/output.png >";
		echo '</td>';
	}
	echo '</td></tr></table>';
	echo '<br><br>';
}

?>

<input type="hidden" name="initflag" value=0>
<input type="hidden" name="annealflag" value=0>

</form>

</html>
