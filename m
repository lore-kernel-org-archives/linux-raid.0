From: Bo Yang <byang@dsg.stanford.edu>
Subject: Patch: kernel crash while trying to mount XFS on a failed-to-start
	raid5 array
Date: Sun, 16 Oct 2005 16:24:56 -0700
Message-ID: <1129505096.9776.19.camel@d-upal04-81-195.SFBay.Sun.COM>
Reply-To: byang@dsg.stanford.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was testing a modified raid5 implementation and ran into a kernel
crash while trying to do the following:

1) mkfs.xfs /dev/md0;
2) /dev/md0 running in degraded mode is shut down uncleanly;
3) reboot;
4) try to start the array;
5) raid5 refused to start the array and logged "raid5: cannot start
dirty degraded array";
6) mount /dev/md0 /mnt/test-dir;
7) kernel crash;

The following patch fixed this problem. I've only tested it with the
modified raid5 implementation. But looks like it's the same case for
vanilla raid5. I was using 2.6.9. Should apply to 2.6.13-stable as well.

--- linux-2.6.9.orig/drivers/md/raid5.c Mon Oct 25 11:49:50 2004
+++ linux-2.6.9/drivers/md/raid5.c      Sun Oct 16 15:25:21 2005
@@ -1697,6 +1700,14 @@
                kfree(conf);
        }
        mddev->private = NULL;
+       /* mddev is initialized in md_ioctl() when array is started.
+        * The object is passed to md layer via
+        * inode->i_bdev->bd_disk->private_data.
+        * Need to revert it back to its original state.
+        */
+       mddev->queue->unplug_fn = NULL;
+       mddev->queue->issue_flush_fn = NULL;
+
        printk(KERN_ALERT "raid5: failed to run raid set %s\n",
mdname(mddev));
        return -EIO;
 }


