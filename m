From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: raid5 write performance
Date: Sat, 31 Mar 2007 00:44:11 +0300
Message-ID: <5d96567b0703301444j9b416c2nbc5ce27487eef5bc@mail.gmail.com>
References: <5d96567b0607020702p25d66490i79445bac606e5210@mail.gmail.com>
	 <17576.18978.563672.656847@cse.unsw.edu.au>
	 <5d96567b0608130619w60d8d883q4ffbfefcf650ee82@mail.gmail.com>
	 <17650.29175.778076.964022@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_79546_24611748.1175291051207"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17650.29175.778076.964022@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

------=_Part_79546_24611748.1175291051207
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Please see bellow.

On 8/28/06, Neil Brown <neilb@suse.de> wrote:
> On Sunday August 13, raziebe@gmail.com wrote:
> > well ... me again
> >
> > Following your advice....
> >
> > I added a deadline for every WRITE stripe head when it is created.
> > in raid5_activate_delayed i checked if deadline is expired and if not i am
> > setting the sh to prereadactive mode as .
> >
> > This small fix ( and in few other places in the code) reduced the
> > amount of reads
> > to zero with dd but with no improvement to throghput. But with random access to
> > the raid  ( buffers are aligned by the stripe width and with the size
> > of stripe width )
> > there is an improvement of at least 20 % .
> >
> > Problem is that a user must know what he is doing else there would be
> > a reduction
> > in performance if deadline line it too long (say 100 ms).
>
> So if I understand you correctly, you are delaying write requests to
> partial stripes slightly (your 'deadline') and this is sometimes
> giving you a 20% improvement ?
>
> I'm not surprised that you could get some improvement.  20% is quite
> surprising.  It would be worth following through with this to make
> that improvement generally available.
>
> As you say, picking a time in milliseconds is very error prone.  We
> really need to come up with something more natural.
> I had hopped that the 'unplug' infrastructure would provide the right
> thing, but apparently not.  Maybe unplug is just being called too
> often.
>
> I'll see if I can duplicate this myself and find out what is really
> going on.
>
> Thanks for the report.
>
> NeilBrown
>

Neil Hello. I am sorry for this interval , I was assigned abruptly to
a different project.

1.
  I'd taken a look at the raid5 delay patch I have written a while
ago. I ported it to 2.6.17 and tested it. it makes sounds of working
and when used correctly it eliminates the reads penalty.

2. Benchmarks .
    configuration:
     I am testing a raid5 x 3 disks with 1MB chunk size.  IOs are
synchronous and non-buffered(o_direct) , 2 MB in size and always
aligned to the beginning of a stripe. kernel is 2.6.17. The
stripe_delay was set to 10ms.

 Attached is the simple_write code.

         command :
               simple_write /dev/md1 2048 0 1000
                       simple_write raw writes (O_DIRECT) sequentially
starting from offset zero 2048 kilobytes 1000 times.

Benchmark Before patch

sda            1848.00      8384.00     50992.00       8384      50992
sdb            1995.00     12424.00     51008.00      12424      51008
sdc            1698.00      8160.00     51000.00       8160      51000
sdd               0.00         0.00         0.00          0          0
md0               0.00         0.00         0.00          0          0
md1             450.00         0.00    102400.00          0     102400


Benchmark After patch

sda             389.11         0.00    128530.69          0     129816
sdb             381.19         0.00    129354.46          0     130648
sdc             383.17         0.00    128530.69          0     129816
sdd               0.00         0.00         0.00          0          0
md0               0.00         0.00         0.00          0          0
md1            1140.59         0.00    259548.51          0     262144

As one can see , no additional reads were done. One can actually
calculate  the raid's utilization: n-1/n * ( single disk throughput
with 1M writes ) .


      3.  The patch code.
          Kernel tested above was 2.6.17. The patch is of 2.6.20.2
because I have noticed a big code differences between 17 to 20.x .
This patch was not tested on 2.6.20.2 but it is essentialy the same. I
have not tested (yet) degraded mode or any other non-common pathes.


--- linux-2.6.20.2/drivers/md/raid5.c   2007-03-09 20:58:04.000000000 +0200
+++ linux-2.6.20.2-raid/drivers/md/raid5.c      2007-03-30
12:37:55.000000000 +0300
@@ -65,6 +65,7 @@
 #define NR_HASH                        (PAGE_SIZE / sizeof(struct hlist_head))
 #define HASH_MASK              (NR_HASH - 1)

