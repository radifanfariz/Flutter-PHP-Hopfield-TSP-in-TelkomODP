<?php
class Hopfield_network{
    public $distanceArray;
    public $polylineArray;
    public static $locData,$labelTour;
    public $pointname,$lat,$lng,$polylineTour;
    public $pointno,$a,$b,$c,$d,$totout,
    $neuron,$dist,$tourcity,$tourorder,
    $outs,$acts,$weight,$citouts,$ordouts,
    $energy;

    // public __construct(){

    // }
    
    /////get distance
    public function initDistance($arrayFromJson,$pointno){
        $latlngArray = [];
        $length = $pointno;
        $i = 0;
        foreach($arrayFromJson as $key => $items){
            $latlngArray[$i] = $items;
            $this->pointname[$i] = $key;
            $i++;
        }
        
        for ($i=0; $i < $length; $i++) { 
            for ($j=$i; $j < $length; $j++) { 
                if ($j == $i) {
                    $this->distanceArray[$i][$j] = 0;
                    $this->polylineArray[$i][$j] = 0;
                }
                else {
                    $apiDataArray = self::getDistanceFromApi($latlngArray[$i]["lat"],$latlngArray[$i]["lng"],
                    $latlngArray[$j]["lat"],$latlngArray[$j]["lng"]);
                    $this->distanceArray[$i][$j] = $apiDataArray["distance"]/1000;
                    $this->polylineArray[$i][$j] = $apiDataArray["polyline"];
                }
                $this->distanceArray[$j][$i] = $this->distanceArray[$i][$j];
                $this->polylineArray[$j][$i] = $this->polylineArray[$i][$j];
            }
            $this->lat[$i] = $latlngArray[$i]["lat"];
            $this->lng[$i] = $latlngArray[$i]["lng"];
        }
        // $this->print_distance();
    }

    public function print_distance(){
        // var_dump($this->distanceArray);
        echo "<br><table>";
        echo "Distance Matrix: ";
        $i=0;
        foreach($this->distanceArray as $data){
            echo "<tr>";
            echo "<th>".$i."|</th>";
            foreach($data as $field){
                echo "<td>".$field."</td>";
            }
            echo "</tr>";
            $i++;
        }
        echo "<table>";
    }

