From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: patch for raid1 to make it choose the fastest device for READ (resend)
Date: Fri, 13 Aug 2004 10:21:29 +0200 (MET DST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408130821.i7D8LTm02571@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Mime-Version: 1.0
Content-Type: text/plain; charset=UNKNOWN-8BIT
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here is a preliminary patch for raid1 (2.4) to make it choose the
fastest device in the array to read from.

The standard kernel code changes the read device every 128 sectors, in
equal-handed style. That's not so good when one device is much slower
than the other, as is the cse if one is a network device and one is a
local device. In principle, any algorithm which applies some knowledge
or intelligence will do better than a 50/50 strategy, provided it's at
all oriented in the right direction.

I'll work through the patch, commenting on it=B8 then I'll repeat the
patch, whole, at the end.


The patch works by replacing the swapover to the next device=20
at 128 sectors by a short blast of testing to get a picture of the
latency, then a swapover to the fastest device found, which it stays on
for 1024 sectors instead of 128. Here is what logging shows:


mdadm: /dev/md/0 has been started with 2 drives.
sh-2.03# dd if=3D/dev/md/0 of=3D/dev/null
raid1: disk 0 latency 0 abandoned after 1024 sectors
raid1: choosing disk 1 latency 0                       <- test
raid1: disk 1 latency 0 abandoned after 32 sectors      _|
raid1: choosing disk 0 latency 0                       <- test
raid1: disk 0 latency 0 abandoned after 32 sectors      _|
raid1: choosing disk 1 latency 0                       <- run
raid1: disk 1 latency 0 abandoned after 1024 sectors    _|
raid1: choosing disk 0 latency 0
raid1: disk 0 latency 0 abandoned after 32 sectors
raid1: choosing disk 1 latency 0
raid1: disk 1 latency 0 abandoned after 32 sectors
raid1: choosing disk 1 latency 0
raid1: disk 1 latency 0 abandoned after 1024 sectors
raid1: choosing disk 0 latency 0
raid1: disk 0 latency 0 abandoned after 32 sectors
raid1: choosing disk 1 latency 0
raid1: disk 1 latency 0 abandoned after 32 sectors
raid1: choosing disk 1 latency 0
raid1: disk 1 latency 0 abandoned after 1024 sectors
raid1: choosing disk 0 latency 0
raid1: disk 0 latency 0 abandoned after 32 sectors
raid1: choosing disk 1 latency 0
raid1: disk 1 latency 0 abandoned after 32 sectors
raid1: choosing disk 1 latency 0
raid1: disk 1 latency 2 abandoned after 1024 sectors
raid1: choosing disk 0 latency 0
=2E..

(I was running on loopback devices, so the latency is not very
realistic, but that's not the point).





--- linux-2.4.25/drivers/md/raid1.c.post-fr1-2.14b,pre-read-balance	Tue=
 Aug 10 21:36:51 2004
+++ linux-2.4.25/drivers/md/raid1.c	Mon Aug  9 19:27:32 2004
@@ -46,7 +46,7 @@
 #define MD_DRIVER
 #define MD_PERSONALITY
=20
-#define MAX_WORK_PER_DISK 128
+#define MAX_WORK_PER_DISK (128 * 8)
=20
 #define	NR_RESERVED_BUFS	32
=20

I replace swapover after 128 sectors by swapover at 1024 sectors.  I
want the testing to not be more than about 1% of the running period, an=
d
one can't test meaningfully in less than about 10 sectors, so the run
period has to be about 1000 sectors.  Back of envelope calculation.

I should #define MAX_TEST_PER_DISK 32.




@@ -434,6 +434,31 @@
                         bitmap->clearbits(bitmap, bh->b_rsector >> 1, =
bh->b_size >> 10);
                 }
         }
+        /* PTB calculate the latency of the read device and update the=
 record */


