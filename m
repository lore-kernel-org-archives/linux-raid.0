From: Bobby S <at7max@hotmail.com>
Subject: Needing help with Raid 5 array with 2 failed disks of 4
Date: Tue, 17 Oct 2006 08:24:54 -0700 (PDT)
Message-ID: <6857614.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello, I had a software raid 5 array of 4 disks drop two last night and was
curious of what help I may find.

I have 4 250GB maxtor drives in software raid 5 array and I seem to get the
dma_timer_expiry error comming up every few weeks and I was curious as to
how I may recover what I can from the array.

I am running the array on an Abit AT7 Max motherboard with an AMD 2400XP+
CPU, 1 GB ddr266 ram and a HPT 374 onboard raid controller with 4 channels.

Centos 4.3 with Vanilla Sources (2.6.17) is the current linux flavor.

So far I have left the affected system running without doing anything to it
and was curious where I should start?



Here are the dmesg and at the end the cat/proc/mdtstat outputs:

[root@localhost ~]# dmesg

[17429656.684000] hde: dma_timer_expiry: dma status == 0x21
[17429656.684000] hdg: dma_timer_expiry: dma status == 0x21
[17429666.684000] hde: DMA timeout error
[17429666.684000] hde: dma timeout error: status=0x50 { DriveReady
SeekComplete }
[17429666.684000] ide: failed opcode was: unknown
[17429666.684000] hdg: DMA timeout error
[17429666.684000] hdg: dma timeout error: status=0x50 { DriveReady
SeekComplete }
[17429666.684000] ide: failed opcode was: unknown
[17429666.684000] hde: task_in_intr: status=0x51 { DriveReady SeekComplete
Error }
[17429666.684000] hde: task_in_intr: error=0x04 { DriveStatusError }
[17429666.684000] ide: failed opcode was: unknown
[17429666.684000] hde: task_in_intr: status=0x51 { DriveReady SeekComplete
Error }
[17429666.684000] hde: task_in_intr: error=0x04 { DriveStatusError }
[17429666.684000] ide: failed opcode was: unknown
[17429666.684000] hdg: task_in_intr: status=0x51 { DriveReady SeekComplete
Error }
[17429666.684000] hdg: task_in_intr: error=0x04 { DriveStatusError }
[17429666.684000] ide: failed opcode was: unknown
[17429666.684000] hdg: task_in_intr: status=0x51 { DriveReady SeekComplete
Error }
[17429666.684000] hdg: task_in_intr: error=0x04 { DriveStatusError }
[17429666.684000] ide: failed opcode was: unknown
[17429666.688000] hde: task_in_intr: status=0x51 { DriveReady SeekComplete
Error }
[17429666.688000] hde: task_in_intr: error=0x04 { DriveStatusError }
[17429666.688000] ide: failed opcode was: unknown
[17429666.688000] hde: task_in_intr: status=0x51 { DriveReady SeekComplete
Error }
[17429666.688000] hde: task_in_intr: error=0x04 { DriveStatusError }
[17429666.688000] ide: failed opcode was: unknown
[17429666.688000] hdg: task_in_intr: status=0x51 { DriveReady SeekComplete
Error }
[17429666.692000] hdg: task_in_intr: error=0x04 { DriveStatusError }
[17429666.692000] ide: failed opcode was: unknown
[17429666.692000] hdg: task_in_intr: status=0x51 { DriveReady SeekComplete
Error }
[17429666.692000] hdg: task_in_intr: error=0x04 { DriveStatusError }
[17429666.692000] ide: failed opcode was: unknown
[17429666.736000] ide2: reset: success
[17429666.740000] ide3: reset: success
[17429686.848000] hde: dma_timer_expiry: dma status == 0x21
[17429686.856000] hdg: dma_timer_expiry: dma status == 0x21
[17429696.848000] hde: DMA timeout error
[17429700.884000] eth0: excessive work at interrupt.
[17429700.884000] hde: dma timeout error: status=0xba { Busy }
[17429700.884000] ide: failed opcode was: unknown
[17429700.884000] hde: DMA disabled
[17429700.884000] hdg: DMA timeout error
[17429700.884000] hdg: dma timeout error: status=0xba { Busy }
[17429700.884000] ide: failed opcode was: unknown
[17429700.884000] hdg: DMA disabled
[17429700.932000] ide2: reset: master: error (0x0a?)
[17429700.932000] ide3: reset: master: error (0x0a?)
[17429710.932000] hde: lost interrupt
[17429710.932000] hde: task_in_intr: status=0x7f { DriveReady DeviceFault
SeekComplete DataRequest CorrectedError Index Error }
[17429710.932000] hde: task_in_intr: error=0x7f { DriveStatusError
UncorrectableError SectorIdNotFound TrackZeroNotFound AddrMarkNotFound },
LBAsect=149568083689343, high=8914952, low=8355711, sector=402758271
[17429710.932000] ide: failed opcode was: unknown
[17429710.932000] hdg: lost interrupt
[17429710.932000] hdg: task_in_intr: status=0x7f { DriveReady DeviceFault
SeekComplete DataRequest CorrectedError Index Error }
[17429710.932000] hdg: task_in_intr: error=0x7f { DriveStatusError
UncorrectableError SectorIdNotFound TrackZeroNotFound AddrMarkNotFound },
LBAsect=149568083689343, high=8914952, low=8355711, sector=402758271
[17429710.932000] ide: failed opcode was: unknown
[17429710.980000] ide2: reset: master: error (0x0a?)
[17429710.980000] end_request: I/O error, dev hde, sector 402758271
repeating the previous line many many times with different sector numbers
...
[17429710.980000] end_request: I/O error, dev hde, sector 402758279
[17429710.984000] end_request: I/O error, dev hde, sector 402758559
[17429710.984000] end_request: I/O error, dev hde, sector 126019863
[17429710.992000] end_request: I/O error, dev hde, sector 126026191
[17429710.992000] end_request: I/O error, dev hde, sector 204444559
[17429710.996000] end_request: I/O error, dev hde, sector 204444727
[17429710.996000] ide3: reset: master: error (0x0a?)
[17429711.004000] end_request: I/O error, dev hdg, sector 402758559
[17429711.004000] end_request: I/O error, dev hdg, sector 126013855
[17429711.020000] end_request: I/O error, dev hdg, sector 126036287
[17429711.020000] end_request: I/O error, dev hdg, sector 204444223
[17429711.024000] end_request: I/O error, dev hdg, sector 204444439
[17429711.024000] raid5: Disk failure on hdg1, disabling device. Operation
continuing on 3 devices
[17429711.024000] raid5: Disk failure on hde1, disabling device. Operation
continuing on 2 devices
[17429711.024000] printk: 5 messages suppressed.
[17429711.024000] Buffer I/O error on device md0, logical block 151034312
[17429711.024000] lost page write due to I/O error on md0
[17429711.024000] Buffer I/O error on device md0, logical block 151034313
[17429711.024000] lost page write due to I/O error on md0
[17429711.024000] Buffer I/O error on device md0, logical block 151034314
[17429711.024000] lost page write due to I/O error on md0
[17429711.024000] Buffer I/O error on device md0, logical block 151034315
[17429711.024000] lost page write due to I/O error on md0
[17429711.024000] Buffer I/O error on device md0, logical block 151034316
[17429711.024000] lost page write due to I/O error on md0
[17429711.024000] Buffer I/O error on device md0, logical block 151034317
[17429711.028000] lost page write due to I/O error on md0
[17429711.028000] Buffer I/O error on device md0, logical block 151034318
[17429711.028000] lost page write due to I/O error on md0
[17429711.028000] Buffer I/O error on device md0, logical block 151034319
[17429711.028000] lost page write due to I/O error on md0
[17429711.028000] Buffer I/O error on device md0, logical block 151034320
[17429711.028000] lost page write due to I/O error on md0
[17429711.028000] Buffer I/O error on device md0, logical block 151034321
[17429711.028000] lost page write due to I/O error on md0
[17429711.028000] end_request: I/O error, dev hdg, sector 204444559
[17429711.028000] raid5: read error not correctable.
[17429711.028000] end_request: I/O error, dev hdg, sector 204444567
[17429711.028000] raid5: read error not correctable.
[17429711.028000] end_request: I/O error, dev hdg, sector 204444575
[17429711.028000] raid5: read error not correctable.
[17429711.028000] end_request: I/O error, dev hdg, sector 204444583
[17429711.028000] raid5: read error not correctable.
[17429711.028000] end_request: I/O error, dev hdg, sector 204444591
[17429711.028000] raid5: read error not correctable.
[17429711.028000] end_request: I/O error, dev hdg, sector 204444599
[17429711.028000] raid5: read error not correctable.
[17429711.028000] end_request: I/O error, dev hdg, sector 204444607
[17429711.028000] raid5: read error not correctable.
[17429711.032000] end_request: I/O error, dev hdg, sector 204444615
[17429711.032000] raid5: read error not correctable.
[17429711.032000] end_request: I/O error, dev hdg, sector 204444623
[17429711.032000] raid5: read error not correctable.
[17429711.032000] end_request: I/O error, dev hdg, sector 204444631
[17429711.032000] raid5: read error not correctable.
[17429711.032000] end_request: I/O error, dev hdg, sector 204444639
[17429711.032000] raid5: read error not correctable.
[17429711.032000] end_request: I/O error, dev hdg, sector 204444647
[17429711.032000] raid5: read error not correctable.
[17429711.032000] end_request: I/O error, dev hdg, sector 204444655
[17429711.032000] raid5: read error not correctable.
[17429711.032000] end_request: I/O error, dev hdg, sector 204444663
[17429711.032000] raid5: read error not correctable.
[17429711.032000] end_request: I/O error, dev hdg, sector 204444671
[17429711.032000] raid5: read error not correctable.
[17429711.032000] end_request: I/O error, dev hdg, sector 204444679
[17429711.032000] raid5: read error not correctable.
[17429711.032000] end_request: I/O error, dev hdg, sector 204444687
[17429711.032000] raid5: read error not correctable.
[17429711.032000] end_request: I/O error, dev hdg, sector 204444695
[17429711.032000] raid5: read error not correctable.
[17429711.032000] end_request: I/O error, dev hdg, sector 204444703
[17429711.032000] raid5: read error not correctable.
[17429711.036000] end_request: I/O error, dev hdg, sector 204444711
[17429711.036000] raid5: read error not correctable.
[17429711.036000] end_request: I/O error, dev hdg, sector 204444719
[17429711.036000] raid5: read error not correctable.
[17429711.036000] end_request: I/O error, dev hdg, sector 204444727
[17429711.036000] raid5: read error not correctable.
[17429711.036000] end_request: I/O error, dev hdg, sector 126019863
[17429711.036000] raid5: read error not correctable.
[17429711.036000] end_request: I/O error, dev hdg, sector 126019871
[17429711.036000] raid5: read error not correctable.
[17429711.036000] end_request: I/O error, dev hdg, sector 126019879
[17429711.036000] raid5: read error not correctable.
[17429711.036000] end_request: I/O error, dev hdg, sector 126019887
[17429711.036000] raid5: read error not correctable.
[17429711.036000] end_request: I/O error, dev hdg, sector 126019895
[17429711.036000] raid5: read error not correctable.
[17429711.036000] end_request: I/O error, dev hdg, sector 126019903
[17429711.036000] raid5: read error not correctable.
[17429711.036000] end_request: I/O error, dev hdg, sector 126019911
[17429711.036000] raid5: read error not correctable.
[17429711.036000] end_request: I/O error, dev hdg, sector 126019919
[17429711.036000] raid5: read error not correctable.
[17429711.036000] end_request: I/O error, dev hdg, sector 126019927
[17429711.036000] raid5: read error not correctable.
[17429711.036000] end_request: I/O error, dev hdg, sector 126019935
[17429711.036000] raid5: read error not correctable.
[17429711.040000] end_request: I/O error, dev hdg, sector 126019943
[17429711.040000] raid5: read error not correctable.
[17429711.040000] end_request: I/O error, dev hdg, sector 126019951
[17429711.040000] raid5: read error not correctable.
[17429711.040000] end_request: I/O error, dev hdg, sector 126025791
[17429711.040000] raid5: read error not correctable.
[17429711.040000] end_request: I/O error, dev hdg, sector 126025799
[17429711.040000] raid5: read error not correctable.
[17429711.040000] end_request: I/O error, dev hdg, sector 126025807
[17429711.040000] raid5: read error not correctable.
[17429711.040000] end_request: I/O error, dev hdg, sector 126025815
[17429711.040000] raid5: read error not correctable.
[17429711.040000] end_request: I/O error, dev hdg, sector 126025823
[17429711.040000] raid5: read error not correctable.
[17429711.040000] end_request: I/O error, dev hdg, sector 126025831
[17429711.040000] raid5: read error not correctable.
[17429711.040000] end_request: I/O error, dev hdg, sector 126025839
[17429711.040000] raid5: read error not correctable.
[17429711.040000] end_request: I/O error, dev hdg, sector 126025847
[17429711.040000] raid5: read error not correctable.
[17429711.040000] end_request: I/O error, dev hdg, sector 126025855
[17429711.040000] raid5: read error not correctable.
[17429711.040000] end_request: I/O error, dev hdg, sector 126025863
[17429711.040000] raid5: read error not correctable.
[17429711.044000] end_request: I/O error, dev hdg, sector 126025871
[17429711.044000] raid5: read error not correctable.
[17429711.044000] end_request: I/O error, dev hdg, sector 126025879
[17429711.044000] raid5: read error not correctable.
[17429711.044000] end_request: I/O error, dev hdg, sector 126025887
[17429711.044000] raid5: read error not correctable.
[17429711.044000] end_request: I/O error, dev hdg, sector 126025895
[17429711.044000] raid5: read error not correctable.
[17429711.044000] end_request: I/O error, dev hdg, sector 126025903
[17429711.044000] raid5: read error not correctable.
[17429711.044000] end_request: I/O error, dev hdg, sector 126025911
[17429711.044000] raid5: read error not correctable.
[17429711.044000] end_request: I/O error, dev hdg, sector 126025919
[17429711.044000] raid5: read error not correctable.
[17429711.044000] end_request: I/O error, dev hdg, sector 126025927
[17429711.044000] raid5: read error not correctable.
[17429711.044000] end_request: I/O error, dev hdg, sector 126025935
[17429711.044000] raid5: read error not correctable.
[17429711.044000] end_request: I/O error, dev hdg, sector 126025983
[17429711.044000] raid5: read error not correctable.
[17429711.044000] end_request: I/O error, dev hdg, sector 126025991
[17429711.044000] raid5: read error not correctable.
[17429711.044000] end_request: I/O error, dev hdg, sector 126025999
[17429711.044000] raid5: read error not correctable.
[17429711.048000] end_request: I/O error, dev hdg, sector 126026007
[17429711.048000] raid5: read error not correctable.
[17429711.048000] end_request: I/O error, dev hdg, sector 126026015
[17429711.048000] raid5: read error not correctable.
[17429711.048000] end_request: I/O error, dev hdg, sector 126026023
[17429711.048000] raid5: read error not correctable.
[17429711.048000] end_request: I/O error, dev hdg, sector 126026031
[17429711.048000] raid5: read error not correctable.
[17429711.048000] end_request: I/O error, dev hdg, sector 126026039
[17429711.048000] raid5: read error not correctable.
[17429711.048000] end_request: I/O error, dev hdg, sector 126026047
[17429711.048000] raid5: read error not correctable.
[17429711.048000] end_request: I/O error, dev hdg, sector 126026111
[17429711.048000] raid5: read error not correctable.
[17429711.048000] end_request: I/O error, dev hdg, sector 126026119
[17429711.048000] raid5: read error not correctable.
[17429711.048000] end_request: I/O error, dev hdg, sector 126026127
[17429711.048000] raid5: read error not correctable.
[17429711.048000] end_request: I/O error, dev hdg, sector 126026135
[17429711.048000] raid5: read error not correctable.
[17429711.048000] end_request: I/O error, dev hdg, sector 126026143
[17429711.048000] raid5: read error not correctable.
[17429711.048000] end_request: I/O error, dev hdg, sector 126026151
[17429711.048000] raid5: read error not correctable.
[17429711.052000] end_request: I/O error, dev hdg, sector 126026159
[17429711.052000] raid5: read error not correctable.
[17429711.052000] end_request: I/O error, dev hdg, sector 126026167
[17429711.052000] raid5: read error not correctable.
[17429711.052000] end_request: I/O error, dev hdg, sector 126026175
[17429711.052000] raid5: read error not correctable.
[17429711.052000] end_request: I/O error, dev hdg, sector 126026183
[17429711.052000] raid5: read error not correctable.
[17429711.052000] end_request: I/O error, dev hdg, sector 126026191
[17429711.052000] raid5: read error not correctable.
[17429711.096000] RAID5 conf printout:
[17429711.096000]  --- rd:4 wd:2 fd:2
[17429711.096000]  disk 0, o:0, dev:hde1
[17429711.096000]  disk 1, o:0, dev:hdg1
[17429711.096000]  disk 2, o:1, dev:hdi1
[17429711.100000]  disk 3, o:1, dev:hdk1
[17429711.116000] Aborting journal on device md0.
[17429711.116000] RAID5 conf printout:
[17429711.116000]  --- rd:4 wd:2 fd:2
[17429711.116000]  disk 0, o:0, dev:hde1
[17429711.116000]  disk 2, o:1, dev:hdi1
[17429711.116000]  disk 3, o:1, dev:hdk1
[17429711.116000] RAID5 conf printout:
[17429711.116000]  --- rd:4 wd:2 fd:2
[17429711.116000]  disk 0, o:0, dev:hde1
[17429711.116000]  disk 2, o:1, dev:hdi1
[17429711.116000]  disk 3, o:1, dev:hdk1
[17429711.116000] ext3_abort called.
[17429711.116000] EXT3-fs error (device md0): ext3_journal_start_sb:
Detected aborted journal
[17429711.116000] Remounting filesystem read-only
[17429711.128000] RAID5 conf printout:
[17429711.128000]  --- rd:4 wd:2 fd:2
[17429711.128000]  disk 2, o:1, dev:hdi1
[17429711.128000]  disk 3, o:1, dev:hdk1

[root@localhost ~]# cat /proc/mdstat
Personalities : [raid5] [raid4] [raid6] [multipath] [faulty] 
md0 : active raid5 hdk1[3] hdi1[2] hdg1[4](F) hde1[5](F)
      735334656 blocks level 5, 256k chunk, algorithm 2 [4/2] [__UU]
      
unused devices: <none>

Thank you for your time,

Bobby
-- 
View this message in context: http://www.nabble.com/Needing-help-with-Raid-5-array-with-2-failed-disks-of-4-tf2460295.html#a6857614
Sent from the linux-raid mailing list archive at Nabble.com.

