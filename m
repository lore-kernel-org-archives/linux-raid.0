Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEE220B1E2
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 13:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730985718; cv=none; b=Sy9JitxCc8k98jnPIiHiBYBvtBaa87hFAEi8thGNIIzj05U82la0IoLXMjKq5gSyDRZ0B0vJYehY2onht9IK3AkSqx80Efj9VG0Bk2rdoDqwKVhLPKWpIs4W6RiRyM69IHVSESC7Btn8TQhkvL0U2I0MCRZEOePsayAy9YDuJso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730985718; c=relaxed/simple;
	bh=nxZ4GjK6sHH9W7pSei+KW/+1xJzUnm073HyAUJYIdX4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=HFPIc7o47MPx6f67HsBotfsqoY9KxAtq4Mi9toEUvnToy5JlryKbuxYrYbhF8pTYfuAKao5LVSa8Asr/sq8j7v0hJeLMtFYcQOmLQsPgQwDFZtlNZ26pMw6SfNeHK6Tzk2qwMDUHRopgIiwLXX5SeP+mttPfY3fud7RiIYoZhAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XkjQP61X7z4f3p0x
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 21:21:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B64961A0568
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 21:21:52 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCngYXwvixn5DF0BA--.5057S3;
	Thu, 07 Nov 2024 21:21:52 +0800 (CST)
Subject: Re: Experiencing md raid5 hang and CPU lockup on kernel v6.11
To: Haris Iqbal <haris.iqbal@ionos.com>,
 =?UTF-8?Q?Dragan_Milivojevi=c4=87?= <galileo@pkm-inc.com>
Cc: linux-raid@vger.kernel.org, Jinpu Wang <jinpu.wang@ionos.com>,
 =?UTF-8?Q?Florian-Ewald_M=c3=bcller?= <florian-ewald.mueller@ionos.com>,
 "yukuai (C)" <yukuai3@huawei.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com>
 <CALtW_ahYbP71XPM=ZGoqyBd14wVAtUyGGgXK0gxk52KjJZUk4A@mail.gmail.com>
 <CAJpMwyjG61FjozvbG1oSej2ytRxnRpj3ga=V7zTLrjXKeDYZ_Q@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <4a914bc9-0d4e-e7c8-bed8-7b781f585587@huaweicloud.com>
Date: Thu, 7 Nov 2024 21:21:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAJpMwyjG61FjozvbG1oSej2ytRxnRpj3ga=V7zTLrjXKeDYZ_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCngYXwvixn5DF0BA--.5057S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Jr47uryxGryDtw13Zr15XFb_yoWxWw1rpa
	yjva45JrZ8XFZYg3srC3yDuF1Fgwn7KrZrtFW8X34SkF13Kr9avF4fWa4FyFn8CFWxCF9x
	Zrn8Kry7Jry2qrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8
	JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	Ha0DUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/11/05 23:34, Haris Iqbal 写道:
> On Tue, Nov 5, 2024 at 3:04 PM Dragan Milivojević <galileo@pkm-inc.com> wrote:
>>
>> On Tue, 5 Nov 2024 at 10:58, Haris Iqbal <haris.iqbal@ionos.com> wrote:
>>>
>>> Hi,
>>>
>>> I am running fio over a RDMA block device. The server side of this
>>> mapping is an md-raid0 device, created over 3 md-raid5 devices.
>>> The md-raid5 devices each are created over 8 block devices. Below is
>>> how the raid configuration looks (md400, md300, md301 and md302 are
>>> relevant for this discussion here).
>>
>> Try disabling the bitmap as a quick "fix" and see if that helps.
> 
> Yes. Disabling bitmap does seem to prevent the hang completely. I ran
> fio for 10 minutes and no hang.
> Triggered the hang in 10 seconds after reverting back to internal bitmap.
> 

Can you give the following patch a test? It's based on v6.11.

Thanks,
Kuai

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d3a837506a36..5e1a82b79e41 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8753,6 +8753,30 @@ void md_submit_discard_bio(struct mddev *mddev, 
struct md_rdev *rdev,
  }
  EXPORT_SYMBOL_GPL(md_submit_discard_bio);

+static bool is_raid456(struct mddev *mddev)
+{
+       return mddev->pers->level == 4 || mddev->pers->level == 5 ||
+              mddev->pers->level == 6;
+}
+
+static void bitmap_startwrite(struct mddev *mddev, struct bio *bio)
+{
+       if (!is_raid456(mddev) || !mddev->bitmap)
+               return;
+
+       md_bitmap_startwrite(mddev->bitmap, bio_offset(bio), 
bio_sectors(bio),
+                            0);
+}
+
+static void bitmap_endwrite(struct mddev *mddev, struct bio *bio, 
sector_t sectors)
+{
+       if (!is_raid456(mddev) || !mddev->bitmap)
+               return;
+
+       md_bitmap_endwrite(mddev->bitmap, bio_offset(bio), sectors,o
+                          bio->bi_status == BLK_STS_OK, 0);
+}
+
  static void md_end_clone_io(struct bio *bio)
  {
         struct md_io_clone *md_io_clone = bio->bi_private;
@@ -8765,6 +8789,7 @@ static void md_end_clone_io(struct bio *bio)
         if (md_io_clone->start_time)
                 bio_end_io_acct(orig_bio, md_io_clone->start_time);

+       bitmap_endwrite(mddev, orig_bio, md_io_clone->sectors);
         bio_put(bio);
         bio_endio(orig_bio);
         percpu_ref_put(&mddev->active_io);
@@ -8778,6 +8803,7 @@ static void md_clone_bio(struct mddev *mddev, 
struct bio **bio)
                 bio_alloc_clone(bdev, *bio, GFP_NOIO, 
&mddev->io_clone_set);

         md_io_clone = container_of(clone, struct md_io_clone, bio_clone);
+       md_io_clone->sectors = bio_sectors(*bio);
         md_io_clone->orig_bio = *bio;
         md_io_clone->mddev = mddev;
         if (blk_queue_io_stat(bdev->bd_disk->queue))
@@ -8790,6 +8816,7 @@ static void md_clone_bio(struct mddev *mddev, 
struct bio **bio)

  void md_account_bio(struct mddev *mddev, struct bio **bio)
  {
+       bitmap_startwrite(mddev, *bio);
         percpu_ref_get(&mddev->active_io);
         md_clone_bio(mddev, bio);
  }
@@ -8807,6 +8834,8 @@ void md_free_cloned_bio(struct bio *bio)
         if (md_io_clone->start_time)
                 bio_end_io_acct(orig_bio, md_io_clone->start_time);

+       bitmap_endwrite(mddev, orig_bio, md_io_clone->sectors);
+
         bio_put(bio);
         percpu_ref_put(&mddev->active_io);
  }