    public static function getDistanceFromApi($origin_lat,$origin_lng,$destination_lat,$destination_lng,$key="AIzaSyCbmENUBCCH2xyUISfh--jwLyM931PDJhU"){
        $url = "https://maps.googleapis.com/maps/api/directions/json?origin=${origin_lat},${origin_lng}&destination=${destination_lat},${destination_lng}&key=${key}";
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_URL,$url);
        $result = curl_exec($ch);
        curl_close($ch);
        $array = json_decode($result,false);
        $distance = $array->routes[0]->legs[0]->distance->value;
        $polyline = $array->routes[0]->overview_polyline->points;
        // var_dump($array["routes"][0]["legs"][0]["distance"]);
        // var_dump($array->routes[0]->legs[0]->distance->value);
        // var_dump($array->routes[0]->overview_polyline->points);
        $array = array(
            "distance" => $distance,
            "polyline" => $polyline
        );
        return $array;
    }

    /////random function
    public static function randomNum($maxval){
        return rand()%$maxval;
    }

    /////krondelt
    public function krondelt($i, $j){
        $k;
        $k=(($i==$j)?(1):(0));
        return $k;
    }

    /////getnwk
    public function getnwk($arrayFromJson,$x,$y,$z,$w){
        $i;$j;$k;$l;$t1;$t2;$t3;$t4;$t5;$t6;
        $p;$q;
        $this->pointno = count($arrayFromJson);
        $this->a = $x;
        $this->b = $y;
        $this->c = $z;
        $this->d = $w;
        $this->initDistance($arrayFromJson,$this->pointno);

        ////neuron class object array instantiate
        // $tnrn[[]] = new Neuron();

        // for ($i=0; $i < $this->pointno; $i++) { 
        //     for ($j=0; $j < $this->pointno; $j++) { 
        //         $tnrn[$i][$j]->getnrn($i,$j);
        //     }
        // }
        //////////////////////////

        for ($i=0; $i < $this->pointno; $i++) { 
            for ($j=0; $j < $this->pointno; $j++) { 
                $p=(($j==$this->pointno-1)?(0):($j+1));
                $q=(($j==0)?($this->pointno-1):($j-1));
                $t1 = $j+$i*$this->pointno;
                for ($k=0; $k < $this->pointno; $k++) { 
                    for ($l=0; $l < $this->pointno; $l++) { 
                        $t2 = $l+$k*$this->pointno;
                        $t3 = $this->krondelt($i,$k);
                        $t4 = $this->krondelt($j,$l);
                        $t5 = $this->krondelt($l,$p);
                        $t6 = $this->krondelt($l,$q);
                        $this->weight[$t1][$t2] = -$this->a*$t3*(1-$t4)-$this->b*$t4*(1-$t3)
                        -$this->c-$this->d*$this->distanceArray[$i][$k]*($t5+$t6)/100;

                    }
                }
            }
        }
        // $this->print_weight($this->pointno);
    }

    //////print weight matrix
    public function print_weight($k){
        $nbrsq = $k*$k;
        echo "<br>Weight Matrix : <br>";
        for ($i=0; $i < $nbrsq; $i++) { 
            for ($j=0; $j < $nbrsq; $j++) { 
                echo $this->weight[$i][$j]." | ";
            }
            echo "<br>";
        }
        echo "<br> Length of Array: ".count($this->weight);
    }

    /////////////assign initial input to the network
    public function asgninpt($ip){
        $t1;$t2;

        for ($i=0; $i < $this->pointno; $i++) { 
            for ($j=0; $j < $this->pointno; $j++) { 
                $this->acts[$i][$j] = 0.0;
            }
        }

        ////find initial activation
        for ($i=0; $i < $this->pointno; $i++) { 
            for ($j=0; $j < $this->pointno; $j++) { 
                $t1 = $j+$i*$this->pointno;
                for ($k=0; $k < $this->pointno; $k++) { 
                    for ($l=0; $l < $this->pointno; $l++) { 
                        $t2 = $l+$k*$this->pointno;
                        $this->acts[$i][$j] += $this->weight[$t1][$t2]*$ip[$t1];
                    }
                }
            }
        }
        // $this->print_acts();
    }

    /////////////////////////get acts
    public function getacts($nprm,$dlt,$tau){
        $p;$q;
        $r1;$r2;$r3;$r4;$r5;
        $r3 = $this->totout - $nprm;

        for ($i=0; $i < $this->pointno; $i++) { 
            $r4 = 0.0;
            $p = (($i==$this->pointno-1)?(0):($i+1));
            $q = (($i==0)?($this->pointno-1):($i-1));

            for ($j=0; $j < $this->pointno; $j++) { 
                $r1 = $this->citouts[$i]-$this->outs[$i][$j];
                $r2 = $this->ordouts[$j]-$this->outs[$i][$j];

                for ($k=0; $k < $this->pointno; $k++) { 
                    $r4 += $this->distanceArray[$i][$k]*($this->outs[$k][$p]+$this->outs[$k][$q])/100;
                }
                $r5 = $dlt*(-$this->acts[$i][$j]/$tau-$this->a*$r1-$this->b*$r2-$this->c*$r3-$this->d*$r4);
                $this->acts[$i][$j] += $r5;
            }
        }
    }

    ////////////////////get neural network output
    public function getouts($la){
        $b1;$b2;$b3;$b4;
        $this->totout = 0.0;

        for ($i=0; $i < $this->pointno; $i++) { 
            $this->citouts[$i] = 0.0;
            for ($j=0; $j < $this->pointno; $j++) { 
                $b1 = $la*$this->acts[$i][$j];
                $b4 = $b1;
                $b2 = exp($b4);
                $b3 = exp(-$b4);
                $this->outs[$i][$j] = (1.0+($b2-$b3)/($b2+$b3))/2.0;
                $this->citouts[$i] += $this->outs[$i][$j];
            }
            $this->totout += $this->citouts[$i];
        }

        for ($j=0; $j < $this->pointno; $j++) { 
            $this->ordouts[$j] = 0.0;
            for ($i=0; $i < $this->pointno; $i++) { 
                $this->ordouts[$j] += $this->outs[$i][$j];
            }
        }
    }

    /////////////////// compute the energy function
    public function getEnergy(){
        $p;$q;
        $t1 = 0.0;
        $t2 = 0.0;
        $t3 = 0.0;
        $t4 = 0.0;
        $e;

        for ($i=0; $i < $this->pointno; $i++) { 
            $p = (($i==$this->pointno-1)?(0):($i+1));
            $q = (($i==0)?($this->pointno-1):($i-1));

            for ($j=0; $j < $this->pointno; $j++) { 
                $t3 += $this->outs[$i][$j];

                for ($k=0; $k < $this->pointno; $k++) { 
                    if ($k != $j) {
                        $t1 += $this->outs[$i][$j]*$this->outs[$i][$k];
                        $t2 += $this->outs[$j][$i]*$this->outs[$k][$i];
                        $t4 += $this->distanceArray[$k][$j]*$this->outs[$k][$i]*
                        ($this->outs[$j][$p]+$this->outs[$j][$q])/10;
                    }
                }
            }
        }
        $t3 = $t3 - $this->pointno;
        $t3 = $t3 * $t3;
        $e = 0.5*($this->a*$t1+$this->b*$t2+$this->c*$t3+$this->d*$t4);

        return $e;
    }
    /////////////////find a valid tour
    public function findtour(){
        $tag = [[]];
        $tmp;
        for ($i=0; $i < $this->pointno; $i++) { 
            for ($j=0; $j < $this->pointno; $j++) { 
                $tag[$i][$j] = 0;
            }
        }

        for ($i=0; $i < $this->pointno; $i++) { 
            $tmp = -10.0;
            for ($j=0; $j < $this->pointno; $j++) { 
                for ($k=0; $k < $this->pointno; $k++) { 
                    // echo "<br> Test Loop: (".$i.",".$j.",".$k.") => ".$tag[$i][$k]."<br>";
                    if (($this->outs[$i][$k]>=$tmp)&&($tag[$i][$k]==0)) {
                        $tmp = $this->outs[$i][$k];
                        // echo "<br> Test IF 1: ".$tmp."(".$i.",".$k.")<br>";
                    }
                }
                if (($this->outs[$i][$j]>=$tmp)&&($tag[$i][$j]==0)) {
                    $this->tourcity[$i] = $j;
                    $this->tourorder[$j] = $i;
                    // echo "<br> Test IF 2: ".$tmp."(".$i.",".$j.")<br>";
                    // echo "tour order ${j} <br>";
                    for ($k=0; $k < $this->pointno; $k++) { 
                        $tag[$i][$k] = 1;
                        $tag[$k][$j] = 1;
                    }
                }
            }
        }
    }

    ////////pritn outs
    public function print_outs(){
        echo "<br>The Outputs";
        echo "<table>";
        for ($i=0; $i < $this->pointno; $i++) { 
            echo "<tr>";
            echo "<th>".$i."|</th>";
            for ($j=0; $j < $this->pointno; $j++) { 
                echo "<td>".$this->outs[$i][$j]."</td>";
            }
            echo "</tr>";   
        }
        echo "</table>";
    }

    ///////////calculate total distance for tour
    public function calcdist(){
        $k;$l;
        $distance = 0.0;

        for ($i=0; $i < $this->pointno; $i++) { 
            $k = $this->tourorder[$i];
            $l = (($i==$this->pointno-1)?($this->tourorder[0]):($this->tourorder[$i+1]));
            $distance += $this->distanceArray[$k][$l];
        }
        // echo "Total distance of tour is : ${distance} <br>";
    }
    ///////////print tour matrix
    public function print_tour(){
        echo "<br> The Tour order: <br>";

        for ($i=0; $i < $this->pointno; $i++) { 
            echo $this->tourorder[$i];
            if ($i == $this->pointno-1) {
                echo "<br>";
            }else{
                echo " --> ";
            }
        }
    }

    ////////////////////////print acts
    public function print_acts(){
        echo "<br>Activision Matrix : <br>";
        for ($i=0; $i < $this->pointno; $i++) { 
            for ($j=0; $j < $this->pointno; $j++) { 
                echo $this->acts[$i][$j]." | ";
            }
            echo "<br>";
        }
        echo "<br> Length of Array: ".count($this->acts);
    }

    //////////////////////Iterate the network specified number of times
    public function iterate($nit, $nprm, $dlt, $tau, $la){
        $k;$b;
        $oldEnergy;$newEnergy;$energy_diff;
        $b = 1;
        $oldEnergy = $this->getEnergy();
        // echo $oldEnergy."<br>";
        $k = 0;
        do {
            $this->getacts($nprm,$dlt,$tau);
            $this->getouts($la);
            $newEnergy = $this->getEnergy();
            // echo $newEnergy."<br>";

            //$energy_diff = $oldEnergy - $newEnergy;
            // if ($energy_diff < 0) {
            //     $energy_diff = $energy_diff*(-1);
            // }

            if ($oldEnergy - $newEnergy < 0.0000001) {
                // echo "Energy before break : ".$oldEnergy - $newEnergy;
                break;
            }

            $oldEnergy = $newEnergy;
            $k++;
        } while ($k < $nit);
        // echo $k." Iteration taken for convergence <br>";
        // $this->print_acts();
        // echo "<br>";
        // $this->print_outs();
    }

    ////////////collect data
    public function collectData(){
        $k;$l;
        $this->tourorder = $this->tourOrderFromStartPoint(0);

        for ($i=0; $i < $this->pointno; $i++) { 
            $k = $this->tourorder[$i];
            $l = (($i==$this->pointno-1)?($this->tourorder[0]):($this->tourorder[$i+1]));
            self::$locData[$i]["pointname"] = $this->pointname[$k];
            self::$locData[$i]["lat"] = $this->lat[$k];
            self::$locData[$i]["lng"] = $this->lng[$k];
            self::$locData[$i]["polyline"] = $this->polylineArray[$k][$l];
            self::$locData[$i]["distance"] = $this->distanceArray[$k][$l];
            // self::$locData[$i][4] = $k;
            // echo " |".$k." to ".$l."| ";
            // echo "[".$this->distanceArray[$k][$l]."]";
        }
        // echo "<br> New tourorder array with optional start point :";
        // $variable = $this->tourOrderFromStartPoint(3);
        // ksort($variable);
        // foreach ($variable as $key => $value) {
        //     echo $value." --> ";
        // }
        // echo "<br>";
    }

    public function tourOrderFromStartPoint($start){
        $newTourOrder = [];
        $startIndex = array_search(strval($start),$this->tourorder);
        $endIndex = $this->pointno - 1;
        // echo $startIndex;
        for ($i=0; $i <= $endIndex; $i++) { 
            if ($i >= $startIndex) {
                $newTourOrder[$i-$startIndex] = $this->tourorder[$i];
            }else{
                $newTourOrder[$i-$startIndex+$endIndex+1] = $this->tourorder[$i];
            }
        }
        return $newTourOrder;
    }
}

