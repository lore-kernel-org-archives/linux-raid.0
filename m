From: Chuck Ebbert <76306.1226@compuserve.com>
Subject: [PATCH][RFC] Fix "two RAID1 mirrors are faster than three"
Date: Mon, 12 May 2003 13:17:57 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200305121322_MC3-1-3884-D0AC@compuserve.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid <linux-raid@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids


  This patch is only lightly tested on 2.4.21-rc2-ac1.

  It attempts to speed up single sequential streaming reads as well as
fixing the problem with multiple streams not working on 3+ disk
mirrors.  With this patch applied I get full speed form all three
disks when reading three streams at once.

  A version of this on 2.4.20aa1 gives about 60% performance gains on s=
ingle
sequential streams but it yields effectively no gain on stock kernels (=
?)
I've given up trying to figure out why...

  How much of this is worth merging?  (One line has already been reject=
ed.)


diff -u --exclude-from=3D/home/me/.exclude -r 21p2-ref/drivers/md/raid1=
=2Ec linux-2.4.21-rc2-ac1/drivers/md/raid1.c
--- 21p2-ref/drivers/md/raid1.c Sat May 10 18:31:43 2003
+++ linux-2.4.21-rc2-ac1/drivers/md/raid1.c     Mon May 12 13:03:54 200=
3
@@ -8,6 +8,8 @@
  * RAID-1 management functions.
  *
  * Better read-balancing code written by Mika Kuoppala <miku@iki.fi>, =
2000
+ * Read balance rewritten for better sequential performance May 2003
+ *             by Chuck Ebbert <76306.1226@compuserve.com>
  *
  * Fixes to reconstruction by Jakob =D8stergaard" <jakob@ostenfeld.dk>
  * Various fixes by Neil Brown <neilb@cse.unsw.edu.au>
@@ -24,6 +26,8 @@
=20
 #include <linux/module.h>
 #include <linux/config.h>
+#include <linux/sysctl.h>
+#include <linux/proc_fs.h>
 #include <linux/slab.h>
 #include <linux/raid/raid1.h>
 #include <asm/atomic.h>
@@ -32,10 +36,44 @@
 #define MD_DRIVER
 #define MD_PERSONALITY
=20
-#define MAX_WORK_PER_DISK 128
-
 #define        NR_RESERVED_BUFS        32
=20
+/*
+ * Force disk switch after this many random
+ * sectors read in a row from one disk.
+ */
+static int sysctl_max_work_per_disk =3D          128;
+static int min_max_work_per_disk =3D             65;
+static int max_max_work_per_disk =3D             1280;
+/*
+ * Switch disks after this many sequential sectors.
+ */
+static int sysctl_max_seq_work_per_disk =3D      1408;
+static int min_max_seq_work_per_disk =3D         1281;
+static int max_max_seq_work_per_disk =3D         25600;
+
+static struct ctl_table_header *raid_table_header;
+enum {  /* FIXME: move to sysctl.h */
+       DEV_RAID_MAX_WORK_PER_DISK=3D3,
+       DEV_RAID_MAX_SEQ_WORK_PER_DISK=3D4,
+};
+static ctl_table raid_table[] =3D {
+       {DEV_RAID_MAX_WORK_PER_DISK, "max_work_per_disk", &sysctl_max_w=
ork_per_disk,
+        sizeof(int), 0644, NULL, &proc_dointvec_minmax, &sysctl_intvec=
,
+        NULL, &min_max_work_per_disk, &max_max_work_per_disk},
+       {DEV_RAID_MAX_SEQ_WORK_PER_DISK, "max_seq_work_per_disk", &sysc=
tl_max_seq_work_per_disk,
+        sizeof(int), 0644, NULL, &proc_dointvec_minmax, &sysctl_intvec=
,
+        NULL, &min_max_seq_work_per_disk, &max_max_seq_work_per_disk},
+       {0}
+};
+static ctl_table raid_dir_table[] =3D {
+       {DEV_RAID, "raid", NULL, 0, 0555, raid_table},
+       {0}
+};
+static ctl_table raid_root_table[] =3D {
+       {CTL_DEV, "dev", NULL, 0, 0555, raid_dir_table},
+       {0}
+};
=20
 /*
  * The following can be used to debug the driver
@@ -332,14 +370,14 @@
         */
