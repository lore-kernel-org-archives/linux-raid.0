From: Richard Mittendorfer <delist@gmx.net>
Subject: mdraid0 worries on 2.6
Date: Tue, 7 Feb 2006 01:12:20 +0100
Message-ID: <20060207011220.711e2424.delist@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I do have _great_ performance troubles with software raid0 with 2.6.12
to .15. I have not tried earlier 2.6's, but 2.4 (tested up to 2.4.24) do
it right.

In fact, mdraid0 over 2 rather old 9G scsi disks here in my home server
show same throughput as a single drive. I did try to tune readahead,
tune various proc settings, used reiserfs and xfs or mdadm with
different
settings -- nothing helped. I'm clueless.

=====================================

0000:01:00.0 SCSI storage controller: Adaptec AIC-7861 (rev 03)

scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
aic7860: Ultra Single Channel A, SCSI Id=7, 3/253 SCBs

Vendor: IBM Model: DDRS-34560 Rev: S97B
Type: Direct-Access ANSI SCSI revision: 02
scsi0:A:0:0: Tagged Queuing enabled. Depth 64
target0:0:0: Beginning Domain Validation
target0:0:0: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 15)
target0:0:0: Domain Validation skipping write tests
target0:0:0: Ending Domain Validation
Vendor: IBM Model: DNES-309170 Rev: SA30
Type: Direct-Access ANSI SCSI revision: 03
scsi0:A:1:0: Tagged Queuing enabled. Depth 80
target0:0:1: Beginning Domain Validation
target0:0:1: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 15)
target0:0:1: Domain Validation skipping write tests
target0:0:1: Ending Domain Validation
Vendor: IBM Model: DNES-309170 Rev: SA30
Type: Direct-Access ANSI SCSI revision: 03
scsi0:A:2:0: Tagged Queuing enabled. Depth 80
target0:0:2: Beginning Domain Validation
target0:0:2: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 15)
target0:0:2: Domain Validation skipping write tests
target0:0:2: Ending Domain Validation

=====================================

md4 : active raid0 sdc8[1] sdb8[0]
9542400 blocks 64k chunks

/dev/md4 /home xfs rw,noatime,logbufs=8,sunit=128,swidth=256

/dev/sdc8:
Timing cached reads: 340 MB in 2.00 seconds = 170.00 MB/sec
Timing buffered disk reads: 56 MB in 3.12 seconds = 17.95 MB/sec

/dev/sdb8:
Timing cached reads: 344 MB in 2.01 seconds = 171.14 MB/sec
Timing buffered disk reads: 54 MB in 3.01 seconds = 17.94 MB/sec

/dev/md4:
Timing cached reads: 344 MB in 2.01 seconds = 171.14 MB/sec
Timing buffered disk reads: 50 MB in 3.07 seconds = 16.29 MB/sec

=====================================

short vmstat 1 output running sequential writes with tiotest -f64 on
2.6.15(-cks3):

 3 0 61020 52928 2132 125236 0  0 0     0 163  403 0  0 100   0
 2 0 61020 53348 2132 125236 0  0 0    11 157  406 0  0 100   0
13 0 61020 10868 2132 167020 0  0 8 47093 157  376 1 63  36   0
 2 3 61020  3716 2116 172980 0 84 0 63761 163 1982 3 71   0  26
 3 3 61020  2500 2116 174176 0  0 0 17980 161 1179 0 30   0  70
 2 3 61020  2404 2116 174252 0  0 0  6694 155  686 0 10   0  90 X
 2 3 61020  2404 2116 174252 0  0 0     0 168  413 0  0   0 100 X
 3 2 61020  2228 2116 174260 0  0 0     0 162  425 0  0   0 100 X disk
 3 2 61020  2600 2120 174260 0  0 4     0 150  407 0  0   0 100 X use
 2 2 61020  3264 2120 175196 0  0 0  5283 158  423 1  1  21  77 X
 2 1 61020  3752 2120 174004 0  0 8 42110 177 2036 0 64   0  36
 3 0 61020  3752 2120 174004 0  0 0     5 161  399 0  0  65  35


Tiotest results for 4 concurrent io threads:
,-----------------------------------------------------------------.
| Item                |  Time   |   Rate      | Usr CPU | Sys CPU |
+---------------------+---------+-------------+---------+---------+
| Write 256 MBs       | 15.4 s  | 16.648 MB/s |  3.1 %  |  83.9 % |
| Random Write 16 MBs | 11.1 s  |  1.413 MB/s |  0.2 %  |   6.6 % |
| Read 256 MBs        | 19.4 s  | 13.166 MB/s |  0.9 %  |  28.6 % |
| Random Read 16 MBs  |  5.7 s  |  2.731 MB/s |  0.0 %  |  20.3 % |
`-----------------------------------------------------------------'
Tiotest latency results:
,------------------------------------------------------------------.
| Item        |Average latency |Maximum latency |% >2 sec |% >10 sec |
+-------------+----------------+----------------+---------+----------+
| Write       |       0.539 ms |    6917.495 ms | 0.00763 |  0.00000 |
| Random Write|       0.135 ms |      71.025 ms | 0.00000 |  0.00000 |
| Read        |       0.997 ms |    1478.135 ms | 0.00000 |  0.00000 |
| Random Read |       5.131 ms |      44.875 ms | 0.00000 |  0.00000 |
|-------------+----------------+----------------+---------+----------|
| Total       |       0.875 ms |    6917.495 ms | 0.00360 |  0.00000 |
`-------------+----------------+----------------+---------+----------' 

ritch
