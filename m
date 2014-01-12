From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: read errors not corrected when doing check on RAID6
Date: Sun, 12 Jan 2014 07:41:14 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1401120723010.20074@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello.

Running Debian with 3.11-0.bpo.2-amd64 with mdadm 3.2.5 (later upgraded to 
3.3 to do the replace function described).

/dev/sds on the system had 9 pending sectors according to smartctl. I 
issued a check and got several read during the check. I started the check 
by taking what debian has in its crontab:

/usr/share/mdadm/checkarray --cron --all --idle --quiet

This resulted in this in dmesg (there are two arrays), I don't know why it 
didn't do the RAID conf printout for md2.

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

There were even more errors (not included), but md didn't seem to correct 
them. After the check, the number of pending sectors on /dev/sds was still 
9.

The reason to upgrade fmor kernel 3.2 to 3.11 was to gain the use of the 
replace function. I then issued:

mdadm /dev/md0 --replace /dev/sds

dmesg:

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

So here now in the replace function, md decided to correct the read errors 
on /dev/sds. Now the pending sectors are down to 7 on /dev/sds. There were 
some more errors which were also corrected, and now the pending count is 
down to 5. Recovery is still ongoing.

So my question is, what did I do wrong the first time when doing the 
check? I expected it to correct the read errors on the drive then, but it 
seems it didn't. Should I have issued a "repair" instead?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
