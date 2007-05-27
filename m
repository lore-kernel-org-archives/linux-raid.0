From: Tim Harvey <tim_harvey@yahoo.com>
Subject: assemble array without rebuild - readonly mode?
Date: Sat, 26 May 2007 18:44:15 -0700 (PDT)
Message-ID: <308187.13773.qm@web35614.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

I've got a RAID5 array running on 4 PATA IDE drives on a linux 2.6.15 kernel
which has had a drive go out.  When I replace the drive and force a re-assembly
a rebuild starts but at a certain point through the rebuild an uncorrectable
error occurs on another disk and kicks the 2nd disk out.  This occurs at the
same LBA every time.  I am wondering what some suggestions are for getting my
data off the array without causing the particular LBA to be read on the 2nd
disk thats got a problem.

Is there a way to assemble an array that has a disk replaced without causing a
rebuild and if so, is there a way to keep the array read-only so that I
minimize the chance of another error occurring while I'm pulling data off (or
does it really matter?).  I figure if I could mount the array in the safest way
possible with three disks out of 4 I can copy data off the array avoiding to
copy the file(s) that exist at the particular LBA causing the issue (by trial
and error).

Below are the messages from syslog showing the failure that occurs during the
rebuild.  I assume there is nothing else I can do about getting around this
error?


login as: root
root@nas2's password:
Last login: Sat May 26 15:25:01 2007 from darwin.home.harvey
[root@nas2 ~]# tail -f /var/log/messages
May 26 15:26:45 nas2 kernel: RAID5 conf printout:
May 26 15:26:45 nas2 kernel:  --- rd:4 wd:3 fd:1
May 26 15:26:45 nas2 kernel:  disk 0, o:1, dev:hde1
May 26 15:26:45 nas2 kernel:  disk 1, o:1, dev:hdf1
May 26 15:26:45 nas2 kernel:  disk 2, o:1, dev:hdg1
May 26 15:26:45 nas2 kernel:  disk 3, o:1, dev:hdh1
May 26 15:26:45 nas2 kernel: md: syncing RAID array md0
May 26 15:26:45 nas2 kernel: md: minimum _guaranteed_ reconstruction speed:
1000                                                                        
KB/sec/disc.
May 26 15:26:45 nas2 kernel: md: using maximum available idle IO bandwidth (but
                                                                        not
more than 200000 KB/sec) for reconstruction.
May 26 15:26:45 nas2 kernel: md: using 128k window, over a total of 292969216
bl                                                                        ocks.

