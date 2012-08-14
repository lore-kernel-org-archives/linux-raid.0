From: Shaohua Li <shli@kernel.org>
Subject: [patch v2]raid5: fix directio regression
Date: Tue, 14 Aug 2012 14:33:43 +0800
Message-ID: <20120814063343.GA30353@kernel.org>
References: <20120807032240.GA22495@kernel.org>
 <201208071312593120932@gmail.com>
 <CANejiEUQcA6X75WG0xSgSv6NAQaBQnwpDD-5QaNVbqmo-oqLsA@mail.gmail.com>
 <201208071421033759628@gmail.com>
 <CANejiEVoOprAFoS6mCVYDJKh+nbGE0=7Xw_CpVS+Z9AcUoh6RQ@mail.gmail.com>
 <201208081321202343795@gmail.com>
 <CANejiEWC5ZKWT2L4DM-bfGi+v=TpkABruQqe5h0qG4oQg9sDhw@mail.gmail.com>
 <201208090919591567972@gmail.com>
 <20120809113230.152aade3@notabene.brown>
 <CANejiEX1TKG_KhAsgUauHaCe2GE7jU1ozD-3c21VFgrm9COajQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANejiEX1TKG_KhAsgUauHaCe2GE7jU1ozD-3c21VFgrm9COajQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jianpeng Ma <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-raid.ids

On Thu, Aug 09, 2012 at 01:07:01PM +0800, Shaohua Li wrote:
> 2012/8/9 NeilBrown <neilb@suse.de>:
> > On Thu, 9 Aug 2012 09:20:05 +0800 "Jianpeng Ma" <majianpeng@gmail.com> wrote:
> >
> >> On 2012-08-08 20:53 Shaohua Li <shli@kernel.org> Wrote:
> >> >2012/8/8 Jianpeng Ma <majianpeng@gmail.com>:
> >> >> On 2012-08-08 10:58 Shaohua Li <shli@kernel.org> Wrote:
> >> >>>2012/8/7 Jianpeng Ma <majianpeng@gmail.com>:
> >> >>>> On 2012-08-07 13:32 Shaohua Li <shli@kernel.org> Wrote:
> >> >>>>>2012/8/7 Jianpeng Ma <majianpeng@gmail.com>:
> >> >>>>>> On 2012-08-07 11:22 Shaohua Li <shli@kernel.org> Wrote:
> >> >>>>>>>My directIO randomwrite 4k workload shows a 10~20% regression caused by commit
> >> >>>>>>>895e3c5c58a80bb. directIO usually is random IO and if request size isn't big
> >> >>>>>>>(which is the common case), delay handling of the stripe hasn't any advantages.
> >> >>>>>>>For big size request, delay can still reduce IO.
> >> >>>>>>>
> >> >>>>>>>Signed-off-by: Shaohua Li <shli@fusionio.com>
> >> >>>> [snip]
> >> >>>>>>>--
> >> >>>>>> May be used size to judge is not a good method.
> >> >>>>>> I firstly sended this patch, only want to control direct-write-block,not for reqular file.
> >> >>>>>> Because i think if someone used direct-write-block for raid5,he should know the feature of raid5 and he can control
> >> >>>>>> for write to full-write.
> >> >>>>>> But at that time, i did know how to differentiate between regular file and block-device.
> >> >>>>>> I thik we should do something to do this.
> >> >>>>>
> >> >>>>>I don't think it's possible user can control his write to be a
> >> >>>>>full-write even for
> >> >>>>>raw disk IO. Why regular file and block device io matters here?
> >> >>>>>
> >> >>>>>Thanks,
> >> >>>>>Shaohua
> >> >>>> Another problem is the size. How to judge the size is large or not?
> >> >>>> A syscall write is a dio and a dio may be split more bios.
> >> >>>> For my workload, i usualy write chunk-size.
> >> >>>> But your patch is judge by bio-size.
> >> >>>
> >> >>>I'd ignore workload which does sequential directIO, though
> >> >>>your workload is, but I bet no real workloads are. So I'd like
> >> >> Sorry,my explain maybe not corcrect. I write data once which size is almost chunks-size * devices,in order to full-write
> >> >> and as possible as to no pre-read operation.
> >> >>>only to consider big size random directio. I agree the size
> >> >>>judge is arbitrary. I can optimize it to be only consider stripe
> >> >>>which hits two or more disks in one bio, but not sure if it's
> >> >>>worthy doing. Not ware big size directio is common, and even
> >> >>>is, big size request IOPS is low, a bit delay maybe not a big
> >> >>>deal.
> >> >> If add a acc_time for 'striep_head' to control?
> >> >> When get_active_stripe() is ok, update acc_time.
> >> >> For some time, stripe_head did not access and it shold pre-read.
> >> >
> >> >Do you want to add a timer for each stripe? This is even ugly.
> >> >How do you choose the expire time? A time works for harddisk
> >> >definitely will not work for a fast SSD.
> >> A time is like the size which is arbitrary.
> >> How about add a interface in sysfs to control by user?
> >> Only user can judge the workload, which sequatial write or random write.
> >
> > This is getting worse by the minute.  A sysfs interface for this is
> > definitely not a good idea.
> >
> > The REQ_NOIDLE flag is a pretty clear statement that no more requests that
> > merge with this one are expected.  If some use cases sends random requests,
> > maybe it should be setting REQ_NOIDLE.
> >
> > Maybe someone should do some research and find out why WRITE_ODIRECT doesn't
> > include REQ_NOIDLE.  Understanding that would help understand the current
> > problem.
> 
> A quick search shows only cfq-iosched uses REQ_NOIDLE. In
> cfq, a queue is idled to avoid losing its share. REQ_NOIDLE
> tells cfq to avoid idle, since the task will not dispatch further
> requests any more. Note this isn't no merge.

