From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 hang on get_active_stripe
Date: Tue, 23 May 2006 12:33:25 +1000
Message-ID: <17522.29813.189944.397154@cse.unsw.edu.au>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
	<Pine.LNX.4.56.0603061156140.26994@lion.drogon.net>
	<5d96567b0603060456h5f2c3cc8me790c86b74e1f854@mail.gmail.com>
	<4415F400.5030808@ucolick.org>
	<17429.64926.100005.904328@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605110758100.25283@twinlark.arctic.org>
	<Pine.LNX.4.64.0605171137350.29929@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="7XZeJb07CE"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from dean gaudet on Wednesday May 17
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Neil Brown <neilb@suse.de>, Patrik Jonsson <patrik@ucolick.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--7XZeJb07CE
Content-Type: text/plain; charset=us-ascii
Content-Description: message body text
Content-Transfer-Encoding: 7bit

On Wednesday May 17, dean@arctic.org wrote:
> On Thu, 11 May 2006, dean gaudet wrote:
> 
> > On Tue, 14 Mar 2006, Neil Brown wrote:
> > 
> > > On Monday March 13, patrik@ucolick.org wrote:
> > > > I just experienced some kind of lockup accessing my 8-drive raid5
> > > > (2.6.16-rc4-mm2). The system has been up for 16 days running fine, but
> > > > now processes that try to read the md device hang. ps tells me they are
> > > > all sleeping in get_active_stripe. There is nothing in the syslog, and I
> > > > can read from the individual drives fine with dd. mdadm says the state
> > > > is "active".
> ...
> > 
> > i seem to be running into this as well... it has happenned several times 
> > in the past three weeks.  i attached the kernel log output...
> 
> it happenned again...  same system as before...
> 

I've spent all morning looking at this and while I cannot see what is
happening I did find a couple of small bugs, so that is good...

I've attached three patches.  The first fix two small bugs (I think).
The last adds some extra information to
  /sys/block/mdX/md/stripe_cache_active

They are against 2.6.16.11.

If you could apply them and if the problem recurs, report the content
of stripe_cache_active several times before and after changing it,
just like you did last time, that might help throw some light on the
situation.

Thanks,
NeilBrown


--7XZeJb07CE
Content-Type: text/plain
Content-Disposition: inline;
	filename="002MdR5PlugProblem"
Content-Transfer-Encoding: 7bit

Status: ok

Fix a plug/unplug race in raid5

When a device is unplugged, requests are moved from one or two
(depending on whether a bitmap is in use) queues to the main
request queue.

