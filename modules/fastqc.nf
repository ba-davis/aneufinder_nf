process FASTQC {
    
    conda "${projectDir}/envs/fastqc.yml"

    tag "$sample"

    publishDir "${params.outdir}/fastqc", mode: 'copy'

    input:
    tuple val(sample), path(reads)

    output:
    path "*.html", emit: html
    path "*.zip", emit: zip

    script:
    """
    fastqc \
        --threads ${task.cpus} \
        ${reads[0]} \
        ${reads[1]}
    """

    stub:
    """
    touch ${sample}_R1_fastqc.html
    touch ${sample}_R1_fastqc.zip
    touch ${sample}_R2_fastqc.html
    touch ${sample}_R2_fastqc.zip
    """
}
