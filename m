From: Fernando Serboncini <fserb@campogeral.com.br>
Subject: RAID5 resync blocking on 2.6.0-test11
Date: Thu, 11 Dec 2003 22:25:57 -0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FD90B15.8050905@campogeral.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, I sent this e-mail to the LKML yesterday, that's when I found the 
linux-raid list. ;)

So hi, LinuxRaid

I've just installed a software-RAID 5 on my Alpha (miata) Workstation
500au with Kernel 2.6.0-test11. The RAID is made of 4 Western Digital
250Gb HDs on a promise-ata-133tx2.

The initial raidstart and mke2fs worked fine. After the initial sync, a
clean boot and a new raidstart, the /proc/mdstat reported that the drive
was at "resync" (/var/log/messages says that "raid array is not clean").

The problem is, the resync was blocking the /dev/md0. So, when I did a
'mount /dev/md0', it blocked until the resync was done (and it was a
looong time for a nearly 1TB RAID).

Looking through driver/md code I've realized that md_do_sync() was the
real devil. After a few diffs with 2.4.23 code I've realized that at the
speed limiter part of the function, the old "current->nice = " lines
were deleted.

After a few more search (and looking through LXR) at
/fs/jffs2/background.c and /net/bluetooth/bnep/core.c I've realized that
some people have changed "current->nice =" statements to
"set_user_nice(current,...)" ones.

Done that. The RAID worked just fine (still resyncing at boot, not fully
tested yet) but don't block mounts anymore (btw, mount returns a lot
faster than with 2.4.23).

Since I'm no kernel (nor RAID) expert (first post here, btw), just
wandering if I did something really stupid or not.

Also, is this an Alpha-only issue? Or a 2.6.0 issue?

Anyway, here follows the patch for what I've done.

thanks for the attention.

Fernando Serboncini



--- linux-2.6.0-test11/drivers/md/md.c  2003-11-26 18:43:29.000000000 -0200
+++ linux/drivers/md/md.c       2003-12-10 23:29:33.000000000 -0200
@@ -3290,6 +3290,8 @@
                 currspeed =
(j-mddev->resync_mark_cnt)/2/((jiffies-mddev->resync_mark)/HZ +1) +1;

                 if (currspeed > sysctl_speed_limit_min) {
+                       set_user_nice(current,19);
+
                         if ((currspeed > sysctl_speed_limit_max) ||
                                         !is_mddev_idle(mddev)) {
                                 current->state = TASK_INTERRUPTIBLE;
@@ -3297,6 +3299,8 @@
                                 goto repeat;
                         }
                 }
+               else
+                       set_user_nice(current,-20);
         }
         printk(KERN_INFO "md: md%d: sync done.\n",mdidx(mddev));
         /*