We're in the end_io routine for a raid1 buffer head. I forget what it's
called (:-() and exactly what a r1_bh is, but it's approximately a
master controller for a whole splat of other buffer heads that are sent
to component devices in the case of writes. There's only one buffer hea=
d
in the splat in the case of a read, but the r1_bh contains useful info
anyway, such as a pointer back to the original bh that landed on the
raid device and caused all the kerfuffle.

Here we take the opportunity to examine a field I added to the r1_bh to
record when we started the i/o, look at the time now, calculate the
difference - that's the latency, folks - and add it into a rolling
average that I am recording for the component device.


+        if (uptodate && (r1_bh->cmd =3D=3D READ || r1_bh->cmd =3D=3D R=
EADA)) {


Only for successful reads, of course! I don't think we can get READAhea=
ds at
this point, but checking does no harm.


+                unsigned long latency =3D jiffies - r1_bh->start_jiffi=
es;

That's the latency for this just-completing read i/o.  This will fail a=
t
the 32 bit rollover point.  Improvement welcome.

+                kdev_t dev =3D (&r1_bh->bh_req)->b_dev;

That's the device the buffer head was aimed at. I need to get back from
that to the index of the device in the array.

+                int i;
+
+                /* PTB find the mirror component being read */
+                for (i =3D 0; i < conf->raid_disks; i++) {
+                    if (conf->mirrors[i].dev =3D=3D dev)
+                        break;
+                }

Was there a better way to find the index in the array of mirror
components? I didn't like searching through them all on each buffer
head, even though in general the list will be exactly two long.



+                if (i < conf->raid_disks) {


If we found the device ...

+                        if (latency < 120 * HZ && latency >=3D 0) {

and the calculated latency is not completely wacko ...

+                                conf->latency[i] =3D 9 * conf->latency=
[i]
+                                                 + latency;
+                                conf->latency[i] /=3D 10;

roll the latency into the rolling average. I'm using a 90:10 rolloff.
I used a parallel array of rollong averages added to the conf structure=
=2E
It would have been nicer to use the mirror struct, but I didn't want to
step out of the raid1 into the md environment (is it sited there? I don=
't
know).


+                        } else {
+		               printk(KERN_ERR "raid1: bad latency %lu jiffies\n",=20
+			         latency);
+                        }

Mention if the latency was absurd. This will cause noise in 75 years.

+                } else {
+		       printk(KERN_ERR "raid1: could not find dev %02x:%02x\n",=20
+                               MAJOR(dev), MINOR(dev));
+                }
+        }

What do we do if the i/o is for a device not in the array now? Yell and
scream? We ought to do something. Presumably we can take the disk out o=
f
the array just after i/o for it has been done and just before we get
notified about it. Is there a lock to stop removal while requests are i=
n
flight? I suspect we should  not lock, but just error now.

         raid1_free_r1bh(r1_bh);
 }
=20
@@ -569,7 +594,7 @@
 	 * Don't touch anything for sequential reads.
 	 */
=20
Here we are back in the main routine that deals with incoming requests
and launches buffer heads/requests out to the component devices in=20
response. We'll have to choose the right device to read from.


