From: Luca Berra <bluca@comedia.it>
Subject: parallel resync
Date: Mon, 29 Sep 2003 19:51:17 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030929175116.GA5305@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hello,
i have this problem
i have one server connected via two fc cards to two different storages.
the storages are intelligent so they handle raid internally and allow
mapping of one or more internal raid sets to different luns seen by the
host.
I use md to mirror between the two storages for disaster recovery
purposes.
The problem is that after an unclean shutdown (we had a big power outage
this weekend) all luns are resynced in parallel, thus bringing the
server and both storages down to their knees.

Having a look at match_mddev_units() in md.c (kernel 2.4) it seems to me
that raid code uses device major/minor number to determine if two md
devices are on the same underlying physical device.

from dev_unit():
mask = ~((1 << hd->minor_shift) - 1);
return MKDEV(MAJOR(dev), MINOR(dev) & mask);

in my case the logical drives are seen as different scsi devices by sd
layer, so all devices would appear to be on different disks, hence the
parallel resync effect.

I can change /proc/sys/dev/raid/speed_limit_max to a lower value to make
the server suffer less, but this won't stop the head trashing effect on
the storage.

Is there any way of having raid code use a different method for deciding
which devices are on the same physical device. i.e checking on which
scsi channel they appear.

I can, if i am short of option change match_mddev_units() to use a
different match_dev_unit() which uses a different dev_unit() which only
checks major, but i would have to hardcode a lot of stuff because sd
uses different major numbers (and i am thinking only of sd driver), or i
could add tunable with a kernel or module parameter that changes the
behaviour of md_do_sync()

smth like

recheck:
     serialize = 0;
     ITERATE_MDDEV(mddev2,tmp) {
         if (mddev2 == mddev)
             continue;
+        if (force_serialize) {
+            if (mddev2->curr_resync) {
+                printk(KERN_INFO "md: delaying resync of md%d until md%d "
+                       "has finished resync (force_serialize=1)\n",
+                       mdidx(mddev), mdidx(mddev2));
+                serialize = 1;
+                break;
+            }
+        } else 
         if (mddev2->curr_resync && match_mddev_units(mddev,mddev2)) {
             printk(KERN_INFO "md: delaying resync of md%d until md%d "
                    "has finished resync (they share one or more physical units)\n",
                    mdidx(mddev), mdidx(mddev2));
             serialize = 1;
             break;
         }
     }


An other idea could be storing a container indicator in the md superblock that
can be initialized by mdadm.

comments?

L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