class Neuron{
    protected $cit,$ord,$output,$activation;
    // public function neuron(){

    // }
    public function getnrn($i, $j){
        $this->cit = $i;
        $this->ord = $j;
        $this->output = 0.0;
        $this->activation = 0.0;
    }
}

// Hopfield_network::getDistanceFromApi(3.6120217155,98.638737221,3.6443505296,98.687265560);
// $tsp = new Hopfield_network();
// $tsp->getDistance($arrayFromJson);
// $tsp->getnwk($arrayFromJson,0.5,0.5,0.2,0.5);

function main(){
// $jsonFile = file_get_contents("latlng_location_example.json");
$arrayFromJson = getJson();
// $arrayFromJson = json_decode($jsonFile,true);
$pointno = count($arrayFromJson);
// var_dump($array);

// foreach($array as $first){
//     echo $first["lat"]."<br>";
//     // print_r($element);
// }
// $latlngArray = [];
// $i = 0;
//         foreach($arrayFromJson as $array){
//             $latlngArray[$i] = $array;
//             $i++;
//         }
//         var_dump($latlngArray[4]["lng"]);
    $nprm = 15;
    $a = 0.5;
    $b = 0.5;
    $c = 0.2;
    $d = 0.5;
    $dt = 0.01;
    $tau = 1;
    $lambda = 3.0;
    $i;$n2;
    $numit = 4000;
    $input_vector = [];
    $start;$end;
    $diff;

    $start = time();
    srand(time());
    $n2 = $pointno*$pointno;
    // echo "Input Vector: <br>";
    for ($i=0; $i < $n2; $i++) { 
        if ($i%$pointno==0) {
            // echo "<br>";
        }
        $input_vector[$i] = (Hopfield_network::randomNum(100)/100.0)-1;
        // echo $input_vector[$i];
    }
    // echo "<br>";

    $tsp = new Hopfield_network();

    $tsp->getnwk($arrayFromJson,$a,$b,$c,$d);
    $tsp->asgninpt($input_vector);
    $tsp->getouts($lambda);
    $tsp->iterate($numit,$nprm,$dt,$tau,$lambda);
    $tsp->findtour();
    // $tsp->print_tour();
    $tsp->calcdist();
    $tsp->collectData();
    $end = time();
    $diff = $end - $start;
    // echo "Time taken the algorithm :".$diff;
    Hopfield_network::$labelTour = $tsp->tourorder;
}

function getJson(){
    $contentType = explode(';', $_SERVER['CONTENT_TYPE']); // Check all available Content-Type
    $rawBody = file_get_contents("php://input"); // Read body
    $data = array(); // Initialize default data array

    if(in_array('application/json', $contentType)) { // Check if Content-Type is JSON
        $data = json_decode($rawBody,true); // Then decode it
    } else {
        parse_str($data, $data); // If not JSON, just do same as PHP default method
    }
    return $data;

    // header('Content-Type: application/json; charset=UTF-8');
    // echo json_encode(array( // Return data
    // 'data' => $data
    // ));
}

main();
echo json_encode(Hopfield_network::$locData);
?>