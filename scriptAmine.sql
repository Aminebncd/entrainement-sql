A partir du script SQL Gaulois fourni par votre formateur, écrivez et exécutez les
requêtes SQL suivantes:


1. Nom des lieux qui finissent par 'um'.

REPONSE : 

SELECT nom_lieu
FROM lieu
WHERE nom_lieu LIKE '%um%';



2. Nombre de personnages par lieu (trié par nombre de personnages décroissant).

REPONSE : 

SELECT COUNT(personnage.id_personnage) AS population, nom_lieu
FROM personnage
INNER JOIN lieu ON personnage.id_lieu = lieu.id_lieu
GROUP BY lieu.id_lieu
ORDER BY COUNT(*) DESC



3. Nom des personnages + spécialité + adresse et lieu d habitation, triés par lieu puis par nom
de personnage.

REPONSE :

SELECT personnage.nom_personnage, personnage.adresse_personnage, specialite.nom_specialite
FROM personnage
INNER JOIN specialite ON personnage.id_specialite=specialite.id_specialite
ORDER BY nom_personnage



4. Nom des spécialités avec nombre de personnages par spécialité (trié par nombre de
personnages décroissant).

REPONSE :
 
 SELECT specialite.nom_specialite, COUNT(*) AS nombre_personnages
FROM personnage
INNER JOIN specialite ON personnage.id_specialite = specialite.id_specialite
GROUP BY specialite.id_specialite
ORDER BY nombre_personnages DESC;



5. Nom, date et lieu des batailles, classées de la plus récente à la plus ancienne (dates affichées
au format jj/mm/aaaa).

REPONSE :

SELECT bataille.nom_bataille, DATE_FORMAT(bataille.date_bataille, "%d/%m/%Y" ), lieu.nom_lieu
FROM bataille
INNER JOIN lieu ON bataille.id_lieu = lieu.id_lieu


6. Nom des potions + coût de réalisation de la potion (trié par coût décroissant).

RESULTAT :

SELECT potion.nom_potion, SUM(composer.qte * ingredient.cout_ingredient) AS TOTAL 
FROM composer
INNER JOIN ingredient ON ingredient.id_ingredient = composer.id_ingredient
INNER JOIN potion ON potion.id_potion = composer.id_potion
GROUP BY potion.id_potion
ORDER BY TOTAL DESC


7. Nom des ingrédients + coût + quantité de chaque ingrédient qui composent la potion 'Santé'.

RESULTAT :

SELECT ingredient.nom_ingredient, ingredient.cout_ingredient, composer.qte
FROM ingredient
INNER JOIN composer ON ingredient.id_ingredient = composer.id_ingredient
INNER JOIN potion ON composer.id_potion = potion.id_potion
WHERE nom_potion LIKE '%Santé%' 




8. Nom du ou des personnages qui ont pris le plus de casques dans la bataille 'Bataille du village
gaulois'.

RESULTAT :


-- SELECT personnage.nom_personnage, sum(prendre_casque.qte) AS SCORE
-- FROM personnage

-- INNER JOIN prendre_casque ON personnage.id_personnage = prendre_casque.id_personnage
-- INNER JOIN bataille ON prendre_casque.id_bataille = bataille.id_bataille
-- WHERE bataille.id_bataille = 1

-- GROUP BY nom_personnage
-- ORDER BY SCORE DESC



-- SELECT personnage.nom_personnage, sum(prendre_casque.qte) AS SCORE
-- FROM personnage

-- INNER JOIN prendre_casque ON personnage.id_personnage = prendre_casque.id_personnage
-- INNER JOIN bataille ON prendre_casque.id_bataille = bataille.id_bataille

-- WHERE bataille.id_bataille = 1
-- AND SCORE >= ALL (
-- 	SELECT MAX(SCORE) AS BestScore)
-- 	FROM personnage
-- 	INNER JOIN prendre_casque ON personnage.id_personnage = prendre_casque.id_personnage
-- )
-- GROUP BY BestScore

SELECT personnage.nom_personnage, sum(prendre_casque.qte) AS SCORE
FROM personnage

INNER JOIN prendre_casque ON personnage.id_personnage = prendre_casque.id_personnage
INNER JOIN bataille ON prendre_casque.id_bataille = bataille.id_bataille

WHERE bataille.id_bataille = 1
GROUP BY personnage.id_personnage

HAVING SCORE >= ALL (
	SELECT SUM(prendre_casque.qte)
	FROM personnage
	INNER JOIN prendre_casque ON personnage.id_personnage = prendre_casque.id_personnage
	INNER JOIN bataille ON prendre_casque.id_bataille = bataille.id_bataille
	WHERE bataille.id_bataille = 1
	GROUP BY personnage.id_personnage
)


9. Nom des personnages et leur quantité de potion bue (en les classant du plus grand buveur
au plus petit).

RESULTAT :

SELECT personnage.nom_personnage, boire.dose_boire
FROM personnage

INNER JOIN boire ON boire.id_personnage = personnage.id_personnage
ORDER BY boire.dose_boire DESC




