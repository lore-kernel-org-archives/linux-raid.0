From: David Greaves <david@dgreaves.com>
Subject: I've had a libata-sata / raid5 / lvm / reiserfs corruption problem
Date: Thu, 10 Jun 2004 15:31:15 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40C870B3.10900@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all
(also posted to linux-ide)

I've recently had an unpleasant experience building a 1Tb reiser fs on
an lvm2 lv on a raid5 array on sata disks through a promise tx4
controlled by libata - running 2.6.6.

Basically the system hard crashed whilst idle 2 hours after finishing a
raid5 resync. This was within hours of setting it up.

This seems to be a reasonable thing to want to do. The problem of course
is that each subsystem works individually.
(and yes, it could be an unrelated hardware fault, bad memory etc I'll
re-run memtest in a quiet period soon)

Since the filesystem rebuild it's been working happily serving
multiple-gigabyte video files.

What I did:
* HW is a promise TX4, 4x250Gb sata + 1 x 300Gb via-driven pata
* I built a raid 5 array to about a terrabyte with mdadm
* I built the array (degraded) with 4 sata disks
* I prepped for lvm2 and put an lvm2 volume on it.
* I formatted it with reiserfs
* I copied (rsync) ~400Gb of data over
* I mdadm added the 300Gb drive
* the resync finished
* 2 hours later the system crashed
* After a reboot the raid array + lvm came up but needed an fsck.reiser
--rebuild-tree to recover and showed extensive corruption.

The sync had finished cleanly at 4am and the machine died at 6am
Unfortunately I didn't note the errors properly - I assumed they would
have been logged - d'oh!

If you want the (almost) exact commands then see:
http://www.mythtv.info/moin.cgi/AdministrationSoftware_2fLvmRaid

Also, I have the raid5 resync patch from a few days ago
(http://marc.theaimsgroup.com/?l=linux-raid&m=108635099921570&w=2)


== I rebooted and looked at the logs
== (extract from kern.log - nothing removed between these times)
Jun  6 20:36:48 cu kernel: md: using maximum available idle IO bandwith
(but not more than 200000 KB/sec) for reconstruction.
Jun  6 20:36:48 cu kernel: md: using 128k window, over a total of
245111552 blocks.
Jun  6 20:42:26 cu kernel: nfs warning: mount version older than kernel
Jun  6 20:42:26 cu last message repeated 4 times
Jun  6 21:02:29 cu kernel: nfsd: last server has exited
Jun  6 21:02:29 cu kernel: nfsd: unexporting all filesystems
Jun  6 21:05:12 cu kernel: nfs_stat_to_errno: bad nfs status return
value: 11
Jun  6 21:05:13 cu last message repeated 362 times
Jun  6 21:05:14 cu kernel: nfs warning: mount version older than kernel
Jun  6 21:05:14 cu last message repeated 4 times
Jun  7 04:25:48 cu kernel: md: md0: sync done.
Jun  7 04:25:48 cu kernel: RAID5 conf printout:
Jun  7 04:25:48 cu kernel:  --- rd:5 wd:5 fd:0
Jun  7 04:25:48 cu kernel:  disk 0, o:1, dev:sda1
Jun  7 04:25:48 cu kernel:  disk 1, o:1, dev:sdc1
Jun  7 04:25:48 cu kernel:  disk 2, o:1, dev:sdb1
Jun  7 04:25:48 cu kernel:  disk 3, o:1, dev:sdd1
Jun  7 04:25:48 cu kernel:  disk 4, o:1, dev:hdb1

== 2 hours later it went down
== Nothing in the message logs at all:
== (from log/messages)
Jun  7 06:19:16 cu rpc.mountd: export request from 10.0.0.95
Jun  7 06:23:37 cu rpc.mountd: export request from 10.0.0.95
Jun  7 06:23:53 cu rpc.mountd: export request from 10.0.0.105
Jun  7 09:17:32 cu syslogd 1.4.1#10: restart.
Jun  7 09:17:32 cu kernel: klogd 1.4.1#10, log source = /proc/kmsg started.
Jun  7 09:17:32 cu kernel: Inspecting /boot/System.map-2.6.6
Jun  7 09:17:32 cu kernel: Loaded 27572 symbols from
/boot/System.map-2.6.6.
Jun  7 09:17:32 cu kernel: Symbols match kernel version 2.6.6.


== I remounted and it processed it's journal
== I looked around the fs and noticed a directory was empty and gave an
I/O error on an ls
== I fairly quickly stopped nfs and unmounted to run fsck

Jun  7 10:33:45 cu rpc.mountd: export request from 10.0.0.95
Jun  7 10:34:36 cu kernel: is_tree_node: node level 65535 does not match
to the expected one 1
Jun  7 10:34:36 cu kernel: vs-5150: search_by_key: invalid format found
in block 27361280. Fsck?
Jun  7 10:34:38 cu kernel: is_tree_node: node level 65535 does not match
to the expected one 1
Jun  7 10:34:38 cu kernel: vs-5150: search_by_key: invalid format found
in block 27361280. Fsck?
Jun  7 10:37:16 cu rpc.mountd: export request from 10.0.0.95
Jun  7 10:37:33 cu rpc.mountd: export request from 10.0.0.105
Jun  7 10:39:21 cu kernel: is_tree_node: node level 65535 does not match
to the expected one 1
Jun  7 10:39:21 cu kernel: vs-5150: search_by_key: invalid format found
in block 27361280. Fsck?
Jun  7 10:42:17 cu kernel: nfsd: last server has exited
Jun  7 10:42:17 cu kernel: nfsd: unexporting all filesystems


At this point I began a reiserfs fsck that lost quite a few files and
showed extensive corruption
I've been discussing offline with namesys guys who suspect a bad
reiser/sata interaction - well, a generic 'journalling-fs'/sata problem

Has anyone else tried resyncing a raid5 array like this? on libata maybe?
(If there are others who've performed this operation happily then I'll
look harder for system faults.)

Does anyone have any other thoughts as to the problem?
I feel pretty uncomfortable thinking that if one of my raid5 disks goes
down then I'm likely to be screwed on the resync!

David