=20
        for (i =3D 0; i < disks; i++) {
-               if (conf->mirrors[i].operational) {
+               if (READABLE_MIRROR(i)) {
                        *rdev =3D conf->mirrors[i].dev;
-                       return (0);
+                       return 0;
                }
        }
=20
-       printk (KERN_ERR "raid1_map(): huh, no more operational devices=
?\n");
-       return (-1);
+       printk(KERN_ERR "raid1_map(): huh, no more operational devices?=
\n");
+       return -1;
 }
=20
 static void raid1_reschedule_retry (struct raid1_bh *r1_bh)
@@ -464,112 +502,85 @@
  * in array and when new read requests come, the disk which last
  * position is nearest to the request, is chosen.
  *
- * TODO: now if there are 2 mirrors in the same 2 devices, performance
+ * If there are two mirrors on the same two devices, performance
  * degrades dramatically because position is mirror, not device based.
- * This should be changed to be device based. Also atomic sequential
- * reads should be somehow balanced.
  */
=20
 static int raid1_read_balance (raid1_conf_t *conf, struct buffer_head =
*bh)
 {
-       int new_disk =3D conf->last_used;
-       const int sectors =3D bh->b_size >> 9;
        const unsigned long this_sector =3D bh->b_rsector;
-       int disk =3D new_disk;
-       unsigned long new_distance;
-       unsigned long current_distance;
-      =20
-       /*
-        * Check if it is sane at all to balance
-        */
-      =20
-       if (conf->resync_mirrors)
-               goto rb_out;
-      =20
-
-       /* make sure that disk is operational */
-       while( !conf->mirrors[new_disk].operational) {
-               if (new_disk <=3D 0) new_disk =3D conf->raid_disks;
-               new_disk--;
-               if (new_disk =3D=3D disk) {
-                       /*
-                        * This means no working disk was found
-                        * Nothing much to do, lets not change anything
-                        * and hope for the best...
-                        */
-                      =20
-                       new_disk =3D conf->last_used;
+       unsigned long new_distance, temp_distance;
+       const unsigned int sectors =3D bh->b_size >> 9;
+       int old_disk =3D conf->last_used;
+       int new_disk =3D old_disk, temp_disk =3D old_disk, first_disk;
=20
-                       goto rb_out;
-               }
-       }
-       disk =3D new_disk;
-       /* now disk =3D=3D new_disk =3D=3D starting point for search */
-      =20
        /*
-        * Don't touch anything for sequential reads.
+        * Do not balance if resyncing.
         */
+       if (unlikely(conf->resync_mirrors))
+               goto rb_out_nocount;
=20
-       if (this_sector =3D=3D conf->mirrors[new_disk].head_position)
-               goto rb_out;
-      =20
+rb_find_first:
        /*
-        * If reads have been done only on a single disk
-        * for a time, lets give another disk a change.
-        * This is for kicking those idling disks so that
-        * they would find work near some hotspot.
+        * Look for two readable disks and save the index of the
+        * first alternate for later in case of forced disk switch.
         */
+       first_disk =3D ITER_NEXT_READABLE(temp_disk, old_disk);
+       if (unlikely(first_disk =3D=3D old_disk))
+               /* No additional disks are available. */
+               goto rb_out_nocount;
+
+       if (unlikely(!READABLE_MIRROR(old_disk))) {
+               new_disk =3D old_disk =3D temp_disk;
+               goto rb_find_first;
+       }
       =20
-       if (conf->sect_count >=3D conf->mirrors[new_disk].sect_limit) {
-               conf->sect_count =3D 0;
+       new_distance =3D HEAD_DISTANCE(new_disk, this_sector);
+       if (new_distance =3D=3D 0) {
+               /* Sequential read, same disk as last. */
+               if (unlikely(conf->same_count >=3D sysctl_max_seq_work_=
per_disk))
+                       goto rb_out_force_switch;
=20
+               goto rb_out; /* Do not switch disks. */
+       }
+
+       do {    /* Look for the nearest disk. */
+
+               temp_distance =3D HEAD_DISTANCE(temp_disk, this_sector)=
;
+               if (temp_distance < new_distance) {
+                       new_distance =3D temp_distance;
+                       new_disk =3D temp_disk;
+                       conf->same_count =3D 0;
+               }
+
+/* FIXME: is this SPARC64 GCC hack still necessary??? */
 #if defined(CONFIG_SPARC64) && (__GNUC__ =3D=3D 2) && (__GNUC_MINOR__ =
=3D=3D 92)
                /* Work around a compiler bug in egcs-2.92.11 19980921 =
*/
                new_disk =3D *(volatile int *)&new_disk;
 #endif
-               do {
-                       if (new_disk<=3D0)
-                               new_disk =3D conf->raid_disks;
-                       new_disk--;
-                       if (new_disk =3D=3D disk)
-                               break;
-               } while ((conf->mirrors[new_disk].write_only) ||
-                        (!conf->mirrors[new_disk].operational));
+               ITER_NEXT_READABLE(temp_disk, old_disk);
+
+       } while (temp_disk !=3D old_disk);
=20
+       if (likely(conf->same_count < sysctl_max_work_per_disk))
                goto rb_out;
-       }
-      =20
-       current_distance =3D abs(this_sector -
-                               conf->mirrors[disk].head_position);
-      =20
-       /* Find the disk which is closest */
-      =20
-       do {
-               if (disk <=3D 0)
-                       disk =3D conf->raid_disks;
-               disk--;
-              =20
-               if ((conf->mirrors[disk].write_only) ||
-                               (!conf->mirrors[disk].operational))
-                       continue;
-              =20
-               new_distance =3D abs(this_sector -
-                                       conf->mirrors[disk].head_positi=
on);
-              =20
-               if (new_distance < current_distance) {
-                       conf->sect_count =3D 0;
-                       current_distance =3D new_distance;
-                       new_disk =3D disk;
-               }
-       } while (disk !=3D conf->last_used);
+
+rb_out_force_switch:
+       /*
+        * If reads have only been done on a single disk for some time,
+        * let's give another disk a chance.  This is for kicking
+        * those idle disks so that they can find work near a hotspot.
+        */
+       new_disk =3D first_disk;
+       conf->same_count =3D 0;
=20
 rb_out:
-       conf->mirrors[new_disk].head_position =3D this_sector + sectors=
;
+       conf->same_count +=3D sectors;
=20
-       conf->last_used =3D new_disk;
-       conf->sect_count +=3D sectors;
+rb_out_nocount:
+       conf->mirrors[new_disk].head_position =3D this_sector + sectors=
;
=20
-       return new_disk;
+       return conf->last_used =3D new_disk;
 }
=20
 static int raid1_make_request (mddev_t *mddev, int rw,
@@ -582,8 +593,7 @@
        int i, sum_bhs =3D 0;
        struct mirror_info *mirror;
=20
-       if (!buffer_locked(bh))
-               BUG();
+       BUG_ON(!buffer_locked(bh));
       =20
 /*
  * make_request() can abort the operation when READA is being
@@ -1184,17 +1194,22 @@
                                struct buffer_head *bhl, *mbh;
                               =20
                                conf =3D mddev_to_conf(mddev);
-                               bhl =3D raid1_alloc_bh(conf, conf->raid=
_disks); /* don't really need this many */
+                               /* don't really need this many bh
+                                */
+                               bhl =3D raid1_alloc_bh(conf, conf->raid=
_disks);
                                for (i =3D 0; i < disks ; i++) {
                                        if (!conf->mirrors[i].operation=
al)
                                                continue;
-                                       if (i=3D=3Dconf->last_used)
-                                               /* we read from here, n=
o need to write */
+                                       if (conf->mirrors[i].dev =3D=3D=
 bh->b_dev)
+                                               /* we read from here,
+                                                * no need to write
+                                                */
                                                continue;
                                        if (i < conf->raid_disks
                                            && !conf->resync_mirrors)
                                                /* don't need to write =
this,
-                                                * we are just rebuildi=
ng */
+                                                * we are just rebuildi=
ng
+                                                */
                                                continue;
                                        mbh =3D bhl;
                                        if (!mbh) {
@@ -1386,9 +1401,12 @@
                        MD_BUG();
        }
        while (sector_nr >=3D conf->start_pending) {
-               PRINTK("wait .. sect=3D%lu start_active=3D%d ready=3D%d=
 pending=3D%d future=3D%d, cnt_done=3D%d active=3D%d ready=3D%d pending=
=3D%d future=3D%d\n",
-                       sector_nr, conf->start_active, conf->start_read=
y, conf->start_pending, conf->start_future,
-                       conf->cnt_done, conf->cnt_active, conf->cnt_rea=
dy, conf->cnt_pending, conf->cnt_future);
+               PRINTK("wait .. sect=3D%lu start_active=3D%d ready=3D%d=
 pending=3D%d future=3D%d"
+                       ", cnt_done=3D%d active=3D%d ready=3D%d pending=
=3D%d future=3D%d\n",
+                       sector_nr, conf->start_active, conf->start_read=
y,
+                       conf->start_pending, conf->start_future,
+                       conf->cnt_done, conf->cnt_active, conf->cnt_rea=
dy,
+                       conf->cnt_pending, conf->cnt_future);
                wait_event_lock_irq(conf->wait_done,
                                        !conf->cnt_active,
                                        conf->segment_lock);
@@ -1413,21 +1431,15 @@
=20
        /* If reconstructing, and >1 working disc,
         * could dedicate one to rebuild and others to
-        * service read requests ..
+        * service read requests, or use read_balance...
         */
        disk =3D conf->last_used;
        /* make sure disk is operational */
-       while (!conf->mirrors[disk].operational) {
-               if (disk <=3D 0) disk =3D conf->raid_disks;
-               disk--;
-               if (disk =3D=3D conf->last_used)
-                       break;
-       }
-       conf->last_used =3D disk;
+       conf->last_used =3D ITER_THIS_READABLE(disk, disk);
       =20
-       mirror =3D conf->mirrors+conf->last_used;
+       mirror =3D conf->mirrors + disk;
       =20
-       r1_bh =3D raid1_alloc_buf (conf);
+       r1_bh =3D raid1_alloc_buf(conf);
        r1_bh->master_bh =3D NULL;
        r1_bh->mddev =3D mddev;
        r1_bh->cmd =3D SPECIAL;
@@ -1445,12 +1457,9 @@
        bh->b_dev =3D mirror->dev;
        bh->b_rdev =3D mirror->dev;
        bh->b_state =3D (1<<BH_Req) | (1<<BH_Mapped) | (1<<BH_Lock);
-       if (!bh->b_page)
-               BUG();
-       if (!bh->b_data)
-               BUG();
-       if (bh->b_data !=3D page_address(bh->b_page))
-               BUG();
+       BUG_ON(!bh->b_page);
+       BUG_ON(!bh->b_data);
+       BUG_ON(bh->b_data !=3D page_address(bh->b_page));
        bh->b_end_io =3D end_sync_read;
        bh->b_private =3D r1_bh;
        bh->b_blocknr =3D sector_nr;
@@ -1589,7 +1598,6 @@
                        disk->number =3D descriptor->number;
                        disk->raid_disk =3D disk_idx;
                        disk->dev =3D rdev->dev;
-                       disk->sect_limit =3D MAX_WORK_PER_DISK;
                        disk->operational =3D 0;
                        disk->write_only =3D 0;
                        disk->spare =3D 0;
@@ -1621,7 +1629,6 @@
                        disk->number =3D descriptor->number;
                        disk->raid_disk =3D disk_idx;
                        disk->dev =3D rdev->dev;
-                       disk->sect_limit =3D MAX_WORK_PER_DISK;
                        disk->operational =3D 1;
                        disk->write_only =3D 0;
                        disk->spare =3D 0;
@@ -1636,7 +1643,6 @@
                        disk->number =3D descriptor->number;
                        disk->raid_disk =3D disk_idx;
                        disk->dev =3D rdev->dev;
-                       disk->sect_limit =3D MAX_WORK_PER_DISK;
                        disk->operational =3D 0;
                        disk->write_only =3D 0;
                        disk->spare =3D 1;
@@ -1700,14 +1706,16 @@
        /*
         * find the first working one and use it as a starting point
         * to read balancing.
+        * FIXME: previous code iterated through all MD_SB_DISKS while =
this
+        * stops at conf->raid_disks - 1.  which is better???
         */
-       for (j =3D 0; !conf->mirrors[j].operational && j < MD_SB_DISKS;=
 j++)
-               /* nothing */;
-       conf->last_used =3D j;
+       j =3D 0;
+       conf->last_used =3D ITER_THIS_READABLE(j, j);
=20
=20
        if (conf->working_disks !=3D sb->raid_disks) {
-               printk(KERN_ALERT "raid1: md%d, not all disks are opera=
tional -- trying to recover array\n", mdidx(mddev));
+               printk(KERN_ALERT "raid1: md%d, not all disks are opera=
tional "
+                                 "-- trying to recover array\n", mdidx=
(mddev));
                start_recovery =3D 1;
        }
=20
@@ -1792,7 +1800,8 @@
                        conf->resync_mirrors =3D 2;
                        md_interrupt_thread(conf->resync_thread);
=20
-                       printk(KERN_INFO "raid1: mirror resync was not =
fully finished, restarting next time.\n");
+                       printk(KERN_INFO "raid1: mirror resync was not =
fully "
+                                        "finished, restarting next tim=
e.\n");
                        return 1;
                }
                return 0;
@@ -1848,12 +1857,16 @@
=20
 static int md__init raid1_init (void)
 {
-       return register_md_personality (RAID1, &raid1_personality);
+       int ret =3D register_md_personality(RAID1, &raid1_personality);
+       if (!ret)
+               raid_table_header =3D register_sysctl_table(raid_root_t=
able, 1);
+       return ret;
 }
=20
 static void raid1_exit (void)
 {
-       unregister_md_personality (RAID1);
+       unregister_sysctl_table(raid_table_header);
+       unregister_md_personality(RAID1);
 }
=20
 module_init(raid1_init);
diff -u --exclude-from=3D/home/me/.exclude -r 21p2-ref/include/linux/ra=
id/raid1.h linux-2.4.21-rc2-ac1/include/linux/raid/raid1.h
--- 21p2-ref/include/linux/raid/raid1.h Sat May 10 18:47:22 2003
+++ linux-2.4.21-rc2-ac1/include/linux/raid/raid1.h     Mon May 12 07:4=
8:12 2003
@@ -7,8 +7,12 @@
        int             number;
        int             raid_disk;
        kdev_t          dev;
-       int             sect_limit;
-       int             head_position;
+
+       /*
+        * Sector number where disk head is located.
+        * Note that the disk elevator may reorder these reads.
+        */
+       unsigned long   head_position;
=20
        /*
         * State bits:
@@ -28,7 +32,10 @@
        int                     working_disks;
        int                     last_used;
        unsigned long           next_sect;
-       int                     sect_count;
+
+       /* Count of sectors read without disk switch. */
+       unsigned int            same_count;
+
        mdk_thread_t            *thread, *resync_thread;
        int                     resync_mirrors;
        struct mirror_info      *spare;
@@ -69,6 +76,45 @@
  */
 #define mddev_to_conf(mddev) ((raid1_conf_t *) mddev->private)
=20
+#define READABLE_MIRROR(disk) ({                                      =
 \
+               struct mirror_info * _rm_disk =3D conf->mirrors + (disk=
); \
+               !!_rm_disk->operational & !_rm_disk->write_only;       =
 \
+       })
+
+#define HEAD_DISTANCE(disk,sect) ({                                   =
 \
+               unsigned long _hd_x =3D (sect);                        =
   \
+               unsigned long _hd_y =3D                                =
   \
+                               conf->mirrors[(disk)].head_position;   =
 \
+               _hd_x >=3D _hd_y ? _hd_x - _hd_y : _hd_y - _hd_x;      =
   \
+       })
+/*
+ * disk is evaluated multiple times in these macros and must be
+ * a simple lvalue
+ */
+#define ITERATE_MIRROR(disk) ({                                       =
         \
+               if (((disk) <=3D 0) | ((disk) > conf->raid_disks))     =
   \
+                       (disk) =3D conf->raid_disks;                   =
   \
+               --(disk);                                              =
 \
+       })
+/*
+ * After using these two macros you must check to see if
+ * you actually got a readable disk.
+ */
+#define ITER_NEXT_READABLE(disk,last) ({                              =
 \
+               int _inr_last =3D (last);                              =
   \
+               while (!READABLE_MIRROR(ITERATE_MIRROR(disk))          =
 \
+                      && (disk) !=3D _inr_last)                       =
   \
+                       ;                                              =
 \
+               (disk);                                                =
 \
+       })
+
+#define ITER_THIS_READABLE(disk,last) ({                              =
 \
+               int _itr_last =3D (last);                              =
   \
+               while (!READABLE_MIRROR(disk)                          =
 \
+                      && ITERATE_MIRROR(disk) !=3D _itr_last)         =
   \
+                       ;                                              =
 \
+               (disk);                                                =
 \
+       })
 /*
  * this is our 'private' 'collective' RAID1 buffer head.
  * it contains information about what kind of IO operations were start=
ed
@@ -91,4 +137,5 @@
 #define        R1BH_Uptodate   1
 #define        R1BH_SyncPhase  2
 #define        R1BH_PreAlloc   3       /* this was pre-allocated, add =
to free list */
-#endif
+
+#endif /* ndef _RAID1_H */
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