-	if (this_sector =3D=3D conf->mirrors[new_disk].head_position)
+	if (0 && /* PTB */ this_sector =3D=3D conf->mirrors[new_disk].head_po=
sition)
 		goto rb_out;
 =09
 	/*

I disabled the line that says "keep on reading from the same device if
we are running a linear sequence of requests". Since I upped the
swapover period by 10, it can't make more than about 10% difference
either way, and I wanted to see the swapovers. I don't like this line
anyway! Who says we will receive linear requests in linear sequence? An=
d
what if somebody else asks to read somewhere else meanwhile?


@@ -578,22 +603,66 @@
 	 * This is for kicking those idling disks so that
 	 * they would find work near some hotspot.
 	 */
 =09
 	if (conf->sect_count >=3D conf->mirrors[new_disk].sect_limit) {
-		conf->sect_count =3D 0;

This is the counter for how many sectors we have read without swapping
over to read from somewhere else. It ticks along until it triggers
the swapover limit (which I set higher, to 1024 instead of 128) and is
reset.  I moved the reset further down ...


+
+                PRINTK(KERN_INFO
+                  "raid1: disk %d latency %d abandoned after %d sector=
s\n",
+                  new_disk,
+                  conf->latency[new_disk],
+	          conf->sect_count);

 ... because I wanted to print the value at swapover.

+
+                if (conf->last_source < 0) {

This is a field I introduced in order to govern the swapover algorithm.
It records the (index of the) last device we have read from continuousl=
y
and deliberately, not the last device read from (for which a field
already exists), because sometimes we just are reading in order to test=
,
which is not to be counted as "deliberately". Perhaps "last_worked"
would be a better name. I want to distinguish between "working reads"
and "testing reads". Anyway, when the field is -1, it indicates "don't
know" and means that we should go and find the fastest device already
known and use it, setting the field to the device index we used.

Later, the next time we come to the swapover point, the field will be
nonnegative, which indicates that we should retest the devices in short
read bursts, and only later choose the fastest of them.


+                    /* PTB find the fastest already known and use that=
 */
+
+                        int fastest =3D -1;
+                        unsigned long best_latency =3D 0x7fffffff;
+                        int i;
+
+	                for (i =3D 0; i < conf->raid_disks; i++) {
+	                        if (conf->mirrors[i].write_only
+                                || !conf->mirrors[i].operational)
+                                        continue;
+                                if (conf->latency[i] <=3D best_latency=
) {
+                                    best_latency =3D conf->latency[i];
+                                    fastest =3D i;
+                                }
+                        }

That found the fastest known.  I guess this search now (infrequent) is
faster than updating the index as we update the rolling latency for eac=
h
device on completion of each r1_bh, but we could do it that way instead=
=2E
This way will scan two points on average, every 1024 sectors, so it
will be better than doing something else 512 times meanwhiles. I think.


+                        if (fastest >=3D 0)
+                                new_disk =3D fastest;

I don't know what happens if we didn't find a fastest! new_disk stays a=
t
whatever it already was, which I think is the disk we were using till
now (last_used?).

+	                conf->mirrors[new_disk].sect_limit =3D
+                                                MAX_WORK_PER_DISK;

We set the next swapover point to be the normal value .. 1024 sectors.

+                        conf->last_source =3D new_disk;


And we set the control field for the algorithm to something nonnegative=
=2E
In fact to us.  We need to know who was last used before testing began
so we can cycle the tests through all the devices.

+                } else {
+                    /* PTB move on to run a short test on the next dis=
k */
=20

This is the case when we should be running tests to determine latencies=
,
not doing serious committed reading.


 #if defined(CONFIG_SPARC64) && (__GNUC__ =3D=3D 2) && (__GNUC_MINOR__ =
=3D=3D 92)
 		/* Work around a compiler bug in egcs-2.92.11 19980921 */
 		new_disk =3D *(volatile int *)&new_disk;
 #endif


Weird!

-		do {
-			if (new_disk<=3D0)
-				new_disk =3D conf->raid_disks;
-			new_disk--;
-			if (new_disk =3D=3D disk)
-				break;
-		} while ((conf->mirrors[new_disk].write_only) ||
-			 (!conf->mirrors[new_disk].operational));


That was the old selection algorithm, which just moved us one along in
the array of disks (modulo nonworking and not-to-be-read-yet disks).

The following uses it instead only in the testing phase, as we want to
test all disks.=20

The patch has a delete and add because the line indentation has changed=
 by
one. It is now inside one more set of braces. An if. The if that detect=
s
that we're in a testing phase.


+		        do {
+			        if (new_disk<=3D0)
+				        new_disk =3D conf->raid_disks;
+			        new_disk--;
+			        if (new_disk =3D=3D disk)
+				        break; /* nothing else available */
+		        } while ((conf->mirrors[new_disk].write_only) ||
+			         (!conf->mirrors[new_disk].operational));


So that was now the "move along and test the next one".

+                      /* PTB if tested all, will need to choose next t=
ime */
+                        if (new_disk =3D=3D conf->last_source) {
+                                conf->last_source =3D -1;

If we have run around the array once we will hit the "last used
deliberately" disk, and should stop testing and start running in a
committed fashion next time. So we set the controlling field to -1.


+                                /* PTB don't retest last source at all=
 */
+	                        //conf->mirrors[new_disk].sect_limit =3D 0;

The above is a possible modification that would reduce testing on the=20
disk we used long-term last time to just 2 sectors. This would reduce
the testing time by nearly half in 2-device array, but I'm not convince=
d
it avoids anything, since we will likely choose the same device again
anyway, and using it now a bit extra is good, not bad.


+                        }
+                        /* PTB only a short test run */
+	                conf->mirrors[new_disk].sect_limit =3D 32;

This is how we make sure the tests are short! We temporarily set the=20
swapover point low for them. This should be MAX_TEST_whatever. The
value will be reset to the large value when we come to choose the
device for a long run.


+                }
+
+		conf->sect_count =3D 0;


Here is the delayed reset of the sectors read counter.


+                PRINTK(KERN_INFO
+                  "raid1: choosing disk %d latency %d\n",
+                  new_disk,
+                  conf->latency[new_disk]);
=20
 		goto rb_out;
 	}
