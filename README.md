# Orthologs finder

This image includes two commands to retrieve orthologous genes from input lists containing gene identifiers. The two commands are:
- `diopt-orthologs`: to obtain orthologs using the [DIOPT Ortholog Finder](https://www.flyrnai.org/diopt). It allows using several gene identifiers as input, the same that appear in the *3. Enter Gene list* combobox at the DIOPT online tool (default is `Entrez GeneID`).
- `ensembl-orthologs`: to obtain orthologs using the [Ensembl REST API](https://rest.ensembl.org/documentation/info/homology_symbol). It only allows using NCBI Gene IDs as input.

Both commands accept as input a TXT containing a list of Gene IDs (`--gene_list_file`), the input species (`--input_species`) and the target or output species (`--output_species`). Examples of both commands are provided below.

An additional command (`list-species`) is provided to show the taxonomy identifiers of the most common species: `docker run --rm pegi3s/orthologs-finder list-species`.

## `diopt-orthologs`

The `diopt-orthologs` command also accepts these three parameters:
- `-gs/--gene_list_search_fields=<search_fields>`: the gene identifiers type. It must be one of the values that appear in the *3. Enter Gene list* combobox at the DIOPT online tool (default is `Entrez GeneID`).
- `-sd/--search_datasets=<search_datasets>`: the ortholog sources. It must be one of the values that appear in the *4. Choose Ortholog Sources* combobox at the DIOPT online tool (default is `All`).
- `-af/--additional_filter=<additional_filter>`: one of `None`, `Best` (return only best match when there is more than one match per input gene or protein), `NoLow` (default, exclude low score [score > 1, unless only match score is 1]), `AboveTwo` (exclude low scores [score > 2, unless only match score is 1 or 2]), or `HighRank` (exclude Low Ranked Scores).

You should adapt and run the following command to use it: `docker run --rm -it -v "/your/data/dir:/data" pegi3s/orthologs-finder diopt-orthologs --input_species=<input_species> --output_species=<output_species> --gene_list_file=/path/to/gene_list_file --output=/path/to/output`

Where you should replace:
- `/your/data/dir` to point to the directory that contains your input data.
- `<input_species>` and `<output_species>` with the taxonomy IDs of the input and output species (you can list the most common ones with `docker run --rm pegi3s/orthologs-finder list-species`).
- `/path/to/gene_list_file` to point to the path to the list of input gene identifiers.
- `/path/to/output` to point to the path where the output files will be created.

This script produces two TSV files:
- `/path/to/output.tsv`: the full conversion report provided by DIOPT.
- `/path/to/output.mapping.tsv`: a two-column TSV containing the gene identifiers in the input and target species.

You can use the input files in the `test_data` directory to try this command.
```sh
docker run --rm -it -v "$(pwd)/test_data:/data" -w /data pegi3s/orthologs-finder diopt-orthologs --input_species=7227 --output_species=9606 --gene_list_file=gene_list_dros_7227 --output=gene_list_dros_7227_converted

docker run --rm -it -v "$(pwd)/test_data:/data" -w /data pegi3s/orthologs-finder diopt-orthologs --input_species=10090 --output_species=9606 --gene_list_file=gene_list_mus_musculus_10090 --output=gene_list_mus_musculus_10090_converted

docker run --rm -it -v "$(pwd)/test_data:/data" -w /data pegi3s/orthologs-finder diopt-orthologs --input_species=9606 --output_species=7227 --gene_list_file=gene_list_homo_9606 --output=gene_list_homo_9606_converted
```

### Debugging

The script produces several temporary and intermediate files to create the final output. In case you obtain unexected results, you may want to inspect these temporary folder. To do so, just add `-v /tmp:/tmp` to the corresponding `docker run` command.

## `ensembl-orthologs`

The `ensembl-orthologs` has no additional parameters appart from the input and output species taxonomy IDs and the input list of gene identifiers. Note that this script requires the gene identifiers to be  NCBI Gene IDs. In case you need to map your identifiers, you may use the [UniProt ID mapping tool](https://www.uniprot.org/id-mapping/) or some other tool (e.g. [Unipressed (Uniprot REST)](https://multimeric.github.io/Unipressed/)).

You should adapt and run the following command to use it: `docker run --rm -it -v "/your/data/dir:/data" pegi3s/orthologs-finder ensembl-orthologs --input_species=<input_species> --output_species=<output_species> --gene_list_file=/path/to/gene_list_file --output=/path/to/output`

Where you should replace:
- `/your/data/dir` to point to the directory that contains your input data.
- `<input_species>` and `<output_species>` with the taxonomy IDs of the input and output species (you can list the most common ones with `docker run --rm pegi3s/orthologs-finder list-species`).
- `/path/to/gene_list_file` to point to the path to the list of input gene identifiers (NCBI Gene IDs).
- `/path/to/output` to point to the path where the output files will be created.

This script produces two TSV files:
- `/path/to/output.tsv`: the full conversion report provided by Ensembl. The first and second columns are the input gene identifier (`source_gene_id` and `source_ensenbl_id`) and the remaining ones are referred to the corresponding orthologous genes in the target species.
- `/path/to/output.mapping.tsv`: a two-column TSV containing the gene identifiers in the input (`source_gene_id`) and target species (`id`). Note that the gene identifiers on the target species may belong to different databases depending on the target species (e.g. if the target species is *Drosophila melanogaster*, these may be *FBgnXXXX* identifiers, whereas for *Mus musculus* they are Ensembl IDs).

You can use the input files in the `test_data` directory to try this command.
```sh
docker run --rm -it -v "$(pwd)/test_data:/data" -w /data pegi3s/orthologs-finder ensembl-orthologs --input_species=10090 --output_species=9606 --gene_list_file=gene_list_mus_musculus_10090 --output=gene_list_mus_musculus_10090_converted

docker run --rm -it -v "$(pwd)/test_data:/data" -w /data pegi3s/orthologs-finder ensembl-orthologs --input_species=9606 --output_species=7227 --gene_list_file=gene_list_homo_9606 --output=gene_list_homo_9606_converted

docker run --rm -it -v "$(pwd)/test_data:/data" -w /data pegi3s/orthologs-finder ensembl-orthologs --input_species=7227 --output_species=9606 --gene_list_file=gene_list_dros_7227 --output=gene_list_dros_7227_converted
```