So whenever requests are put on either of those queues, we should make
sure the raid5 array is 'plugged'.
However we don't.  We currently plug the raid5 queue just before
putting requests on queues, so there is room for a race.  If something
unplugs the queue at just the wrong time, requests will be left on
the queue and nothing will want to unplug them.
Normally something else will plug and unplug the queue fairly
soon, but there is a risk that nothing will.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2006-05-23 12:27:58.000000000 +1000
+++ ./drivers/md/raid5.c	2006-05-23 12:28:26.000000000 +1000
@@ -77,12 +77,14 @@ static void __release_stripe(raid5_conf_
 		if (atomic_read(&conf->active_stripes)==0)
 			BUG();
 		if (test_bit(STRIPE_HANDLE, &sh->state)) {
-			if (test_bit(STRIPE_DELAYED, &sh->state))
+			if (test_bit(STRIPE_DELAYED, &sh->state)) {
 				list_add_tail(&sh->lru, &conf->delayed_list);
-			else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
-				 conf->seq_write == sh->bm_seq)
+				blk_plug_device(conf->mddev->queue);
+			} else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
+				   conf->seq_write == sh->bm_seq) {
 				list_add_tail(&sh->lru, &conf->bitmap_list);
-			else {
+				blk_plug_device(conf->mddev->queue);
+			} else {
 				clear_bit(STRIPE_BIT_DELAY, &sh->state);
 				list_add_tail(&sh->lru, &conf->handle_list);
 			}
@@ -1519,13 +1521,6 @@ static int raid5_issue_flush(request_que
 	return ret;
 }
 
-static inline void raid5_plug_device(raid5_conf_t *conf)
-{
-	spin_lock_irq(&conf->device_lock);
-	blk_plug_device(conf->mddev->queue);
-	spin_unlock_irq(&conf->device_lock);
-}
-
 static int make_request (request_queue_t *q, struct bio * bi)
 {
 	mddev_t *mddev = q->queuedata;
@@ -1577,7 +1572,6 @@ static int make_request (request_queue_t
 				goto retry;
 			}
 			finish_wait(&conf->wait_for_overlap, &w);
-			raid5_plug_device(conf);
 			handle_stripe(sh);
 			release_stripe(sh);
 

--7XZeJb07CE
Content-Type: text/plain
Content-Disposition: inline;
	filename="003MdR5BitmapPlug"
Content-Transfer-Encoding: 7bit

Status: ok

Fix some small races in bitmap plugging in raid5.

The comment gives more details, but I didn't quite have the
sequencing write, so there was room for races to leave bits
unset in the on-disk bitmap for short periods of time.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2006-05-23 12:28:26.000000000 +1000
+++ ./drivers/md/raid5.c	2006-05-23 12:28:53.000000000 +1000
@@ -15,6 +15,30 @@
  * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+/*
+ * BITMAP UNPLUGGING:
+ *
+ * The sequencing for updating the bitmap reliably is a little
+ * subtle (and I got it wrong the first time) so it deserves some
+ * explanation.
+ *
+ * We group bitmap updates into batches.  Each batch has a number.
+ * We may write out several batches at once, but that isn't very important.
+ * conf->bm_write is the number of the last batch successfully written.
+ * conf->bm_flush is the number of the last batch that was closed to
+ *    new additions.
+ * When we discover that we will need to write to any block in a stripe
+ * (in add_stripe_bio) we update the in-memory bitmap and record in sh->bm_seq
+ * the number of the batch it will be in. This is bm_flush+1.
+ * When we are ready to do a write, if that batch hasn't been written yet,
+ *   we plug the array and queue the stripe for later.
+ * When an unplug happens, we increment bm_flush, thus closing the current
+ *   batch.
+ * When we notice that bm_flush > bm_write, we write out all pending updates
+ * to the bitmap, and advance bm_write to where bm_flush was.
+ * This may occasionally write a bit out twice, but is sure never to
+ * miss any bits.
+ */
 
 #include <linux/config.h>
 #include <linux/module.h>
@@ -81,7 +105,7 @@ static void __release_stripe(raid5_conf_
 				list_add_tail(&sh->lru, &conf->delayed_list);
 				blk_plug_device(conf->mddev->queue);
 			} else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
-				   conf->seq_write == sh->bm_seq) {
+				   sh->bm_seq - conf->seq_write > 0) {
 				list_add_tail(&sh->lru, &conf->bitmap_list);
 				blk_plug_device(conf->mddev->queue);
 			} else {
@@ -884,9 +908,9 @@ static int add_stripe_bio(struct stripe_
 		(unsigned long long)sh->sector, dd_idx);
 
 	if (conf->mddev->bitmap && firstwrite) {
-		sh->bm_seq = conf->seq_write;
 		bitmap_startwrite(conf->mddev->bitmap, sh->sector,
 				  STRIPE_SECTORS, 0);
+		sh->bm_seq = conf->seq_flush+1;
 		set_bit(STRIPE_BIT_DELAY, &sh->state);
 	}
 
@@ -1692,7 +1716,7 @@ static void raid5d (mddev_t *mddev)
 	while (1) {
 		struct list_head *first;
 
-		if (conf->seq_flush - conf->seq_write > 0) {
+		if (conf->seq_flush != conf->seq_write) {
 			int seq = conf->seq_flush;
 			spin_unlock_irq(&conf->device_lock);
 			bitmap_unplug(mddev->bitmap);

--7XZeJb07CE
Content-Type: text/plain
Content-Disposition: inline;
	filename="004MdR5Debug"
Content-Transfer-Encoding: 7bit

Status: ok

Add some debugging to track raid5 hang problem


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2006-05-23 12:28:53.000000000 +1000
+++ ./drivers/md/raid5.c	2006-05-23 12:29:05.000000000 +1000
@@ -1807,9 +1807,23 @@ static ssize_t
 stripe_cache_active_show(mddev_t *mddev, char *page)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
-	if (conf)
-		return sprintf(page, "%d\n", atomic_read(&conf->active_stripes));
-	else
+	if (conf) {
+		int n;
+		int c1, c2;
+		struct list_head *l;
+		n = sprintf(page, "%d\n", atomic_read(&conf->active_stripes));
+		n += sprintf(page+n, "%d preread\n", atomic_read(&conf->preread_active_stripes));
+		spin_lock_irq(&conf->device_lock);
+		c1=0;
+		list_for_each(l, &conf->bitmap_list)
+			c1++;
+		c2=0;
+		list_for_each(l, &conf->delayed_list)
+			c2++;
+		spin_unlock_irq(&conf->device_lock);
+		n += sprintf(page+n, "bitlist=%d delaylist=%d\n", c1, c2);
+		return n;
+	} else
 		return 0;
 }
 

--7XZeJb07CE--