@@ -680,6 +749,7 @@
 	r1_bh->master_bh =3D bh;
 	r1_bh->mddev =3D mddev;
 	r1_bh->cmd =3D rw;
+	r1_bh->start_jiffies =3D jiffies; /* PTB record start time */
         async_data =3D NULL;
=20
 	if (rw =3D=3D READ) {


Aha .. the above was just after the r1_bh we will use is recieved from =
the
allocater, and we set the time on it. It's done at the same time as we
set the other fields.

--- linux-2.4.25/include/linux/raid/raid1.h.post-fr1-2.14b,pre-read-bal=
ance	Tue Aug 10 21:48:31 2004
+++ linux-2.4.25/include/linux/raid/raid1.h	Mon Aug  9 18:53:57 2004
@@ -59,6+59,10 @@
 	md_wait_queue_head_t	wait_done;
 	md_wait_queue_head_t	wait_ready;
 	md_spinlock_t		segment_lock;
+
+	int			latency[MD_SB_DISKS];
+	int			last_source;        /* PTB disk read from */
+
 };
=20
 typedef struct raid1_private_data raid1_conf_t;


That was the addition of the latency records and last-used-continuously
for reads fields to the raid1 conf structure.


@@ -92,6 +96,7 @@
 	struct buffer_head	*mirror_bh_list;
 	struct buffer_head	bh_req;
 	struct raid1_bh		*next_r1;	/* next for retry or in free list */
+	unsigned long		start_jiffies;  /* PTB when i/o started */
 };
 /* bits for raid1_bh.state */
 #define	R1BH_Uptodate	1

And the above is the addition of the start time to the r1_bh struct.


Now I'll repeat the patch again, whole. Improvements welcome.


---------------------------------------------------------------------
Peter T. Breuer                   MA CASM PhD (Ing.), Prof. Ramon & Caj=
al
Area de Ingenieria Telematica	  E-mail: ptb@it.uc3m.es
Dpto. Ingenieria		  Tel: +34 (9)1 624 87 81
Universidad Carlos III de Madrid  Fax: +34 (9)1 624 8749/9430
Butarque 15, Leganes/Madrid       URL: http://www.it.uc3m.es/~ptb
E-28911 Spain                     Mob: +34 69 666 7835



--- linux-2.4.25/drivers/md/raid1.c.post-fr1-2.14b,pre-read-balance	Tue=
 Aug 10 21:36:51 2004
+++ linux-2.4.25/drivers/md/raid1.c	Mon Aug  9 19:27:32 2004
@@ -46,7 +46,7 @@
 #define MD_DRIVER
 #define MD_PERSONALITY
=20
-#define MAX_WORK_PER_DISK 128
+#define MAX_WORK_PER_DISK (128 * 8)
=20
 #define	NR_RESERVED_BUFS	32
=20
@@ -434,6 +434,31 @@
                         bitmap->clearbits(bitmap, bh->b_rsector >> 1, =
bh->b_size >> 10);
                 }
         }
+        /* PTB calculate the latency of the read device and update the=
 record */
+        if (uptodate && (r1_bh->cmd =3D=3D READ || r1_bh->cmd =3D=3D R=
EADA)) {
+                unsigned long latency =3D jiffies - r1_bh->start_jiffi=
es;
+                kdev_t dev =3D (&r1_bh->bh_req)->b_dev;
+                int i;
+
+                /* PTB find the mirror component being read */
+                for (i =3D 0; i < conf->raid_disks; i++) {
+                    if (conf->mirrors[i].dev =3D=3D dev)
+                        break;
+                }
+                if (i < conf->raid_disks) {
+                        if (latency < 120 * HZ && latency >=3D 0) {
+                                conf->latency[i] =3D 9 * conf->latency=
[i]
+                                                 + latency;
+                                conf->latency[i] /=3D 10;
+                        } else {
+		               printk(KERN_ERR "raid1: bad latency %lu jiffies\n",=20
+			         latency);
+                        }
+                } else {
+		       printk(KERN_ERR "raid1: could not find dev %02x:%02x\n",=20
+                               MAJOR(dev), MINOR(dev));
+                }
+        }
         raid1_free_r1bh(r1_bh);
 }
=20
@@ -569,7 +594,7 @@
 	 * Don't touch anything for sequential reads.
 	 */