+
 #define stripe_hash(conf, sect)
(&((conf)->stripe_hashtbl[((sect) >> STRIPE_SHIFT) & HASH_MASK]))

 /* bio's attached to a stripe+device for I/O are linked together in bi_sector
@@ -234,6 +235,8 @@
        sh->sector = sector;
        sh->pd_idx = pd_idx;
        sh->state = 0;
+       sh->active_preread_jiffies =
+                       msecs_to_jiffies(
atomic_read(&conf->deadline_ms) )+ jiffies;

        sh->disks = disks;

@@ -628,6 +631,7 @@

        clear_bit(R5_LOCKED, &sh->dev[i].flags);
        set_bit(STRIPE_HANDLE, &sh->state);
+       sh->active_preread_jiffies = jiffies;
        release_stripe(sh);
        return 0;
 }
@@ -1255,8 +1259,11 @@
                bip = &sh->dev[dd_idx].towrite;
                if (*bip == NULL && sh->dev[dd_idx].written == NULL)
                        firstwrite = 1;
-       } else
+       } else{
                bip = &sh->dev[dd_idx].toread;
+               sh->active_preread_jiffies = jiffies;
+       }
+
        while (*bip && (*bip)->bi_sector < bi->bi_sector) {
                if ((*bip)->bi_sector + ((*bip)->bi_size >> 9) > bi->bi_sector)
                        goto overlap;
@@ -2437,13 +2444,27 @@



-static void raid5_activate_delayed(raid5_conf_t *conf)
+static struct stripe_head*  raid5_activate_delayed(raid5_conf_t *conf)
 {
        if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD) {
                while (!list_empty(&conf->delayed_list)) {
                        struct list_head *l = conf->delayed_list.next;
                        struct stripe_head *sh;
                        sh = list_entry(l, struct stripe_head, lru);
+
+                       if( time_before(jiffies,sh->active_preread_jiffies) ){
+                         PRINTK("deadline : no expire sec=%lld %8u %8u\n",
+                               (unsigned long long) sh->sector,
+
jiffies_to_msecs(sh->active_preread_jiffies),
+                                       jiffies_to_msecs(jiffies));
+                         return sh;
+                       }
+                       else{
+                             PRINTK("deadline:  expire:sec=%lld %8u %8u\n",
+                                       (unsigned long long)sh->sector,
+
jiffies_to_msecs(sh->active_preread_jiffies),
+                                               jiffies_to_msecs(jiffies));
+                       }
                        list_del_init(l);
                        clear_bit(STRIPE_DELAYED, &sh->state);
                        if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE,
&sh->state))
@@ -2451,6 +2472,7 @@
                        list_add_tail(&sh->lru, &conf->handle_list);
                }
        }
+     return NULL;
 }

 static void activate_bit_delay(raid5_conf_t *conf)
@@ -3191,7 +3213,7 @@
  */
 static void raid5d (mddev_t *mddev)
 {
-       struct stripe_head *sh;
+       struct stripe_head *sh,*delayed_sh=NULL;
        raid5_conf_t *conf = mddev_to_conf(mddev);
        int handled;

@@ -3218,8 +3240,10 @@
                    atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD &&
                    !blk_queue_plugged(mddev->queue) &&
                    !list_empty(&conf->delayed_list))
-                       raid5_activate_delayed(conf);
-
+                       delayed_sh=raid5_activate_delayed(conf);
+
+               if(delayed_sh) break;
+
                while ((bio = remove_bio_from_retry(conf))) {
                        int ok;
                        spin_unlock_irq(&conf->device_lock);
@@ -3254,9 +3278,51 @@
        unplug_slaves(mddev);

        PRINTK("--- raid5d inactive\n");
+       if (delayed_sh){
+               long wakeup=delayed_sh->active_preread_jiffies-jiffies;
+               PRINTK("--- raid5d inactive sleep for %d\n",
+                       jiffies_to_msecs(wakeup) );
+               if (wakeup>0)
+               mddev->thread->timeout = wakeup;
+       }
+}
+
+static ssize_t
+raid5_show_stripe_deadline(mddev_t *mddev, char *page)
+{
+  raid5_conf_t *conf = mddev_to_conf(mddev);
+  if (conf)
+    return sprintf(page, "%d\n", atomic_read(&conf->deadline_ms));
+  else
+    return 0;
 }

 static ssize_t