May 26 15:26:45 nas2 kernel: md: syncing RAID array md0
May 26 15:26:45 nas2 kernel: md: minimum _guaranteed_ reconstruction speed:
1000 KB/sec/disc.
May 26 15:26:45 nas2 kernel: md: using maximum available idle IO bandwidth (but
not more than 200000 KB/sec) for reconstruction.
May 26 15:26:45 nas2 kernel: md: using 128k window, over a total of 292969216
blocks.
...
May 26 18:09:05 nas2 kernel: hdh: dma_intr: status=0x51 { DriveReady
SeekComplete Error }
May 26 18:09:05 nas2 kernel: hdh: dma_intr: error=0x40 { UncorrectableError },
LBAsect=385347135, high=22, low=16248383, sector=385347103
May 26 18:09:05 nas2 kernel: ide: failed opcode was: unknown
May 26 18:09:05 nas2 kernel: end_request: I/O error, dev hdh, sector 385347103
May 26 18:09:05 nas2 kernel: raid5: read error not correctable.
May 26 18:09:05 nas2 kernel: raid5: Disk failure on hdh1, disabling device.
Operation continuing on 2 devices
May 26 18:09:07 nas2 kernel: hdh: dma_intr: status=0x51 { DriveReady
SeekComplete Error }
May 26 18:09:07 nas2 kernel: hdh: dma_intr: error=0x40 { UncorrectableError },
LBAsect=385347135, high=22, low=16248383, sector=385347111
May 26 18:09:07 nas2 kernel: ide: failed opcode was: unknown
May 26 18:09:07 nas2 kernel: end_request: I/O error, dev hdh, sector 385347111
May 26 18:09:07 nas2 kernel: raid5: read error not correctable.
May 26 18:09:09 nas2 kernel: hdh: dma_intr: status=0x51 { DriveReady
SeekComplete Error }
May 26 18:09:09 nas2 kernel: hdh: dma_intr: error=0x40 { UncorrectableError },
LBAsect=385347135, high=22, low=16248383, sector=385347119
May 26 18:09:09 nas2 kernel: ide: failed opcode was: unknown
May 26 18:09:09 nas2 kernel: end_request: I/O error, dev hdh, sector 385347119
May 26 18:09:09 nas2 kernel: raid5: read error not correctable.
May 26 18:09:11 nas2 kernel: hdh: dma_intr: status=0x51 { DriveReady
SeekComplete Error }
May 26 18:09:11 nas2 kernel: hdh: dma_intr: error=0x40 { UncorrectableError },
LBAsect=385347135, high=22, low=16248383, sector=385347127
May 26 18:09:11 nas2 kernel: ide: failed opcode was: unknown
May 26 18:09:11 nas2 kernel: end_request: I/O error, dev hdh, sector 385347127
May 26 18:09:11 nas2 kernel: raid5: read error not correctable.
May 26 18:09:13 nas2 kernel: hdh: dma_intr: status=0x51 { DriveReady
SeekComplete Error }
May 26 18:09:13 nas2 kernel: hdh: dma_intr: error=0x40 { UncorrectableError },
LBAsect=385347135, high=22, low=16248383, sector=385347135
May 26 18:09:13 nas2 kernel: ide: failed opcode was: unknown
May 26 18:09:13 nas2 kernel: end_request: I/O error, dev hdh, sector 385347135
May 26 18:09:13 nas2 kernel: raid5: read error not correctable.
May 26 18:09:13 nas2 kernel: md: md0: sync done.
May 26 18:09:13 nas2 kernel: RAID5 conf printout:
May 26 18:09:13 nas2 kernel:  --- rd:4 wd:2 fd:2
May 26 18:09:13 nas2 kernel:  disk 0, o:1, dev:hde1
May 26 18:09:13 nas2 kernel:  disk 1, o:1, dev:hdf1
May 26 18:09:13 nas2 kernel:  disk 2, o:1, dev:hdg1
May 26 18:09:13 nas2 kernel:  disk 3, o:0, dev:hdh1
May 26 18:09:13 nas2 kernel: RAID5 conf printout:
May 26 18:09:13 nas2 kernel:  --- rd:4 wd:2 fd:2
May 26 18:09:13 nas2 kernel:  disk 0, o:1, dev:hde1
May 26 18:09:13 nas2 kernel:  disk 2, o:1, dev:hdg1
May 26 18:09:13 nas2 kernel:  disk 3, o:0, dev:hdh1
May 26 18:09:13 nas2 kernel: RAID5 conf printout:
May 26 18:09:13 nas2 kernel:  --- rd:4 wd:2 fd:2
May 26 18:09:13 nas2 kernel:  disk 0, o:1, dev:hde1
May 26 18:09:13 nas2 kernel:  disk 2, o:1, dev:hdg1
May 26 18:09:13 nas2 kernel:  disk 3, o:0, dev:hdh1
May 26 18:09:13 nas2 kernel: RAID5 conf printout:
May 26 18:09:13 nas2 kernel:  --- rd:4 wd:2 fd:2
May 26 18:09:13 nas2 kernel:  disk 0, o:1, dev:hde1
May 26 18:09:13 nas2 kernel:  disk 2, o:1, dev:hdg1

Thanks for any advice.

Tim
