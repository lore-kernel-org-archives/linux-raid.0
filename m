From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: read errors not corrected when doing check on RAID6
Date: Thu, 16 Jan 2014 10:38:54 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1401161031430.20074@uplift.swm.pp.se>
References: <alpine.DEB.2.02.1401120723010.20074@uplift.swm.pp.se> <20140116095900.6861234c@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140116095900.6861234c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 16 Jan 2014, NeilBrown wrote:

> To check this you can looked for "end_request: I/O error" in the kernel 
> logs. In the fragments you included there is just one error during the 
> 'check', but 3 for each block during the 'replace'.  Given the 
> timestamps, the 2nd and 3rd are probably for the same request - some 
> logging weirdness maybe. Obviously you only provided fragments so we 
> can't read too much into what we see.  Looking at the complete logs 
> could be more helpful.

Sure, here it is. I cut off the boot stuff, I don't think there was that 
much interesting there

[  103.321478] md: md0 stopped.
[  103.326136] md: bind<sdh>
[  103.326481] md: bind<sdj>
[  103.326678] md: bind<sdd>
[  103.326921] md: bind<sds>
[  103.327120] md: bind<sdv>
[  103.327295] md: bind<sdb>
[  103.327466] md: bind<sdc>
[  103.327639] md: bind<sdf>
[  103.327850] md: bind<sde>
[  103.328076] md: bind<sdk>
[  103.328251] md: bind<sdn>
[  103.403226] async_tx: api initialized (async)
[  103.404441] xor: measuring software checksum speed
[  103.444005]    prefetch64-sse:  9607.000 MB/sec
[  103.484002]    generic_sse:  8565.000 MB/sec
[  103.484055] xor: using function: prefetch64-sse (9607.000 MB/sec)
[  103.552005] raid6: sse2x1    4263 MB/s
[  103.620015] raid6: sse2x2    5114 MB/s
[  103.688011] raid6: sse2x4    7205 MB/s
[  103.688063] raid6: using algorithm sse2x4 (7205 MB/s)
[  103.688116] raid6: using ssse3x2 recovery algorithm
[  103.688936] w83627ehf: Found W83627DHG chip at 0x290
[  103.689018] ACPI Warning: 0x0000000000000295-0x0000000000000296 SystemIO conflicts with Region \_SB_.PCI0.SBRG.SIOR.HWRE 1 (20130517/utaddress-251)
[  103.689172] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[  103.696793] md: raid6 personality registered for level 6
[  103.696854] md: raid5 personality registered for level 5
[  103.696910] md: raid4 personality registered for level 4
[  103.697351] md/raid:md0: device sdn operational as raid disk 0
[  103.697408] md/raid:md0: device sde operational as raid disk 9
[  103.697464] md/raid:md0: device sdf operational as raid disk 8
[  103.697520] md/raid:md0: device sdc operational as raid disk 7
[  103.697575] md/raid:md0: device sdb operational as raid disk 6
[  103.697631] md/raid:md0: device sdv operational as raid disk 5
[  103.697687] md/raid:md0: device sds operational as raid disk 4
[  103.697742] md/raid:md0: device sdd operational as raid disk 3
[  103.699136] md/raid:md0: device sdj operational as raid disk 2
[  103.699191] md/raid:md0: device sdh operational as raid disk 1
[  103.699925] md/raid:md0: allocated 10674kB
[  103.700000] md/raid:md0: raid level 6 active with 10 out of 10 devices, algorithm 2
[  103.700081] RAID conf printout:
[  103.700083]  --- level:6 rd:10 wd:10
[  103.700085]  disk 0, o:1, dev:sdn
[  103.700086]  disk 1, o:1, dev:sdh
[  103.700088]  disk 2, o:1, dev:sdj
[  103.700089]  disk 3, o:1, dev:sdd
[  103.700091]  disk 4, o:1, dev:sds
[  103.700092]  disk 5, o:1, dev:sdv
[  103.700094]  disk 6, o:1, dev:sdb
[  103.700095]  disk 7, o:1, dev:sdc
[  103.700097]  disk 8, o:1, dev:sdf
[  103.700098]  disk 9, o:1, dev:sde
[  103.700233] created bitmap (15 pages) for device md0
[  103.700714] md0: bitmap initialized from disk: read 1 pages, set 0 of 29809 bits
[  103.785552] md0: detected capacity change from 0 to 16003178168320
[  103.785641] RAID conf printout:
[  103.785644]  --- level:6 rd:10 wd:10
[  103.785646]  disk 0, o:1, dev:sdn
[  103.785648]  disk 1, o:1, dev:sdh
[  103.785650]  disk 2, o:1, dev:sdj
[  103.785651]  disk 3, o:1, dev:sdd
[  103.785653]  disk 4, o:1, dev:sds
[  103.785655]  disk 5, o:1, dev:sdv
[  103.785657]  disk 6, o:1, dev:sdb
[  103.785658]  disk 7, o:1, dev:sdc
[  103.785660]  disk 8, o:1, dev:sdf
[  103.785662]  disk 9, o:1, dev:sde
[  103.791690]  md0: unknown partition table
[  104.031804] md: md2 stopped.
[  104.035115] md: bind<sdm>
[  104.035312] md: bind<sdo>
[  104.035483] md: bind<sdp>
[  104.035661] md: bind<sdq>
[  104.035879] md: bind<sdw>
[  104.036102] md: bind<sdu>
[  104.036281] md: bind<sdl>
[  104.139144] md/raid:md2: device sdl operational as raid disk 0
[  104.139205] md/raid:md2: device sdu operational as raid disk 6
[  104.139262] md/raid:md2: device sdw operational as raid disk 5
[  104.139318] md/raid:md2: device sdq operational as raid disk 4
[  104.139374] md/raid:md2: device sdp operational as raid disk 3
[  104.139430] md/raid:md2: device sdo operational as raid disk 2
[  104.139486] md/raid:md2: device sdm operational as raid disk 1
[  104.140104] md/raid:md2: allocated 7506kB
[  104.141433] md/raid:md2: raid level 6 active with 7 out of 7 devices, algorithm 2
[  104.141514] RAID conf printout:
[  104.141515]  --- level:6 rd:7 wd:7
[  104.141517]  disk 0, o:1, dev:sdl
[  104.141519]  disk 1, o:1, dev:sdm
[  104.141521]  disk 2, o:1, dev:sdo
[  104.141523]  disk 3, o:1, dev:sdp
[  104.141524]  disk 4, o:1, dev:sdq
[  104.141526]  disk 5, o:1, dev:sdw
[  104.141528]  disk 6, o:1, dev:sdu
[  104.141658] created bitmap (22 pages) for device md2
[  104.142227] md2: bitmap initialized from disk: read 2 pages, set 0 of 44713 bits
[  104.284166] md2: detected capacity change from 0 to 15002958888960
[  104.320646]  md2: unknown partition table
[  114.003127] Adding 3905528k swap on /dev/mapper/swap.  Priority:-1 extents:1 across:3905528k SS
[  114.118236] EXT4-fs (sdr1): mounting ext2 file system using the ext4 subsystem
[  114.119773] EXT4-fs (sdr1): mounted filesystem without journal. Opts: (null)
[  114.151684] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[  114.152897] XFS (dm-5): Mounting Filesystem
[  114.673690] XFS (dm-5): Ending clean mount
[  114.685733] XFS (dm-4): Mounting Filesystem
[  115.508942] XFS (dm-4): Ending clean mount
[  116.233038] RPC: Registered named UNIX socket transport module.
[  116.233115] RPC: Registered udp transport module.
[  116.233170] RPC: Registered tcp transport module.
[  116.233226] RPC: Registered tcp NFSv4.1 backchannel transport module.
[  116.239399] FS-Cache: Loaded
[  116.254219] FS-Cache: Netfs 'nfs' registered for caching
[  116.269545] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[  116.366618] fuse init (API version 7.22)
[  117.208184] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[  117.208705] NFSD: starting 90-second grace period (net ffffffff81882080)
[  117.507070] ip_tables: (C) 2000-2006 Netfilter Core Team
[  117.519316] ip6_tables: (C) 2000-2006 Netfilter Core Team
[  117.542465] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)

