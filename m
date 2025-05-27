Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50311A239F;
	Tue, 27 May 2025 08:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748334258; cv=none; b=a4JT5bAmueY38Djm7OQv4wMk+MlfG8wr2onpny+gWOyiiY+CQQPgndkFENbdYfXdT8LnCjmMli5arECS/NkcLmqUzMbsFP0zR9+B95+ax6K0zQ5/iAGd36VU3BsAjHsgmASsOUMU5yQl3q4CPVx2izquPSIrBZ0GPIFYQTeaOl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748334258; c=relaxed/simple;
	bh=eLBdd7cHtkF1AA22gJm3XQpGpMKrNjegYwVk2UCAA48=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=tpMUKAQ2d/vCj6QX3dYvfZkJ283brO2RxQ6d+RhV3yIz8oI23MtHq+Gn9hSZjkil61LVlbKKmrWYQuWLhznCx0uVJmOnEy1HnPzt98WB7vDyda6cyYSUiUzMMgtPZNkpMVBH6wa+RoPRqzVSzPZ9gxKNJHPld1N8GroQsJD6BSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4b65J24mzxz4f3jXX;
	Tue, 27 May 2025 16:23:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id E5DA51A0359;
	Tue, 27 May 2025 16:24:11 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP2 (Coremail) with SMTP id Syh0CgCHkWSqdjVosO4wNg--.57749S3;
	Tue, 27 May 2025 16:24:11 +0800 (CST)
Subject: Re: [PATCH v2] md/raid1,raid10: don't handle IO error for REQ_RAHEAD
 and REQ_NOWAIT
To: Yu Kuai <yukuai1@huaweicloud.com>, mpatocka@redhat.com,
 zdenek.kabelac@gmail.com, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250527081407.3004055-1-yukuai1@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <190d2a22-b858-1320-cd2e-c71f057b233d@huaweicloud.com>
Date: Tue, 27 May 2025 16:24:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250527081407.3004055-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCHkWSqdjVosO4wNg--.57749S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Jw48tw48ur4kWw18tF17Awb_yoWxKFy3p3
	y7Ga9Yv39rJw47ZFnrJFWUua4Fkw1Sq34UCrW8G34xZw4a9rZ8Aa1DG3yYgF98ZFWrW3Wa
	qF1vgw4Dua9FqFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi, Zdenek Kabelac

ÔÚ 2025/05/27 16:14, Yu Kuai Ð´µÀ:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> IO with REQ_RAHEAD or REQ_NOWAIT can fail early, even if the storage medium
> is fine, hence record badblocks or remove the disk from array does not
> make sense.
> 
> This problem if found by lvm2 test lvcreate-large-raid, where dm-zero
> will fail read ahead IO directly.
> 
> Reported-and-tested-by: Mikulas Patocka <mpatocka@redhat.com>
> Closes: https://lore.kernel.org/all/34fa755d-62c8-4588-8ee1-33cb1249bdf2@redhat.com/
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
> Changes in v2:
>   - handle REQ_NOWAIT as well.
> 
>   drivers/md/raid1-10.c | 10 ++++++++++
>   drivers/md/raid1.c    | 19 ++++++++++---------
>   drivers/md/raid10.c   | 11 ++++++-----
>   3 files changed, 26 insertions(+), 14 deletions(-)
> 

Just to let you know that while testing lvcreate-large-raid, the test
can fail sometime:

[ 0:12.021] ## DEBUG0: 08:11:43.596775 lvcreate[8576] 
device_mapper/ioctl/libdm-iface.c:2118  device-mapper: create ioctl on 
LVMTEST8371vg1-LV1_rmeta_0 
LVM-iqJjW9HItbME2d4DC2S7D58zd2omecjf0yQN83foinyxHaPoZqGEnX4rRUN7i0kH 
failed: Device or resource busy

