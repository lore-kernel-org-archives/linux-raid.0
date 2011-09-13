From: Johannes Truschnigg <johannes@truschnigg.info>
Subject: What just happened to my disks/RAID5 array?
Date: Tue, 13 Sep 2011 10:27:35 +0200
Message-ID: <4E6F13F7.6070507@truschnigg.info>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060005030306080705070709"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------060005030306080705070709
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dear list members,

my server at home just mailed in multiple FAIL events from members of 
the RAID5 array in it. I won't be able to get to the machine during the 
next ten or so hours, but I'd like to be prepared as best as I can when 
I face the disaster that apparently struck. I attached the relevant 
dmesg excerpt, as well as the current mdstat contents. Theories 
explaining what could have happened - and how to deal with such a 
scenario - are highly appreciated, as only some of the data on the array 
is actually backed up elsewhere. If you need any additional information 
about the system or its setup, please ask right away!

I do have SSH access to the box.

Thanks for your support!
-- 
with best regards:
- Johannes Truschnigg ( johannes@truschnigg.info )

www: http://johannes.truschnigg.info/
phone: +43 650 2 133337
xmpp: johannes@truschnigg.info

Please do not bother me with HTML-eMail or attachments. Thank you.

--------------060005030306080705070709
Content-Type: text/plain;
 name="mdstat.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mdstat.txt"

Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
md0 : active raid5 sdf[5](F) sdd[2](F) sde[1](F)
      5860548608 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/0] [_____]
      bitmap: 2/11 pages [8KB], 65536KB chunk

unused devices: <none>

--------------060005030306080705070709
Content-Type: text/plain;
 name="raidfail.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="raidfail.txt"

