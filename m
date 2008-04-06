From: Christian Kujau <christian@nerdbynature.de>
Subject: INFO: task md1_resync:3897 blocked for more than 120 seconds.
Date: Sun, 6 Apr 2008 02:24:00 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.0804060220040.14044@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again,

after a few difficulties with earlier -rc kernel, I was running 2.6.25-rc7 
for ~1 week and I'm currently running -rc8 for 2 now. About 2 hours ago
the weekly md check (triggered by Debian's checkarray script, basically
doing "echo check > /sys/block/$array/md/sync_action") made the kernel 
print:

[174861.373571] md: data-check of RAID array md0
[174861.373904] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[174861.374277] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[174861.374969] md: using 128k window, over a total of 371093312 blocks.
[174861.378073] md: delaying data-check of md1 until md0 has finished (they share one or more physical units)
[174861.380037] md: data-check of RAID array md3
[174861.380370] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[174861.380471] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[174861.381209] md: using 128k window, over a total of 143990464 blocks.
[174990.936065] INFO: task md1_resync:3897 blocked for more than 120 seconds.
[174990.936473] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[174990.937108] md1_resync    D c02c407a     0  3897      2
[174990.937462]        00000000 00000092 f7dc694c c02c407a f7d7ac0c f3ba5f84 f7dc6810 f7dc6a14 
[174990.937742]        c0379f55 c050e230 c04f8fe7 f7d7ac0c f7dc6c0c f7d7a810 314001e3 318001e3 
[174990.937999]        f7d7a800 00000000 f3ab0fd4 dae52d70 c04f8fe7 f7dc6800 dae52d70 00000000 
[174990.938256] Call Trace:
[174990.938462]  [<c02c407a>] _atomic_dec_and_lock+0x2a/0x40
[174990.938606]  [<c0379f55>] md_do_sync+0x915/0x9f0
[174990.938744]  [<c02c7817>] rb_insert_color+0x77/0xe0
[174990.938938]  [<c0115842>] enqueue_task_fair+0x52/0xa0
[174990.939077]  [<c037c8e0>] md_thread+0x0/0xe0
[174990.939208]  [<c012c900>] autoremove_wake_function+0x0/0x40
[174990.939573]  [<c037c8e0>] md_thread+0x0/0xe0
[174990.939900]  [<c037c902>] md_thread+0x22/0xe0
[174990.940229]  [<c043de5c>] schedule+0x16c/0x2a0
[174990.940562]  [<c037c8e0>] md_thread+0x0/0xe0
[174990.940888]  [<c012c632>] kthread+0x42/0x70
[174990.941223]  [<c012c5f0>] kthread+0x0/0x70
[174990.941544]  [<c0103a2f>] kernel_thread_helper+0x7/0x18
[174990.941899]  =======================
[174990.942206] INFO: lockdep is turned off.

Full dmesg and .config: http://nerdbynature.de/bits/2.6.25-rc8/

This looks alot like http://bugzilla.kernel.org/show_bug.cgi?id=10207, but 
this time the box is still usable, /bin/sync still does its job and from 
looking at /proc/mdstat, the resync is still processing. So, for now it's 
"only" the warning getting spit out every 120 seconds, because md1_resync 
*is* still waiting for the other resyncs to finish:

# cat /proc/mdstat
Personalities : [raid0] [raid1] 
md1 : active raid1 hdc2[1] hda2[0]
       18844160 blocks [2/2] [UU]
       	resync=DELAYED

md2 : active raid0 hdc3[1] hda3[0]
       1542016 blocks 64k chunks

md3 : active raid1 hdd1[1] hdb1[0]
       143990464 blocks [2/2] [UU]
       [================>....]  check = 84.9% (122268864/143990464) finish=13.2min speed=27418K/sec

md4 : active raid0 sdb2[0] hdd2[2] hdb2[1]
       37486400 blocks 64k chunks

md0 : active raid1 hdc1[1] hda1[0]
       371093312 blocks [2/2] [UU]
       [=========>...........]  check = 46.5% (172895552/371093312) finish=83.3min speed=39649K/sec

       unused devices: <none>

Can someone please look into this?

Thanks,
Christian.
-- 
BOFH excuse #374:

It's the InterNIC's fault.