Here I started the check:

[  569.034227] RAID conf printout:
[  569.034233]  --- level:6 rd:10 wd:10
[  569.034236]  disk 0, o:1, dev:sdn
[  569.034238]  disk 1, o:1, dev:sdh
[  569.034241]  disk 2, o:1, dev:sdj
[  569.034243]  disk 3, o:1, dev:sdd
[  569.034245]  disk 4, o:1, dev:sds
[  569.034248]  disk 5, o:1, dev:sdv
[  569.034250]  disk 6, o:1, dev:sdb
[  569.034252]  disk 7, o:1, dev:sdc
[  569.034254]  disk 8, o:1, dev:sdf
[  569.034257]  disk 9, o:1, dev:sde
[  569.034292] md: data-check of RAID array md0
[  569.034337] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  569.034384] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[  569.034440] md: using 128k window, over a total of 1953512960k.
[  569.520326] md: data-check of RAID array md2
[  569.520379] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  569.520427] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[  569.520488] md: using 128k window, over a total of 2930265408k.
[  662.413059] perf samples too long (2504 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[  714.577123] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  714.577187] ata13.01: failed command: READ DMA EXT
[  714.577245] ata13.01: cmd 25/00:00:58:3a:7c/00:04:00:00:00/f0 tag 0 dma 524288 in
[  714.577245]          res 51/40:28:30:3c:7c/40:02:00:00:00/f0 Emask 0x9 (media error)
[  714.577330] ata13.01: status: { DRDY ERR }
[  714.577381] ata13.01: error: { UNC }
[  714.796272] ata13.00: configured for UDMA/133
[  714.804347] ata13.01: configured for UDMA/133
[  714.804767] sd 13:0:1:0: [sds] Unhandled sense code
[  714.804887] sd 13:0:1:0: [sds] 
[  714.804988] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  714.805094] sd 13:0:1:0: [sds] 
[  714.805194] Sense Key : Medium Error [current] [descriptor]
[  714.805491] Descriptor sense data with sense descriptors (in hex):
[  714.805665]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[  714.806845]         00 7c 3c 30 
[  714.807257] sd 13:0:1:0: [sds] 
[  714.807357] Add. Sense: Unrecovered read error - auto reallocate failed
[  714.807531] sd 13:0:1:0: [sds] CDB: 
[  714.807632] Read(10): 28 00 00 7c 3a 58 00 04 00 00
[  714.808494] end_request: I/O error, dev sds, sector 8141872
[  714.808638] ata13: EH complete
[  868.240036] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  868.240113] ata13.01: failed command: READ DMA EXT
[  868.240183] ata13.01: cmd 25/00:00:18:49:f5/00:04:00:00:00/f0 tag 0 dma 524288 in
[  868.240183]          res 51/40:f8:20:49:f5/40:03:00:00:00/f0 Emask 0x9 (media error)
[  868.240312] ata13.01: status: { DRDY ERR }
[  868.240374] ata13.01: error: { UNC }
[  868.456254] ata13.00: configured for UDMA/133
[  868.464333] ata13.01: configured for UDMA/133
[  868.464754] sd 13:0:1:0: [sds] Unhandled sense code
[  868.464812] sd 13:0:1:0: [sds] 
[  868.464866] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  868.464924] sd 13:0:1:0: [sds] 
[  868.464978] Sense Key : Medium Error [current] [descriptor]
[  868.465135] Descriptor sense data with sense descriptors (in hex):
[  868.465226]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[  868.465848]         00 f5 49 20 
[  868.466068] sd 13:0:1:0: [sds] 
[  868.466123] Add. Sense: Unrecovered read error - auto reallocate failed
[  868.466215] sd 13:0:1:0: [sds] CDB: 
[  868.466269] Read(10): 28 00 00 f5 49 18 00 04 00 00
[  868.466729] end_request: I/O error, dev sds, sector 16075040
[  868.466884] ata13: EH complete
[ 1095.166247] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[ 1095.166327] ata13.01: failed command: READ DMA EXT
[ 1095.166400] ata13.01: cmd 25/00:00:10:a4:ad/00:04:01:00:00/f0 tag 0 dma 524288 in
[ 1095.166400]          res 51/40:30:e0:a4:ad/40:03:01:00:00/f0 Emask 0x9 (media error)
[ 1095.166546] ata13.01: status: { DRDY ERR }
[ 1095.166612] ata13.01: error: { UNC }
[ 1095.388269] ata13.00: configured for UDMA/133
[ 1095.396331] ata13.01: configured for UDMA/133
[ 1095.396938] sd 13:0:1:0: [sds] Unhandled sense code
[ 1095.397004] sd 13:0:1:0: [sds] 
[ 1095.397064] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 1095.397129] sd 13:0:1:0: [sds] 
[ 1095.397190] Sense Key : Medium Error [current] [descriptor]
[ 1095.397370] Descriptor sense data with sense descriptors (in hex):
[ 1095.397473]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 1095.398154]         01 ad a4 e0 
[ 1095.399853] sd 13:0:1:0: [sds] 
[ 1095.399910] Add. Sense: Unrecovered read error - auto reallocate failed
[ 1095.400019] sd 13:0:1:0: [sds] CDB: 
[ 1095.400079] Read(10): 28 00 01 ad a4 10 00 04 00 00
[ 1095.400603] end_request: I/O error, dev sds, sector 28157152
[ 1095.400736] ata13: EH complete
[ 1119.195283] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[ 1119.195363] ata13.01: failed command: READ DMA EXT
[ 1119.195436] ata13.01: cmd 25/00:00:50:c6:be/00:04:01:00:00/f0 tag 0 dma 524288 in
[ 1119.195436]          res 51/40:40:10:c9:be/40:01:01:00:00/f0 Emask 0x9 (media error)
[ 1119.195583] ata13.01: status: { DRDY ERR }
[ 1119.195654] ata13.01: error: { UNC }
[ 1119.416277] ata13.00: configured for UDMA/133
[ 1119.424349] ata13.01: configured for UDMA/133
[ 1119.424803] sd 13:0:1:0: [sds] Unhandled sense code
[ 1119.424874] sd 13:0:1:0: [sds] 
[ 1119.424940] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 1119.425013] sd 13:0:1:0: [sds] 
[ 1119.425081] Sense Key : Medium Error [current] [descriptor]
[ 1119.425284] Descriptor sense data with sense descriptors (in hex):
[ 1119.425399]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 1119.426181]         01 be c9 10 
[ 1119.426431] sd 13:0:1:0: [sds] 
[ 1119.426492] Add. Sense: Unrecovered read error - auto reallocate failed
[ 1119.426595] sd 13:0:1:0: [sds] CDB: 
[ 1119.426654] Read(10): 28 00 01 be c6 50 00 04 00 00
[ 1119.427166] end_request: I/O error, dev sds, sector 29280528
[ 1119.427272] ata13: EH complete
[45411.209327] md: md0: data-check done.
[45412.147602] RAID conf printout:
[45412.147609]  --- level:6 rd:10 wd:10
[45412.147612]  disk 0, o:1, dev:sdn
[45412.147614]  disk 1, o:1, dev:sdh
[45412.147617]  disk 2, o:1, dev:sdj
[45412.147620]  disk 3, o:1, dev:sdd
[45412.147623]  disk 4, o:1, dev:sds
[45412.147625]  disk 5, o:1, dev:sdv
[45412.147628]  disk 6, o:1, dev:sdb
[45412.147631]  disk 7, o:1, dev:sdc
[45412.147634]  disk 8, o:1, dev:sdf
[45412.147636]  disk 9, o:1, dev:sde
[58772.330150] md: md2: data-check done.

