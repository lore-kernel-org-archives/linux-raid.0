From: <linux-raid.vger.kernel.org@atu.cjb.net>
Subject: =?UTF-8?B?UmU6IFJBSUQtNiBtZGFkbSBkaXNrcyBvdXQgb2Ygc3luYyBpc3N1ZSAobW9yZSBxdWVzdGlvbnMp?=
Date: Sun, 14 Jun 2009 15:01:12 -0600
Message-ID: <200906142101.n5EL1Hpj087478@cjb.net>
References: <b95d48b03b2756869e786c0982e54f86.squirrel@neil.brown.name>
Reply-To: <linux-raid.vger.kernel.org@atu.cjb.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b95d48b03b2756869e786c0982e54f86.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TmVpbEJyb3du?= <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> This doesn't make a lot of sense.  It should not have been marked
> as a spare unless someone explicitly tried to "Add" it to the
> array.
> 
> However you description of event suggests that this was automatic
> which is strange.

Yes, it was entirely automatic.  The only commands I had running on the computer when it happened were:

# watch -n 0.1 'uptime; echo; cat /proc/mdstat|grep md13 -A 2; echo; dmesg|tac'

This gave me a nice, simple display of what was going on with the
rebuild, and a monitor of dmesg in case there were any new kernel
messages.

> Can I get the complete kernel logs from when the rebuild started
> to when you finally gave up?  It might help me understand.

Sure.

Just to confirm, /dev/sd{a,b,c,d,e,f}1 are the partitions which
contain my up-to-date data.  /dev/sd{i,j}1 contain many days old data.

Here is the entire dmesg output during the rebuild:

[ 4245.3] md: md13 switched to read-write mode.
[ 4260.7] md: md13 still in use.
[ 4268.0] md: md13 still in use.
[ 4269.8] md: md13 still in use.
[ 4354.9] md: md13 still in use.
[ 4402.9] md: md13 switched to read-only mode.
[ 4408.1] md: md13 switched to read-write mode.

I had tried to add the two old disks (sdi and sdj) while the array was
in read-only mode for the rebuild, but it didn't allow me.  Is there
any way to mark the six valid disks as read-only so they will not be
modified during the rebuild (and not become spares, have their event
count updated, etc.)?

[ 4418.3] md: bind<sdi1>
[ 4418.4] RAID5 conf printout:
[ 4418.4]  --- rd:8 wd:6
[ 4418.4]  disk 0, o:1, dev:sdi1
[ 4418.4]  disk 1, o:1, dev:sdd1
[ 4418.4]  disk 2, o:1, dev:sda1
[ 4418.4]  disk 3, o:1, dev:sdf1
[ 4418.4]  disk 5, o:1, dev:sdc1
[ 4418.4]  disk 6, o:1, dev:sde1
[ 4418.4]  disk 7, o:1, dev:sdb1
[ 4418.4] md: recovery of RAID array md13
[ 4418.4] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 4418.4] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[ 4418.4] md: using 128k window, over a total of 975490752 blocks.
[ 4421.8] md: md_do_sync() got signal ... exiting
[ 4421.9] md: md13 switched to read-only mode.
[ 4549.0] md: md13 switched to read-write mode.

I again switched back to read-only mode, hoping it would continue
rebuilding, but it stopped, so I went back to read-write mode and
it resumed the rebuild.

[ 4549.0] RAID5 conf printout:
[ 4549.0]  --- rd:8 wd:6
[ 4549.0]  disk 0, o:1, dev:sdi1
[ 4549.0]  disk 1, o:1, dev:sdd1
[ 4549.0]  disk 2, o:1, dev:sda1
[ 4549.0]  disk 3, o:1, dev:sdf1
[ 4549.0]  disk 5, o:1, dev:sdc1
[ 4549.0]  disk 6, o:1, dev:sde1
[ 4549.0]  disk 7, o:1, dev:sdb1
[ 4549.0] RAID5 conf printout:
[ 4549.0]  --- rd:8 wd:6
[ 4549.0]  disk 0, o:1, dev:sdi1
[ 4549.0]  disk 1, o:1, dev:sdd1
[ 4549.0]  disk 2, o:1, dev:sda1
[ 4549.0]  disk 3, o:1, dev:sdf1
[ 4549.0]  disk 5, o:1, dev:sdc1
[ 4549.0]  disk 6, o:1, dev:sde1
[ 4549.0]  disk 7, o:1, dev:sdb1
[ 4549.0] md: recovery of RAID array md13
[ 4549.0] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 4549.0] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[ 4549.0] md: using 128k window, over a total of 975490752 blocks.
[ 4549.0] md: resuming recovery of md13 from checkpoint.
[ 4628.7] mdadm[19700]: segfault at 0 ip 000000000041617f sp 00007fff87776290 error 4 in mdadm[400000+2a000]

