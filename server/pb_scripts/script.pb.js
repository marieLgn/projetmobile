cronAdd("sync_rappels", "0 0, 12 * * *", () => {
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
                record.set("motif", item.motif_rappel)
                record.set("Conseils", item.preconisations_sanitaires);
                $app.dao().saveRecord(record);
            }

            catch(e){
                //si le barcode (gtin) existe pas encore on créer une nouvelle entrée
                const collection = $app.dao().findCollectionByNameOrId("Rappel_Produit");
                const record = new Record(collection,{
                    "gtin": item.gtin,
                    "motif": item.motif_rappel,
                    "Conseils": item.preconisations_sanitaires
                });
                $app.dao().saveRecord(record);
            }
        }
    })
})