And add debug info in kernel:
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 4165fef4c170..04b66b804365 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -263,6 +263,7 @@ static int dm_hash_insert(const char *name, const 
char *uuid, struct mapped_devi
  {
         struct hash_cell *cell, *hc;

+       printk("%s: %s %s\n", __func__, name, uuid);
         /*
          * Allocate the new cells.
          */
@@ -310,6 +311,7 @@ static struct dm_table *__hash_remove(struct 
hash_cell *hc)
         struct dm_table *table;
         int srcu_idx;

+       printk("%s: %s %s\n", __func__, hc->name, hc->uuid);
         lockdep_assert_held(&_hash_lock);

         /* remove from the dev trees */
@@ -882,18 +884,23 @@ static int dev_create(struct file *filp, struct 
dm_ioctl *param, size_t param_si
         struct mapped_device *md;

         r = check_name(param->name);
-       if (r)
+       if (r) {
+               printk("%s: check_name failed %d\n", __func__, r);
                 return r;
+       }

         if (param->flags & DM_PERSISTENT_DEV_FLAG)
                 m = MINOR(huge_decode_dev(param->dev));

         r = dm_create(m, &md);
-       if (r)
+       if (r) {
+               printk("%s: dm_create failed %d\n", __func__, r);
                 return r;
+       }

         r = dm_hash_insert(param->name, *param->uuid ? param->uuid : 
NULL, md);
         if (r) {
+               printk("%s: dm_hash_insert failed %d\n", __func__, r);
                 dm_put(md);
                 dm_destroy(md);
                 return r;

I got:
[ 2265.277214] dm_hash_insert: LVMTEST8371vg1-LV1_rmeta_0 
LVM-iqJjW9HItbME2d4DC2S7D58zd2omecjf0yQN83foinyxHaPoZqGEnX4rRUN7i0kH^M
[ 2265.279666] dm_hash_insert: LVMTEST8371vg1-LV1_rmeta_0 
LVM-iqJjW9HItbME2d4DC2S7D58zd2omecjf0yQN83foinyxHaPoZqGEnX4rRUN7i0kH^M
[ 2265.281043] dev_create: dm_hash_insert failed -16

Looks like the test somehow insert the same target twice? Is this a
known issue?

Thanks,
Kuai

> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index c7efd8aab675..b8b3a9069701 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -293,3 +293,13 @@ static inline bool raid1_should_read_first(struct mddev *mddev,
>   
>   	return false;
>   }
> +
> +/*
> + * bio with REQ_RAHEAD or REQ_NOWAIT can fail at anytime, before such IO is
> + * submitted to the underlying disks, hence don't record badblocks or retry
> + * in this case.
> + */
> +static inline bool raid1_should_handle_error(struct bio *bio)
> +{
> +	return !(bio->bi_opf & (REQ_RAHEAD | REQ_NOWAIT));
> +}
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 657d481525be..19c5a0ce5a40 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -373,14 +373,16 @@ static void raid1_end_read_request(struct bio *bio)
>   	 */
>   	update_head_pos(r1_bio->read_disk, r1_bio);
>   
> -	if (uptodate)
> +	if (uptodate) {
>   		set_bit(R1BIO_Uptodate, &r1_bio->state);
> -	else if (test_bit(FailFast, &rdev->flags) &&
> -		 test_bit(R1BIO_FailFast, &r1_bio->state))
> +	} else if (test_bit(FailFast, &rdev->flags) &&
> +		 test_bit(R1BIO_FailFast, &r1_bio->state)) {
>   		/* This was a fail-fast read so we definitely
>   		 * want to retry */
>   		;
> -	else {
> +	} else if (!raid1_should_handle_error(bio)) {
> +		uptodate = 1;
> +	} else {
>   		/* If all other devices have failed, we want to return
>   		 * the error upwards rather than fail the last device.
>   		 * Here we redefine "uptodate" to mean "Don't want to retry"
> @@ -451,16 +453,15 @@ static void raid1_end_write_request(struct bio *bio)
>   	struct bio *to_put = NULL;
>   	int mirror = find_bio_disk(r1_bio, bio);
>   	struct md_rdev *rdev = conf->mirrors[mirror].rdev;
> -	bool discard_error;
>   	sector_t lo = r1_bio->sector;
>   	sector_t hi = r1_bio->sector + r1_bio->sectors;
> -
> -	discard_error = bio->bi_status && bio_op(bio) == REQ_OP_DISCARD;
> +	bool ignore_error = !raid1_should_handle_error(bio) ||
> +		(bio->bi_status && bio_op(bio) == REQ_OP_DISCARD);
>   
>   	/*
>   	 * 'one mirror IO has finished' event handler:
>   	 */
> -	if (bio->bi_status && !discard_error) {
> +	if (bio->bi_status && !ignore_error) {
>   		set_bit(WriteErrorSeen,	&rdev->flags);
>   		if (!test_and_set_bit(WantReplacement, &rdev->flags))
>   			set_bit(MD_RECOVERY_NEEDED, &
> @@ -511,7 +512,7 @@ static void raid1_end_write_request(struct bio *bio)
>   
>   		/* Maybe we can clear some bad blocks. */
>   		if (rdev_has_badblock(rdev, r1_bio->sector, r1_bio->sectors) &&
> -		    !discard_error) {
> +		    !ignore_error) {
>   			r1_bio->bios[mirror] = IO_MADE_GOOD;
>   			set_bit(R1BIO_MadeGood, &r1_bio->state);
>   		}
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index dce06bf65016..b74780af4c22 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -399,6 +399,8 @@ static void raid10_end_read_request(struct bio *bio)
>   		 * wait for the 'master' bio.
>   		 */
>   		set_bit(R10BIO_Uptodate, &r10_bio->state);
> +	} else if (!raid1_should_handle_error(bio)) {
> +		uptodate = 1;
>   	} else {
>   		/* If all other devices that store this block have
>   		 * failed, we want to return the error upwards rather
> @@ -456,9 +458,8 @@ static void raid10_end_write_request(struct bio *bio)
>   	int slot, repl;
>   	struct md_rdev *rdev = NULL;
>   	struct bio *to_put = NULL;
> -	bool discard_error;
> -
> -	discard_error = bio->bi_status && bio_op(bio) == REQ_OP_DISCARD;
> +	bool ignore_error = !raid1_should_handle_error(bio) ||
> +		(bio->bi_status && bio_op(bio) == REQ_OP_DISCARD);
>   
>   	dev = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
>   
> @@ -472,7 +473,7 @@ static void raid10_end_write_request(struct bio *bio)
>   	/*
>   	 * this branch is our 'one mirror IO has finished' event handler:
>   	 */
> -	if (bio->bi_status && !discard_error) {
> +	if (bio->bi_status && !ignore_error) {
>   		if (repl)
>   			/* Never record new bad blocks to replacement,
>   			 * just fail it.
> @@ -527,7 +528,7 @@ static void raid10_end_write_request(struct bio *bio)
>   		/* Maybe we can clear some bad blocks. */
>   		if (rdev_has_badblock(rdev, r10_bio->devs[slot].addr,
>   				      r10_bio->sectors) &&
> -		    !discard_error) {
> +		    !ignore_error) {
>   			bio_put(bio);
>   			if (repl)
>   				r10_bio->devs[slot].repl_bio = IO_MADE_GOOD;
> 