The following is the kernel message upon the crash:
Oct 14 18:58:13 mstor06 kernel: md: autorun ...
Oct 14 18:58:13 mstor06 kernel: md: considering sdai ...
Oct 14 18:58:13 mstor06 kernel: md:  adding sdai ...
Oct 14 18:58:13 mstor06 kernel: md:  adding sdp ...
Oct 14 18:58:13 mstor06 kernel: md:  adding sdat ...
Oct 14 18:58:13 mstor06 kernel: md:  adding sdy ...
Oct 14 18:58:13 mstor06 kernel: md: created md1
Oct 14 18:58:13 mstor06 kernel: md: bind<sdy>
Oct 14 18:58:13 mstor06 kernel: md: bind<sdat>
Oct 14 18:58:13 mstor06 kernel: md: bind<sdp>
Oct 14 18:58:13 mstor06 kernel: md: bind<sdai>
Oct 14 18:58:13 mstor06 kernel: md: running: <sdai><sdp><sdat><sdy>
Oct 14 18:58:13 mstor06 kernel: md: kicking non-fresh sdai from array!
Oct 14 18:58:13 mstor06 kernel: md: unbind<sdai>
Oct 14 18:58:13 mstor06 kernel: md: export_rdev(sdai)
Oct 14 18:58:13 mstor06 kernel: raid5: device sdp operational as raid
disk 3
Oct 14 18:58:13 mstor06 kernel: raid5: device sdat operational as raid
disk 1
Oct 14 18:58:13 mstor06 kernel: raid5: device sdy operational as raid
disk 0
Oct 14 18:58:13 mstor06 kernel: raid5: cannot start dirty degraded array
for md1
Oct 14 18:58:13 mstor06 kernel: RAID5 conf printout:
Oct 14 18:58:13 mstor06 kernel:  --- rd:4 wd:3 fd:1
Oct 14 18:58:13 mstor06 kernel:  disk 0, o:1, dev:sdy
Oct 14 18:58:13 mstor06 kernel:  disk 1, o:1, dev:sdat
Oct 14 18:58:13 mstor06 kernel:  disk 3, o:1, dev:sdp
Oct 14 18:58:13 mstor06 kernel: raid5: failed to run raid set md1
Oct 14 18:58:13 mstor06 kernel: md: pers->run() failed ...
Oct 14 18:58:13 mstor06 kernel: md :do_md_run() returned -22
Oct 14 18:58:13 mstor06 kernel: md: md1 stopped.
Oct 14 18:58:13 mstor06 kernel: md: unbind<sdp>
Oct 14 18:58:13 mstor06 kernel: md: export_rdev(sdp)
Oct 14 18:58:13 mstor06 kernel: md: unbind<sdat>
Oct 14 18:58:13 mstor06 kernel: md: export_rdev(sdat)
Oct 14 18:58:13 mstor06 kernel: md: unbind<sdy>
Oct 14 18:58:13 mstor06 kernel: md: export_rdev(sdy)
Oct 14 18:58:13 mstor06 kernel: md: ... autorun DONE.
Oct 14 18:58:16 mstor06 kernel: XFS: SB read failed
Oct 14 18:58:17 mstor06 kernel: Unable to handle kernel NULL pointer
dereference at virtual address 00000000
Oct 14 18:58:17 mstor06 kernel:  printing eip:
Oct 14 18:58:17 mstor06 kernel: f892e099
Oct 14 18:58:17 mstor06 kernel: *pde = 00000000
Oct 14 18:58:17 mstor06 kernel: Oops: 0000 [#1]
Oct 14 18:58:17 mstor06 kernel: SMP
Oct 14 18:58:17 mstor06 kernel: Modules linked in: raid5ext ixge ztx
mv_sata xor
Oct 14 18:58:17 mstor06 kernel: CPU:    0
Oct 14 18:58:17 mstor06 kernel: EIP:    0060:[<f892e099>]    Tainted:
P   VLI
Oct 14 18:58:17 mstor06 kernel: EFLAGS: 00010296   (2.6.9-bslk-1.3)
Oct 14 18:58:17 mstor06 kernel: EIP is at raid5_unplug_device+0x14/0x130
[raid5ext]
Oct 14 18:58:17 mstor06 kernel: eax: 00000000   ebx: e59ba068   ecx:
c029dd94   edx: f892e085
Oct 14 18:58:17 mstor06 kernel: esi: e63ebd8c   edi: e63ebdbc   ebp:
e63ebda0   esp: e63ebd78
Oct 14 18:58:17 mstor06 kernel: ds: 007b   es: 007b   ss: 0068
Oct 14 18:58:17 mstor06 kernel: Process mount (pid: 1602,
threadinfo=e63ea000 task=e5c635f0)
Oct 14 18:58:17 mstor06 kernel: Stack: c0419134 00000004 c0526d68
c0526d68 dfd5e000 00000020 00000000 e63ebd8c
Oct 14 18:58:17 mstor06 kernel:        e63ebd8c e63ebdbc e63ebda8
c029dda8 e63ebdd0 c0220ace 00000000 00000001
Oct 14 18:58:17 mstor06 kernel:        e6660ea0 e63ebdbc e63ebdbc
e60f9800 00000005 e6122800 e63ebe00 c02143db
Oct 14 18:58:17 mstor06 kernel: Call Trace:
Oct 14 18:58:17 mstor06 kernel:  [<c0106d5b>] show_stack+0x7a/0x90
Oct 14 18:58:17 mstor06 kernel:  [<c0106ede>] show_registers+0x152/0x1ba
Oct 14 18:58:17 mstor06 kernel:  [<c01070f4>] die+0x11f/0x1a2
Oct 14 18:58:17 mstor06 kernel:  [<c01178fc>] do_page_fault+0x359/0x5f3
Oct 14 18:58:17 mstor06 kernel:  [<c0106981>] error_code+0x2d/0x38
Oct 14 18:58:17 mstor06 kernel:  [<c029dda8>]
blk_backing_dev_unplug+0x14/0x16
Oct 14 18:58:17 mstor06 kernel:  [<c0220ace>]
xfs_flush_buftarg+0xfc/0x19e
Oct 14 18:58:17 mstor06 kernel:  [<c02143db>] xfs_mount+0x289/0x57d
Oct 14 18:58:17 mstor06 kernel:  [<c02262bc>] vfs_mount+0x1c/0x1f
Oct 14 18:58:17 mstor06 kernel:  [<c0226178>]
linvfs_fill_super+0x7f/0x181
Oct 14 18:58:17 mstor06 kernel:  [<c015d3e3>] get_sb_bdev+0xf0/0x11f
Oct 14 18:58:17 mstor06 kernel:  [<c0226296>] linvfs_get_sb+0x1c/0x26
Oct 14 18:58:17 mstor06 kernel:  [<c015d5af>] do_kern_mount+0x4d/0xcb
Oct 14 18:58:17 mstor06 kernel:  [<c0171862>] do_new_mount+0x89/0xba
Oct 14 18:58:17 mstor06 kernel:  [<c0171eec>] do_mount+0x140/0x174
Oct 14 18:58:17 mstor06 kernel:  [<c01722b0>] sys_mount+0x91/0x10a
Oct 14 18:58:17 mstor06 kernel:  [<c0105ec5>]
sysenter_past_esp+0x52/0x71
Oct 14 18:58:17 mstor06 kernel: Code: 9d ab c7 89 c2 f0 ff 4b 48 8b 45
f0 8b 48 48 eb b1 89 f0 ff d2 eb e4 55 89 e5 57 56 53 89 c3 83 ec 1c 8b
80 64 01 00 00 89 45 f0 <8b> 30 8d 96 d0 00 00 00 89 55 e8
 89 d0 e8 f7 9c ab c7 89 45 ec

- Bo

