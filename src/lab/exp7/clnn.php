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


/*$dimen_arr = array(1=>"1",2=>"2");*/
//$map_arr = array(1=>"2D-2D",2=>"2D-1D");
$map_arr = array(1=>"2D-2D");
/*$pdf_arr = array(1=>"Uniform pdf",2=>"Gaussian");*/
$region_arr = array(1=>"Square",2=>"Circle",3=>"Triangle");
$numDataPoints_arr = array(100=>"100",300=>"300",1000=>"1000");
$numIterations_arr = array(20=>"20",50=>"50",100=>"100");

$typeOfMapping = $_POST["mapping"];
/*$pdfType = $_POST["distribution"];*/
$regionType = $_POST["region"];
$numDataPoints = $_POST["numDataPoints"];
$numIterations= $_POST["numIterations"];
$NIstep = $_POST["NIstep"];
$genflag = $_POST["genflag"];
$iternflag = $_POST["iternflag"];

/*
echo $typeOfMapping;
echo $regionType;
echo $numDataPoints;
echo $numIterations;
echo $NIstep;
echo $genflag;
echo $iternflag;
*/

if($typeOfMapping == 0) $typeOfMapping = 1; /*0 or 1 -> 2D-2D*/
/*if($pdfType == 0) $pdfType  = 1;*/
if($regionType == 0) $regionType = 1;
if($numIterations == 0) $numIterations = 20;
if($numDataPoints == 0) $numDataPoints = 100;
if($NIstep=='') $NIstep=1;

if($typeOfMapping == 1) /* 0 or 1 -> 2D-2D, 2 -> 2D-1D */
{
	$inputDim = 2;
	$outputDim = 2;
}

if($typeOfMapping == 2) /* 2 -> 2D-1D */
{
	$inputDim = 2;
	$outputDim = 1;
}



function showOptionsDrop($array){
        $string = '';
        foreach($array as $k => $v){
            $string .= '<option value="'.$k.'"'.$s.'>'.$v.'</option>'."\n";
        }
        return $string;
    }

function generateData(){
global $inputDim, $numDataPoints, $regionType, $numIterations, $sessionID;
$cmd="cd tmp/$sessionID; octave --eval 'addpath ../../ ; generateData(".$inputDim.",".$numDataPoints.",".$regionType.", ".$numIterations.");cd ../../ ; quit;' 1> log.txt 2>&1 ";

$out=exec($cmd,$results,$status);
}

function nextIteration(){
global $NIstep,$sessionID;
$cmd="cd tmp/$sessionID; octave --eval 'addpath ../../ ; clnnMappingCore(".$NIstep.");cd ../../ ; quit;' 1> log.txt 2>&1 ";

$out=exec($cmd,$results,$status);
}

if($genflag == 1){
	exec("mkdir -p tmp/$sessionID");
	generateData();
}

if($iternflag==1){
	nextIteration();
}

?>

<script type="text/javascript">
function jssetgenflag(){
	document.myform.genflag.value=1;
}
function jssetiternflag(){
	document.myform.iternflag.value=1;
}


</script>


<form name="myform" action="<?php echo $_SERVER['PHP_SELF'];?>" method="post">

<h3> Illustration of feature mapping using CLNN </h3>

<!--<h2> Type of mapping </h2> -->

<select name="mapping">
    <option value="0">Type of mapping</option>
    <?php echo showOptionsDrop($map_arr); ?>
</select>


<select name="region">
    <option value="0">Region</option>
    <?php echo showOptionsDrop($region_arr); ?>
</select>

<select name="numDataPoints">
    <option value="0">Number of data points</option>
    <?php echo showOptionsDrop($numDataPoints_arr); ?>
</select>

<select name="numIterations">
    <option value="0">Number of iterations</option>
    <?php echo showOptionsDrop($numIterations_arr); ?>
</select>

<button type="submit" name="generateData" value="Generate data" onclick="jssetgenflag();" >Generate data</button>

 <br><br>

Iteration step size: <input type="text" name=NIstep value=<?php echo $NIstep;?> >

<button type="submit" name="nextIteration" value="Next iteration" onclick="jssetiternflag();" >Next iteration</button> 


 <br>

<?php 
if($genflag == 1 | $iternflag == 1){
	echo "<img name=curimage id=curimage width=800 src=tmp/$sessionID/clnnState.png> <br><br>";
}
?>
<input type=hidden name=genflag value=0>
<input type=hidden name=iternflag value=0>

</form>

</html>
