workflow gcStats {

    File inputSamplesFile

    Array[Array[String]] inputSamples = read_tsv(inputSamplesFile)
    #scatter the list of inputs to process them individually
    scatter (sample in inputSamples) {
     call samtools_stats_tool {
       input:
         filein=sample[0],
         filename=sample[1]
       }
     }

     scatter (statout in samtools_stats_tool.statsout) {
      call grep_tool {
        input:
          grepin = statout
      }
     }

     scatter (grepped in grep_tool.grepout) {
       call cut_tool {
            input:
              cutin = grepped
       }
     }

     call cat_tool {
       input:
         filesin = cut_tool.cuttoolout
     }

}
# end workflow
#this task use sammtools to produce stats from bam files
task samtools_stats_tool {
    File filein
    String filename

    runtime {
      docker: "gcr.io/genomics-tools/samtools"
    }
    command {
        samtools stats ${filein} > ${filename}_gc_stats.txt
    }
    output {
         File statsout = "${filename}_gc_stats.txt"
    }
}

#this task grab the GCF line out of the stat files.
task grep_tool {
    File grepin

    runtime {
      docker: "gcr.io/genomics-tools/samtools"
    }

    command {
        grep --with-filename '^GCF' ${grepin} > grep_out.txt
    }

    output {
        File grepout = "grep_out.txt"
    }
}

task cut_tool {
    File cutin

    runtime {
      docker: "gcr.io/genomics-tools/samtools"
    }

    command {
      cut -d '/' -f 9- ${cutin} > cut_out.txt
    }

    output {
        File cuttoolout = "cut_out.txt"
    }

}


task cat_tool {
    Array[File] filesin

    runtime {
      docker: "gcr.io/genomics-tools/samtools"
    }

    command {
        cat ${sep=" " filesin} > final_gc_stats_out.txt
    }

    output {
        File finalfile = "final_gc_stats_out.txt"
    }
}
