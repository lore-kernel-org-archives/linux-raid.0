From: "Dailey, Nate" <Nate.Dailey@stratus.com>
Subject: crash: write_sb_page walks mddev.disks without holding reconfig_mutex
Date: Mon, 14 Jul 2008 14:30:24 -0400
Message-ID: <3DC430E8F4814543943B52C2F34BF52A119474@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: mingo@redhat.com, neilb@suse.de
List-Id: linux-raid.ids

Hitting several related crashes, and looking for advice/help...

I'm using MD raid1 under RHEL 5 update 2 (kernel 2.6.18-92.el5). I've
also incorporated a few upstream patches to address various bugs, but
don't believe any of these are causing what I'm now seeing.

I've hit 3 different crashes that all involve an rdev being ripped out
from under someone walking the mddev.disks list. It looks like the
reconfig_mutex is supposed to prevent this.

One of these cases has already been fixed upstream (modify
rdev_attr_store to call mddev_lock):

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=co
mmit;h=ca38805945edf5d1f5444b283eed95bb954772e8

But I don't see fixes for the other two. Here are the problematic code
paths (I'm using raid1, but I imagine the same thing applies to other
personalities):

- raid1d -> [freeze_array ->] flush_pending_writes -> bitmap_unplug ->
write_page -> write_sb_page

- raid1d -> md_check_recovery -> bitmap_daemon_work -> write_page ->
write_sb_page

In both cases, write_sb_page walks the mddev.disks list without holding
the reconfig_mutex. I think these are only problematic when using an
internal bitmap.

I've made changes that seem to fix these for me (patches below). But I'm
not sure I'm doing it in the best way possible, and specifically:

- I'm not using mddev_lock/unlock. This is mainly because mddev_unlock
wakes up the thread, which does not seem like something you want to do
unconditionally (my CPUs were monopolized running various raid1d
threads).

- I'm using mutex_lock_interruptible because that's what mddev_lock
uses, but no idea what to do if this call returns non-zero.

- Not sure about using mutex_lock vs. mutex_trylock. The existing code
in md_check_recovery uses trylock, but I'm not sure why.

So in other words, I have something that seems to work okay, but I don't
know this code well at all and am hoping to get this fixed the "right"
way.

Thanks!

Nate Dailey
Stratus Technologies



--- old/drivers/md/raid1.c      2008-07-14 13:51:02.000000000 -0400
+++ new/drivers/md/raid1.c      2008-07-14 13:51:22.000000000 -0400
@@ -625,7 +625,17 @@ static int flush_pending_writes(conf_t *
                spin_unlock_irq(&conf->device_lock);
                /* flush any pending bitmap writes to
                 * disk before proceeding w/ I/O */
-               bitmap_unplug(conf->mddev->bitmap);
+               /* Need the reconfig_mutex when calling bitmap_unplug to
+                  prevent an rdev from going away. What to do if mutex_
+                  lock_interruptible returns non-zero? */
+               if
(!mutex_lock_interruptible(&conf->mddev->reconfig_mutex)) {
+                       bitmap_unplug(conf->mddev->bitmap);
+
+                       /* Call only mutex_unlock (not md_wakeup_thread,
as
+                          mddev_unlock would do), don't want to wake
the
+                          thread. */
+                       mutex_unlock(&conf->mddev->reconfig_mutex);
+               }

                while (bio) { /* submit pending writes */
                        struct bio *next = bio->bi_next;


--- old/drivers/md/md.c 2008-07-09 14:44:13.000000000 -0400
+++ new/drivers/md/md.c 2008-07-11 15:59:21.000000000 -0400
@@ -5360,8 +5381,18 @@ void md_check_recovery(mddev_t *mddev)
        struct list_head *rtmp;


-       if (mddev->bitmap)
-               bitmap_daemon_work(mddev->bitmap);
+       if (mddev->bitmap) {
+               /* Need the reconfig mutex when calling
bitmap_daemon_work
+                  to prevent an rdev from going away. What to do if
+                  mddev_lock returns non-zero? */
+               if (!mddev_lock(mddev)) {
+                       bitmap_daemon_work(mddev->bitmap);
+
+                       /* Call mutex_unlock instead of mddev_unlock to
+                          avoid waking the thread. */
+                       mutex_unlock(&mddev->reconfig_mutex);
+               }
+       }

        if (mddev->ro)
                return;
