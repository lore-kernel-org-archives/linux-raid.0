From: Ethan Wilson <ethan.wilson@shiftmail.org>
Subject: Bitmap does not account for write errors prior to kicking?
Date: Wed, 15 Jan 2014 16:31:41 +0100
Message-ID: <52D6A9DD.7030007@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello list,
I have spotted a problem but I don't know if it's related to MD, libata, 
SCSI, or the drive firmware. MD seems a bit more likely.

(kernel is 3.2.0-31-generic #50-Ubuntu SMP)

I have a raid5 array with a bitmap, like this

md1 : active raid5 sdd1[3] sdf1[5] sdc1[2] sdb1[1] sda1[0]
       3867340800 blocks super 1.2 level 5, 1024k chunk, algorithm 2 
[5/5] [UUUUU]
       bitmap: 5/58 pages [20KB], 8192KB chunk

sdd1 failed a few days ago with an IDNF error logged in dmesg (see 
bottom of email), which was repeated 8 times and eventually, after about 
90 seconds, triggered kicking of the drive out of the array.

After some SMART tests, the sdd disk appeared good to me, so I re-added 
it to the array.
There was a brief resync due to the bitmap, then all seemed good.

However, running a check afterwards, I found 464 mismatches between 
sectors 1206556120 and 1207194368  (numbers as coming out of sync_completed)
This is very near to the position of the IDNF error. Also I am quite 
confident that there were no mismatches before such episode.

Since the disk was kicked at the 8th IDNF error in dmesg and not before 
(not at the 1st or 2nd error... why?), and MD didn't complain before the 
8th error, I am wondering if something went wrong, such as some bitmaps 
bits might have cleared when in fact there were write errors pending 
(e.g. cleared after write errors were logged in dmesg, but prior to 
kicking the drive; such time frame was 88 seconds).

One more thing that puzzles me is that the position of the mismatches 
found by check is not equal, in fact a bit below in term of LBA 
position, to what I would expect from the IDNF, even if it's very near:
Consider that partition 1 in sdd starts at 32768 sectors (16MB) from the 
start of the disk, then there is an 1.2 MD superblock which is 1MB afair.
The IDNF error is at sector 1207453816 according to dmesg, and this is 
computed from the start of the disk, so I would have expected the 
mismatch to be a value 17MB lower than that, to account for partition 
offset and MD superblock, so it would be at sector 1207419000 , but in 
fact the mismatches are found between 1206556120 and 1207194368 as I 
said so they are at least 109MB above the reported IDNF error. 109MB are 
still a small distance considering the disk is 1TB so I am pretty sure 
such mismatches are related to the IDNF failure / drive kicking and not 
purely random.

But maybe the 109MB distance is due to that I don't know how to read 
those numbers.
This is how I found the mismatches offset: i periodically dumped the 
value of mismatch_cnt and that of sync_completed , while the array was 
performing the check:
the file is like:
.....
0,1205239464 / 1933670400
0,1205239464 / 1933670400
0,1205239464 / 1933670400
0,1205239464 / 1933670400
0,1205797472 / 1933670400
0,1205797472 / 1933670400
0,1205797472 / 1933670400
0,1205797472 / 1933670400
0,1206556120 / 1933670400
0,1206556120 / 1933670400
0,1206556120 / 1933670400
0,1206556120 / 1933670400
0,1206556120 / 1933670400
0,1206556120 / 1933670400
464,1206556120 / 1933670400
464,1207194368 / 1933670400
464,1207194368 / 1933670400
464,1207194368 / 1933670400
464,1207194368 / 1933670400
464,1207194368 / 1933670400
464,1207849472 / 1933670400
464,1207849472 / 1933670400
464,1207849472 / 1933670400
464,1207849472 / 1933670400
464,1207849472 / 1933670400
.....

so you see it jumps from 0 to 464 mismatches between 1206556120 and 
1207194368.


Here is the relevant part of the dmesg:
---------------------------------------------------------------------------
[7432327.406259] ata4.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 
action 0x0
[7432327.406333] ata4.00: irq_stat 0x40000008
[7432327.406374] ata4.00: failed command: WRITE FPDMA QUEUED
[7432327.406423] ata4.00: cmd 61/00:70:50:61:f6/04:00:47:00:00/40 tag 14 
ncq 524288 out
[7432327.406425]          res 41/10:a0:50:61:f6/00:00:47:00:00/40 Emask 
0x481 (invalid argument) <F>
[7432327.406563] ata4.00: status: { DRDY ERR }
[7432327.406602] ata4.00: error: { IDNF }
[7432327.408627] ata4.00: configured for UDMA/133
[7432327.408779] ata4: EH complete
[7432343.618770] ata4.00: exception Emask 0x0 SAct 0x40000000 SErr 0x0 
action 0x0
[7432343.618844] ata4.00: irq_stat 0x40000008
[7432343.618881] ata4.00: failed command: WRITE FPDMA QUEUED
[7432343.618929] ata4.00: cmd 61/a8:f0:58:55:f7/02:00:47:00:00/40 tag 30 
ncq 348160 out
[7432343.618931]          res 41/10:48:58:55:f7/00:00:47:00:00/40 Emask 
0x481 (invalid argument) <F>
[7432343.619071] ata4.00: status: { DRDY ERR }
[7432343.619110] ata4.00: error: { IDNF }
[7432343.621130] ata4.00: configured for UDMA/133
[7432343.621149] ata4: EH complete
[7432355.448978] ata4.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 
action 0x0
[7432355.449052] ata4.00: irq_stat 0x40000008
[7432355.449094] ata4.00: failed command: WRITE FPDMA QUEUED
[7432355.449142] ata4.00: cmd 61/00:b8:78:48:f8/04:00:47:00:00/40 tag 23 
ncq 524288 out
[7432355.449144]          res 41/10:c0:78:48:f8/00:01:47:00:00/40 Emask 
0x481 (invalid argument) <F>
[7432355.449283] ata4.00: status: { DRDY ERR }
[7432355.449322] ata4.00: error: { IDNF }
[7432355.451395] ata4.00: configured for UDMA/133
[7432355.451552] ata4: EH complete
[7432362.463288] ata4.00: exception Emask 0x0 SAct 0x7fffff81 SErr 0x0 
action 0x0
[7432362.463360] ata4.00: irq_stat 0x40000008
[7432362.463400] ata4.00: failed command: WRITE FPDMA QUEUED
[7432362.463448] ata4.00: cmd 61/00:38:78:48:f8/04:00:47:00:00/40 tag 7 
ncq 524288 out
[7432362.463450]          res 41/10:01:78:48:f8/00:00:47:00:00/40 Emask 
0x481 (invalid argument) <F>
[7432362.463589] ata4.00: status: { DRDY ERR }
[7432362.463628] ata4.00: error: { IDNF }
[7432362.466467] ata4.00: configured for UDMA/133
[7432362.466589] ata4: EH complete
[7432374.895106] ata4.00: exception Emask 0x0 SAct 0x1800000 SErr 0x0 
action 0x0
[7432374.895157] ata4.00: irq_stat 0x40000008
[7432374.895197] ata4.00: failed command: WRITE FPDMA QUEUED
[7432374.895244] ata4.00: cmd 61/00:b8:78:48:f8/04:00:47:00:00/40 tag 23 
ncq 524288 out
[7432374.895246]          res 41/10:01:78:48:f8/00:00:47:00:00/40 Emask 
0x481 (invalid argument) <F>
[7432374.895380] ata4.00: status: { DRDY ERR }
[7432374.895416] ata4.00: error: { IDNF }
[7432374.897471] ata4.00: configured for UDMA/133
[7432374.897498] ata4: EH complete
[7432381.899309] ata4.00: exception Emask 0x0 SAct 0x2 SErr 0x0 action 0x0
[7432381.899357] ata4.00: irq_stat 0x40000008
[7432381.899398] ata4.00: failed command: WRITE FPDMA QUEUED
[7432381.899446] ata4.00: cmd 61/00:08:78:48:f8/04:00:47:00:00/40 tag 1 
ncq 524288 out
[7432381.899448]          res 41/10:01:78:48:f8/00:00:47:00:00/40 Emask 
0x481 (invalid argument) <F>
[7432381.899585] ata4.00: status: { DRDY ERR }
[7432381.899624] ata4.00: error: { IDNF }
[7432381.901567] ata4.00: configured for UDMA/133
[7432381.901587] ata4: EH complete
[7432388.901393] ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
[7432388.901442] ata4.00: irq_stat 0x40000008
[7432388.901482] ata4.00: failed command: WRITE FPDMA QUEUED
[7432388.901526] ata4.00: cmd 61/00:00:78:48:f8/04:00:47:00:00/40 tag 0 
ncq 524288 out
[7432388.901528]          res 41/10:02:78:48:f8/00:00:47:00:00/40 Emask 
0x481 (invalid argument) <F>
[7432388.901660] ata4.00: status: { DRDY ERR }
[7432388.901696] ata4.00: error: { IDNF }
[7432388.903708] ata4.00: configured for UDMA/133
[7432388.903728] ata4: EH complete
[7432395.903549] ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
[7432395.903598] ata4.00: irq_stat 0x40000008
[7432395.903634] ata4.00: failed command: WRITE FPDMA QUEUED
[7432395.903682] ata4.00: cmd 61/00:00:78:48:f8/04:00:47:00:00/40 tag 0 
ncq 524288 out
[7432395.903684]          res 41/10:02:78:48:f8/00:00:47:00:00/40 Emask 
0x481 (invalid argument) <F>
[7432395.905818] ata4.00: status: { DRDY ERR }
[7432395.905859] ata4.00: error: { IDNF }
[7432395.907981] ata4.00: configured for UDMA/133
[7432395.908045] sd 3:0:0:0: [sdd]  Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[7432395.908050] sd 3:0:0:0: [sdd]  Sense Key : Aborted Command 
[current] [descriptor]
[7432395.908057] Descriptor sense data with sense descriptors (in hex):
[7432395.908061]         72 0b 14 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[7432395.908074]         47 f8 48 78
[7432395.908079] sd 3:0:0:0: [sdd]  Add. Sense: Recorded entity not found
[7432395.908086] sd 3:0:0:0: [sdd] CDB: Write(10): 2a 00 47 f8 48 78 00 
04 00 00
[7432395.908099] end_request: I/O error, dev sdd, sector 1207453816
[7432395.908231] ata4: EH complete
[7432402.906933] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[7432402.906982] ata4.00: irq_stat 0x40000001
[7432402.907021] ata4.00: failed command: FLUSH CACHE EXT
[7432402.907068] ata4.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[7432402.907070]          res 51/04:00:38:df:f7/00:00:00:00:00/a7 Emask 
0x1 (device error)
[7432402.907177] ata4.00: status: { DRDY ERR }
[7432402.907216] ata4.00: error: { ABRT }
[7432402.909334] ata4.00: configured for UDMA/133
[7432402.909349] ata4: EH complete
[7432409.907953] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[7432409.908002] ata4.00: irq_stat 0x40000001
[7432409.908041] ata4.00: failed command: FLUSH CACHE EXT
[7432409.908088] ata4.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[7432409.908090]          res 51/04:00:38:df:f7/00:00:00:00:00/a7 Emask 
0x1 (device error)
[7432409.908202] ata4.00: status: { DRDY ERR }
[7432409.908266] ata4.00: error: { ABRT }
[7432409.910976] ata4.00: configured for UDMA/133
[7432409.910998] ata4: EH complete
[7432414.078061] md/raid:md1: Disk failure on sdd1, disabling device.
[7432414.078062] md/raid:md1: Operation continuing on 4 devices.
[7432414.096961] RAID conf printout:
[7432414.096964]  --- level:5 rd:5 wd:4
[7432414.096965]  disk 0, o:1, dev:sda1
[7432414.096967]  disk 1, o:1, dev:sdb1
[7432414.096968]  disk 2, o:1, dev:sdc1
[7432414.096969]  disk 3, o:0, dev:sdd1
[7432414.096970]  disk 4, o:1, dev:sdf1
[7432414.097043] RAID conf printout:
[7432414.097049]  --- level:5 rd:5 wd:4
[7432414.097054]  disk 0, o:1, dev:sda1
[7432414.097057]  disk 1, o:1, dev:sdb1
[7432414.097060]  disk 2, o:1, dev:sdc1
[7432414.097063]  disk 4, o:1, dev:sdf1
---------------------------------------------------------------------------

What do you think about this problem?

Thanks
Ethan
