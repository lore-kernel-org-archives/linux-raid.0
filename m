From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v3 07/11] md/raid5: split bio for chunk_aligned_read
Date: Thu, 07 May 2015 22:57:54 -0700
Message-ID: <554C5062.5060107@kernel.org>
References: <1430980461-5235-1-git-send-email-mlin@kernel.org>	<1430980461-5235-8-git-send-email-mlin@kernel.org> <20150508141435.17666f2a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150508141435.17666f2a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dpark@posteo.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/07/2015 09:14 PM, NeilBrown wrote:
> On Wed,  6 May 2015 23:34:17 -0700 Ming Lin <mlin@kernel.org> wrote:
> 
>> If a read request fits entirely in a chunk, it will be passed directly to the
>> underlying device (providing it hasn't failed of course).  If it doesn't fit,
>> the slightly less efficient path that uses the stripe_cache is used.
>> Requests that get to the stripe cache are always completely split up as
>> necessary.
>>
>> So with RAID5, ripping out the merge_bvec_fn doesn't cause it to stop work,
>> but could cause it to take the less efficient path more often.
>>
>> All that is needed to manage this is for 'chunk_aligned_read' do some bio
>> splitting, much like the RAID0 code does.
>>
>> Cc: Neil Brown <neilb@suse.de>
>> Cc: linux-raid@vger.kernel.org
>> Signed-off-by: Ming Lin <mlin@kernel.org>
>> ---
>>  drivers/md/raid5.c | 42 +++++++++++++++++++++++++++++++++++++-----
>>  1 file changed, 37 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 7f4a717..b18f548 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -4738,7 +4738,7 @@ static void raid5_align_endio(struct bio *bi, int error)
>>  	add_bio_to_retry(raid_bi, conf);
>>  }
>>  
>> -static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
>> +static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
>>  {
>>  	struct r5conf *conf = mddev->private;
>>  	int dd_idx;
>> @@ -4747,7 +4747,7 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
>>  	sector_t end_sector;
>>  
>>  	if (!in_chunk_boundary(mddev, raid_bio)) {
>> -		pr_debug("chunk_aligned_read : non aligned\n");
>> +		pr_debug("%s: non aligned\n", __func__);
>>  		return 0;
>>  	}
>>  	/*
>> @@ -4822,6 +4822,36 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
>>  	}
>>  }
>>  
>> +static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
>> +{
>> +	struct bio *split;
>> +
>> +	do {
>> +		sector_t sector = raid_bio->bi_iter.bi_sector;
>> +		unsigned chunk_sects = mddev->chunk_sectors;
>> +		unsigned sectors;
>> +
>> +		if (likely(is_power_of_2(chunk_sects)))
>> +			sectors = chunk_sects - (sector & (chunk_sects-1));
>> +		else
>> +			sectors = chunk_sects - sector_div(sector, chunk_sects);
> 
> RAID5 doesn't currently allow non-power-of-2 chunks.  So this test is
> pointless, but not really harmful.  Maybe someday we will.
> 
> I'm equally happy for it to stay or go.

Then it's better for it to go.
Thanks.

From d40e9dfaae261cc86170193305e2022d2e1cda1a Mon Sep 17 00:00:00 2001
From: Ming Lin <mlin@kernel.org>
Date: Wed, 6 May 2015 22:51:24 -0700
Subject: [PATCH 07/11] md/raid5: split bio for chunk_aligned_read

If a read request fits entirely in a chunk, it will be passed directly to the
underlying device (providing it hasn't failed of course).  If it doesn't fit,
the slightly less efficient path that uses the stripe_cache is used.
Requests that get to the stripe cache are always completely split up as
necessary.

So with RAID5, ripping out the merge_bvec_fn doesn't cause it to stop work,
but could cause it to take the less efficient path more often.

All that is needed to manage this is for 'chunk_aligned_read' do some bio
splitting, much like the RAID0 code does.

Cc: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Ming Lin <mlin@kernel.org>
---
 drivers/md/raid5.c | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7f4a717..1978aa9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4738,7 +4738,7 @@ static void raid5_align_endio(struct bio *bi, int error)
 	add_bio_to_retry(raid_bi, conf);
 }
 
-static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
+static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 {
 	struct r5conf *conf = mddev->private;
 	int dd_idx;
@@ -4747,7 +4747,7 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 	sector_t end_sector;
 
 	if (!in_chunk_boundary(mddev, raid_bio)) {
-		pr_debug("chunk_aligned_read : non aligned\n");
+		pr_debug("%s: non aligned\n", __func__);
 		return 0;
 	}
 	/*
@@ -4822,6 +4822,31 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 	}
 }
 
+static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
+{
+	struct bio *split;
+
+	do {
+		sector_t sector = raid_bio->bi_iter.bi_sector;
+		unsigned chunk_sects = mddev->chunk_sectors;
+		unsigned sectors = chunk_sects - (sector & (chunk_sects-1));
+
+		if (sectors < bio_sectors(raid_bio)) {
+			split = bio_split(raid_bio, sectors, GFP_NOIO, fs_bio_set);
+			bio_chain(split, raid_bio);
+		} else
+			split = raid_bio;
+
+		if (!raid5_read_one_chunk(mddev, split)) {
+			if (split != raid_bio)
+				generic_make_request(raid_bio);
+			return split;
+		}
+	} while (split != raid_bio);
+
+	return NULL;
+}
+
 /* __get_priority_stripe - get the next stripe to process
  *
  * Full stripe writes are allowed to pass preread active stripes up until
@@ -5099,9 +5124,11 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 	 * data on failed drives.
 	 */
 	if (rw == READ && mddev->degraded == 0 &&
-	     mddev->reshape_position == MaxSector &&
-	     chunk_aligned_read(mddev,bi))
-		return;
+	    mddev->reshape_position == MaxSector) {
+		bi = chunk_aligned_read(mddev, bi);
+		if (!bi)
+			return;
+	}
 
 	if (unlikely(bi->bi_rw & REQ_DISCARD)) {
 		make_discard_request(mddev, bi);
-- 
1.9.1
