From: Nathan Hunsperger <linux-raid@hunsperger.com>
Subject: Raid5 resyncs after every reboot
Date: Tue, 3 Feb 2004 18:19:30 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040204021930.GA29676@munchnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi -

For some reason, my raid5 array resyncs after every reboot.  I don't
recall this happening originally, although I have had to hot-add disks
after failures and upgrade mdadm between then and now.

Below I have attached some logs of bootup.

All of the event counters are identical, so I wouldn't expect to see a
resync.  Does the kernel not stop raid arrays that it did not start?  I
ask because the disks in question are attached to a controller which is
started when its driver is loaded via a module.  When the module is
loaded, I have already seen md autodetect in the logs, and I have a
mdadm-raid script in my bootscripts which kicks in.  However, I don't
have any kill scripts on shutdown.  Lastly, after unmounting all file
systems, I see something blink on console about md0 (I believe to the
affect that it is in use) right before the actual reset.

If someone could provide insight into the resyncs (even though the
event counters are the same), or validate what I think may be happening
(meaning that md keeps a dirty bit around in addition to the event
counter), I'd appreciate that.

regards,
Nathan

Feb  3 15:59:51 screwdriver kernel: md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
Feb  3 15:59:51 screwdriver kernel: md: Autodetecting RAID arrays.
Feb  3 15:59:51 screwdriver kernel: md: autorun ...
Feb  3 15:59:51 screwdriver kernel: md: ... autorun DONE.
--snip--
<< module for controller loaded >>
--snip--
Feb  3 15:59:51 screwdriver kernel:  [events: 00000018]
Feb  3 15:59:51 screwdriver kernel: md: bind<scsi/host4/bus0/target1/lun0/part1,1>
Feb  3 15:59:51 screwdriver kernel:  [events: 00000018]
Feb  3 15:59:51 screwdriver kernel: md: bind<scsi/host4/bus0/target2/lun0/part1,2>
Feb  3 15:59:51 screwdriver kernel:  [events: 00000018]
Feb  3 15:59:51 screwdriver kernel: md: bind<scsi/host4/bus0/target3/lun0/part1,3>
Feb  3 15:59:51 screwdriver kernel:  [events: 00000018]
Feb  3 15:59:51 screwdriver kernel: md: bind<scsi/host4/bus0/target4/lun0/part1,4>
Feb  3 15:59:51 screwdriver kernel:  [events: 00000018]
Feb  3 15:59:51 screwdriver kernel: md: bind<scsi/host4/bus0/target5/lun0/part1,5>
Feb  3 15:59:51 screwdriver kernel:  [events: 00000018]
Feb  3 15:59:51 screwdriver kernel: md: bind<scsi/host4/bus0/target6/lun0/part1,6>
Feb  3 15:59:51 screwdriver kernel:  [events: 00000018]
Feb  3 15:59:51 screwdriver kernel: md: bind<scsi/host4/bus0/target7/lun0/part1,7>
Feb  3 15:59:51 screwdriver kernel:  [events: 00000018]
Feb  3 15:59:51 screwdriver kernel: md: bind<scsi/host4/bus0/target8/lun0/part1,8>
Feb  3 15:59:51 screwdriver kernel:  [events: 00000018]
Feb  3 15:59:51 screwdriver kernel: md: bind<scsi/host4/bus0/target9/lun0/part1,9>
Feb  3 15:59:51 screwdriver kernel:  [events: 00000018]
Feb  3 15:59:51 screwdriver kernel: md: bind<scsi/host4/bus0/target10/lun0/part1,10>
Feb  3 15:59:51 screwdriver kernel:  [events: 00000018]
Feb  3 15:59:51 screwdriver kernel: md: bind<scsi/host4/bus0/target11/lun0/part1,11>
Feb  3 15:59:51 screwdriver kernel:  [events: 00000018]
Feb  3 15:59:51 screwdriver kernel: md: bind<scsi/host4/bus0/target12/lun0/part1,12>
Feb  3 15:59:51 screwdriver kernel:  [events: 00000018]
Feb  3 15:59:51 screwdriver kernel: md: bind<scsi/host4/bus0/target13/lun0/part1,13>
Feb  3 15:59:51 screwdriver kernel:  [events: 00000018]
Feb  3 15:59:51 screwdriver kernel: md: bind<scsi/host4/bus0/target0/lun0/part1,14>
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target0/lun0/part1's event counter: 00000018
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target13/lun0/part1's event counter: 00000018
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target12/lun0/part1's event counter: 00000018
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target11/lun0/part1's event counter: 00000018
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target10/lun0/part1's event counter: 00000018
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target9/lun0/part1's event counter: 00000018
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target8/lun0/part1's event counter: 00000018
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target7/lun0/part1's event counter: 00000018
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target6/lun0/part1's event counter: 00000018
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target5/lun0/part1's event counter: 00000018
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target4/lun0/part1's event counter: 00000018
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target3/lun0/part1's event counter: 00000018
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target2/lun0/part1's event counter: 00000018
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target1/lun0/part1's event counter: 00000018
Feb  3 15:59:51 screwdriver kernel: md0: max total readahead window set to 3328k
Feb  3 15:59:51 screwdriver kernel: md0: 13 data-disks, max readahead per data-disk: 256k
Feb  3 15:59:51 screwdriver kernel: raid5: device scsi/host4/bus0/target0/lun0/part1 operational as raid disk 0
Feb  3 15:59:51 screwdriver kernel: raid5: device scsi/host4/bus0/target13/lun0/part1 operational as raid disk 13
Feb  3 15:59:51 screwdriver kernel: raid5: device scsi/host4/bus0/target12/lun0/part1 operational as raid disk 12
Feb  3 15:59:51 screwdriver kernel: raid5: device scsi/host4/bus0/target11/lun0/part1 operational as raid disk 11
Feb  3 15:59:51 screwdriver kernel: raid5: device scsi/host4/bus0/target10/lun0/part1 operational as raid disk 10
Feb  3 15:59:51 screwdriver kernel: raid5: device scsi/host4/bus0/target9/lun0/part1 operational as raid disk 9
Feb  3 15:59:51 screwdriver kernel: raid5: device scsi/host4/bus0/target8/lun0/part1 operational as raid disk 8
Feb  3 15:59:51 screwdriver kernel: raid5: device scsi/host4/bus0/target7/lun0/part1 operational as raid disk 7
Feb  3 15:59:51 screwdriver kernel: raid5: device scsi/host4/bus0/target6/lun0/part1 operational as raid disk 6
Feb  3 15:59:51 screwdriver kernel: raid5: device scsi/host4/bus0/target5/lun0/part1 operational as raid disk 5
Feb  3 15:59:51 screwdriver kernel: raid5: device scsi/host4/bus0/target4/lun0/part1 operational as raid disk 4
Feb  3 15:59:51 screwdriver kernel: raid5: device scsi/host4/bus0/target3/lun0/part1 operational as raid disk 3
Feb  3 15:59:51 screwdriver kernel: raid5: device scsi/host4/bus0/target2/lun0/part1 operational as raid disk 2
Feb  3 15:59:51 screwdriver kernel: raid5: device scsi/host4/bus0/target1/lun0/part1 operational as raid disk 1
Feb  3 15:59:51 screwdriver kernel: raid5: allocated 14819kB for md0
Feb  3 15:59:51 screwdriver kernel: raid5: raid level 5 set md0 active with 14 out of 14 devices, algorithm 2
Feb  3 15:59:51 screwdriver kernel: raid5: raid set md0 not clean; reconstructing parity
Feb  3 15:59:51 screwdriver kernel: RAID5 conf printout:
Feb  3 15:59:51 screwdriver kernel:  --- rd:14 wd:14 fd:0
Feb  3 15:59:51 screwdriver kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:scsi/host4/bus0/target0/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:scsi/host4/bus0/target1/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:scsi/host4/bus0/target2/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:scsi/host4/bus0/target3/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:scsi/host4/bus0/target4/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 5, s:0, o:1, n:5 rd:5 us:1 dev:scsi/host4/bus0/target5/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:scsi/host4/bus0/target6/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 7, s:0, o:1, n:7 rd:7 us:1 dev:scsi/host4/bus0/target7/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 8, s:0, o:1, n:8 rd:8 us:1 dev:scsi/host4/bus0/target8/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 9, s:0, o:1, n:9 rd:9 us:1 dev:scsi/host4/bus0/target9/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 10, s:0, o:1, n:10 rd:10 us:1 dev:scsi/host4/bus0/target10/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 11, s:0, o:1, n:11 rd:11 us:1 dev:scsi/host4/bus0/target11/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 12, s:0, o:1, n:12 rd:12 us:1 dev:scsi/host4/bus0/target12/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 13, s:0, o:1, n:13 rd:13 us:1 dev:scsi/host4/bus0/target13/lun0/part1
Feb  3 15:59:51 screwdriver kernel: RAID5 conf printout:
Feb  3 15:59:51 screwdriver kernel:  --- rd:14 wd:14 fd:0
Feb  3 15:59:51 screwdriver kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:scsi/host4/bus0/target0/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:scsi/host4/bus0/target1/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:scsi/host4/bus0/target2/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:scsi/host4/bus0/target3/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:scsi/host4/bus0/target4/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 5, s:0, o:1, n:5 rd:5 us:1 dev:scsi/host4/bus0/target5/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:scsi/host4/bus0/target6/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 7, s:0, o:1, n:7 rd:7 us:1 dev:scsi/host4/bus0/target7/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 8, s:0, o:1, n:8 rd:8 us:1 dev:scsi/host4/bus0/target8/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 9, s:0, o:1, n:9 rd:9 us:1 dev:scsi/host4/bus0/target9/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 10, s:0, o:1, n:10 rd:10 us:1 dev:scsi/host4/bus0/target10/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 11, s:0, o:1, n:11 rd:11 us:1 dev:scsi/host4/bus0/target11/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 12, s:0, o:1, n:12 rd:12 us:1 dev:scsi/host4/bus0/target12/lun0/part1
Feb  3 15:59:51 screwdriver kernel:  disk 13, s:0, o:1, n:13 rd:13 us:1 dev:scsi/host4/bus0/target13/lun0/part1
Feb  3 15:59:51 screwdriver kernel: md: updating md0 RAID superblock on device
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target0/lun0/part1 [events: 00000019]<6>(write) scsi/host4/bus0/target0/lun0/part1's sb offset: 35005504
Feb  3 15:59:51 screwdriver kernel: md: syncing RAID array md0
Feb  3 15:59:51 screwdriver kernel: md: minimum _guaranteed_ reconstruction speed: 100 KB/sec/disc.
Feb  3 15:59:51 screwdriver kernel: md: using maximum available idle IO bandwith (but not more than 100000 KB/sec) for reconstruction.
Feb  3 15:59:51 screwdriver kernel: md: using 124k window, over a total of 35005504 blocks.
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target13/lun0/part1 [events: 00000019]<6>(write) scsi/host4/bus0/target13/lun0/part1's sb offset: 35005504
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target12/lun0/part1 [events: 00000019]<6>(write) scsi/host4/bus0/target12/lun0/part1's sb offset: 35005504
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target11/lun0/part1 [events: 00000019]<6>(write) scsi/host4/bus0/target11/lun0/part1's sb offset: 35005504
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target10/lun0/part1 [events: 00000019]<6>(write) scsi/host4/bus0/target10/lun0/part1's sb offset: 35005504
Feb  3 15:59:51 screwdriver kernel: md: scsi/host4/bus0/target9/lun0/part1 [events: 00000019]<6>(write) scsi/host4/bus0/target9/lun0/part1's sb offset: 35005504
Feb  3 15:59:52 screwdriver kernel: md: scsi/host4/bus0/target8/lun0/part1 [events: 00000019]<6>(write) scsi/host4/bus0/target8/lun0/part1's sb offset: 35005504
Feb  3 15:59:52 screwdriver kernel: md: scsi/host4/bus0/target7/lun0/part1 [events: 00000019]<6>(write) scsi/host4/bus0/target7/lun0/part1's sb offset: 35005504
Feb  3 15:59:52 screwdriver kernel: md: scsi/host4/bus0/target6/lun0/part1 [events: 00000019]<6>(write) scsi/host4/bus0/target6/lun0/part1's sb offset: 35005504
Feb  3 15:59:52 screwdriver kernel: md: scsi/host4/bus0/target5/lun0/part1 [events: 00000019]<6>(write) scsi/host4/bus0/target5/lun0/part1's sb offset: 35005504
Feb  3 15:59:52 screwdriver kernel: md: scsi/host4/bus0/target4/lun0/part1 [events: 00000019]<6>(write) scsi/host4/bus0/target4/lun0/part1's sb offset: 35005504
Feb  3 15:59:52 screwdriver kernel: md: scsi/host4/bus0/target3/lun0/part1 [events: 00000019]<6>(write) scsi/host4/bus0/target3/lun0/part1's sb offset: 35005504
Feb  3 15:59:52 screwdriver kernel: md: scsi/host4/bus0/target2/lun0/part1 [events: 00000019]<6>(write) scsi/host4/bus0/target2/lun0/part1's sb offset: 35005504
Feb  3 15:59:52 screwdriver kernel: md: scsi/host4/bus0/target1/lun0/part1 [events: 00000019]<6>(write) scsi/host4/bus0/target1/lun0/part1's sb offset: 35005504
--snip--