This new version of mdadm from after my Ubuntu 9.10 upgrade with Linux
2.6.28 seg faults every time a new event happens, such as a disk being
added or removed.  Prior to the upgrade, using Linux 2.6.17 and
whichever older version of mdadm it had, I had never seen it seg fault.

# mdadm --version

mdadm - v2.6.7.1 - 15th October 2008

[ 4647.7] ata1.00: exception Emask 0x0 SAct 0xff SErr 0x0 action 0x6 frozen
[ 4647.7] ata1.00: cmd 61/80:00:87:3c:63/00:00:00:00:00/40 tag 0 ncq 65536 out
[ 4647.7]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 4647.7] ata1.00: status: { DRDY }
[ 4647.7] ata1.00: cmd 61/40:08:07:3d:63/00:00:00:00:00/40 tag 1 ncq 32768 out
[ 4647.7]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 4647.7] ata1.00: status: { DRDY }
[ 4647.7] ata1.00: cmd 61/b0:10:47:3d:63/00:00:00:00:00/40 tag 2 ncq 90112 out
[ 4647.7]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 4647.7] ata1.00: status: { DRDY }
[ 4647.7] ata1.00: cmd 61/b8:18:f7:3d:63/01:00:00:00:00/40 tag 3 ncq 225280 out
[ 4647.7]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 4647.7] ata1.00: status: { DRDY }
[ 4647.7] ata1.00: cmd 61/60:20:af:3f:63/02:00:00:00:00/40 tag 4 ncq 311296 out
[ 4647.7]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 4647.7] ata1.00: status: { DRDY }
[ 4647.7] ata1.00: cmd 61/08:28:0f:42:63/01:00:00:00:00/40 tag 5 ncq 135168 out
[ 4647.7]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 4647.7] ata1.00: status: { DRDY }
[ 4647.7] ata1.00: cmd 61/b0:30:d7:43:63/00:00:00:00:00/40 tag 6 ncq 90112 out
[ 4647.7]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 4647.7] ata1.00: status: { DRDY }
[ 4647.7] ata1.00: cmd 61/c0:38:17:43:63/00:00:00:00:00/40 tag 7 ncq 98304 out
[ 4647.7]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 4647.7] ata1.00: status: { DRDY }
[ 4647.7] ata1: hard resetting link
[ 4648.2] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 4648.2] ata1.00: configured for UDMA/133
[ 4648.2] ata1: EH complete

I've noticed that dmesg most often lists disks as "ata1", "ata9" etc.
and I have found no way to convert these into /dev/sdc style format.
Do you know how to translate these disk identifiers?  It's really
quite frustrating not knowing which disk an error/message is from,
especially when 2 or 3 disks have issues at the same time.

[ 4648.2] sd 0:0:0:0: [sdi] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
[ 4648.2] sd 0:0:0:0: [sdi] Write Protect is off
[ 4648.2] sd 0:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[ 4648.2] sd 0:0:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

Proceeding is when I added the last disk back into the set.  I had hoped
that both disks could rebuild simultaneously, but it seems to force it
to only rebuild one at a time.  Is there any way to rebuild both disks
together?  It is frustrating having two idle CPUs during the rebuild,
and low disk throughput.  I'm guessing mdadm is not a threaded app.

Though I am actually going to keep /dev/sdj as a backup, in case there
is no way to successfully read the data from /dev/sdc.  sdj is a week
older than the rest of the data, but something would be better than
nothing.  Though I would try mounting it read-only and using rsync to
copy data off before I tried something that would break things like that.

