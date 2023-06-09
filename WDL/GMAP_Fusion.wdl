version 1.0


workflow gmap_fusion_wf {

    input {
       String sample_name
       File transcripts
       File genome_lib_tar
       Int min_per_id=90
       
      
       String docker="trinityctat/gmapfusion:latest"
       Int cpu = 10
       String memory="50G"
       Int preemptible = 0
       Int maxRetries = 0
       Float disk_space_multiplier = 3.0

      
     }
    
     call GMAP_FUSION_TASK {
        input:
          sample_name=sample_name,
          transcripts=transcripts,
          genome_lib_tar=genome_lib_tar,
          min_per_id=min_per_id,
          docker=docker,
          cpu=cpu,
          memory=memory,
          preemptible=preemptible,
	      maxRetries=maxRetries,
          disk_space_multiplier=disk_space_multiplier    
     }
}


task GMAP_FUSION_TASK {

    input {
       String sample_name
       File transcripts
       File genome_lib_tar
       Int min_per_id
    
       String docker
       Int cpu
       String memory
       Int preemptible
       Int maxRetries
       Float disk_space_multiplier
  }

  Int disk_space = ceil(size(genome_lib_tar, "GB") * disk_space_multiplier)
  
  command <<<

    set -ex

    # untar the genome lib
    tar xvf ~{genome_lib_tar}
    rm ~{genome_lib_tar}
    
    # GMAP-Fusion
    GMAP-fusion --version

    GMAP-fusion -T ~{transcripts} \
                --genome_lib_dir GRCh38_gencode_v22_CTAT_lib_Mar012021.gmap_fusion_only/ctat_genome_lib_build_dir \
                -min_J 1  --min_sumJS 1 \
                --min_per_id ~{min_per_id} \
                -o gmap_fusion_outdir


    mv gmap_fusion_outdir/GMAP-fusion.fusion_predictions.tsv ~{sample_name}.GMAP-fusion.fusion_predictions.tsv 

    >>>
    
    output {
      File fusion_report="~{sample_name}.GMAP-fusion.fusion_predictions.tsv"
    }
    

    runtime {
            docker: "~{docker}"
            disks: "local-disk " + disk_space + " HDD"
            memory: "~{memory}"
            cpu: cpu
            preemptible: preemptible
            maxRetries: maxRetries
    }
}

