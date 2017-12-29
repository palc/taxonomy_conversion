Scripts to convert qiime taxonomy/fasta format to RDP format

    extract_names.pl <original taxonomy file> <output new taxonomy file> <original fasta file> <output new RDP fasta file> <output taxa file>
    get_taxid.pl <taxa file> > <output taxids file>
    convert_taxonomy.pl <taxids file> <new taxonomy file> > <output converted RDP file>

Example
-------

    extract_names.pl nema_28S_ID_to_taxonomy.txt nema_28S_ID_to_taxonomy.new.txt nema_28S_refseq_lib.fasta nema_28S_refseq_lib.rdp.fasta taxa2.txt
    get_taxid.pl taxa2.txt > taxids2.txt
    convert_taxonomy.pl taxids2.txt nema_28S_ID_to_taxonomy.new.txt > nema_28S_ID_to_taxonomy.rdp.txt

To create the classifier database:

    java -jar RDPTools/classifier.jar train -s nema_28S_refseq_lib.rdp.fasta -t nema_28S_ID_to_taxonomy.rdp.txt -o rdp_db

Add the "rRNAClassifier.properties" to rdp_db:

    cp rRNAClassifier.properties rdp_db

Finally, you can use your new custom database:

    java -jar RDPTools/classifier.jar classify -o classify.out -t rdp_db/rRNAClassifier.properties nema_28S_refseq_lib.fasta