[ 4648.3] md: bind<sdj1>
[ 4661.8] mdadm[19774]: segfault at 0 ip 000000000041617f sp 00007fff7630ae00 error 4 in mdadm[400000+2a000]
[ 4662.2] mdadm[19854]: segfault at 0 ip 000000000041617f sp 00007fff72062b80 error 4 in mdadm[400000+2a000]
[ 4697.7] mdadm[19913]: segfault at 0 ip 000000000041617f sp 00007fffefb31640 error 4 in mdadm[400000+2a000]
[ 4697.7] mdadm[19912]: segfault at 0 ip 000000000041617f sp 00007fff9b1bacb0 error 4 in mdadm[400000+2a000]
[ 4697.9] mdadm[19997]: segfault at 0 ip 000000000041617f sp 00007fffd001fb10 error 4 in mdadm[400000+2a000]
[ 4697.9] mdadm[20016]: segfault at 0 ip 000000000041617f sp 00007fff4e9d44f0 error 4 in mdadm[400000+2a000]
[ 4916.6] md: unbind<sdj1>
[ 4916.6] md: export_rdev(sdj1)
[ 4935.3] md: export_rdev(sdj1)
[ 4935.4] md: bind<sdj1>

At this point it was rebuilding fine.  It had an ETA of 4.5 hours left,
from the original 6.0 hours.  I left the house.  Following is the disk
error when I was gone:

[13691.4] ata5.00: exception Emask 0x0 SAct 0x3ff SErr 0x0 action 0x0
[13691.4] ata5.00: irq_stat 0x40000008
[13691.4] ata5.00: cmd 60/98:20:7f:af:fa/00:00:31:00:00/40 tag 4 ncq 77824 in
[13691.4]          res 41/40:00:f7:af:fa/09:00:31:00:00/40 Emask 0x409 (media error) <F>
[13691.4] ata5.00: status: { DRDY ERR }
[13691.4] ata5.00: error: { UNC }
[13691.4] ata5.00: configured for UDMA/133
[13691.4] ata5: EH complete
[13691.4] sd 4:0:0:0: [sdc] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
[13691.4] sd 4:0:0:0: [sdc] Write Protect is off
[13691.4] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[13691.4] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[13693.4] ata5.00: exception Emask 0x0 SAct 0x3ff SErr 0x0 action 0x0
[13693.4] ata5.00: irq_stat 0x40000008
[13693.4] ata5.00: cmd 60/98:28:7f:af:fa/00:00:31:00:00/40 tag 5 ncq 77824 in
[13693.4]          res 41/40:00:f7:af:fa/09:00:31:00:00/40 Emask 0x409 (media error) <F>
[13693.4] ata5.00: status: { DRDY ERR }
[13693.4] ata5.00: error: { UNC }
[13693.4] ata5.00: configured for UDMA/133
[13693.4] ata5: EH complete

It seems to me like it simply disconnected and then reconnected.  I have
always had this issue on all sorts of hardware on 2.6 kernels, which
makes me think it isn't always a hardware issue, and possibly a Linux
kernel/driver issue.

