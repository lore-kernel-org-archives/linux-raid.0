From: "Donghui Wen" <dhwen@protegonetworks.com>
Subject: Re: can't reconstruct array and kernel panic
Date: Thu, 19 Jun 2003 15:22:26 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <001601c336b1$43a3b7a0$df01010a@moon>
References: <3EF2151C.8000006@bnap.hu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Farkas Levente <lfarkas@bnap.hu>, ataraid-list@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Try to use mdadm to recover.
mdadm ( -f) can assemble the array event if some superblocks appear
out-of-date.

Donghui

----- Original Message -----
From: "Farkas Levente" <lfarkas@bnap.hu>
To: <ataraid-list@redhat.com>; <linux-raid@vger.kernel.org>
Sent: Thursday, June 19, 2003 12:55 PM
Subject: can't reconstruct array and kernel panic


> hi,
> we've got a server with 3ware 7500-8 card and 8 pieces of 120GB maxtor
> hd. we use 7 of them in a software raid5 array and one spare disk on a
> fully updated rh 8.0 (kernel 2.4.20-18.8). it seems today at the same
> time 2 of the 7 disk are failed. it's strange that two disk failed at
> the same time. so I've got two problem:
> - the kernel crashed
> - after we reset the machine we can't reconstruct the array since 2 of
> the 7 disk failed. after we run matrox's test one of the disk is realy
> bad, but the second seems does not have any phisical error. we replace
> the wrong hd. but keep the second in place. is there any way to mark
> this second hd as NOT faulty? in this case I can save my date otherwise
> 500gb date are lost. is there any trick or dirty way to try to  recover
> the array?
> thank you for you help in advance.
> yours.
>
> here is the message log and at the and you can see the kernel panic:
> ----------------------------------------------------------
> Jun 19 16:10:49 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x7f, unit #3.
> Jun 19 16:10:49 black kernel: 3w-xxxx: scsi0: Reset succeeded.
> Jun 19 16:12:55 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x25, unit #2.
> Jun 19 16:12:55 black kernel: 3w-xxxx: scsi0: Reset succeeded.
> Jun 19 16:24:46 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #3.
> Jun 19 16:24:46 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #3.
> Jun 19 16:24:46 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #2.
> Jun 19 16:24:46 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #2.
> Jun 19 16:24:46 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #3.
> Jun 19 16:24:46 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #3.
> Jun 19 16:24:47 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #2.
> Jun 19 16:24:47 black last message repeated 2 times
> Jun 19 16:24:47 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #3.
> Jun 19 16:24:47 black last message repeated 3 times
> Jun 19 16:24:47 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #2.
> Jun 19 16:24:47 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #3.
> Jun 19 16:24:47 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #2.
> Jun 19 16:24:48 black last message repeated 3 times
> Jun 19 16:24:48 black kernel: 3w-xxxx: scsi0: Reset succeeded.
> Jun 19 16:25:23 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #2.
> Jun 19 16:25:23 black kernel: scsi: device set offline - not ready or
> command retry failed after host reset: host 0 channel 0 id 2 lun 0
> Jun 19 16:25:26 black kernel: 3w-xxxx: scsi0: AEN: WARNING: ATA port
> timeout: Port #2.
> Jun 19 16:25:52 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #2.
> Jun 19 16:25:52 black kernel: scsi: device set offline - not ready or
> command retry failed after host reset: host 0 channel 0 id 2 lun 0
> Jun 19 16:25:55 black kernel: 3w-xxxx: scsi0: AEN: WARNING: ATA port
> timeout: Port #2.
> Jun 19 16:26:21 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #2.
> Jun 19 16:26:21 black kernel: scsi: device set offline - not ready or
> command retry failed after host reset: host 0 channel 0 id 2 lun 0
> Jun 19 16:26:24 black kernel: 3w-xxxx: scsi0: AEN: WARNING: ATA port
> timeout: Port #2.
> Jun 19 16:26:50 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #2.
> Jun 19 16:26:50 black kernel: scsi: device set offline - not ready or
> command retry failed after host reset: host 0 channel 0 id 2 lun 0
> Jun 19 16:26:53 black kernel: 3w-xxxx: scsi0: AEN: WARNING: ATA port
> timeout: Port #2.
> Jun 19 16:27:19 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #2.
> Jun 19 16:27:19 black kernel: scsi: device set offline - not ready or
> command retry failed after host reset: host 0 channel 0 id 2 lun 0
> Jun 19 16:27:22 black kernel: 3w-xxxx: scsi0: AEN: WARNING: ATA port
> timeout: Port #2.
> Jun 19 16:27:48 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #2.
> Jun 19 16:27:48 black kernel: scsi: device set offline - not ready or
> command retry failed after host reset: host 0 channel 0 id 2 lun 0
> Jun 19 16:27:52 black kernel: 3w-xxxx: scsi0: AEN: WARNING: ATA port
> timeout: Port #2.
> Jun 19 16:28:17 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #2.
> Jun 19 16:28:17 black kernel: scsi: device set offline - not ready or
> command retry failed after host reset: host 0 channel 0 id 2 lun 0
> Jun 19 16:28:21 black kernel: 3w-xxxx: scsi0: AEN: WARNING: ATA port
> timeout: Port #2.
> Jun 19 16:28:46 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #2.
> Jun 19 16:28:46 black kernel: scsi: device set offline - not ready or
> command retry failed after host reset: host 0 channel 0 id 2 lun 0
> Jun 19 16:28:50 black kernel: 3w-xxxx: scsi0: AEN: WARNING: ATA port
> timeout: Port #2.
> Jun 19 16:29:15 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1b, unit #2.
> Jun 19 16:29:15 black kernel: scsi: device set offline - not ready or
> command retry failed after host reset: host 0 channel 0 id 2 lun 0
> Jun 19 16:29:19 black kernel: 3w-xxxx: scsi0: AEN: WARNING: ATA port
> timeout: Port #2.
> Jun 19 16:29:48 black kernel:  I/O error: dev 08:21, sector 26488
> Jun 19 16:29:48 black kernel: raid5: Disk failure on sdc1, disabling
> device. Operation continuing on 6 devices
> Jun 19 16:29:48 black kernel:  I/O error: dev 08:21, sector 120200632
> Jun 19 16:29:48 black kernel: SCSI disk error : host 0 channel 0 id 2
> lun 0 return code = 2
> Jun 19 16:29:48 black kernel:  I/O error: dev 08:21, sector 120200704
> Jun 19 16:29:48 black kernel:  I/O error: dev 08:21, sector 120200712
> Jun 19 16:29:48 black kernel: SCSI disk error : host 0 channel 0 id 2
> lun 0 return code = 2
> Jun 19 16:29:48 black kernel:  I/O error: dev 08:21, sector 120200448
> Jun 19 16:29:48 black kernel:  I/O error: dev 08:21, sector 120200456
> Jun 19 16:29:48 black kernel: SCSI disk error : host 0 channel 0 id 2
> lun 0 return code = 2
> Jun 19 16:29:48 black kernel:  I/O error: dev 08:21, sector 120200576
> Jun 19 16:29:48 black kernel: SCSI disk error : host 0 channel 0 id 2
> lun 0 return code = 2
> Jun 19 16:29:48 black kernel:  I/O error: dev 08:21, sector 120201328
> Jun 19 16:29:48 black kernel: SCSI disk error : host 0 channel 0 id 2
> lun 0 return code = 2
> Jun 19 16:29:48 black kernel:  I/O error: dev 08:21, sector 120200608
> Jun 19 16:29:48 black kernel: SCSI disk error : host 0 channel 0 id 2
> lun 0 return code = 2
> Jun 19 16:29:48 black kernel:  I/O error: dev 08:21, sector 120200488
> Jun 19 16:29:48 black kernel:  I/O error: dev 08:21, sector 120200496
> Jun 19 16:29:48 black kernel: SCSI disk error : host 0 channel 0 id 2
> lun 0 return code = 2
> Jun 19 16:29:48 black kernel:  I/O error: dev 08:21, sector 120200960
> Jun 19 16:29:48 black kernel:  I/O error: dev 08:21, sector 120200968
> Jun 19 16:29:48 black kernel: SCSI disk error : host 0 channel 0 id 2
> lun 0 return code = 2
> Jun 19 16:29:48 black kernel:  I/O error: dev 08:21, sector 120200592
> Jun 19 16:29:48 black kernel: SCSI disk error : host 0 channel 0 id 2
> lun 0 return code = 2
> Jun 19 16:29:48 black kernel:  I/O error: dev 08:21, sector 120200640
> Jun 19 16:29:48 black kernel:  I/O error: dev 08:21, sector 120200648
> Jun 19 16:29:48 black kernel: SCSI disk error : host 0 channel 0 id 2
> lun 0 return code = 2
> Jun 19 16:29:48 black kernel:  I/O error: dev 08:21, sector 120200624
> Jun 19 16:29:48 black kernel: md: updating md0 RAID superblock on device
> Jun 19 16:29:48 black kernel: md: sdh1 [events: 0000001a]<6>(write)
> sdh1's sb offset: 120053632
> Jun 19 16:29:48 black kernel: md: recovery thread got woken up ...
> Jun 19 16:29:48 black kernel: md0: resyncing spare disk sdh1 to replace
> failed disk
> Jun 19 16:29:48 black kernel: RAID5 conf printout:
> Jun 19 16:29:48 black kernel:  --- rd:7 wd:6 fd:1
> Jun 19 16:29:48 black kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
> Jun 19 16:29:48 black kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
> Jun 19 16:29:48 black kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:sdc1
> Jun 19 16:29:48 black kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
> Jun 19 16:29:48 black kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sde1
> Jun 19 16:29:48 black kernel:  disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdf1
> Jun 19 16:29:48 black kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdg1
> Jun 19 16:29:48 black kernel: RAID5 conf printout:
> Jun 19 16:29:48 black kernel:  --- rd:7 wd:6 fd:1
> Jun 19 16:29:48 black kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
> Jun 19 16:29:48 black kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
> Jun 19 16:29:48 black kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:sdc1
> Jun 19 16:29:48 black kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
> Jun 19 16:29:48 black kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sde1
> Jun 19 16:29:48 black kernel:  disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdf1
> Jun 19 16:29:48 black kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdg1
> Jun 19 16:29:48 black kernel: md: syncing RAID array md0
> Jun 19 16:29:48 black kernel: md: minimum _guaranteed_ reconstruction
> speed: 100 KB/sec/disc.
> Jun 19 16:29:48 black kernel: md: using maximum available idle IO
> bandwith (but not more than 10000 KB/sec) for reconstruction.
> Jun 19 16:29:48 black kernel: md: using 124k window, over a total of
> 120053632 blocks.
> Jun 19 16:29:48 black kernel: md: sdg1 [events: 0000001a]<6>(write)
> sdg1's sb offset: 120053632
> Jun 19 16:29:48 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1, unit #3.
> Jun 19 16:29:48 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x1, unit #3.
> Jun 19 16:29:51 black kernel: 3w-xxxx: scsi0: AEN: ERROR: Drive error:
> Port #3.
> Jun 19 16:29:51 black kernel: md: sdf1 [events: 0000001a]<6>(write)
> sdf1's sb offset: 120053632
> Jun 19 16:29:51 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x80, unit #3.
> Jun 19 16:29:55 black kernel: md: sde1 [events: 0000001a]<6>(write)
> sde1's sb offset: 120053632
> Jun 19 16:29:56 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x7f, unit #3.
> Jun 19 16:29:56 black kernel: 3w-xxxx: scsi0: Reset succeeded.
> Jun 19 16:30:06 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x7f, unit #3.
> Jun 19 16:30:06 black kernel: scsi: device set offline - not ready or
> command retry failed after host reset: host 0 channel 0 id 3 lun 0
> Jun 19 16:30:10 black kernel: 3w-xxxx: scsi0: AEN: ERROR: Drive error:
> Port #3.
> Jun 19 16:30:10 black kernel: 3w-xxxx: scsi0: Command failed: status =
> 0xc7, flags = 0x80, unit #3.
> Jun 19 16:30:10 black kernel: scsi: device set offline - not ready or
> command retry failed after host reset: host 0 channel 0 id 3 lun 0
> Jun 19 16:30:10 black kernel: SCSI disk error : host 0 channel 0 id 3
> lun 0 return code = 2
> Jun 19 16:30:10 black kernel:  I/O error: dev 08:31, sector 744
> Jun 19 16:30:10 black kernel: raid5: Disk failure on sdd1, disabling
> device. Operation continuing on 5 devices
> Jun 19 16:30:10 black kernel:  I/O error: dev 08:31, sector 752
> Jun 19 16:30:10 black kernel: SCSI disk error : host 0 channel 0 id 3
> lun 0 return code = 2
> Jun 19 16:30:10 black kernel:  I/O error: dev 08:31, sector 496
> Jun 19 16:30:10 black kernel:  I/O error: dev 08:31, sector 504
> Jun 19 16:30:13 black kernel: md: (skipping faulty sdd1 )
> Jun 19 16:30:13 black kernel: md: (skipping faulty sdc1 )
> Jun 19 16:30:13 black kernel: md: sdb1 [events: 0000001a]<6>(write)
> sdb1's sb offset: 120060736
> Jun 19 16:30:13 black kernel: md: sda1 [events: 0000001a]<6>(write)
> sda1's sb offset: 120060736
> Jun 19 16:30:13 black kernel: md: updating md0 RAID superblock on device
> Jun 19 16:30:13 black kernel: md: sdh1 [events: 0000001b]<6>(write)
> sdh1's sb offset: 120053632
> Jun 19 16:30:13 black kernel: md: sdg1 [events: 0000001b]<6>(write)
> sdg1's sb offset: 120053632
> Jun 19 16:30:13 black kernel: md: sdf1 [events: 0000001b]<6>(write)
> sdf1's sb offset: 120053632
> Jun 19 16:30:13 black kernel: md: sde1 [events: 0000001b]<6>(write)
> sde1's sb offset: 120053632
> Jun 19 16:30:13 black kernel: md: (skipping faulty sdd1 )
> Jun 19 16:30:13 black kernel: md: (skipping faulty sdc1 )
> Jun 19 16:30:13 black kernel: md: sdb1 [events: 0000001b]<6>(write)
> sdb1's sb offset: 120060736
> Jun 19 16:30:13 black kernel: md: sda1 [events: 0000001b]<6>(write)
> sda1's sb offset: 120060736
> Jun 19 16:30:13 black kernel: md: md_do_sync() got signal ... exiting
> Jun 19 16:30:13 black kernel: RAID5 conf printout:
> Jun 19 16:30:13 black kernel:  --- rd:7 wd:5 fd:2
> Jun 19 16:30:13 black kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
> Jun 19 16:30:13 black kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
> Jun 19 16:30:13 black kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:sdc1
> Jun 19 16:30:13 black kernel:  disk 3, s:0, o:0, n:3 rd:3 us:1 dev:sdd1
> Jun 19 16:30:13 black kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sde1
> Jun 19 16:30:13 black kernel:  disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdf1
> Jun 19 16:30:13 black kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdg1
> Jun 19 16:30:13 black kernel: RAID5 conf printout:
> Jun 19 16:30:13 black kernel:  --- rd:7 wd:5 fd:2
> Jun 19 16:30:13 black kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
> Jun 19 16:30:13 black kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
> Jun 19 16:30:13 black kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:sdc1
> Jun 19 16:30:13 black kernel:  disk 3, s:0, o:0, n:3 rd:3 us:1 dev:sdd1
> Jun 19 16:30:13 black kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sde1
> Jun 19 16:30:13 black kernel:  disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdf1
> Jun 19 16:30:13 black kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdg1
> Jun 19 16:30:13 black kernel: md: recovery thread got woken up ...
> Jun 19 16:30:13 black kernel: md0: resyncing spare disk sdh1 to replace
> failed disk
> Jun 19 16:30:13 black kernel: RAID5 conf printout:
> Jun 19 16:30:13 black kernel:  --- rd:7 wd:5 fd:2
> Jun 19 16:30:13 black kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
> Jun 19 16:30:13 black kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
> Jun 19 16:30:13 black kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:sdc1
> Jun 19 16:30:13 black kernel:  disk 3, s:0, o:0, n:3 rd:3 us:1 dev:sdd1
> Jun 19 16:30:13 black kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sde1
> Jun 19 16:30:13 black kernel:  disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdf1
> Jun 19 16:30:13 black kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdg1
> Jun 19 16:30:13 black kernel: RAID5 conf printout:
> Jun 19 16:30:13 black kernel:  --- rd:7 wd:5 fd:2
> Jun 19 16:30:13 black kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
> Jun 19 16:30:13 black kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
> Jun 19 16:30:13 black kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:sdc1
> Jun 19 16:30:13 black kernel:  disk 3, s:0, o:0, n:3 rd:3 us:1 dev:sdd1
> Jun 19 16:30:13 black kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sde1
> Jun 19 16:30:13 black kernel:  disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdf1
> Jun 19 16:30:13 black kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdg1
> Jun 19 16:30:13 black kernel: md: syncing RAID array md0
> Jun 19 16:30:13 black kernel: md: minimum _guaranteed_ reconstruction
> speed: 100 KB/sec/disc.
> Jun 19 16:30:13 black kernel: md: using maximum available idle IO
> bandwith (but not more than 10000 KB/sec) for reconstruction.
> Jun 19 16:30:13 black kernel: md: using 124k window, over a total of
> 120053632 blocks.
> Jun 19 16:30:13 black kernel: md: md_do_sync() got signal ... exiting
> Jun 19 16:30:13 black kernel: RAID5 conf printout:
> Jun 19 16:30:13 black kernel:  --- rd:7 wd:5 fd:2
> Jun 19 16:30:13 black kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
> Jun 19 16:30:13 black kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
> Jun 19 16:30:13 black kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:sdc1
> Jun 19 16:30:13 black kernel:  disk 3, s:0, o:0, n:3 rd:3 us:1 dev:sdd1
> Jun 19 16:30:13 black kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sde1
> Jun 19 16:30:13 black kernel:  disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdf1
> Jun 19 16:30:13 black kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdg1
> Jun 19 16:30:13 black kernel: RAID5 conf printout:
> Jun 19 16:30:13 black kernel:  --- rd:7 wd:5 fd:2
> Jun 19 16:30:13 black kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
> Jun 19 16:30:13 black kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
> Jun 19 16:30:13 black kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:sdc1
> Jun 19 16:30:13 black kernel:  disk 3, s:0, o:0, n:3 rd:3 us:1 dev:sdd1
> Jun 19 16:30:13 black kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sde1
> Jun 19 16:30:13 black kernel:  disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdf1
> Jun 19 16:30:13 black kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdg1
> Jun 19 16:35:44 black kernel: sector=528 i=6 00000000 00000000 dde3d43c 0
> Jun 19 16:35:44 black kernel: ------------[ cut here ]------------
> Jun 19 16:35:44 black kernel: kernel BUG at raid5.c:212!
> Jun 19 16:35:44 black kernel: invalid operand: 0000
> Jun 19 16:35:44 black kernel: nfs lockd sunrpc tg3 ohci1394 ieee1394
> raid5 xor mousedev keybdev hid input ehci-hcd usb-uhci usbcore ext3 jbd
> 3w-xxxx sd_mod scsi_mod
> Jun 19 16:35:44 black kernel: CPU:    0
> Jun 19 16:35:44 black kernel: EIP:    0010:[<f8994484>]    Not tainted
> Jun 19 16:35:44 black kernel: EFLAGS: 00010086
> Jun 19 16:35:44 black kernel:
> Jun 19 16:35:44 black kernel: EIP is at get_active_stripe [raid5] 0x1d4
> (2.4.20-18.8)
> Jun 19 16:35:44 black kernel: eax: 0000002c   ebx: f72c302c   ecx:
> f71b2000   edx: 00000000
> Jun 19 16:35:44 black kernel: esi: 00000006   edi: f72c3000   ebp:
> f7950c00   esp: f71b3d98
> Jun 19 16:35:44 black kernel: ds: 0018   es: 0018   ss: 0018
> Jun 19 16:35:44 black kernel: Process kjournald (pid: 278,
> stackpage=f71b3000)
> Jun 19 16:35:44 black kernel: Stack: f8997a73 00000528 00000006 00000000
> 00000000 dde3d43c 00000000 f7950c00
> Jun 19 16:35:44 black kernel:        00000000 00000001 00001000 00000296
> f724b000 00000001 00000028 f7950c00
> Jun 19 16:35:44 black kernel:        00000000 00000001 e7c7d270 f89962a8
> f7950c00 00000528 00001000 00000000
> Jun 19 16:35:44 black kernel: Call Trace:   [<f8997a73>] .rodata.str1.1
> [raid5] 0x8 (0xf71b3d98))
> Jun 19 16:35:44 black kernel: [<f89962a8>] raid5_make_request [raid5]
> 0x68 (0xf71b3de4))
> Jun 19 16:35:44 black kernel: [<c01e37c2>] md_make_request [kernel] 0x82
> (0xf71b3e18))
> Jun 19 16:35:44 black kernel: [<c019cbd1>] generic_make_request [kernel]
> 0xe1 (0xf71b3e2c))
> Jun 19 16:35:44 black kernel: [<f883ef36>] journal_write_metadata_buffer
> [jbd] 0x1e6 (0xf71b3e3c))
> Jun 19 16:35:44 black kernel: [<c019cc84>] submit_bh [kernel] 0x54
> (0xf71b3e58))
> Jun 19 16:35:44 black kernel: [<f883bb90>] journal_commit_transaction
> [jbd] 0x410 (0xf71b3e70))
> Jun 19 16:35:44 black kernel: [<c0117f3f>] schedule [kernel] 0x1ef
> (0xf71b3f60))
> Jun 19 16:35:44 black kernel: [<f883ec2a>] kjournald [jbd] 0x14a
> (0xf71b3fb8))
> Jun 19 16:35:44 black kernel: [<f883eac0>] commit_timeout [jbd] 0x0
> (0xf71b3fd8))
> Jun 19 16:35:44 black kernel: [<c010741e>] arch_kernel_thread [kernel]
> 0x2e (0xf71b3ff0))
> Jun 19 16:35:44 black kernel: [<f883eae0>] kjournald [jbd] 0x0
(0xf71b3ff8))
> Jun 19 16:35:44 black kernel:
> Jun 19 16:35:44 black kernel:
> Jun 19 16:35:44 black kernel: Code: 0f 0b d4 00 6b 7a 99 f8 8b 13 31 c0
> 0f b3 42 18 89 74 24 04
> ----------------------------------------------------------
>
> --
>    Levente                               "Si vis pacem para bellum!"
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

