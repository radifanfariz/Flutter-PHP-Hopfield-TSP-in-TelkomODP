<?php
$mysqli = new mysqli("localhost","root","","db_odp_compliance");
$limit;
if(isset($_GET['limit']))
{
     $limit = $_GET['limit'];
}else{
    $limit = "200";
}
// $result = $mysqli->query("SELECT odp_name,latitude,longitude FROM t_odp_compliance WHERE witel='medan'");
$stmt = $mysqli->prepare("SELECT odp_name AS fat_name,latitude,longitude FROM t_odp_compliance WHERE witel=? LIMIT ?");
$param = "medan";
$stmt->bind_param("ss",$param,$limit);
$stmt->execute();
$result = $stmt->get_result();
// print_r($result->fetch_all(MYSQLI_ASSOC));
$collectData = $result->fetch_all(MYSQLI_ASSOC);
echo json_encode($collectData);
$stmt->close();
$mysqli->close();

?>