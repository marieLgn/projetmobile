cronAdd("sync_rappels", "0 0,12 * * *", () => {
    const reponse = $http.send({
        url:"https://codelabs.formation-flutter.fr/assets/rappels.json",
        method: "GET"
    });

    const produits = reponse.json;

    produits.forEach((item) => {
        if(item.gtin){
            try {
                //on vérifie si le produit existe dans la bdd des rappels
                const record = $app.dao().findFirstRecordByData("Rappel_Produit", "gtin", item.gtin);
                
                //on récupère les infos de la bdd
                record.set("motif", item.motif_rappel ?? "");
                record.set("conseil", item.preconisations_sanitaires ?? "");
                record.set("zone", item.zone_geographique_de_vente ?? "");
                record.set("distributeur", item.distributeurs ?? "");
                record.set("date_debut_comm", item.date_debut_commercialisation ?? "");
                record.set("date_fin_comm", item.date_date_fin_commercialisation ?? "");
                $app.dao().saveRecord(record);
            }

            catch(e){
                //si le barcode (gtin) existe pas encore on créer une nouvelle entrée
                const collection = $app.dao().findCollectionByNameOrId("Rappel_Produit");
                const record = new Record(collection,{
                    "gtin": item.gtin,
                    "motif": item.motif_rappel,
                    "conseil": item.preconisations_sanitaires,
                    "zone" : item.zone_geographique_de_vente,
                    "distributeur" : item.distributeurs,
                    "date_debut_comm" : item.date_debut_commercialisation,
                    "date_fin_comm" : item.date_date_fin_commercialisation
                });
                $app.dao().saveRecord(record);
            }
        }
    })
})