[13693.4] sd 4:0:0:0: [sdc] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
[13693.4] sd 4:0:0:0: [sdc] Write Protect is off
[13693.4] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[13693.4] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[13694.4] ata5.00: exception Emask 0x0 SAct 0x3ff SErr 0x0 action 0x0
[13694.4] ata5.00: irq_stat 0x40000008
[13694.4] ata5.00: cmd 60/98:20:7f:af:fa/00:00:31:00:00/40 tag 4 ncq 77824 in
[13694.4]          res 41/40:00:f7:af:fa/09:00:31:00:00/40 Emask 0x409 (media error) <F>
[13694.4] ata5.00: status: { DRDY ERR }
[13694.4] ata5.00: error: { UNC }
[13694.4] ata5.00: configured for UDMA/133
[13694.4] ata5: EH complete
[13694.4] sd 4:0:0:0: [sdc] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
[13694.4] sd 4:0:0:0: [sdc] Write Protect is off
[13694.4] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[13694.4] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[13695.4] ata5.00: exception Emask 0x0 SAct 0x3ff SErr 0x0 action 0x0
[13695.4] ata5.00: irq_stat 0x40000008
[13695.4] ata5.00: cmd 60/98:28:7f:af:fa/00:00:31:00:00/40 tag 5 ncq 77824 in
[13695.4]          res 41/40:00:f7:af:fa/09:00:31:00:00/40 Emask 0x409 (media error) <F>
[13695.4] ata5.00: status: { DRDY ERR }
[13695.4] ata5.00: error: { UNC }
[13695.4] ata5.00: configured for UDMA/133
[13695.4] ata5: EH complete
[13695.4] sd 4:0:0:0: [sdc] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
[13695.4] sd 4:0:0:0: [sdc] Write Protect is off
[13695.4] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[13695.4] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[13696.4] ata5.00: exception Emask 0x0 SAct 0x3ff SErr 0x0 action 0x0
[13696.4] ata5.00: irq_stat 0x40000008
[13696.4] ata5.00: cmd 60/98:20:7f:af:fa/00:00:31:00:00/40 tag 4 ncq 77824 in
[13696.4]          res 41/40:00:f7:af:fa/09:00:31:00:00/40 Emask 0x409 (media error) <F>
[13696.4] ata5.00: status: { DRDY ERR }
[13696.4] ata5.00: error: { UNC }
[13696.4] ata5.00: configured for UDMA/133
[13696.4] ata5: EH complete
[13696.4] sd 4:0:0:0: [sdc] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
[13696.4] sd 4:0:0:0: [sdc] Write Protect is off
[13696.4] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[13696.4] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[13697.4] ata5.00: exception Emask 0x0 SAct 0x3ff SErr 0x0 action 0x0
[13697.4] ata5.00: irq_stat 0x40000008
[13697.4] ata5.00: cmd 60/98:28:7f:af:fa/00:00:31:00:00/40 tag 5 ncq 77824 in
[13697.4]          res 41/40:00:f7:af:fa/09:00:31:00:00/40 Emask 0x409 (media error) <F>
[13697.4] ata5.00: status: { DRDY ERR }
[13697.4] ata5.00: error: { UNC }
[13697.4] ata5.00: configured for UDMA/133
[13697.4] sd 4:0:0:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
[13697.4] sd 4:0:0:0: [sdc] Sense Key : Medium Error [current] [descriptor]
[13697.4] Descriptor sense data with sense descriptors (in hex):
[13697.4]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
[13697.4]         31 fa af f7
[13697.4] sd 4:0:0:0: [sdc] Add. Sense: Unrecovered read error - auto reallocate failed
[13697.4] end_request: I/O error, dev sdc, sector 838512631
[13697.4] raid5:md13: read error not correctable (sector 838512568 on sdc1).
[13697.4] raid5: Disk failure on sdc1, disabling device.
[13697.4] raid5: Operation continuing on 5 devices.

This last line is something I have been baffled by -- how does a RAID-5
or RAID-6 device continue as "active" when fewer than the minimum number
of disks is present?  This happened with my RAID-5 swap array losing 2
disks, and happened above on a RAID-6 with only 5 of 8 disks.  When I
arrived home, it clearly said the array was still "active".

[13697.4] raid5:md13: read error not correctable (sector 838512576 on sdc1).
[13697.4] raid5:md13: read error not correctable (sector 838512584 on sdc1).
[13697.4] raid5:md13: read error not correctable (sector 838512592 on sdc1).
[13697.4] ata5: EH complete
[13697.4] sd 4:0:0:0: [sdc] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
[13697.4] sd 4:0:0:0: [sdc] Write Protect is off
[13697.4] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[13697.4] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[13711.0] md: md13: recovery done.

What is this "recovery done" referring to?  No recovery was completed.