Here I started the replace:

[74791.213852] RAID conf printout:
[74791.213858]  --- level:6 rd:10 wd:10
[74791.213861]  disk 0, o:1, dev:sdn
[74791.213864]  disk 1, o:1, dev:sdh
[74791.213866]  disk 2, o:1, dev:sdj
[74791.213869]  disk 3, o:1, dev:sdd
[74791.213871]  disk 4, o:1, dev:sds
[74791.213874]  disk 5, o:1, dev:sdv
[74791.213876]  disk 6, o:1, dev:sdb
[74791.213879]  disk 7, o:1, dev:sdc
[74791.213881]  disk 8, o:1, dev:sdf
[74791.213884]  disk 9, o:1, dev:sde
[74791.252331] md: recovery of RAID array md0
[74791.252371] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[74791.252405] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[74791.252466] md: using 128k window, over a total of 1953512960k.
[74872.590157] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[74872.590193] ata13.01: failed command: READ DMA EXT
[74872.590226] ata13.01: cmd 25/00:00:38:fd:7b/00:04:00:00:00/f0 tag 0 dma 524288 in
[74872.590226]          res 51/40:48:f0:fe:7b/40:02:00:00:00/f0 Emask 0x9 (media error)
[74872.590315] ata13.01: status: { DRDY ERR }
[74872.590341] ata13.01: error: { UNC }
[74872.820239] ata13.00: configured for UDMA/133
[74872.828258] ata13.01: configured for UDMA/133
[74872.828571] sd 13:0:1:0: [sds] Unhandled sense code
[74872.828601] sd 13:0:1:0: [sds] 
[74872.828624] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[74872.828652] sd 13:0:1:0: [sds] 
[74872.828675] Sense Key : Medium Error [current] [descriptor]
[74872.828710] Descriptor sense data with sense descriptors (in hex):
[74872.828753]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[74872.828816]         00 7b fe f0 
[74872.828850] sd 13:0:1:0: [sds] 
[74872.828874] Add. Sense: Unrecovered read error - auto reallocate failed
[74872.828904] sd 13:0:1:0: [sds] CDB: 
[74872.828928] Read(10): 28 00 00 7b fd 38 00 04 00 00
[74872.828979] end_request: I/O error, dev sds, sector 8126192
[74872.829055] ata13: EH complete
[74877.699161] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[74877.699197] ata13.01: failed command: READ DMA
[74877.699228] ata13.01: cmd c8/00:08:f0:fe:7b/00:00:00:00:00/f0 tag 0 dma 4096 in
[74877.699228]          res 51/40:08:f0:fe:7b/40:02:00:00:00/f0 Emask 0x9 (media error)
[74877.699317] ata13.01: status: { DRDY ERR }
[74877.699342] ata13.01: error: { UNC }
[74877.928227] ata13.00: configured for UDMA/133
[74877.936278] ata13.01: configured for UDMA/133
[74877.936317] sd 13:0:1:0: [sds] Unhandled sense code
[74877.936343] sd 13:0:1:0: [sds] 
[74877.936367] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[74877.936395] sd 13:0:1:0: [sds] 
[74877.936417] Sense Key : Medium Error [current] [descriptor]
[74877.936450] Descriptor sense data with sense descriptors (in hex):
[74877.936479]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[74877.936541]         00 7b fe f0 
[74877.936573] sd 13:0:1:0: [sds] 
[74877.936597] Add. Sense: Unrecovered read error - auto reallocate failed
[74877.936628] sd 13:0:1:0: [sds] CDB: 
[74877.936651] Read(10): 28 00 00 7b fe f0 00 00 08 00
[74877.936701] end_request: I/O error, dev sds, sector 8126192
[74877.936730] end_request: I/O error, dev sds, sector 8126192
[74877.936771] ata13: EH complete
[74884.058379] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[74884.058416] ata13.01: failed command: READ DMA EXT
[74884.058447] ata13.01: cmd 25/00:00:38:39:7c/00:04:00:00:00/f0 tag 0 dma 524288 in
[74884.058447]          res 51/40:08:30:3c:7c/40:01:00:00:00/f0 Emask 0x9 (media error)
[74884.058535] ata13.01: status: { DRDY ERR }
[74884.058561] ata13.01: error: { UNC }
[74884.288226] ata13.00: configured for UDMA/133
[74884.296277] ata13.01: configured for UDMA/133
[74884.296570] sd 13:0:1:0: [sds] Unhandled sense code
[74884.296598] sd 13:0:1:0: [sds] 
[74884.296622] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[74884.296650] sd 13:0:1:0: [sds] 
[74884.296673] Sense Key : Medium Error [current] [descriptor]
[74884.296708] Descriptor sense data with sense descriptors (in hex):
[74884.296739]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[74884.296805]         00 7c 3c 30 
[74884.296838] sd 13:0:1:0: [sds] 
[74884.296862] Add. Sense: Unrecovered read error - auto reallocate failed
[74884.296892] sd 13:0:1:0: [sds] CDB: 
[74884.296916] Read(10): 28 00 00 7c 39 38 00 04 00 00
[74884.296967] end_request: I/O error, dev sds, sector 8141872
[74884.297020] ata13: EH complete
[74889.334006] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[74889.334041] ata13.01: failed command: READ DMA
[74889.334072] ata13.01: cmd c8/00:08:30:3c:7c/00:00:00:00:00/f0 tag 0 dma 4096 in
[74889.334072]          res 51/40:08:30:3c:7c/40:01:00:00:00/f0 Emask 0x9 (media error)
[74889.334159] ata13.01: status: { DRDY ERR }
[74889.334184] ata13.01: error: { UNC }
[74889.564227] ata13.00: configured for UDMA/133
[74889.572286] ata13.01: configured for UDMA/133
[74889.572322] sd 13:0:1:0: [sds] Unhandled sense code
[74889.572349] sd 13:0:1:0: [sds] 
[74889.572372] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[74889.572399] sd 13:0:1:0: [sds] 
[74889.572422] Sense Key : Medium Error [current] [descriptor]
[74889.572455] Descriptor sense data with sense descriptors (in hex):
[74889.572484]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[74889.572546]         00 7c 3c 30 
[74889.572579] sd 13:0:1:0: [sds] 
[74889.572603] Add. Sense: Unrecovered read error - auto reallocate failed
[74889.572633] sd 13:0:1:0: [sds] CDB: 
[74889.572657] Read(10): 28 00 00 7c 3c 30 00 00 08 00
[74889.572708] end_request: I/O error, dev sds, sector 8141872
[74889.572737] end_request: I/O error, dev sds, sector 8141872
[74889.572774] ata13: EH complete
[74891.334029] md/raid:md0: read error corrected (8 sectors at 8126192 on sds)
[74891.353112] md/raid:md0: read error corrected (8 sectors at 8141872 on sds)
[75038.358845] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[75038.358881] ata13.01: failed command: READ DMA EXT
[75038.358913] ata13.01: cmd 25/00:00:48:c5:be/00:04:01:00:00/f0 tag 0 dma 524288 in
[75038.358913]          res 51/40:38:10:c9:be/40:00:01:00:00/f0 Emask 0x9 (media error)
[75038.359001] ata13.01: status: { DRDY ERR }
[75038.359026] ata13.01: error: { UNC }
[75038.588211] ata13.00: configured for UDMA/133
[75038.596261] ata13.01: configured for UDMA/133
[75038.596603] sd 13:0:1:0: [sds] Unhandled sense code
[75038.596631] sd 13:0:1:0: [sds] 
[75038.596655] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[75038.596682] sd 13:0:1:0: [sds] 
[75038.596705] Sense Key : Medium Error [current] [descriptor]
[75038.596739] Descriptor sense data with sense descriptors (in hex):
[75038.596769]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[75038.596833]         01 be c9 10 
[75038.596867] sd 13:0:1:0: [sds] 
[75038.596891] Add. Sense: Unrecovered read error - auto reallocate failed
[75038.596924] sd 13:0:1:0: [sds] CDB: 
[75038.596948] Read(10): 28 00 01 be c5 48 00 04 00 00
[75038.596998] end_request: I/O error, dev sds, sector 29280528
[75038.597036] ata13: EH complete
[75043.039158] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[75043.039193] ata13.01: failed command: READ DMA
[75043.039224] ata13.01: cmd c8/00:08:10:c9:be/00:00:00:00:00/f1 tag 0 dma 4096 in
[75043.039224]          res 51/40:08:10:c9:be/40:00:01:00:00/f1 Emask 0x9 (media error)
[75043.039312] ata13.01: status: { DRDY ERR }
[75043.039337] ata13.01: error: { UNC }
[75043.268249] ata13.00: configured for UDMA/133
[75043.276261] ata13.01: configured for UDMA/133
[75043.276309] sd 13:0:1:0: [sds] Unhandled sense code
[75043.276335] sd 13:0:1:0: [sds] 
[75043.276359] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[75043.276387] sd 13:0:1:0: [sds] 
[75043.276409] Sense Key : Medium Error [current] [descriptor]
[75043.276442] Descriptor sense data with sense descriptors (in hex):
[75043.276471]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[75043.276532]         01 be c9 10 
[75043.276565] sd 13:0:1:0: [sds] 
[75043.277990] Add. Sense: Unrecovered read error - auto reallocate failed
[75043.278021] sd 13:0:1:0: [sds] CDB: 
[75043.278045] Read(10): 28 00 01 be c9 10 00 00 08 00
[75043.278096] end_request: I/O error, dev sds, sector 29280528
[75043.278124] end_request: I/O error, dev sds, sector 29280528
[75043.278160] ata13: EH complete
[75043.464460] md/raid:md0: read error corrected (8 sectors at 29280528 on sds)
[75055.326046] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[75055.326082] ata13.01: failed command: READ DMA EXT
[75055.326114] ata13.01: cmd 25/00:00:58:11:cf/00:04:01:00:00/f0 tag 0 dma 524288 in
[75055.326114]          res 51/40:e0:78:14:cf/40:00:01:00:00/f0 Emask 0x9 (media error)
[75055.326202] ata13.01: status: { DRDY ERR }
[75055.326228] ata13.01: error: { UNC }
[75055.556225] ata13.00: configured for UDMA/133
[75055.564263] ata13.01: configured for UDMA/133
[75055.564635] sd 13:0:1:0: [sds] Unhandled sense code
[75055.564663] sd 13:0:1:0: [sds] 
[75055.564688] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[75055.564715] sd 13:0:1:0: [sds] 
[75055.564738] Sense Key : Medium Error [current] [descriptor]
[75055.564771] Descriptor sense data with sense descriptors (in hex):
[75055.564802]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[75055.564867]         01 cf 14 78 
[75055.564903] sd 13:0:1:0: [sds] 
[75055.564927] Add. Sense: Unrecovered read error - auto reallocate failed
[75055.564958] sd 13:0:1:0: [sds] CDB: 
[75055.564982] Read(10): 28 00 01 cf 11 58 00 04 00 00
[75055.565033] end_request: I/O error, dev sds, sector 30348408
[75055.565082] ata13: EH complete
[75060.601853] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[75060.601887] ata13.01: failed command: READ DMA
[75060.601918] ata13.01: cmd c8/00:08:78:14:cf/00:00:00:00:00/f1 tag 0 dma 4096 in
[75060.601918]          res 51/40:08:78:14:cf/40:00:01:00:00/f1 Emask 0x9 (media error)
[75060.602005] ata13.01: status: { DRDY ERR }
[75060.602032] ata13.01: error: { UNC }
[75060.832227] ata13.00: configured for UDMA/133
[75060.840279] ata13.01: configured for UDMA/133
[75060.840315] sd 13:0:1:0: [sds] Unhandled sense code
[75060.840342] sd 13:0:1:0: [sds] 
[75060.840365] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[75060.840393] sd 13:0:1:0: [sds] 
[75060.840415] Sense Key : Medium Error [current] [descriptor]
[75060.840449] Descriptor sense data with sense descriptors (in hex):
[75060.840478]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[75060.840542]         01 cf 14 78 
[75060.840575] sd 13:0:1:0: [sds] 
[75060.840598] Add. Sense: Unrecovered read error - auto reallocate failed
[75060.840629] sd 13:0:1:0: [sds] CDB: 
[75060.840652] Read(10): 28 00 01 cf 14 78 00 00 08 00
[75060.840703] end_request: I/O error, dev sds, sector 30348408
[75060.840731] end_request: I/O error, dev sds, sector 30348408
[75060.840768] ata13: EH complete
[75061.051075] md/raid:md0: read error corrected (8 sectors at 30348408 on sds)
[75067.557510] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[75067.557547] ata13.01: failed command: READ DMA EXT
[75067.557579] ata13.01: cmd 25/00:00:60:f1:d4/00:04:01:00:00/f0 tag 0 dma 524288 in
[75067.557579]          res 51/40:50:10:f4:d4/40:01:01:00:00/f0 Emask 0x9 (media error)
[75067.557666] ata13.01: status: { DRDY ERR }
[75067.557692] ata13.01: error: { UNC }
[75067.788249] ata13.00: configured for UDMA/133
[75067.796276] ata13.01: configured for UDMA/133
[75067.796591] sd 13:0:1:0: [sds] Unhandled sense code
[75067.796619] sd 13:0:1:0: [sds] 
[75067.796642] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[75067.796671] sd 13:0:1:0: [sds] 
[75067.796694] Sense Key : Medium Error [current] [descriptor]
[75067.796727] Descriptor sense data with sense descriptors (in hex):
[75067.796757]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[75067.796825]         01 d4 f4 10 
[75067.796858] sd 13:0:1:0: [sds] 
[75067.796882] Add. Sense: Unrecovered read error - auto reallocate failed
[75067.796913] sd 13:0:1:0: [sds] CDB: 
[75067.796937] Read(10): 28 00 01 d4 f1 60 00 04 00 00
[75067.796988] end_request: I/O error, dev sds, sector 30733328
[75067.797047] ata13: EH complete
[113272.067198] md: md0: recovery done.
[113272.528813] RAID conf printout:
[113272.528818]  --- level:6 rd:10 wd:10
[113272.528821]  disk 0, o:1, dev:sdn
[113272.528824]  disk 1, o:1, dev:sdh
[113272.528827]  disk 2, o:1, dev:sdj
[113272.528829]  disk 3, o:1, dev:sdd
[113272.528831]  disk 4, o:0, dev:sds
[113272.528834]  disk 5, o:1, dev:sdv
[113272.528836]  disk 6, o:1, dev:sdb
[113272.528839]  disk 7, o:1, dev:sdc
[113272.528841]  disk 8, o:1, dev:sdf
[113272.528844]  disk 9, o:1, dev:sde
[113272.661106] RAID conf printout:
[113272.661111]  --- level:6 rd:10 wd:10
[113272.661113]  disk 0, o:1, dev:sdn
[113272.661114]  disk 1, o:1, dev:sdh
[113272.661116]  disk 2, o:1, dev:sdj
[113272.661118]  disk 3, o:1, dev:sdd
[113272.661119]  disk 4, o:0, dev:sds
[113272.661121]  disk 5, o:1, dev:sdv
[113272.661123]  disk 6, o:1, dev:sdb
[113272.661124]  disk 7, o:1, dev:sdc
[113272.661126]  disk 8, o:1, dev:sdf
[113272.661127]  disk 9, o:1, dev:sde
[113272.668116] RAID conf printout:
[113272.668120]  --- level:6 rd:10 wd:10
[113272.668123]  disk 0, o:1, dev:sdn
[113272.668126]  disk 1, o:1, dev:sdh
[113272.668129]  disk 2, o:1, dev:sdj
[113272.668132]  disk 3, o:1, dev:sdd
[113272.668134]  disk 4, o:1, dev:sdk
[113272.668137]  disk 5, o:1, dev:sdv
[113272.668139]  disk 6, o:1, dev:sdb
[113272.668142]  disk 7, o:1, dev:sdc
[113272.668145]  disk 8, o:1, dev:sdf
[113272.668147]  disk 9, o:1, dev:sde
[115328.025801] md: unbind<sds>
[115328.036030] md: export_rdev(sds)