+raid5_store_stripe_deadline(mddev_t *mddev, const char *page, size_t len)
+{
+  raid5_conf_t *conf = mddev_to_conf(mddev);
+  char *end;
+  int new;
+  if (len >= PAGE_SIZE)
+    return -EINVAL;
+  if (!conf)
+    return -ENODEV;
+  new = simple_strtoul(page, &end, 10);
+  if (!*page || (*end && *end != '\n') )
+    return -EINVAL;
+  if (new < 0 || new > 10000)
+    return -EINVAL;
+  atomic_set(&conf->deadline_ms,new);
+  return len;
+}
+
+static struct md_sysfs_entry
+raid5_stripe_deadline = __ATTR(stripe_deadline, S_IRUGO | S_IWUSR,
+                                raid5_show_stripe_deadline,
+                               raid5_store_stripe_deadline);
+
+
+static ssize_t
 raid5_show_stripe_cache_size(mddev_t *mddev, char *page)
 {
        raid5_conf_t *conf = mddev_to_conf(mddev);
@@ -3297,6 +3363,9 @@
        return len;
 }

+
+
+
 static struct md_sysfs_entry
 raid5_stripecache_size = __ATTR(stripe_cache_size, S_IRUGO | S_IWUSR,
                                raid5_show_stripe_cache_size,
@@ -3318,8 +3387,10 @@
 static struct attribute *raid5_attrs[] =  {
        &raid5_stripecache_size.attr,
        &raid5_stripecache_active.attr,
+    &raid5_stripe_deadline.attr,
        NULL,
 };
+
 static struct attribute_group raid5_attrs_group = {
        .name = NULL,
        .attrs = raid5_attrs,
@@ -3567,6 +3638,8 @@

        blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);

+       atomic_set(&conf->deadline_ms,0);
+
        return 0;
 abort:
        if (conf) {


x/raid/raid5.h
--- linux-2.6.20.2/include/linux/raid/raid5.h   2007-03-09
20:58:04.000000000 +0200
+++ linux-2.6.20.2-raid/include/linux/raid/raid5.h      2007-03-30
00:25:38.000000000 +0200
@@ -136,6 +136,7 @@
        spinlock_t              lock;
        int                     bm_seq; /* sequence number for bitmap flushes */
        int                     disks;                  /* disks in stripe */
+       unsigned long           active_preread_jiffies;
        struct r5dev {
                struct bio      req;
                struct bio_vec  vec;
@@ -254,6 +255,7 @@
         * Free stripes pool
         */
        atomic_t                active_stripes;
+       atomic_t                deadline_ms;
        struct list_head        inactive_list;
        wait_queue_head_t       wait_for_stripe;
        wait_queue_head_t       wait_for_overlap;



3.
 I have also tested it over XFS file system ( I'd written a special
copy method for xfs for this purpose, called r5cp ). I am getting much
better numbers with this patch .
sdd is the source file system and sd[abc] contain the raid. xfs is
mounted over /dev/md1.

stripe_deadline=0ms ( disabled)
Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
hda               0.00         0.00         0.00          0          0
md0               0.00         0.00         0.00          0          0
sda              90.10      7033.66     37409.90       7104      37784
sdb              94.06      7168.32     37417.82       7240      37792
sdc              89.11      7215.84     37417.82       7288      37792
sdd              75.25     77053.47         0.00      77824          0
md1             319.80         0.00     77053.47          0      77824

stripe_deadline=10ms ( enabled)
Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
hda               0.00         0.00         0.00          0          0
md0               0.00         0.00         0.00          0          0
sda             113.00         0.00     67648.00          0      67648
sdb             113.00         0.00     67648.00          0      67648
sdc             113.00         0.00     67648.00          0      67648
sdd             128.00    131072.00         0.00     131072          0
md1             561.00         0.00    135168.00          0     135168

XFS did not crash nor suffer from any other incosistencies so far. Yet
I have only
begon.

4.
I am going to work on this with other configurations, such as raid5's
with more disks and raid50.  I will be happy to hear your opinion on
this matter. what puzzles me is why deadline must be so long as 10 ms?
 the less deadline the more reads I am getting.

Many thanks
Raz

------=_Part_79546_24611748.1175291051207
Content-Type: text/x-c++src; name=simple_write.cpp; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ezx4jxih
Content-Disposition: attachment; filename="simple_write.cpp"

I2luY2x1ZGUgPGlvc3RyZWFtPgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN0cmluZz4K
I2luY2x1ZGUgPHN0ZGRlZi5oPgojaW5jbHVkZSA8c3lzL3RpbWUuaD4KCiNpbmNsdWRlIDxzdGRs
aWIuaD4KI2luY2x1ZGUgPHN5cy90eXBlcy5oPgojaW5jbHVkZSA8c3lzL3N0YXQuaD4KI2luY2x1
ZGUgPGZjbnRsLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KI2luY2x1ZGUgPGxpYmFpby5oPgojaW5j
bHVkZSA8dGltZS5oPgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPGVycm5vLmg+CgoKCnVz
aW5nIG5hbWVzcGFjZSBzdGQ7CgppbnQgbWFpbiAoaW50IGFyZ2MsIGNoYXIgKmFyZ3ZbXSkKewog
IGlmIChhcmdjPDUpewoJY291dCA8PCAidXNhZ2UgIDxkZXZpY2UgbmFtZT4gIDxzaXplIHRvIHdy
aXRlIGluIGtiPiA8b2Zmc2V0IGluIGtiID4gPGxvb3A+IiA8PCBlbmRsOwoJcmV0dXJuIDA7CiAg
fQoKICBjaGFyKiBkZXZfbmFtZSA9IGFyZ3ZbMV07CgogIGludCBmZCA9IG9wZW4oZGV2X25hbWUs
IE9fTEFSR0VGSUxFIHwgT19ESVJFQ1QgfCBPX1dST05MWSAsIDc3NyApOwogIGlmIChmZDwwKXsK
CXBlcnJvcigib3BlbiAiKTsKCXJldHVybiAoLTEpOwogIH0KCiAgbG9uZyBsb25nIHdyaXRlX3N6
X2J5dGVzID0gKCAobG9uZyBsb25nKWF0b2koYXJndlsyXSkpPDwxMDsKICBsb25nIGxvbmcgb2Zm
c2V0X3N6X2J5dGVzICAgPSBhdG9pKGFyZ3ZbM10pPDwxMDsKICBpbnQgICBsb29wcyA9IGF0b2ko
YXJndls0XSk7IAoKICBjaGFyKiBidWZmZXIgPSAoY2hhciopdmFsbG9jKHdyaXRlX3N6X2J5dGVz
KTsKICBpZiAoIWJ1ZmZlcikgewoJcGVycm9yKCJhbGxvYyA6ICIpOwoJcmV0dXJuIC0xOwogIH0K
CiAgbWVtc2V0KGJ1ZmZlciwweDAwLHdyaXRlX3N6X2J5dGVzKTsKCiAgd2hpbGUoICgtLWxvb3Bz
KT4wICl7CiAgICAKICAgIGludCByZXQgPSBwd3JpdGU2NChmZCxidWZmZXIsd3JpdGVfc3pfYnl0
ZXMsb2Zmc2V0X3N6X2J5dGVzKTsKICAgIGlmIChyZXQ8MCkgewogICAgICBwZXJyb3IoImZhaWxl
ZCB0byB3cml0ZTogIik7CiAgICAgIHByaW50ZigicmVhZF9zel9rYj0lZCBvZmZzZXRfc3pfa2I9
JWRcbiIsd3JpdGVfc3pfYnl0ZXMsb2Zmc2V0X3N6X2J5dGVzKTsKICAgICAgcmV0dXJuIC0xOwog
ICAgfQoKICAgIG9mZnNldF9zel9ieXRlcyArPSB3cml0ZV9zel9ieXRlczsKICAgIHByaW50Zigi
d3JpdGluZyAlbGxkIGJ5dGVzIGF0IG9mZnNldCAlbGxkXG4iLHdyaXRlX3N6X2J5dGVzLG9mZnNl
dF9zel9ieXRlcyk7CiAgfQogIAogIHJldHVybigwKTsKfQoKCg==
------=_Part_79546_24611748.1175291051207--
