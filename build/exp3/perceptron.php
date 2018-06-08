<html>
<?php 
session_start();

$sessionID = session_id();
/*if (empty($_SESSION['count'])) {
           $_SESSION['count'] = 1;
	   } else {
	            $_SESSION['count']++;
		    }
*/
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

$probtype_arr = array(1=>"Linearly separable",2=>"Linearly inseparable");

// $NUM_OF_IMAGES = 4;
$probtype = $_POST["probtype"];
 $Nsamples= $_POST["Nsamples"];
// $Nnodes = $_POST["Nnodes"];
 $Niterns = $_POST["Niterns"];
 $Nsamplestep = $_POST["Nsamplestep"];
 $NIstep = $_POST["NIstep"];

$sampleflag = $_POST["sample"];
$iternflag = $_POST["itern"];

if($Nsamples=='') $Nsamples=20;
//if($Nnodes=='') $Nnodes=40;
if($Niterns=='') $Niterns=20;
if($Nsamplestep=='') $Nsamplestep=1;
if($NIstep=='') $NIstep=1;
if($probtype=='') $probtype=1;

if($sampleflag=='') $sampleflag=0;
if($iternflag=='') $iternflag=0;

function showOptionsDrop($array,$value){
//       global $numberOfBits;
       $string = '';
       foreach($array as $k => $v){
	       $string .= '<option value="'.$k.'" ';
	       if($k == $value)
		       $string = $string.'selected=selected ';
	       $string = $string .'>'.$v.'</option>'."\n";
       }
      return $string;
}

exec("mkdir -p tmp/$sessionID");

//cmd="octave --eval 'mysom(".$cityflag.",".$iternflag.");quit;' 1> tmp/log.txt 2>&1 ";
$cmd="cd tmp/$sessionID; octave --eval 'addpath ../../ ;coreMlp(".$Nsamples.",".$Niterns.",".$sampleflag.",".$iternflag.",".$Nsamplestep.",".$NIstep.",".$probtype.");cd ../../ ; quit;' 1> log.txt 2>&1 ";
//echo $cmd;
$out=exec($cmd,$results,$status);

//echo $out;
//echo $status;
//echo $_SERVER['PHP_SELF']."<br>";

function initmlp(){
$cmd="octave --eval 'addpath ../../ ;coreMlp(".$Nsamples.",".$Niterns.",0,0,".$Nsamplestep.",".$NIstep.",".$probtype.");cd ../../ ;quit;' 1> tmp/log.txt 2>&1 ";
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

<h2> Illustration of perceptron learning</h2>

<b>Problem type</b>
<select name="probtype">
    <option value="0">Select problem type</option>
    <?php echo showOptionsDrop($probtype_arr,$probtype); ?>
</select>

<table>
<tr><td>No. of samples per class:</td><td> <input type="text" size=5 name=Nsamples value=<?php echo $Nsamples;?> ></td>
<td>No. of iterations:</td><td> <input type="text" size=5 name=Niterns value=<?php echo $Niterns;?> ></td></tr>
<tr><td>Sample Step Size:</td><td> <input type="text" size=5 name=Nsamplestep value=<?php echo $Nsamplestep;?> ></td>
<td>Iteration Step Size:</td><td> <input type="text" size=5 name=NIstep value=<?php echo $NIstep;?> > </td></tr>
</table>


<button type="submit" name="initmlp" value="Init perceptron">Init perceptron</button>
<button type="submit" name="nextsample" value="Next sample" onclick=document.myform.sample.value=1; >Next sample</button>
<button type="submit" name="nextitern" value="Next Iteration"  onclick=document.myform.itern.value=1; >Next Iteration</button>

<br>
<input type="hidden" name="sample" value=0 >
<input type="hidden" name="itern" value=0 >

<font size=-1>
<ol>
<li>Samples of class 1 and class 2 are shown in blue and red, respectively.</li>
<li>The line described by weights of the perceptron is shown in black. </li>
<li>The sample point presented to the perceptron is shown by a black star symbol. </li>
<li>The lines described by weights, before and after a sample is presented to the perceptron, are shown in the two subplots. </li>
</ol>

<input type="image" name="curimage" id='curimage' width=700 src=<?php echo "'tmp/$sessionID/mlpState.png'"?>> <br><br>

</form>

</html>