[147245.851744] ata7: exception Emask 0x10 SAct 0x0 SErr 0x1990000 action 0xe frozen
[147245.851752] ata7: irq_stat 0x00400000, PHY RDY changed
[147245.851761] ata7: SError: { PHYRdyChg 10B8B Dispar LinkSeq TrStaTrns }
[147245.851774] ata7: hard resetting link
[147246.568754] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[147246.575779] ata7.00: failed to set xfermode (err_mask=0x100)
[147251.568674] ata7: hard resetting link
[147251.895632] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[147251.909913] ata7.00: configured for UDMA/133
[147251.909925] ata7: EH complete
[147260.340033] ata7: exception Emask 0x10 SAct 0x0 SErr 0x1990000 action 0xe frozen
[147260.340041] ata7: irq_stat 0x00400000, PHY RDY changed
[147260.340050] ata7: SError: { PHYRdyChg 10B8B Dispar LinkSeq TrStaTrns }
[147260.340063] ata7: hard resetting link
[147261.418971] ata7: SATA link down (SStatus 20 SControl 300)
[147266.418724] ata7: hard resetting link
[147266.738832] ata7: SATA link down (SStatus 20 SControl 300)
[147266.738844] ata7: limiting SATA link speed to 1.5 Gbps
[147271.738667] ata7: hard resetting link
[147272.058700] ata7: SATA link down (SStatus 20 SControl 310)
[147272.058712] ata7.00: disabled
[147272.058722] ata7: limiting SATA link speed to 1.5 Gbps
[147272.058739] ata7: EH complete
[147272.058759] ata7.00: detaching (SCSI 6:0:0:0)
[147272.072254] sd 6:0:0:0: [sdf] Synchronizing SCSI cache
[147272.072326] sd 6:0:0:0: [sdf]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[147272.072335] sd 6:0:0:0: [sdf] Stopping disk
[147272.072352] sd 6:0:0:0: [sdf] START_STOP FAILED
[147272.072357] sd 6:0:0:0: [sdf]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[147272.086129] md/raid:md0: Disk failure on sdf, disabling device.
[147272.086133] md/raid:md0: Operation continuing on 4 devices.
[147272.087498] ata5.00: exception Emask 0x10 SAct 0x0 SErr 0x1980000 action 0x6 frozen
[147272.087507] ata5.00: irq_stat 0x08000000, interface fatal error
[147272.087516] ata5: SError: { 10B8B Dispar LinkSeq TrStaTrns }
[147272.087524] ata5.00: failed command: WRITE DMA
[147272.087538] ata5.00: cmd ca/00:06:10:00:00/00:00:00:00:00/e0 tag 0 dma 3072 out
[147272.087542]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x10 (ATA bus error)
[147272.087549] ata5.00: status: { DRDY }
[147272.087561] ata5: hard resetting link
[147272.087580] ata4.00: exception Emask 0x10 SAct 0x0 SErr 0x1980000 action 0x6 frozen
[147272.087586] ata4.00: irq_stat 0x08000000, interface fatal error
[147272.087593] ata4: SError: { 10B8B Dispar LinkSeq TrStaTrns }
[147272.087599] ata4.00: failed command: WRITE DMA
[147272.087612] ata4.00: cmd ca/00:06:10:00:00/00:00:00:00:00/e0 tag 0 dma 3072 out
[147272.087616]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x10 (ATA bus error)
[147272.087622] ata4.00: status: { DRDY }
[147272.087630] ata4: hard resetting link
[147272.405565] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[147272.618863] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[147272.625883] ata4.00: failed to set xfermode (err_mask=0x100)
[147277.618667] ata4: hard resetting link
[147277.618706] ata5.00: qc timeout (cmd 0xec)
[147277.618719] ata5.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[147277.618727] ata5.00: revalidation failed (errno=-5)
[147277.618737] ata5: hard resetting link
[147277.938774] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[147277.952986] ata4.00: configured for UDMA/133
[147277.953008] ata4: EH complete
[147282.952226] ata5: link is slow to respond, please be patient (ready=0)
[147287.645624] ata5: COMRESET failed (errno=-16)
[147287.645633] ata5: hard resetting link
[147287.965323] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[147292.968826] ata5.00: qc timeout (cmd 0x27)
[147292.968838] ata5.00: failed to read native max address (err_mask=0x4)
[147292.968844] ata5.00: HPA support seems broken, skipping HPA handling
[147292.968851] ata5.00: revalidation failed (errno=-5)
[147292.968858] ata5: limiting SATA link speed to 1.5 Gbps
[147292.968868] ata5: hard resetting link
[147293.288784] ata5: SATA link up <unknown> (SStatus 103 SControl 310)
[147302.438718] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x1980000 action 0x6 frozen
[147302.438729] ata6: SError: { 10B8B Dispar LinkSeq TrStaTrns }
[147302.438737] ata6.00: failed command: WRITE DMA
[147302.438752] ata6.00: cmd ca/00:06:10:00:00/00:00:00:00:00/e0 tag 0 dma 3072 out
[147302.438756]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[147302.438763] ata6.00: status: { DRDY }
[147302.438774] ata6: hard resetting link
[147302.438798] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x1980000 action 0x6 frozen
[147302.438809] ata3: SError: { 10B8B Dispar LinkSeq TrStaTrns }
[147302.438818] ata3.00: failed command: WRITE DMA
[147302.438833] ata3.00: cmd ca/00:06:10:00:00/00:00:00:00:00/e0 tag 0 dma 3072 out
[147302.438836]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[147302.438843] ata3.00: status: { DRDY }
[147302.438855] ata3: hard resetting link
[147302.758863] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[147302.762125] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[147302.773317] ata3.00: configured for UDMA/133
[147302.773328] ata3.00: device reported invalid CHS sector 0
[147302.773342] ata3: EH complete
[147302.775379] ata6.00: configured for UDMA/133
[147302.775387] ata6.00: device reported invalid CHS sector 0
[147302.775397] ata6: EH complete
[147303.288709] ata5.00: qc timeout (cmd 0xec)
[147303.288718] ata5.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[147303.288725] ata5.00: revalidation failed (errno=-5)
[147303.288730] ata5.00: disabled
[147303.288748] ata5: hard resetting link
[147303.608971] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[147303.608987] ata5: EH complete
[147303.609011] sd 4:0:0:0: [sdd] Unhandled error code
[147303.609017] sd 4:0:0:0: [sdd]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[147303.609026] sd 4:0:0:0: [sdd] CDB: Write(10): 2a 00 00 00 00 10 00 00 06 00
[147303.609042] end_request: I/O error, dev sdd, sector 16
[147303.609050] end_request: I/O error, dev sdd, sector 16
[147303.609055] md: super_written gets error=-5, uptodate=0
[147303.609064] md/raid:md0: Disk failure on sdd, disabling device.
[147303.609067] md/raid:md0: Operation continuing on 3 devices.
[147338.034739] ata5: exception Emask 0x10 SAct 0x0 SErr 0x1990000 action 0xe frozen
[147338.034747] ata5: irq_stat 0x00400000, PHY RDY changed
[147338.034755] ata5: SError: { PHYRdyChg 10B8B Dispar LinkSeq TrStaTrns }
[147338.034772] ata5: hard resetting link
[147338.752214] ata5: SATA link down (SStatus 10 SControl 300)
[147338.752231] ata5: EH complete
[147338.752249] ata5.00: detaching (SCSI 4:0:0:0)
[147338.762446] sd 4:0:0:0: [sdd] Synchronizing SCSI cache
[147338.762686] sd 4:0:0:0: [sdd]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[147338.762695] sd 4:0:0:0: [sdd] Stopping disk
[147338.762712] sd 4:0:0:0: [sdd] START_STOP FAILED
[147338.762717] sd 4:0:0:0: [sdd]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[147347.452182] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x1980000 action 0x6 frozen
[147347.452193] ata4: SError: { 10B8B Dispar LinkSeq TrStaTrns }
[147347.452200] ata4.00: failed command: FLUSH CACHE EXT
[147347.452214] ata4.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[147347.452217]          res 40/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
[147347.452225] ata4.00: status: { DRDY }
[147347.452236] ata4: hard resetting link
[147352.825504] ata4: link is slow to respond, please be patient (ready=0)
[147357.465530] ata4: COMRESET failed (errno=-16)
[147357.465540] ata4: hard resetting link
[147357.785657] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[147357.792665] ata4.00: n_sectors mismatch 2930277168 != 1927137455439861512
[147357.792672] ata4.00: revalidation failed (errno=-19)
[147357.792678] ata4: limiting SATA link speed to 1.5 Gbps
[147362.785605] ata4: hard resetting link
[147363.105612] ata4: SATA link up <unknown> (SStatus 103 SControl 310)
[147363.112206] ata4.00: failed to read native max address (err_mask=0x100)
[147363.112212] ata4.00: HPA support seems broken, skipping HPA handling
[147363.112219] ata4.00: revalidation failed (errno=-5)
[147363.112225] ata4.00: disabled
[147368.105572] ata4: hard resetting link
[147368.425538] ata4: SATA link up <unknown> (SStatus 103 SControl 300)
[147368.432154] ata4.00: ATA-14: SAMSUNG HD154UI                        `, 1AG01118, max MWDMA1
[147368.432163] ata4.00: 2509505962 sectors, multi 0: LBA NCQ (depth 31)
[147368.432171] ata4.00: applying bridge limits
[147368.432941] ata4.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[147368.432947] ata4.00: revalidation failed (errno=-5)
[147373.425473] ata4: hard resetting link
[147373.745335] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[147378.745337] ata4.00: qc timeout (cmd 0xec)
[147378.745348] ata4.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[147378.745355] ata4.00: revalidation failed (errno=-5)
[147378.745361] ata4: limiting SATA link speed to 1.5 Gbps
[147378.745369] ata4: hard resetting link
[147379.065602] ata4: SATA link up <unknown> (SStatus 103 SControl 310)
[147389.065604] ata4.00: qc timeout (cmd 0xec)
[147389.065616] ata4.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[147389.065623] ata4.00: revalidation failed (errno=-5)
[147389.065629] ata4.00: disabled
[147389.065657] ata4: hard resetting link
[147389.598721] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[147389.598766] sd 3:0:0:0: rejecting I/O to offline device
[147389.598780] ata4: EH complete
[147389.598801] sd 3:0:0:0: rejecting I/O to offline device
[147389.598813] end_request: I/O error, dev sdc, sector 8
[147389.598820] md: super_written gets error=-5, uptodate=0
[147389.598828] md/raid:md0: Disk failure on sdc, disabling device.
[147389.598831] md/raid:md0: Operation continuing on 2 devices.
[147389.598880] sd 3:0:0:0: rejecting I/O to offline device
[147389.598895] sd 3:0:0:0: rejecting I/O to offline device
[147389.598904] sd 3:0:0:0: [sdc] READ CAPACITY(16) failed
[147389.598910] sd 3:0:0:0: [sdc]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[147389.598919] sd 3:0:0:0: [sdc] Sense not available.
[147389.598928] sd 3:0:0:0: rejecting I/O to offline device
[147389.598941] sd 3:0:0:0: rejecting I/O to offline device
[147389.598953] sd 3:0:0:0: rejecting I/O to offline device
[147389.598962] sd 3:0:0:0: [sdc] READ CAPACITY failed
[147389.599002] sd 3:0:0:0: [sdc]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[147389.599010] sd 3:0:0:0: [sdc] Sense not available.
[147389.599021] sd 3:0:0:0: rejecting I/O to offline device
[147389.599034] sd 3:0:0:0: rejecting I/O to offline device
[147389.599063] sd 3:0:0:0: rejecting I/O to offline device
[147389.599079] ata3.00: exception Emask 0x12 SAct 0x0 SErr 0x1980400 action 0x6 frozen
[147389.599088] sd 3:0:0:0: rejecting I/O to offline device
[147389.599098] ata3.00: irq_stat 0x08000000, interface fatal error
[147389.599105] sd 3:0:0:0: [sdc] Asking for cache data failed
[147389.599113] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[147389.599125] ata3: SError: { Proto 10B8B Dispar LinkSeq TrStaTrns }
[147389.599133] sdc: detected capacity change from 1500301910016 to 0
[147389.599145] ata3.00: failed command: WRITE DMA
[147389.599163] ata3.00: cmd ca/00:02:08:00:00/00:00:00:00:00/e0 tag 0 dma 1024 out
[147389.599167]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x12 (ATA bus error)
[147389.599174] ata3.00: status: { DRDY }
[147389.599186] ata3: hard resetting link
[147389.599249] ata4.00: detaching (SCSI 3:0:0:0)
[147389.612289] sd 3:0:0:0: [sdc] Stopping disk
[147389.612515] sd 3:0:0:0: [sdc] START_STOP FAILED
[147389.612521] sd 3:0:0:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[147390.135576] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[147390.149879] ata3.00: configured for UDMA/133
[147390.149902] ata3: EH complete
[147393.089812] ata4: exception Emask 0x10 SAct 0x0 SErr 0x1990000 action 0xe frozen
[147393.089819] ata4: irq_stat 0x00400000, PHY RDY changed
[147393.089828] ata4: SError: { PHYRdyChg 10B8B Dispar LinkSeq TrStaTrns }
[147393.089843] ata4: limiting SATA link speed to 1.5 Gbps
[147393.089851] ata4: hard resetting link
[147394.562403] ata6.00: exception Emask 0x10 SAct 0x0 SErr 0x1990000 action 0xe frozen
[147394.562409] ata6.00: irq_stat 0x00400000, PHY RDY changed
[147394.562417] ata6: SError: { PHYRdyChg 10B8B Dispar LinkSeq TrStaTrns }
[147394.562423] ata6.00: failed command: FLUSH CACHE EXT
[147394.562438] ata6.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[147394.562441]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x10 (ATA bus error)
[147394.562448] ata6.00: status: { DRDY }
[147394.562457] ata6: hard resetting link
[147395.338671] ata4: COMRESET failed (errno=-32)
[147395.338678] ata4: reset failed (errno=-32), retrying in 8 secs
[147400.295627] ata6: link is slow to respond, please be patient (ready=0)
[147403.088895] ata4: hard resetting link
[147404.615638] ata6: COMRESET failed (errno=-16)
[147404.615646] ata6: hard resetting link
[147407.225318] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[147407.239058] ata6.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[147407.239065] ata6.00: revalidation failed (errno=-5)
[147412.225599] ata6: hard resetting link
[147412.545517] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[147412.559752] ata6.00: configured for UDMA/133
[147412.559759] ata6.00: retrying FLUSH 0xea Emask 0x10
[147412.560140] ata6.00: device reported invalid CHS sector 0
[147412.560156] ata6: EH complete
[147412.636929] RAID conf printout:
[147412.636938]  --- level:5 rd:5 wd:2
[147412.636946]  disk 0, o:0, dev:sdc
[147412.636951]  disk 1, o:1, dev:sde
[147412.636956]  disk 2, o:0, dev:sdd
[147412.636961]  disk 3, o:1, dev:sdb
[147412.636966]  disk 4, o:0, dev:sdf
[147412.637000] RAID conf printout:
[147412.637006]  --- level:5 rd:5 wd:2
[147412.637012]  disk 0, o:0, dev:sdc
[147412.637016]  disk 1, o:1, dev:sde
[147412.637022]  disk 2, o:0, dev:sdd
[147412.637026]  disk 3, o:1, dev:sdb
[147412.637041] RAID conf printout:
[147412.637045]  --- level:5 rd:5 wd:2
[147412.637050]  disk 0, o:0, dev:sdc
[147412.637054]  disk 1, o:1, dev:sde
[147412.637059]  disk 2, o:0, dev:sdd
[147412.637063]  disk 3, o:1, dev:sdb
[147412.639165] RAID conf printout:
[147412.639170]  --- level:5 rd:5 wd:2
[147412.639175]  disk 0, o:0, dev:sdc
[147412.639180]  disk 1, o:1, dev:sde
[147412.639185]  disk 3, o:1, dev:sdb
[147412.639200] RAID conf printout:
[147412.639204]  --- level:5 rd:5 wd:2
[147412.639208]  disk 0, o:0, dev:sdc
[147412.639213]  disk 1, o:1, dev:sde
[147412.639217]  disk 3, o:1, dev:sdb
[147412.639247] RAID conf printout:
[147412.639252]  --- level:5 rd:5 wd:2
[147412.639257]  disk 1, o:1, dev:sde
[147412.639262]  disk 3, o:1, dev:sdb
[147412.647225] md: unbind<sdc>
[147412.655439] md: export_rdev(sdc)
[147413.132017] ata4: COMRESET failed (errno=-16)
[147413.132034] ata4: hard resetting link
[147413.852109] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[147413.859114] ata4.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
[147413.859124] ata4.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[147413.866547] ata4.00: configured for UDMA/133
[147413.866561] ata4: EH complete
[147413.866746] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD154UI  1AG0 PQ: 0 ANSI: 5
[147413.867111] sd 3:0:0:0: [sdc] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[147413.867121] sd 3:0:0:0: Attached scsi generic sg2 type 0
[147413.867226] sd 3:0:0:0: [sdc] Write Protect is off
[147413.867234] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[147413.867374] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[147413.868029] sdc: detected capacity change from 0 to 1500301910016
[147413.883293]  sdc: unknown partition table
[147413.883663] sd 3:0:0:0: [sdc] Attached SCSI disk
[147421.162867] ata6: exception Emask 0x10 SAct 0x0 SErr 0x1990000 action 0xe frozen
[147421.162875] ata6: irq_stat 0x00400000, PHY RDY changed
[147421.162884] ata6: SError: { PHYRdyChg 10B8B Dispar LinkSeq TrStaTrns }
[147421.162897] ata6: hard resetting link
[147427.855375] ata6: link is slow to respond, please be patient (ready=0)
[147431.215600] ata6: COMRESET failed (errno=-16)
[147431.215610] ata6: hard resetting link
[147431.935560] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[147432.783678] ata3: exception Emask 0x10 SAct 0x0 SErr 0x1990000 action 0xe frozen
[147432.783684] ata3: irq_stat 0x00400000, PHY RDY changed
[147432.783693] ata3: SError: { PHYRdyChg 10B8B Dispar LinkSeq TrStaTrns }
[147432.783706] ata3: hard resetting link
[147436.935545] ata6.00: qc timeout (cmd 0xec)
[147436.935559] ata6.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[147436.935566] ata6.00: revalidation failed (errno=-5)
[147436.935576] ata6: hard resetting link
[147437.468869] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[147437.475816] ata6.00: both IDENTIFYs aborted, assuming NODEV
[147437.475822] ata6.00: revalidation failed (errno=-2)
[147442.468949] ata6: hard resetting link
[147442.788695] ata3: COMRESET failed (errno=-16)
[147442.788706] ata3: hard resetting link
[147442.788731] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[147442.803092] ata6.00: failed to read native max address (err_mask=0x100)
[147442.803099] ata6.00: HPA support seems broken, skipping HPA handling
[147442.803106] ata6.00: revalidation failed (errno=-5)
[147442.803112] ata6.00: disabled
[147442.803121] ata6: limiting SATA link speed to 1.5 Gbps
[147442.805300] sd 5:0:0:0: rejecting I/O to offline device
[147442.805331] ata6: hard resetting link
[147442.805347] sd 5:0:0:0: rejecting I/O to offline device
[147442.805365] sd 5:0:0:0: rejecting I/O to offline device
[147442.805379] sd 5:0:0:0: rejecting I/O to offline device
[147442.805390] sd 5:0:0:0: [sde] READ CAPACITY(16) failed
[147442.805399] sd 5:0:0:0: [sde]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[147442.805412] sd 5:0:0:0: [sde] Sense not available.
[147442.805424] sd 5:0:0:0: rejecting I/O to offline device
[147442.805438] sd 5:0:0:0: rejecting I/O to offline device
[147442.805453] sd 5:0:0:0: rejecting I/O to offline device
[147442.805464] sd 5:0:0:0: [sde] READ CAPACITY failed
[147442.805472] sd 5:0:0:0: [sde]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[147442.805485] sd 5:0:0:0: [sde] Sense not available.
[147442.805498] sd 5:0:0:0: rejecting I/O to offline device
[147442.805512] sd 5:0:0:0: rejecting I/O to offline device
[147442.805530] sd 5:0:0:0: rejecting I/O to offline device
[147442.805545] sd 5:0:0:0: rejecting I/O to offline device
[147442.805554] sd 5:0:0:0: [sde] Asking for cache data failed
[147442.805560] sd 5:0:0:0: [sde] Assuming drive cache: write through
[147442.805572] sde: detected capacity change from 1500301910016 to 0
[147443.125470] ata6: SATA link up <unknown> (SStatus 103 SControl 310)
[147443.508925] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[147444.412118] ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x1980000 action 0x6 frozen
[147444.412129] ata4: SError: { 10B8B Dispar LinkSeq TrStaTrns }
[147444.412137] ata4.00: failed command: READ FPDMA QUEUED
[147444.412152] ata4.00: cmd 60/08:00:20:7b:a8/00:00:ae:00:00/40 tag 0 ncq 4096 in
[147444.412156]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[147444.412163] ata4.00: status: { DRDY }
[147444.412175] ata4: hard resetting link
[147444.945585] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[147444.960590] ata4.00: configured for UDMA/133
[147444.960601] ata4.00: device reported invalid CHS sector 0
[147444.960614] ata4: EH complete
[147448.125388] ata6.00: qc timeout (cmd 0xec)
[147448.125399] ata6.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[147448.125408] ata6: hard resetting link
[147448.508741] ata3.00: qc timeout (cmd 0xec)
[147448.508750] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[147448.508757] ata3.00: revalidation failed (errno=-5)
[147448.508763] ata3: hard resetting link
[147448.658874] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[147448.658928] ata6.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[147453.658890] ata6: hard resetting link
[147453.768760] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[147453.781812] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[147453.781820] ata3.00: revalidation failed (errno=-5)
[147453.781827] ata3: limiting SATA link speed to 1.5 Gbps
[147458.768931] ata3: hard resetting link
[147458.878822] ata6: SATA link down (SStatus 10 SControl 310)
[147458.878840] ata6: EH complete
[147458.878859] ata6.00: detaching (SCSI 5:0:0:0)
[147458.889079] sd 5:0:0:0: [sde] Stopping disk
[147458.889130] sd 5:0:0:0: [sde] START_STOP FAILED
[147458.889135] sd 5:0:0:0: [sde]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[147458.897620] md/raid:md0: Disk failure on sde, disabling device.
[147458.897625] md/raid:md0: Operation continuing on 1 devices.
[147459.088896] ata3: SATA link down (SStatus 20 SControl 310)
[147459.088910] ata3.00: disabled
[147459.088928] ata3: EH complete
[147459.088943] sd 2:0:0:0: rejecting I/O to offline device
[147459.088974] sd 2:0:0:0: rejecting I/O to offline device
[147459.088984] md: super_written gets error=-5, uptodate=0
[147459.088993] md/raid:md0: Disk failure on sdb, disabling device.
[147459.088996] md/raid:md0: Operation continuing on 0 devices.
[147459.089022] ata3.00: detaching (SCSI 2:0:0:0)
[147459.089130] RAID conf printout:
[147459.089139]  --- level:5 rd:5 wd:0
[147459.089145]  disk 1, o:0, dev:sde
[147459.089150]  disk 3, o:0, dev:sdb
[147459.098771] RAID conf printout:
[147459.098780]  --- level:5 rd:5 wd:0
[147459.098787]  disk 3, o:0, dev:sdb
[147459.098801] RAID conf printout:
[147459.098804]  --- level:5 rd:5 wd:0
[147459.098809]  disk 3, o:0, dev:sdb
[147459.102318] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[147459.102416] sd 2:0:0:0: [sdb]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[147459.102425] sd 2:0:0:0: [sdb] Stopping disk
[147459.103462] sd 2:0:0:0: [sdb] START_STOP FAILED
[147459.103469] sd 2:0:0:0: [sdb]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[147459.108690] RAID conf printout:
[147459.108697]  --- level:5 rd:5 wd:0
[147459.116041] md: unbind<sdb>
[147459.125635] md: export_rdev(sdb)
[147475.345396] ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x180000 action 0x6 frozen
[147475.345407] ata4: SError: { 10B8B Dispar }
[147475.345415] ata4.00: failed command: READ FPDMA QUEUED
[147475.345430] ata4.00: cmd 60/08:00:20:7b:a8/00:00:ae:00:00/40 tag 0 ncq 4096 in
[147475.345433]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[147475.345440] ata4.00: status: { DRDY }
[147475.345453] ata4: hard resetting link
[147475.908916] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[147475.908931] ata4.00: failed to IDENTIFY (I/O error, err_mask=0x40)
[147475.908937] ata4.00: revalidation failed (errno=-5)
[147480.908915] ata4: hard resetting link
[147481.495438] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[147481.495451] ata4.00: failed to IDENTIFY (I/O error, err_mask=0x40)
[147481.495457] ata4.00: revalidation failed (errno=-5)
[147486.495645] ata4: hard resetting link
[147486.815525] ata4: SATA link down (SStatus 10 SControl 310)
[147486.815536] ata4.00: disabled
[147486.815552] ata4.00: device reported invalid CHS sector 0
[147486.815575] sd 3:0:0:0: [sdc]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[147486.815583] sd 3:0:0:0: [sdc]  Sense Key : Aborted Command [current] [descriptor]
[147486.815593] Descriptor sense data with sense descriptors (in hex):
[147486.815598]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[147486.815613]         00 00 00 00 
[147486.815620] sd 3:0:0:0: [sdc]  Add. Sense: No additional sense information
[147486.815629] sd 3:0:0:0: [sdc] CDB: Read(10): 28 00 ae a8 7b 20 00 00 08 00
[147486.815645] end_request: I/O error, dev sdc, sector 2930277152
[147486.815654] Buffer I/O error on device sdc, logical block 366284644
[147486.815685] ata4: EH complete
[147486.815713] ata4.00: detaching (SCSI 3:0:0:0)
[147486.828971] sd 3:0:0:0: [sdc] Synchronizing SCSI cache
[147486.829049] sd 3:0:0:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[147486.829058] sd 3:0:0:0: [sdc] Stopping disk
[147486.830153] sd 3:0:0:0: [sdc] START_STOP FAILED
[147486.830160] sd 3:0:0:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[147486.976111] ata4: exception Emask 0x10 SAct 0x0 SErr 0x19d0000 action 0xe frozen
[147486.976119] ata4: irq_stat 0x00400000, PHY RDY changed
[147486.976128] ata4: SError: { PHYRdyChg CommWake 10B8B Dispar LinkSeq TrStaTrns }
[147486.976143] ata4: limiting SATA link speed to 1.5 Gbps
[147486.976151] ata4: hard resetting link
[147488.175607] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[147488.175622] ata4.00: failed to IDENTIFY (I/O error, err_mask=0x40)
[147493.175412] ata4: hard resetting link
[147493.708805] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[147493.865505] ata4.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[147498.708711] ata4: hard resetting link
[147499.242063] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[147499.242078] ata4.00: failed to IDENTIFY (I/O error, err_mask=0x40)
[147504.242060] ata4: hard resetting link
[147504.562106] ata4: SATA link down (SStatus 10 SControl 310)
[147504.562122] ata4: EH complete
[155065.805782] ata7: exception Emask 0x10 SAct 0x0 SErr 0x1990000 action 0xe frozen
[155065.805790] ata7: irq_stat 0x00400000, PHY RDY changed
[155065.805798] ata7: SError: { PHYRdyChg 10B8B Dispar LinkSeq TrStaTrns }
[155065.805815] ata7: hard resetting link
[155066.524554] ata7: SATA link down (SStatus 0 SControl 300)
[155066.524569] ata7: EH complete
[155449.780452] ata7: exception Emask 0x10 SAct 0x0 SErr 0x1990000 action 0xe frozen
[155449.780461] ata7: irq_stat 0x00400000, PHY RDY changed
[155449.780469] ata7: SError: { PHYRdyChg 10B8B Dispar LinkSeq TrStaTrns }
[155449.780486] ata7: hard resetting link
[155450.498168] ata7: SATA link down (SStatus 100 SControl 300)
[155450.498182] ata7: EH complete
[162311.577143] EXT4-fs warning (device dm-0): ext4_end_bio:259: I/O error writing to inode 3424267 (offset 0 size 4096 starting block 876653877)
[162311.577809] EXT4-fs warning (device dm-0): ext4_end_bio:259: I/O error writing to inode 3424266 (offset 0 size 4096 starting block 876648988)
[162317.344302] Aborting journal on device dm-0-8.
[162317.344353] Buffer I/O error on device dm-0, logical block 731938816
[162317.344360] lost page write due to I/O error on dm-0
[162317.344378] JBD2: I/O error detected when updating journal superblock for dm-0-8.


--------------060005030306080705070709--
