From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: raid1 bitmap code [Was: Re: Questions answered by Neil Brown]
Date: Thu, 13 Mar 2003 19:49:40 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200303131849.h2DIneX10112@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: From "(env:" "ptb)" at "Mar 1, 2003 01:36:30 pm"
To: ptb@it.uc3m.es
Cc: Paul Clements <Paul.Clements@SteelEye.com>, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Latest news (fr1-2.8) is that

   1) all the fallback bitmap counting is in place, so that if it can't
      get a page for the bitmap it falls back to counting the unbalance
      between mark and clear attempts per zone and reporting a zone
      dirty or clean according to the unbalance.

      (the bitmap pages are 4KB which maps to 32K blocks each, or 32MB
      with 1KB raid blocks.  There are 16 zones of 2MB in the region
      mapped by each page, and so the precision becomes 2MB instead of
      1KB in out-of-memory conditions.  The fallback counters are 16bit,
      so there is 32B of overhead in this scheme per 4KB page, or less
      than 0.1%.  If you have a 1TB device, it will need 32K pages, or
      128MB of bitmap, if all gets dirty.  That's about 0.01% of the
      mapped area.  But 1MB is preallocated for the fallback counters at
      startup).

      Incidentally, I don't know whether to get the counterspace in
      one lump via kmalloc, or to do it a group of 16 counters (32B) at
      a time.

   2) I have added an ioctl which informs a component device when it 
      is added to (or removed from) a raid device.

      The idea is that the informed device should maintain a list of 
      raid devices it is in, and when it changes to an enabled state
      then it should tell us so by calling our hot_add ioctl (or some
      other similar manouever of its choosing).

I'll add the patch for that below. The full thing is at

      ftp://oboe.it.uc3m.es/pub/Programs/fr1-2.8.tgz

And here's the patch to md.c (apply with -b .. tabs probably expanded
in mail):

@@ -587,6 +597,33 @@
        return 0;
 }

+static void
+notify_device (mddev_t * mddev, kdev_t dev)
+{
+#ifndef BLKMDNTFY
+#define BLKMDNTFY _IOW(0x12,133,sizeof(int))
+#endif
+       struct block_device *bdev;
+       printk (KERN_INFO "md%d: notifying dev %x\n", mdidx(mddev), dev);
+        bdev = bdget (dev);
+       if (!bdev)
+                return;
+        ioctl_by_bdev (bdev, BLKMDNTFY, MKDEV (MD_MAJOR, mddev->__minor));
+}
+static void
+unnotify_device (mddev_t * mddev, kdev_t dev)
+{
+#ifndef BLKMDUNTFY
+#define BLKMDUNTFY _IOW(0x12,134,sizeof(int))
+#endif
+       struct block_device *bdev;
+       printk (KERN_INFO "md%d: unnotifying dev %x\n", mdidx(mddev), dev);
+       bdev = bdget (dev);
+       if (!bdev)
+                return;
+        ioctl_by_bdev(bdev, BLKMDUNTFY, MKDEV(MD_MAJOR, mddev->__minor));
+}
+
 static MD_LIST_HEAD(all_raid_disks);
 static MD_LIST_HEAD(pending_raid_disks);

@@ -610,6 +647,7 @@
        rdev->mddev = mddev;
        mddev->nb_dev++;
        printk(KERN_INFO "md: bind<%s,%d>\n", partition_name(rdev->dev), mddev->nb_dev);
+       notify_device(mddev, rdev->dev);
 }

 static void unbind_rdev_from_array(mdk_rdev_t * rdev)
@@ -618,6 +656,7 @@
                MD_BUG();
                return;
        }
+       unnotify_device(rdev->mddev, rdev->dev);
        md_list_del(&rdev->same_set);
        MD_INIT_LIST_HEAD(&rdev->same_set);
        rdev->mddev->nb_dev--;


The additions are in bind/unbind to/from the array.


Peter

