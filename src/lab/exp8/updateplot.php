
<?php
$MAX_CITY=10;
$MAX_ITERATION=10;


$CITY_NO=1;
$ITER_NO=1;

//if ()
if (isset($_POST["CityNo"])){
   $CITY_NO=$_POST["CityNo"]+1;
}

if (isset($_POST["NextIter"])){
   $CITY_NO=$_POST["CityNo"]+1;
   $CITY_NO=1;
   $ITER_NO=$_POST["IterNo"]+1;
}
else {
  if (isset($_POST["IterNo"])){
	$ITER_NO=$_POST["IterNo"];
	}
}

//echo $IMGNO;
echo "<img src =\"figures/som_",$ITER_NO,"_",$CITY_NO,".png\"/>";

if ($ITER_NO<=$MAX_ITERATION){

?>


<form action="updateplot.php" method="POST">
Current City: <input type="text" value="
<?php 
	echo $CITY_NO ; 
?>
"name="CityNo"> 
<br>
Current Iteration<input type="text" value="
<?php 
	echo $ITER_NO ; 
?>
"name="IterNo"> <br> 
<?php
	if ($CITY_NO<$MAX_CITY){
		echo "<input type=\"submit\" value=\"Next City\" name=\"NextCity\"> ";
	}
	else if ($ITER_NO<$MAX_ITERATION){
		echo "<input type=\"submit\" value=\"Next Iteration\" name=\"NextIter\">" ;
	}
}
?>
</form>
