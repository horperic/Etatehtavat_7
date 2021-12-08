<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Asiakkaiden listaus</title>
</head>
<body>
	<table id="listaus">
		<thead>
			<tr>
				<th colspan="5" class="oikealle"><span id="uusiAsiakas">Lisää
						uusi asiakas</span></th>
			</tr>
			<tr>
				<th colspan="3" class="oikealle">Hakusana:</th>
				<th><input type="text" id="hakusana"></th>
				<th><input type="button" id="hae" value="Hae"></th>
			</tr>
			<tr>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sposti</th>
				<th>&nbsp;</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	<script>
		$("#uusiAsiakas").click(function() {
			document.location = "lisaaasiakas.jsp";
		});

		haeTiedot();
		document.getElementById("hakusana").focus();//viedään kursori hakusana-kenttään sivun latauksen yhteydessä

		function tutkiKey(event) {
			if (event.keyCode == 13) {//Enter
				haeTiedot();
			}
		}
		//Funktio tietojen hakemista varten
		//GET   /asiakkaat/{hakusana}
		function haeTiedot() {
			document.getElementById("tbody").innerHTML = "";
			fetch("asiakkaat/" + document.getElementById("hakusana").value, {//Lähetetään kutsu backendiin
				method : 'GET'
			})
					.then(function(response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
						return response.json()
					})
					.then(
							function(responseJson) {//Otetaan vastaan objekti responseJson-parametrissä		
								var asiakkaat = responseJson.asiakkaat;
								var htmlStr = "";
								for (var i = 0; i < asiakkaat.length; i++) {
									htmlStr += "<tr id='rivi_"+field.asiakas_id+"'>";
									htmlStr += "<td>" + field.etunimi + "</td>";
									htmlStr += "<td>" + field.sukunimi
											+ "</td>";
									htmlStr += "<td>" + field.puhelin + "</td>";
									htmlStr += "<td>" + field.sposti + "</td>";
									htmlStr += "<td><a href='muutaasiakas.jsp?asiakas_id="
											+ field.asiakas_id
											+ "'>Muuta</a>&nbsp;";
									htmlStr += "<span class='poista' onclick=poista("
											+ field.asiakas_id
											+ ",'"
											+ field.etunimi
											+ "','"
											+ field.sukunimi
											+ "')>Poista</span></td>";
									htmlStr += "</tr>";
								}
								document.getElementById("tbody").innerHTML = htmlStr;
							})
		}

		function poista(asiakas_id, etunimi, sukunimi) {
			if (confirm("Poista asiakas " + etunimi + " " + sukunimi + "?")) {
				fetch("asiakkaat/" + asiakas_id, {//Lähetetään kutsu backendiin
					method : 'DELETE'
				})
						.then(function(response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
							return response.json()
						})
						.then(
								function(responseJson) {//Otetaan vastaan objekti responseJson-parametrissä		
									var vastaus = responseJson.response;
									if (vastaus == 0) {
										document.getElementById("ilmo").innerHTML = "Asiakkaan poisto epäonnistui.";
									} else if (vastaus == 1) {
										document.getElementById("ilmo").innerHTML = "Asiakkaan "
												+ etunimi
												+ sukunimi
												+ " poisto onnistui.";
										haeTiedot();
									}
									setTimeout(
											function() {
												document.getElementById("ilmo").innerHTML = "";
											}, 5000);
								})
			}
		}
	</script>
</body>
</html>