=20
-	if (this_sector =3D=3D conf->mirrors[new_disk].head_position)
+	if (0 && /* PTB */ this_sector =3D=3D conf->mirrors[new_disk].head_po=
sition)
 		goto rb_out;
 =09
 	/*
@@ -578,22 +603,66 @@
 	 * This is for kicking those idling disks so that
 	 * they would find work near some hotspot.
 	 */
 =09
 	if (conf->sect_count >=3D conf->mirrors[new_disk].sect_limit) {
-		conf->sect_count =3D 0;
+
+                PRINTK(KERN_INFO
+                  "raid1: disk %d latency %d abandoned after %d sector=
s\n",
+                  new_disk,
+                  conf->latency[new_disk],
+	          conf->sect_count);
+
+                if (conf->last_source < 0) {
+                    /* PTB find the fastest already known and use that=
 */
+
+                        int fastest =3D -1;
+                        unsigned long best_latency =3D 0x7fffffff;
+                        int i;
+
+	                for (i =3D 0; i < conf->raid_disks; i++) {
+	                        if (conf->mirrors[i].write_only
+                                || !conf->mirrors[i].operational)
+                                        continue;
+                                if (conf->latency[i] <=3D best_latency=
) {
+                                    best_latency =3D conf->latency[i];
+                                    fastest =3D i;
+                                }
+                        }
+                        if (fastest >=3D 0)
+                                new_disk =3D fastest;
+	                conf->mirrors[new_disk].sect_limit =3D
+                                                MAX_WORK_PER_DISK;
+                        conf->last_source =3D new_disk;
+                } else {
+                    /* PTB move on to run a short test on the next dis=
k */
=20
 #if defined(CONFIG_SPARC64) && (__GNUC__ =3D=3D 2) && (__GNUC_MINOR__ =
=3D=3D 92)
 		/* Work around a compiler bug in egcs-2.92.11 19980921 */
 		new_disk =3D *(volatile int *)&new_disk;
 #endif
-		do {
-			if (new_disk<=3D0)
-				new_disk =3D conf->raid_disks;
-			new_disk--;
-			if (new_disk =3D=3D disk)
-				break;
-		} while ((conf->mirrors[new_disk].write_only) ||
-			 (!conf->mirrors[new_disk].operational));
+		        do {
+			        if (new_disk<=3D0)
+				        new_disk =3D conf->raid_disks;
+			        new_disk--;
+			        if (new_disk =3D=3D disk)
+				        break; /* nothing else available */
+		        } while ((conf->mirrors[new_disk].write_only) ||
+			         (!conf->mirrors[new_disk].operational));
+                      /* PTB if tested all, will need to choose next t=
ime */
+                        if (new_disk =3D=3D conf->last_source) {
+                                conf->last_source =3D -1;
+                                /* PTB don't retest last source at all=
 */
+	                        //conf->mirrors[new_disk].sect_limit =3D 0;
+                        }
+                        /* PTB only a short test run */
+	                conf->mirrors[new_disk].sect_limit =3D 32;
+                }
+
+		conf->sect_count =3D 0;
+                PRINTK(KERN_INFO
+                  "raid1: choosing disk %d latency %d\n",
+                  new_disk,
+                  conf->latency[new_disk]);
=20
 		goto rb_out;
 	}
@@ -680,6 +749,7 @@
 	r1_bh->master_bh =3D bh;
 	r1_bh->mddev =3D mddev;
 	r1_bh->cmd =3D rw;
+	r1_bh->start_jiffies =3D jiffies; /* PTB record start time */
         async_data =3D NULL;
=20
 	if (rw =3D=3D READ) {
--- linux-2.4.25/include/linux/raid/raid1.h.post-fr1-2.14b,pre-read-bal=
ance	Tue Aug 10 21:48:31 2004
+++ linux-2.4.25/include/linux/raid/raid1.h	Mon Aug  9 18:53:57 2004
@@ -59,6+59,10 @@
 	md_wait_queue_head_t	wait_done;
 	md_wait_queue_head_t	wait_ready;
 	md_spinlock_t		segment_lock;
+
+	int			latency[MD_SB_DISKS];
+	int			last_source;        /* PTB disk read from */
+
 };
=20
 typedef struct raid1_private_data raid1_conf_t;
@@ -92,6 +96,7 @@
 	struct buffer_head	*mirror_bh_list;
 	struct buffer_head	bh_req;
 	struct raid1_bh		*next_r1;	/* next for retry or in free list */
+	unsigned long		start_jiffies;  /* PTB when i/o started */
 };
 /* bits for raid1_bh.state */
 #define	R1BH_Uptodate	1

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
