From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: mdcheck: slow system issues
Date: Mon, 30 Mar 2020 14:18:30 +0200
Message-ID: <2933dddc-8728-51ac-1c60-8a47874966e4@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Linux folks,


When `mdcheck` runs on two 100 TB software RAIDs our users complain 
about being unable to open files in a reasonable time.

> $ uname -a
> Linux handsomejack.molgen.mpg.de 4.19.57.mx64.276 #1 SMP Wed Jul 3 15:15:22 CEST 2019 x86_64 GNU/Linux

> $ more /proc/mdstat 
> Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] [multipath] 
> md1 : active raid6 sdab[0] sdac[15] sdad[14] sdae[13] sdag[12] sdah[11] sdaf[10] sdai[9] sdu[8] sdt[7] sdv[6] sdw[5] sdx[4] sdy[3] sdaa[2] sdz[1]
>       109394518016 blocks super 1.2 level 6, 512k chunk, algorithm 2 [16/16] [UUUUUUUUUUUUUUUU]
>       bitmap: 0/59 pages [0KB], 65536KB chunk
> 
> md0 : active raid6 sde[0] sds[15] sdr[14] sdp[13] sdq[12] sdo[11] sdn[10] sdl[9] sdm[8] sdk[7] sdj[6] sdh[5] sdi[4] sdg[3] sdf[2] sdd[1]
>       109394532352 blocks super 1.2 level 6, 512k chunk, algorithm 2 [16/16] [UUUUUUUUUUUUUUUU]
>       bitmap: 2/59 pages [8KB], 65536KB chunk
> 
> unused devices: <none>

> $ lspci -nn | grep -i RAID
> 03:00.0 RAID bus controller [0104]: Broadcom / LSI MegaRAID SAS-3 3108 [Invader] [1000:005d] (rev 02)

> $ sysctl dev.raid.speed_limit_min
> dev.raid.speed_limit_min = 1000
> $ sysctl dev.raid.speed_limit_max
> dev.raid.speed_limit_max = 200000

> $ more /etc/cron.d/mdcheck
> 0 18 * * Fri              root /usr/bin/mdcheck --duration "Mon 06:00"
> 0 18 * * Mon,Tue,Wed,Thu  root /usr/bin/mdcheck --continue --duration "Tomorrow 06:00"

> $ dmesg | tail -4
> [Fri Mar 27 17:58:58 2020] md: data-check of RAID array md1
> [Fri Mar 27 17:58:58 2020] md: data-check of RAID array md0
> [Sat Mar 28 18:50:20 2020] md: md1: data-check done.
> [Sat Mar 28 22:33:33 2020] md: md0: data-check done.

During that time only four threads of the CPU are used.

The article *Software RAID check - slow system issues* [1] recommends to 
lower `dev.raid.speed_limit_max`, but the RAID should easily be able to 
do 200 MB/s as our tests show over 600 MB/s during some benchmarks.

How do you run `mdcheck` in production without noticeably affecting the 
system?


Kind regards,

Paul


[1]: 
https://www.alttechnical.com/knowledge-base/linux/126-software-raid-check-slow-system-issues


PS: Details:

> $ sudo mdadm -D /dev/md0
> /dev/md0:
>            Version : 1.2
>      Creation Time : Mon Jul 30 11:44:29 2018
>         Raid Level : raid6
>         Array Size : 109394532352 (104326.76 GiB 112020.00 GB)
>      Used Dev Size : 7813895168 (7451.91 GiB 8001.43 GB)
>       Raid Devices : 16
>      Total Devices : 16
>        Persistence : Superblock is persistent
> 
>      Intent Bitmap : Internal
> 
>        Update Time : Mon Mar 30 13:51:44 2020
>              State : active 
>     Active Devices : 16
>    Working Devices : 16
>     Failed Devices : 0
>      Spare Devices : 0
> 
>             Layout : left-symmetric
>         Chunk Size : 512K
> 
> Consistency Policy : bitmap
> 
>               Name : M8015
>               UUID : 0569ef24:5868e228:ca17105b:ba673204
>             Events : 446871
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       64        0      active sync   /dev/sde
>        1       8       48        1      active sync   /dev/sdd
>        2       8       80        2      active sync   /dev/sdf
>        3       8       96        3      active sync   /dev/sdg
>        4       8      128        4      active sync   /dev/sdi
>        5       8      112        5      active sync   /dev/sdh
>        6       8      144        6      active sync   /dev/sdj
>        7       8      160        7      active sync   /dev/sdk
>        8       8      192        8      active sync   /dev/sdm
>        9       8      176        9      active sync   /dev/sdl
>       10       8      208       10      active sync   /dev/sdn
>       11       8      224       11      active sync   /dev/sdo
>       12      65        0       12      active sync   /dev/sdq
>       13       8      240       13      active sync   /dev/sdp
>       14      65       16       14      active sync   /dev/sdr
>       15      65       32       15      active sync   /dev/sds

