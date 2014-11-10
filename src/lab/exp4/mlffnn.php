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

$numberOfBits_arr = array(2=>"2-bit XOR",3=>"3-bit XOR",4=>"4-bit XOR",-1=>"Linearly separable",-2=>"Linearly inseparable");
$numberOfhiddenNodes_arr = array(2=>"2",3=>"3",4=>"4",6=>"6",8=>"8",10=>"10",15=>"15",25=>"25");

$numberOfBits = $_POST["numberOfBits"];
$numberOfhiddenNodes = $_POST["numberOfhiddenNodes"];
$trainFlag = $_POST["trainFlag"];
$testFlag = $_POST["testFlag"];

# $inputDim = 2;
$inputDim = $numberOfBits; 

//echo $numberOfBits.'<br>';

/*
echo $typeOfMapping;
echo $regionType;
echo $numDataPoints;
echo $numIterations;
echo $NIstep;
echo $genflag;
echo $iternflag;
*/

if($numberOfBits == '') $numberOfBits = 0;
if($numberOfhiddenNodes == '') $numberOfhiddenNodes = 0;


function showOptionsDrop($array,$value){
	global $numberOfBits;
        $string = '';
        foreach($array as $k => $v){
            $string .= '<option value="'.$k.'" ';
	    if($k == $value)
		$string = $string.'selected=selected ';
	    $string = $string .'>'.$v.'</option>'."\n";
        }
        return $string;
    }

function trainNN(){
global $inputDim, $numberOfhiddenNodes,$sessionID;
$cmd="cd tmp/$sessionID; octave --eval 'addpath ../../ ;trainXORcore(".$inputDim.",".$numberOfhiddenNodes.");cd ../../ ;quit;' 1> log.txt 2>&1 ";
//echo $cmd;
$out=exec($cmd,$results,$status);
}

function testNN(){
//global $NIstep;
global $numberOfBits, $sessionID;
$cmd="cd tmp/$sessionID; octave --eval 'addpath ../../ ;testXORcore(".$numberOfBits.");cd ../../ ;quit;' 1> log.txt 2>&1 ";

$out=exec($cmd,$results,$status);
}

if($trainFlag== 1){
	exec("mkdir -p tmp/$sessionID");
	trainNN();
}

if($testFlag==1){
	testNN();
}

?>

<script type="text/javascript">
function jsSetTrainFlag(){
	document.myform.trainFlag.value=1;
}


function jsSetTestFlag(){
	document.myform.testFlag.value=1;
}


</script>


<form name="myform" action="<?php echo $_SERVER['PHP_SELF'];?>" method="post">

<h3> MLFFNN for solving linearly inseparable problems </h3>

<font size=-1>
<!--<ol>
<li>This is a 3 layer MLFFNN with one hidden layer, one input layer, and one output layer.</li>
<li>Select the problem type and the number of nodes in the hidden layer, and click in train MLFFNN.</li>
<li>Now click on test MLFFNN.</li>
</ol> -->
</font>

<select name="numberOfBits">
    <option value="0">Problem type</option>
    <?php echo showOptionsDrop($numberOfBits_arr,$numberOfBits); ?>
</select>

<select name="numberOfhiddenNodes">
    <option value="0">Number of nodes in hidden layer</option>
    <?php echo showOptionsDrop($numberOfhiddenNodes_arr,$numberOfhiddenNodes); ?>
</select>


<button type="submit" name="trainMLFFNN" value="Train MLFFNN" onclick="jsSetTrainFlag();" >Train MLFFNN</button>

<button type="submit" name="testMLFFNN" value="Test MLFFNN" onclick="jsSetTestFlag();" >Test MLFFNN</button> 

 <br>

<?php
if($trainFlag == 1){
	if($numberOfBits == -1 | $numberOfBits == -2){
		echo '<table><tr align=center><td><b>Training data</b></td><td><b>Training error</b></td></tr>';
		echo "<td><img name=curimage id=curimage width=600 src=tmp/$sessionID/mlffnntrainingSamples.png> </td>";
		echo "<td><img name=curimage id=curimage width=600 src=tmp/$sessionID/mlffnnState.png> </td>";
		echo '</tr></table>';
	}
	else
		echo "'<table><tr align=center><td><b>Training error</b></td></tr><tr><td><img name=curimage id=curimage width=600 src=tmp/$sessionID/mlffnnState.png></td></tr></table>'";

}
if($testFlag == 1){
	
	if($numberOfBits == -1 | $numberOfBits ==-2){
		echo '<table><tr align=center><td><b>Training data</b></td><td><b>Classification of test data</b></td></tr>';
		echo "<tr><td><img name=curimage id=curimage width=600 src=tmp/$sessionID/mlffnntrainingSamples.png></td>";
		echo "<td><img name=curimage id=curimage width=600 src=tmp/$sessionID/mlffnntestingSamples.png> </td></tr></table>";
	}
	else{
		echo '<br><b>Result of pattern classification</b><br>';
		echo implode('',file("tmp/$sessionID/results.txt"));
		//echo nl2br(implode('',file('tmp/results.txt')));
	}
}
?>
<input type=hidden name=trainFlag value=0>
<input type=hidden name=testFlag value=0>

</form>

</html>