10. Nom de la bataille où le nombre de casques pris a été le plus important.

RESULTAT :

-- SELECT bataille.nom_bataille, sum(prendre_casque.qte) AS SCORE
-- FROM bataille

-- INNER JOIN prendre_casque ON bataille.id_bataille = prendre_casque.id_bataille
-- GROUP BY bataille.id_bataille
-- ORDER BY SCORE DESC


SELECT bataille.nom_bataille, sum(prendre_casque.qte) AS SCORE
FROM bataille

INNER JOIN prendre_casque ON bataille.id_bataille = prendre_casque.id_bataille
GROUP BY bataille.id_bataille

HAVING SCORE >= ALL (
	SELECT SUM(prendre_casque.qte)
	FROM bataille
	INNER JOIN prendre_casque ON bataille.id_bataille = prendre_casque.id_bataille
	
	GROUP BY bataille.id_bataille
)




11. Combien existe-t-il de casques de chaque type et quel est leur coût total ? (classés par
nombre décroissant)

RESULTAT : 

SELECT type_casque.nom_type_casque, count(casque.nom_casque) , SUM(casque.cout_casque) AS TOTAL 
FROM type_casque
INNER JOIN casque ON TYPE_casque.id_type_casque = casque.id_type_casque

GROUP BY type_casque.id_type_casque
ORDER BY TOTAL





12. Nom des potions dont un des ingrédients est le poisson frais.

RESULTAT :

SELECT potion.nom_potion
FROM potion

INNER JOIN composer ON potion.id_potion=composer.id_potion
INNER JOIN ingredient ON composer.id_ingredient=ingredient.id_ingredient

WHERE ingredient.nom_ingredient LIKE '%Poisson frais%'




-- 13. Nom du / des lieu(x) possédant le plus d'habitants, en dehors du village gaulois.

-- RESULTAT :

-- SELECT COUNT(personnage.id_personnage) AS population, nom_lieu
-- FROM personnage
-- INNER JOIN lieu ON personnage.id_lieu = lieu.id_lieu
-- GROUP BY lieu.id_lieu

-- HAVING population >= ALL (

-- 		SELECT COUNT(personnage.id_personnage)
-- 		FROM personnage
-- 		INNER JOIN lieu ON personnage.id_lieu = lieu.id_lieu
		
-- 		GROUP BY lieu.id_lieu

-- )

SELECT COUNT(personnage.id_personnage) AS population, nom_lieu
FROM personnage

INNER JOIN lieu ON personnage.id_lieu = lieu.id_lieu

WHERE lieu.id_lieu <> 1

GROUP BY lieu.id_lieu
HAVING population >= ALL (

		SELECT COUNT(personnage.id_personnage)
		FROM personnage
		INNER JOIN lieu ON personnage.id_lieu = lieu.id_lieu
		WHERE lieu.id_lieu <> 1
		GROUP BY lieu.id_lieu

)




14. Nom des personnages qui n ont jamais bu aucune potion.

RESULTAT :

SELECT personnage.nom_personnage
FROM personnage

WHERE personnage.id_personnage NOT IN (SELECT boire.id_personnage FROM boire)



15. Nom du / des personnages qui n ont pas le droit de boire de la potion 'Magique'.

RESULTAT :


SELECT personnage.nom_personnage
FROM personnage
INNER JOIN autoriser_boire ON personnage.id_personnage=autoriser_boire.id_personnage
WHERE nom_personnage NOT IN (autoriser_boire.id_potion)





En écrivant toujours des requêtes SQL, modifiez la base de données comme suit :


A. Ajoutez le personnage suivant : Champdeblix, agriculteur résidant à la ferme Hantassion de
Rotomagus.

RESULTAT :

INSERT INTO personnage (id_personnage,nom_personnage,adresse_personnage, id_lieu, id_specialite)
 VALUES (45,'Champdeblix','ferme Hantassion', 6, 12)





B. Autorisez Bonemine à boire de la potion magique, elle est jalouse d Iélosubmarine...

RESULTAT :

INSERT INTO autoriser_boire (id_potion, id_personnage)
 VALUES (1,12)




C. Supprimez les casques grecs qui n'ont jamais été pris lors d'une bataille.

RESULTAT :

DELETE FROM casque
WHERE id_type_casque = 3 
AND casque.id_casque NOT IN (SELECT id_casque FROM prendre_casque) 




D. Modifiez l adresse de Zérozérosix : il a été mis en prison à Condate

RESULTAT :

UPDATE personnage
SET adresse_personnage = 'Prison de Condate'
WHERE nom_personnage = 'Zérozérosix'



E. La potion 'Soupe' ne doit plus contenir de persil.

RESULTAT :

DELETE FROM composer
WHERE id_potion = 9
AND id_ingredient = 19




F. Obélix s'est trompé : ce sont 42 casques Weisenau, et non Ostrogoths, qu'il a pris lors de la
bataille 'Attaque de la banque postale'. Corrigez son erreur !

RESULTAT :

UPDATE prendre_casque
SET id_casque = 10
WHERE id_personnage = 5
AND id_casque = 14
AND id_bataille = 2
