From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 hang on get_active_stripe
Date: Sun, 28 May 2006 22:04:51 +1000
Message-ID: <17529.37347.782285.77442@cse.unsw.edu.au>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
	<Pine.LNX.4.56.0603061156140.26994@lion.drogon.net>
	<5d96567b0603060456h5f2c3cc8me790c86b74e1f854@mail.gmail.com>
	<4415F400.5030808@ucolick.org>
	<17429.64926.100005.904328@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605110758100.25283@twinlark.arctic.org>
	<Pine.LNX.4.64.0605171137350.29929@twinlark.arctic.org>
	<17522.29813.189944.397154@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605260903270.7952@twinlark.arctic.org>
	<17527.38282.35857.117651@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605270834240.30550@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from dean gaudet on Saturday May 27
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Patrik Jonsson <patrik@ucolick.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday May 27, dean@arctic.org wrote:
> On Sat, 27 May 2006, Neil Brown wrote:
> 
> > Thanks.  This narrows it down quite a bit... too much infact:  I can
> > now say for sure that this cannot possible happen :-)
> > 
> >   2/ The message.gz you sent earlier with the
> >           echo t > /proc/sysrq-trigger
> >      trace in it didn't contain information about md4_raid5 - the 
> 
> got another hang again this morning... full dmesg output attached.
> 

Thanks.  Nothing surprising there, which maybe is a surprise itself...

I'm still somewhat stumped by this.  But given that it is nicely
repeatable, I'm sure we can get there...

The following patch adds some more tracing to raid5, and might fix a
subtle bug in ll_rw_blk, though it is an incredible long shot that
this could be affecting raid5 (if it is, I'll have to assume there is
another bug somewhere).   It certainly doesn't break ll_rw_blk.
Whether it actually fixes something I'm not sure.

If you could try with these on top of the previous patches I'd really
appreciate it.

When you read from ..../stripe_cache_active, it should trigger a
(cryptic) kernel message within the next 15 seconds.  If I could get
the contents of that file and the kernel messages, that should help.

Thanks heaps,

NeilBrown


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c  |    4 ++--
 ./drivers/md/raid5.c |   18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff ./block/ll_rw_blk.c~current~ ./block/ll_rw_blk.c
--- ./block/ll_rw_blk.c~current~	2006-05-28 21:54:23.000000000 +1000
+++ ./block/ll_rw_blk.c	2006-05-28 21:55:17.000000000 +1000
@@ -874,7 +874,7 @@ static void __blk_queue_free_tags(reques
 	}
 
 	q->queue_tags = NULL;
-	q->queue_flags &= ~(1 << QUEUE_FLAG_QUEUED);
+	clear_bit(QUEUE_FLAG_QUEUED, &q->queue_flags);
 }
 
 /**
@@ -963,7 +963,7 @@ int blk_queue_init_tags(request_queue_t 
 	 * assign it, all done
 	 */
 	q->queue_tags = tags;
-	q->queue_flags |= (1 << QUEUE_FLAG_QUEUED);
+	set_bit(QUEUE_FLAG_QUEUED, &q->queue_flags);
 	return 0;
 fail:
 	kfree(tags);

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2006-05-27 09:17:10.000000000 +1000
+++ ./drivers/md/raid5.c	2006-05-28 21:56:56.000000000 +1000
@@ -1701,13 +1701,20 @@ static sector_t sync_request(mddev_t *md
  * During the scan, completed stripes are saved for us by the interrupt
  * handler, so that they will not have to wait for our next wakeup.
  */
+static unsigned long trigger;
+
 static void raid5d (mddev_t *mddev)
 {
 	struct stripe_head *sh;
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 	int handled;
+	int trace = 0;
 
 	PRINTK("+++ raid5d active\n");
+	if (test_and_clear_bit(0, &trigger))
+		trace = 1;
+	if (trace)
+		printk("raid5d runs\n");
 
 	md_check_recovery(mddev);
 
@@ -1725,6 +1732,13 @@ static void raid5d (mddev_t *mddev)
 			activate_bit_delay(conf);
 		}
 
+		if (trace)
+			printk(" le=%d, pas=%d, bqp=%d le=%d\n",
+			       list_empty(&conf->handle_list),
+			       atomic_read(&conf->preread_active_stripes),
+			       blk_queue_plugged(mddev->queue),
+			       list_empty(&conf->delayed_list));
+
 		if (list_empty(&conf->handle_list) &&
 		    atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD &&
 		    !blk_queue_plugged(mddev->queue) &&
@@ -1756,6 +1770,8 @@ static void raid5d (mddev_t *mddev)
 	unplug_slaves(mddev);
 
 	PRINTK("--- raid5d inactive\n");
+	if (trace)
+		printk("raid5d done\n");
 }
 
 static ssize_t
@@ -1813,6 +1829,7 @@ stripe_cache_active_show(mddev_t *mddev,
 		struct list_head *l;
 		n = sprintf(page, "%d\n", atomic_read(&conf->active_stripes));
 		n += sprintf(page+n, "%d preread\n", atomic_read(&conf->preread_active_stripes));
+		n += sprintf(page+n, "%splugged\n", blk_queue_plugged(mddev->queue)?"":"not ");
 		spin_lock_irq(&conf->device_lock);
 		c1=0;
 		list_for_each(l, &conf->bitmap_list)
@@ -1822,6 +1839,7 @@ stripe_cache_active_show(mddev_t *mddev,
 			c2++;
 		spin_unlock_irq(&conf->device_lock);
 		n += sprintf(page+n, "bitlist=%d delaylist=%d\n", c1, c2);
+		trigger = 0xffff;
 		return n;
 	} else
 		return 0;