Here I started a badblocks test on sds by means of writing 0x00 to the 
entire drive, this should be less relevant though:

[171479.512259] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[171479.512305] ata13.01: failed command: READ DMA
[171479.512335] ata13.01: cmd c8/00:80:80:01:00/00:00:00:00:00/f0 tag 0 dma 65536 in
[171479.512335]          res 51/40:10:f0:01:00/40:01:01:00:00/f0 Emask 0x9 (media error)
[171479.512423] ata13.01: status: { DRDY ERR }
[171479.512448] ata13.01: error: { UNC }
[171479.800230] ata13.00: configured for UDMA/133
[171479.808259] ata13.01: configured for UDMA/133
[171479.808340] sd 13:0:1:0: [sds] Unhandled sense code
[171479.808367] sd 13:0:1:0: [sds] 
[171479.808391] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[171479.808418] sd 13:0:1:0: [sds] 
[171479.808441] Sense Key : Medium Error [current] [descriptor]
[171479.808475] Descriptor sense data with sense descriptors (in hex):
[171479.808504]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[171479.808566]         00 00 01 f0 
[171479.808599] sd 13:0:1:0: [sds] 
[171479.808623] Add. Sense: Unrecovered read error - auto reallocate failed
[171479.808653] sd 13:0:1:0: [sds] CDB: 
[171479.808676] Read(10): 28 00 00 00 01 80 00 00 80 00
[171479.808727] end_request: I/O error, dev sds, sector 496
[171479.808761] ata13: EH complete
[171484.954258] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[171484.954292] ata13.01: failed command: READ DMA
[171484.954324] ata13.01: cmd c8/00:80:e8:01:00/00:00:00:00:00/f0 tag 0 dma 65536 in
[171484.954324]          res 51/40:78:f0:01:00/40:01:01:00:00/f0 Emask 0x9 (media error)
[171484.954413] ata13.01: status: { DRDY ERR }
[171484.954438] ata13.01: error: { UNC }
[171485.184249] ata13.00: configured for UDMA/133
[171485.192259] ata13.01: configured for UDMA/133
[171485.192339] sd 13:0:1:0: [sds] Unhandled sense code
[171485.192367] sd 13:0:1:0: [sds] 
[171485.192390] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[171485.192418] sd 13:0:1:0: [sds] 
[171485.192441] Sense Key : Medium Error [current] [descriptor]
[171485.192475] Descriptor sense data with sense descriptors (in hex):
[171485.192504]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[171485.192566]         00 00 01 f0 
[171485.192599] sd 13:0:1:0: [sds] 
[171485.192623] Add. Sense: Unrecovered read error - auto reallocate failed
[171485.192654] sd 13:0:1:0: [sds] CDB: 
[171485.192677] Read(10): 28 00 00 00 01 e8 00 00 80 00
[171485.192727] end_request: I/O error, dev sds, sector 496
[171485.192755] Buffer I/O error on device sds, logical block 62
[171485.192784] Buffer I/O error on device sds, logical block 63
[171485.192812] Buffer I/O error on device sds, logical block 64
[171485.192840] Buffer I/O error on device sds, logical block 65
[171485.192867] Buffer I/O error on device sds, logical block 66
[171485.192895] Buffer I/O error on device sds, logical block 67
[171485.192923] Buffer I/O error on device sds, logical block 68
[171485.192950] Buffer I/O error on device sds, logical block 69
[171485.192977] Buffer I/O error on device sds, logical block 70
[171485.193005] Buffer I/O error on device sds, logical block 71
[171485.193039] ata13: EH complete
[171496.884843] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[171496.884879] ata13.01: failed command: READ DMA
[171496.884910] ata13.01: cmd c8/00:08:f0:01:00/00:00:00:00:00/f0 tag 0 dma 4096 in
[171496.884910]          res 51/40:08:f0:01:00/40:01:01:00:00/f0 Emask 0x9 (media error)
[171496.885000] ata13.01: status: { DRDY ERR }
[171496.885026] ata13.01: error: { UNC }
[171497.188226] ata13.00: configured for UDMA/133
[171497.196279] ata13.01: configured for UDMA/133
[171497.196317] sd 13:0:1:0: [sds] Unhandled sense code
[171497.196344] sd 13:0:1:0: [sds] 
[171497.196367] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[171497.196394] sd 13:0:1:0: [sds] 
[171497.196417] Sense Key : Medium Error [current] [descriptor]
[171497.196450] Descriptor sense data with sense descriptors (in hex):
[171497.196480]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[171497.196541]         00 00 01 f0 
[171497.196574] sd 13:0:1:0: [sds] 
[171497.196598] Add. Sense: Unrecovered read error - auto reallocate failed
[171497.196629] sd 13:0:1:0: [sds] CDB: 
[171497.196652] Read(10): 28 00 00 00 01 f0 00 00 08 00
[171497.196704] end_request: I/O error, dev sds, sector 496
[171497.196732] quiet_error: 5 callbacks suppressed
[171497.196757] Buffer I/O error on device sds, logical block 62
[171497.196794] ata13: EH complete
[171502.605051] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[171502.605085] ata13.01: failed command: READ DMA
[171502.605114] ata13.01: cmd c8/00:08:f0:01:00/00:00:00:00:00/f0 tag 0 dma 4096 in
[171502.605114]          res 51/40:08:f0:01:00/40:01:01:00:00/f0 Emask 0x9 (media error)
[171502.605202] ata13.01: status: { DRDY ERR }
[171502.605227] ata13.01: error: { UNC }
[171502.868224] ata13.00: configured for UDMA/133
[171502.876225] ata13.01: configured for UDMA/133
[171502.876268] sd 13:0:1:0: [sds] Unhandled sense code
[171502.876295] sd 13:0:1:0: [sds] 
[171502.877696] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[171502.877724] sd 13:0:1:0: [sds] 
[171502.877747] Sense Key : Medium Error [current] [descriptor]
[171502.877782] Descriptor sense data with sense descriptors (in hex):
[171502.877811]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[171502.877874]         00 00 01 f0 
[171502.877908] sd 13:0:1:0: [sds] 
[171502.877932] Add. Sense: Unrecovered read error - auto reallocate failed
[171502.877963] sd 13:0:1:0: [sds] CDB: 
[171502.877987] Read(10): 28 00 00 00 01 f0 00 00 08 00
[171502.878038] end_request: I/O error, dev sds, sector 496
[171502.878066] Buffer I/O error on device sds, logical block 62
[171502.878104] ata13: EH complete
[190261.434197] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[190261.434233] ata13.01: failed command: READ DMA
[190261.434264] ata13.01: cmd c8/00:08:f0:01:00/00:00:00:00:00/f0 tag 0 dma 4096 in
[190261.434264]          res 51/40:08:f0:01:00/40:01:01:00:00/f0 Emask 0x9 (media error)
[190261.434353] ata13.01: status: { DRDY ERR }
[190261.434378] ata13.01: error: { UNC }
[190261.688229] ata13.00: configured for UDMA/133
[190261.696263] ata13.01: configured for UDMA/133
[190261.696310] sd 13:0:1:0: [sds] Unhandled sense code
[190261.696337] sd 13:0:1:0: [sds] 
[190261.696360] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[190261.696388] sd 13:0:1:0: [sds] 
[190261.696411] Sense Key : Medium Error [current] [descriptor]
[190261.696443] Descriptor sense data with sense descriptors (in hex):
[190261.696473]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[190261.696536]         00 00 01 f0 
[190261.696569] sd 13:0:1:0: [sds] 
[190261.696592] Add. Sense: Unrecovered read error - auto reallocate failed
[190261.696623] sd 13:0:1:0: [sds] CDB: 
[190261.696647] Read(10): 28 00 00 00 01 f0 00 00 08 00
[190261.696698] end_request: I/O error, dev sds, sector 496
[190261.696726] Buffer I/O error on device sds, logical block 62
[190261.696759] ata13: EH complete

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