Since REQ_NOIDLE has no relationship with request merge, we'd better remove it.
I came out a new patch, which doesn't depend on request size any more. With
this patch, sequential directio will still introduce unnecessary raid5 preread
(especially for small size IO), but I bet no app does sequential small size
directIO.

Thanks,
Shaohua

Subject: raid5: fix directio regression

My directIO randomwrite 4k workload shows a 10~20% regression caused by commit
895e3c5c58a80bb. This commit isn't friendly for small size random IO, because
delaying such request hasn't any advantages.

DirectIO usually is random IO. I thought we can ignore request merge between
bios from different io_submit. So we only consider one bio which can drive
unnecessary preread in raid5, which is large request. If a bio is large enough
and some of its stripes will access two or more disks, such stripes should be
delayed to avoid unnecessary preread till bio for the last disk of the strips
is added.

REQ_NOIDLE doesn't mean about request merge, I deleted it.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-08-13 15:03:16.479473326 +0800
+++ linux/drivers/md/raid5.c	2012-08-14 11:10:37.335982170 +0800
@@ -4076,6 +4076,7 @@ static void make_request(struct mddev *m
 	struct stripe_head *sh;
 	const int rw = bio_data_dir(bi);
 	int remaining;
+	int chunk_sectors;
 
 	if (unlikely(bi->bi_rw & REQ_FLUSH)) {
 		md_flush_request(mddev, bi);
@@ -4089,6 +4090,11 @@ static void make_request(struct mddev *m
 	     chunk_aligned_read(mddev,bi))
 		return;
 
+	if (mddev->new_chunk_sectors < mddev->chunk_sectors)
+		chunk_sectors = mddev->new_chunk_sectors;
+	else
+		chunk_sectors = mddev->chunk_sectors;
+
 	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	last_sector = bi->bi_sector + (bi->bi_size>>9);
 	bi->bi_next = NULL;
@@ -4192,7 +4198,8 @@ static void make_request(struct mddev *m
 			finish_wait(&conf->wait_for_overlap, &w);
 			set_bit(STRIPE_HANDLE, &sh->state);
 			clear_bit(STRIPE_DELAYED, &sh->state);
-			if ((bi->bi_rw & REQ_NOIDLE) &&
+			if ((bi->bi_rw & REQ_SYNC) &&
+			    (last_sector - logical_sector < chunk_sectors) &&
 			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				atomic_inc(&conf->preread_active_stripes);
 			release_stripe_plug(mddev, sh);