diff --git a/drivers/md/md.h b/drivers/md/md.h
index a0d6827dced9..0c2794230e0a 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -837,6 +837,7 @@ struct md_io_clone {
         struct mddev    *mddev;
         struct bio      *orig_bio;
         unsigned long   start_time;
+       sector_t        sectors;
         struct bio      bio_clone;
  };
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c14cf2410365..4f009e32f68a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3561,12 +3561,6 @@ static void __add_stripe_bio(struct stripe_head 
*sh, struct bio *bi,
                  * is added to a batch, STRIPE_BIT_DELAY cannot be changed
                  * any more.
                  */
-               set_bit(STRIPE_BITMAP_PENDING, &sh->state);
-               spin_unlock_irq(&sh->stripe_lock);
-               md_bitmap_startwrite(conf->mddev->bitmap, sh->sector,
-                                    RAID5_STRIPE_SECTORS(conf), 0);
-               spin_lock_irq(&sh->stripe_lock);
-               clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
                 if (!sh->batch_head) {
                         sh->bm_seq = conf->seq_flush+1;
                         set_bit(STRIPE_BIT_DELAY, &sh->state);
@@ -3621,7 +3615,6 @@ handle_failed_stripe(struct r5conf *conf, struct 
stripe_head *sh,
         BUG_ON(sh->batch_head);
         for (i = disks; i--; ) {
                 struct bio *bi;
-               int bitmap_end = 0;

                 if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
                         struct md_rdev *rdev = conf->disks[i].rdev;
@@ -3646,8 +3639,6 @@ handle_failed_stripe(struct r5conf *conf, struct 
stripe_head *sh,
                 sh->dev[i].towrite = NULL;
                 sh->overwrite_disks = 0;
                 spin_unlock_irq(&sh->stripe_lock);
-               if (bi)
-                       bitmap_end = 1;

                 log_stripe_write_finished(sh);
@@ -3662,10 +3653,6 @@ handle_failed_stripe(struct r5conf *conf, struct 
stripe_head *sh,
                         bio_io_error(bi);
                         bi = nextbi;
                 }
-               if (bitmap_end)
-                       md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-                                          RAID5_STRIPE_SECTORS(conf), 
0, 0);
-               bitmap_end = 0;
                 /* and fail all 'written' */
                 bi = sh->dev[i].written;
                 sh->dev[i].written = NULL;
@@ -3674,7 +3661,6 @@ handle_failed_stripe(struct r5conf *conf, struct 
stripe_head *sh,
                         sh->dev[i].page = sh->dev[i].orig_page;
                 }

-               if (bi) bitmap_end = 1;
                 while (bi && bi->bi_iter.bi_sector <
                        sh->dev[i].sector + RAID5_STRIPE_SECTORS(conf)) {
                         struct bio *bi2 = r5_next_bio(conf, bi, 
sh->dev[i].sector);
@@ -3708,9 +3694,6 @@ handle_failed_stripe(struct r5conf *conf, struct 
stripe_head *sh,
                                 bi = nextbi;
                         }
                 }
-               if (bitmap_end)
-                       md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-                                          RAID5_STRIPE_SECTORS(conf), 
0, 0);
                 /* If we were in the middle of a write the parity block 
might
                  * still be locked - so just clear all R5_LOCKED flags
                  */
@@ -4059,10 +4042,6 @@ static void handle_stripe_clean_event(struct 
r5conf *conf,
                                         bio_endio(wbi);
                                         wbi = wbi2;
                                 }
-                               md_bitmap_endwrite(conf->mddev->bitmap, 
sh->sector,
- RAID5_STRIPE_SECTORS(conf),
- !test_bit(STRIPE_DEGRADED, &sh->state),
-                                                  0);
                                 if (head_sh->batch_head) {
                                         sh = 
list_first_entry(&sh->batch_list,
                                                               struct 
stripe_head,
@@ -5788,13 +5767,6 @@ static void make_discard_request(struct mddev 
*mddev, struct bio *bi)
                 }
                 spin_unlock_irq(&sh->stripe_lock);
                 if (conf->mddev->bitmap) {
-                       for (d = 0;
-                            d < conf->raid_disks - conf->max_degraded;
-                            d++)
-                               md_bitmap_startwrite(mddev->bitmap,
-                                                    sh->sector,
- RAID5_STRIPE_SECTORS(conf),
-                                                    0);
                         sh->bm_seq = conf->seq_flush + 1;
                         set_bit(STRIPE_BIT_DELAY, &sh->state);
                 }
> .
> 

