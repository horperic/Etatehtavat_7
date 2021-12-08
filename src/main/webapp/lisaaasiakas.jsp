<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.15.0/jquery.validate.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Asiakkaan lisääminen</title>
</head>
<body>
<form id="tiedot">
	<table>
	<thead>
		<tr>
			<th colspan="5" class="oikealle"><span id="takaisin">Takaisin listaukseen</span></th>
		</tr>
		<tr>
			<th>Etunimi</th>
			<th>Sukunimi</th>
			<th>Puhelin</th>
			<th>Sposti</th>
			<th></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><input type="text" name="etunimi" id="etunimi"></td>
			<td><input type="text" name="sukunimi" id="sukunimi"></td>
			<td><input type="text" name="puhelin" id="puhelin"></td>
			<td><input type="text" name="sposti" id="sposti"></td> 
			<td><input type="submit" id="tallenna" value="Lisää"></td>
		</tr>
	</tbody>
</table>
</form>
<span id="ilmo"></span>
<script>
function tutkiKey(event){
	if(event.keyCode==13){//Enter
		lisaaTiedot();
	}
	
}

//funktio tietojen lisäämistä varten. Kutsutaan backin POST-metodia ja välitetään kutsun mukana uudet tiedot json-stringinä.
//POST /asiakkaat/
function lisaaTiedot(){	
	var ilmo="";
	var d = new Date();
	if(document.getElementById("etunimi").value.length<2){
		ilmo="Liian lyhyt";		
	}else if(document.getElementById("sukunimi").value.length<2){
		ilmo="Liian lyhyt";		
	}else if(document.getElementById("puhelin").value.length<5){
		ilmo="Liian lyhyt";		
	}
	
	if(ilmo!=""){
		document.getElementById("ilmo").innerHTML=ilmo;
		setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 3000);
		return;
	}
	document.getElementById("etunimi").value=siivoa(document.getElementById("etunimi").value);
	document.getElementById("sukunimi").value=siivoa(document.getElementById("sukunimi").value);
	document.getElementById("puhelin").value=siivoa(document.getElementById("puhelin").value);
	document.getElementById("sposti").value=siivoa(document.getElementById("sposti").value);	
		
	var formJsonStr=formDataToJSON(document.getElementById("tiedot")); //muutetaan lomakkeen tiedot json-stringiksi
	//Lähetään uudet tiedot backendiin
	fetch("asiakkaat",{//Lähetetään kutsu backendiin
	      method: 'POST',
	      body:formJsonStr
	    })
	.then( function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi		
		return response.json()
	})
	.then( function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä	
		var vastaus = responseJson.response;		
		if(vastaus==0){
			document.getElementById("ilmo").innerHTML= "Asiakkaan lisääminen epäonnistui";
      	}else if(vastaus==1){	        	
      		document.getElementById("ilmo").innerHTML= "Asiakkaan lisääminen onnistui";			      	
		}
		setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
	});	
	document.getElementById("tiedot").reset(); //tyhjennetään tiedot -lomake
}
</script>
</body>
</html>