<html>
<?php 
// $NUM_OF_IMAGES = 4;
 $Ncities = $_POST["Ncities"];
 $Nnodes = $_POST["Nnodes"];
 $Niterns = $_POST["Niterns"];
 $NCstep = $_POST["NCstep"];
 $NIstep = $_POST["NIstep"];

$cityflag = $_POST["city"];
$iternflag = $_POST["itern"];

if($Ncities=='') $Ncities=20;
if($Nnodes=='') $Nnodes=40;
if($Niterns=='') $Niterns=20;
if($NCstep=='') $NCstep=1;
if($NIstep=='') $NIstep=1;

if($cityflag=='') $cityflag=0;
if($iternflag=='') $iternflag=0;

/*
echo "No. of Cities = ".$Ncities."<br>";
echo "No. of Nodes = ".$Nnodes."<br>";
echo "No. of Iterns = ".$Niterns."<br>";
echo "City Step Size = ".$NCstep."<br>";
echo "Itern Step Size = ".$NIstep."<br>";
echo "<br>";
echo "City flag = ".$cityflag."<br>";
echo "Itern flag = ".$iternflag."<br>";
*/

//$cmd="octave --eval 'mysom(".$cityflag.",".$iternflag.");quit;' 1> tmp/log.txt 2>&1 ";
$cmd="octave --eval 'coreSom(".$Ncities.",".$Nnodes.",".$Niterns.",".$cityflag.",".$iternflag.",".$NCstep.",".$NIstep.");quit;' 1> tmp/log.txt 2>&1 ";
//echo $cmd;
$out=exec($cmd,$results,$status);

//echo $out;
//echo $status;
//echo $_SERVER['PHP_SELF']."<br>";

function initsom(){
$cmd="octave --eval 'coreSom(".$Ncities.",".$Nnodes.",".$Niterns.",0,0,".$NCstep.",".$NIstep.");quit;' 1> tmp/log.txt 2>&1 ";
$out=exec($cmd,$results,$status);

}

?>

<!--
<script type="text/javascript">
//var interval = 1; // in seconds

setInterval("refreshimage()",500);

function refreshimage(){
 var i = new Image();
 i.src = "tmp/a.jpg";
 document.getElementById('curimage').src = i.src;
 clearInterval(t);
}
</script>
-->

<form name="myform" action="<?php echo $_SERVER['PHP_SELF'];?>" method="post">

<h1> Traveling Salesman Problem</h1>

No. of Cities: <input type="text" name=Ncities value=<?php echo $Ncities;?> > <br>
No. of Nodes: <input type="text" name=Nnodes value=<?php echo $Nnodes;?> > <br>
No. of Iterations: <input type="text" name=Niterns value=<?php echo $Niterns;?> > <br>
City Step Size: <input type="text" name=NCstep value=<?php echo $NCstep;?> > <br>
Itern Step Size: <input type="text" name=NIstep value=<?php echo $NIstep;?> > <br>

<button type="submit" name="initsom" value="Init SOM" onclick=<?php initsom();?> >Init SOM</button>
<button type="submit" name="nextcity" value="Next City" onclick=document.myform.city.value=1; >Next City</button>
<button type="submit" name="nextitern" value="Next Itern"  onclick=document.myform.itern.value=1; >Next Itern</button>

<br><br>
<input type="hidden" name="city" value=0 >
<input type="hidden" name="itern" value=0 >



<input type="image" name="curimage" id='curimage' width=800 src="tmp/somState.png"> <br><br>

</form>

</html>