> $ sudo mdadm -D /dev/md1
> /dev/md1:
>            Version : 1.2
>      Creation Time : Wed Mar  6 13:56:48 2019
>         Raid Level : raid6
>         Array Size : 109394518016 (104326.74 GiB 112019.99 GB)
>      Used Dev Size : 7813894144 (7451.91 GiB 8001.43 GB)
>       Raid Devices : 16
>      Total Devices : 16
>        Persistence : Superblock is persistent
> 
>      Intent Bitmap : Internal
> 
>        Update Time : Mon Mar 30 03:49:21 2020
>              State : clean 
>     Active Devices : 16
>    Working Devices : 16
>     Failed Devices : 0
>      Spare Devices : 0
> 
>             Layout : left-symmetric
>         Chunk Size : 512K
> 
> Consistency Policy : bitmap
> 
>               Name : M8027
>               UUID : fdb36dce:6e2dfdaa:853cb1a1:402a9a9a
>             Events : 48917
> 
>     Number   Major   Minor   RaidDevice State
>        0      65      176        0      active sync   /dev/sdab
>        1      65      144        1      active sync   /dev/sdz
>        2      65      160        2      active sync   /dev/sdaa
>        3      65      128        3      active sync   /dev/sdy
>        4      65      112        4      active sync   /dev/sdx
>        5      65       96        5      active sync   /dev/sdw
>        6      65       80        6      active sync   /dev/sdv
>        7      65       48        7      active sync   /dev/sdt
>        8      65       64        8      active sync   /dev/sdu
>        9      66       32        9      active sync   /dev/sdai
>       10      65      240       10      active sync   /dev/sdaf
>       11      66       16       11      active sync   /dev/sdah
>       12      66        0       12      active sync   /dev/sdag
>       13      65      224       13      active sync   /dev/sdae
>       14      65      208       14      active sync   /dev/sdad
>       15      65      192       15      active sync   /dev/sdac

> $ lscpu
> Architecture:                    x86_64
> CPU op-mode(s):                  32-bit, 64-bit
> Byte Order:                      Little Endian
> Address sizes:                   46 bits physical, 48 bits virtual
> CPU(s):                          12
> On-line CPU(s) list:             0-11
> Thread(s) per core:              1
> Core(s) per socket:              6
> Socket(s):                       2
> NUMA node(s):                    2
> Vendor ID:                       GenuineIntel
> CPU family:                      6
> Model:                           79
> Model name:                      Intel(R) Xeon(R) CPU E5-2603 v4 @ 1.70GHz
> Stepping:                        1
> CPU MHz:                         1698.649
> CPU max MHz:                     1700.0000
> CPU min MHz:                     1200.0000
> BogoMIPS:                        3396.26
> Virtualization:                  VT-x
> L1d cache:                       384 KiB
> L1i cache:                       384 KiB
> L2 cache:                        3 MiB
> L3 cache:                        30 MiB
> NUMA node0 CPU(s):               0,2,4,6,8,10
> NUMA node1 CPU(s):               1,3,5,7,9,11
> Vulnerability L1tf:              Mitigation; PTE Inversion; VMX conditional cache flushes, SMT disabled
> Vulnerability Mds:               Vulnerable: Clear CPU buffers attempted, no microcode; SMT disabled
> Vulnerability Meltdown:          Mitigation; PTI
> Vulnerability Spec store bypass: Vulnerable
> Vulnerability Spectre v1:        Mitigation; __user pointer sanitization
> Vulnerability Spectre v2:        Mitigation; Full generic retpoline, STIBP disabled, RSB filling
> Flags:                           fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm p
>                                  be syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmpe
>                                  rf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic mo
>                                  vbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch cpuid_fault epb cat_l3 cdp_l3 invpc
>                                  id_single pti tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid r
>                                  tm cqm rdt_a rdseed adx smap intel_pt xsaveopt cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local dtherm arat pln pts