[13711.1] RAID5 conf printout:
[13711.1]  --- rd:8 wd:5
[13711.1]  disk 0, o:1, dev:sdi1
[13711.1]  disk 1, o:1, dev:sdd1
[13711.1]  disk 2, o:1, dev:sda1
[13711.1]  disk 3, o:1, dev:sdf1
[13711.1]  disk 5, o:0, dev:sdc1
[13711.1]  disk 6, o:1, dev:sde1
[13711.1]  disk 7, o:1, dev:sdb1
[13711.1] RAID5 conf printout:
[13711.1]  --- rd:8 wd:5
[13711.1]  disk 1, o:1, dev:sdd1
[13711.1]  disk 2, o:1, dev:sda1
[13711.1]  disk 3, o:1, dev:sdf1
[13711.1]  disk 5, o:0, dev:sdc1
[13711.1]  disk 6, o:1, dev:sde1
[13711.1]  disk 7, o:1, dev:sdb1
[13711.1] RAID5 conf printout:
[13711.1]  --- rd:8 wd:5
[13711.1]  disk 1, o:1, dev:sdd1
[13711.1]  disk 2, o:1, dev:sda1
[13711.1]  disk 3, o:1, dev:sdf1
[13711.1]  disk 5, o:0, dev:sdc1
[13711.1]  disk 6, o:1, dev:sde1
[13711.1]  disk 7, o:1, dev:sdb1
[13711.1] RAID5 conf printout:
[13711.1]  --- rd:8 wd:5
[13711.1]  disk 1, o:1, dev:sdd1
[13711.1]  disk 2, o:1, dev:sda1
[13711.1]  disk 3, o:1, dev:sdf1
[13711.1]  disk 6, o:1, dev:sde1
[13711.1]  disk 7, o:1, dev:sdb1

I arrived home and performed the following commands
(I have removed some of the duplicate commands):

# mdadm --verbose --verbose --detail --scan /dev/md13
# mdadm --verbose --verbose --detail --scan /dev/md13
# mdadm /dev/md13 --remove /dev/sdj1 /dev/sdi1
# mdadm --verbose --verbose --detail --scan /dev/md13
# mdadm /dev/md13 --remove /dev/sdc1
# mdadm --verbose --verbose --detail --scan /dev/md13
# mdadm /dev/md13 --re-add /dev/sdc1
# mdadm --verbose --verbose --detail --scan /dev/md13
# mdadm /dev/md13 --remove /dev/sdc1
# mdadm --verbose --verbose --detail --scan /dev/md13
# mdadm --readonly /dev/md13
# cat /proc/mdstat
# man mdadm
# mdadm --stop /dev/md13
# c; for disk in /dev/sd{a,b,c,d,e,f}1; do mdadm --examine "$disk"; read; c; done
# c; for disk in /dev/sd{a,b,c,d,e,f}1; do printf "$disk"; mdadm --examine "$disk" | g events; done
# mdadm --stop /dev/md13
# mdadm --assemble /dev/md13 --verbose --force /dev/sd{a,b,c,d,e,f}1
# mdadm --stop /dev/md13
# mdadm --verbose --examine /dev/sdc1

I also detached the /dev/sdc disk and reattached it to my other SATA
controller.

