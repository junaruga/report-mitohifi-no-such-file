# report-mitohifi-no-such-file

Here are the reproducing steps

## Run on the non-interactive mode

```
$ docker build --rm -t mitohifi-test .

$ docker run --rm -t mitohifi-test \
  mitohifi.py -r data/generated_asm.bp.r_utg.fa -f data/ON980565.1.fasta -g data/ON980565.1.gb -t 4 -o 2
2022-10-17 15:38:28 [INFO] Welcome to MitoHifi v2. Starting pipeline...
2022-10-17 15:38:28 [INFO] Length of related mitogenome is: 16574 bp
2022-10-17 15:38:28 [INFO] Number of genes on related mitogenome: 37
2022-10-17 15:38:28 [INFO] Running MitoHifi pipeline in reads mode...
2022-10-17 15:38:28 [INFO] 1. First we map your Pacbio HiFi reads to the close-related mitogenome
2022-10-17 15:38:28 [INFO] minimap2 -t 4 --secondary=no -ax map-pb data/ON980565.1.fasta data/generated_asm.bp.r_utg.fa | samtools view -@ 4 -S -b -F4 -F 0x800 > reads.HiFiMapped.bam
2022-10-17 15:38:28 [INFO] 2. Now we filter out any mapped reads that are larger than the reference mitogenome to avoid NUMTS
2022-10-17 15:38:28 [INFO] 2.1 First we convert the mapped reads from BAM to FASTA format:
2022-10-17 15:38:28 [INFO] samtools fasta reads.HiFiMapped.bam > gbk.HiFiMapped.bam.fasta
2022-10-17 15:38:28 [INFO] Total number of mapped reads: 0
2022-10-17 15:38:28 [INFO] 2.2 Then we filter reads that are larger than 16574 bp
2022-10-17 15:38:28 [INFO] Number of filtered reads: 0
2022-10-17 15:38:28 [INFO] 3. Now let's run hifiasm to assemble the mapped and filtered reads!
2022-10-17 15:38:28 [INFO] hifiasm --primary -t 4 -f 0 -o gbk.HiFiMapped.bam.filtered.assembled gbk.HiFiMapped.bam.filtered.fasta
Traceback (most recent call last):
  File "/bin/MitoHiFi/mitohifi.py", line 139, in main
    f1 = open("gbk.HiFiMapped.bam.filtered.assembled.p_ctg.gfa")
FileNotFoundError: [Errno 2] No such file or directory: 'gbk.HiFiMapped.bam.filtered.assembled.p_ctg.gfa'

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/bin/MitoHiFi/mitohifi.py", line 143, in main
    An error may have occurred when assembling reads with HiFiasm.""")
SystemExit: No gbk.HiFiMapped.bam.filtered.assembled.[a/p]_ctg.gfa file(s).
            An error may have occurred when assembling reads with HiFiasm.

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/bin/MitoHiFi/mitohifi.py", line 377, in <module>
    main()
  File "/bin/MitoHiFi/mitohifi.py", line 145, in main
    f1.close()
UnboundLocalError: local variable 'f1' referenced before assignment
```

## Run on the interactive mode

Run the Docker container `mitohifi-test` built above on the interactive mode to debug interactively.

```
$ docker run --rm -it mitohifi-test bash

root@07fed5ecc3e3:/#
```

```
root@07fed5ecc3e3:/# minimap2 -t 4 --secondary=no -ax map-pb data/ON980565.1.fasta data/generated_asm.bp.r_utg.fa > minimap2_out.fa

root@07fed5ecc3e3:/# wc -l minimap2_out.fa
65 minimap2_out.fa

root@07fed5ecc3e3:/# ls -lh minimap2_out.fa
-rw-r--r--. 1 root root 3.7M Oct 17 15:43 minimap2_out.fa

root@07fed5ecc3e3:/# cat minimap2_out.fa | samtools view -@ 4 -S -b -F4 -F 0x800 > out.bam

root@07fed5ecc3e3:/# ls -lh out.bam
-rw-r--r--. 1 root root 211 Oct 17 15:46 out.bam
```