[21281.4] md: unbind<sdj1>
[21281.4] md: export_rdev(sdj1)
[21281.4] md: unbind<sdi1>
[21281.4] md: export_rdev(sdi1)
[21281.5] Buffer I/O error on device md13, logical block 1463236112
[21281.5] Buffer I/O error on device md13, logical block 1463236112
[21281.5] Buffer I/O error on device md13, logical block 1463236126
[21281.5] Buffer I/O error on device md13, logical block 1463236126
[21281.5] Buffer I/O error on device md13, logical block 1463236127
[21281.5] Buffer I/O error on device md13, logical block 1463236127
[21281.5] Buffer I/O error on device md13, logical block 1463236127
[21281.5] Buffer I/O error on device md13, logical block 1463236127
[21281.5] Buffer I/O error on device md13, logical block 1463236127
[21281.5] Buffer I/O error on device md13, logical block 1463236127
[21307.3] md: unbind<sdc1>
[21307.3] md: export_rdev(sdc1)
[21307.4] __ratelimit: 6 callbacks suppressed
[21307.4] Buffer I/O error on device md13, logical block 1463236112
[21307.4] Buffer I/O error on device md13, logical block 1463236112
[21307.4] Buffer I/O error on device md13, logical block 1463236126
[21307.4] Buffer I/O error on device md13, logical block 1463236126
[21307.4] Buffer I/O error on device md13, logical block 1463236127
[21307.4] Buffer I/O error on device md13, logical block 1463236127
[21307.4] Buffer I/O error on device md13, logical block 1463236127
[21307.4] Buffer I/O error on device md13, logical block 1463236127
[21307.4] Buffer I/O error on device md13, logical block 1463236127
[21307.4] Buffer I/O error on device md13, logical block 1463236127
[21323.4] md: bind<sdc1>
[21323.5] __ratelimit: 6 callbacks suppressed
[21323.5] Buffer I/O error on device md13, logical block 1463236112
[21323.5] Buffer I/O error on device md13, logical block 1463236112
[21323.5] Buffer I/O error on device md13, logical block 1463236126
[21323.5] Buffer I/O error on device md13, logical block 1463236126
[21323.5] Buffer I/O error on device md13, logical block 1463236127
[21323.5] Buffer I/O error on device md13, logical block 1463236127
[21323.5] Buffer I/O error on device md13, logical block 1463236127
[21323.5] Buffer I/O error on device md13, logical block 1463236127
[21323.5] Buffer I/O error on device md13, logical block 1463236127
[21323.5] Buffer I/O error on device md13, logical block 1463236127
[21350.1] md: unbind<sdc1>
[21350.1] md: export_rdev(sdc1)
[21350.2] __ratelimit: 6 callbacks suppressed
[21350.2] Buffer I/O error on device md13, logical block 1463236112
[21350.2] Buffer I/O error on device md13, logical block 1463236112
[21350.2] Buffer I/O error on device md13, logical block 1463236126
[21350.2] Buffer I/O error on device md13, logical block 1463236126
[21350.2] Buffer I/O error on device md13, logical block 1463236127
[21350.2] Buffer I/O error on device md13, logical block 1463236127
[21350.2] Buffer I/O error on device md13, logical block 1463236127
[21350.2] Buffer I/O error on device md13, logical block 1463236127
[21350.2] Buffer I/O error on device md13, logical block 1463236127
[21350.2] Buffer I/O error on device md13, logical block 1463236127
[21368.1] md: md13 switched to read-only mode.
[21368.1] __ratelimit: 6 callbacks suppressed
[21368.1] Buffer I/O error on device md13, logical block 1463236112
[21368.1] Buffer I/O error on device md13, logical block 1463236112
[21368.1] Buffer I/O error on device md13, logical block 1463236126
[21368.1] Buffer I/O error on device md13, logical block 1463236126
[21368.1] Buffer I/O error on device md13, logical block 1463236127
[21368.1] Buffer I/O error on device md13, logical block 1463236127
[21368.1] Buffer I/O error on device md13, logical block 1463236127
[21368.1] Buffer I/O error on device md13, logical block 1463236127
[21368.1] Buffer I/O error on device md13, logical block 1463236127
[21368.1] Buffer I/O error on device md13, logical block 1463236127
[21488.8] md: md13 stopped.
[21488.8] md: unbind<sdf1>
[21488.8] md: export_rdev(sdf1)
[21488.8] md: unbind<sda1>
[21488.8] md: export_rdev(sda1)
[21488.8] md: unbind<sdd1>
[21488.8] md: export_rdev(sdd1)
[21488.8] md: unbind<sde1>
[21488.8] md: export_rdev(sde1)
[21488.8] md: unbind<sdb1>
[21488.8] md: export_rdev(sdb1)
[22603.8] ata5: exception Emask 0x10 SAct 0x0 SErr 0x1810000 action 0xe frozen
[22603.8] ata5: irq_stat 0x00400000, PHY RDY changed
[22603.8] ata5: SError: { PHYRdyChg LinkSeq TrStaTrns }
[22603.8] ata5: hard resetting link
[22604.5] ata5: SATA link down (SStatus 0 SControl 300)
[22609.5] ata5: hard resetting link
[22609.8] ata5: SATA link down (SStatus 0 SControl 300)
[22609.8] ata5: limiting SATA link speed to 1.5 Gbps
[22614.8] ata5: hard resetting link
[22615.2] ata5: SATA link down (SStatus 0 SControl 310)
[22615.2] ata5.00: disabled
[22615.2] ata5: EH complete
[22615.2] ata5.00: detaching (SCSI 4:0:0:0)
[22615.2] sd 4:0:0:0: [sdc] Synchronizing SCSI cache
[22615.2] sd 4:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[22615.2] sd 4:0:0:0: [sdc] Stopping disk
[22615.2] sd 4:0:0:0: [sdc] START_STOP FAILED
[22615.2] sd 4:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[22640.1] ata8: exception Emask 0x10 SAct 0x0 SErr 0x50000 action 0xe frozen
[22640.1] ata8: SError: { PHYRdyChg CommWake }
[22640.1] ata8: hard resetting link
[22640.8] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[22640.9] ata8.00: ATA-7: SAMSUNG HD103UJ, 1AA01109, max UDMA7
[22640.9] ata8.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 0/32)
[22640.9] ata8.00: configured for UDMA/100
[22640.9] ata8: EH complete
[22640.9] scsi 7:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
[22640.9] sd 7:0:0:0: [sdc] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
[22640.9] sd 7:0:0:0: [sdc] Write Protect is off
[22640.9] sd 7:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[22640.9] sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[22640.9] sd 7:0:0:0: [sdc] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
[22640.9] sd 7:0:0:0: [sdc] Write Protect is off
[22640.9] sd 7:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[22640.9] sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[22640.9]  sdc: sdc1 sdc2
[22640.9] sd 7:0:0:0: [sdc] Attached SCSI disk
[22640.9] sd 7:0:0:0: Attached scsi generic sg2 type 0
[22641.0] md: bind<sdc1>
[22687.9] md: md13 stopped.
[22687.9] md: unbind<sdc1>
[22687.9] md: export_rdev(sdc1)
[22804.2] md: md13 stopped.
[22804.2] md: bind<sda1>
[22804.2] md: bind<sdf1>
[22804.2] md: bind<sde1>
[22804.2] md: bind<sdb1>
[22804.2] md: bind<sdc1>
[22804.2] md: bind<sdd1>
[22864.5] md: md13 stopped.
[22864.5] md: unbind<sdd1>
[22864.6] md: export_rdev(sdd1)
[22864.6] md: unbind<sdc1>
[22864.6] md: export_rdev(sdc1)
[22864.6] md: unbind<sdb1>
[22864.6] md: export_rdev(sdb1)
[22864.6] md: unbind<sde1>
[22864.6] md: export_rdev(sde1)
[22864.6] md: unbind<sdf1>
[22864.6] md: export_rdev(sdf1)
[22864.6] md: unbind<sda1>
[22864.6] md: export_rdev(sda1)

> As long as there are two missing devices no resync will happen so the
> data will not be changed.  So after doing a --create you can fsck and
> mount etc and ensure the data is safe before continuing.

Thank you, that is useful information.

Do you know if the data on /dev/sdc1 would be altered as a result of
it becoming a Spare after it disconnected and reconnected itself?

> But if you cannot get though a sequential read of all devices without
> any read error, you wont be able to rebuild redundancy.  (There are
> plans to make raid6 more robust in this scenario, but they are a long
> way from fruition yet).

Prior to attempting the rebuild, I did the following:

# dd if=/dev/sda1 of=/dev/null &
# dd if=/dev/sdb1 of=/dev/null &
# dd if=/dev/sdc1 of=/dev/null &
# dd if=/dev/sdd1 of=/dev/null &
# dd if=/dev/sde1 of=/dev/null &
# dd if=/dev/sdf1 of=/dev/null &
# dd if=/dev/sdi1 of=/dev/null &
# dd if=/dev/sdj1 of=/dev/null &

I left it running for about an hour, and none of the disks had any errors.
I really hope it is not a permanent fault 75% of the way through the disk.
Though if it was just bad sectors, why would the disk be disconnecting
from the system?

Thanks again for all your help.

 - S.A.





