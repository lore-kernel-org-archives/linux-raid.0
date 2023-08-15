Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF97C001DB
	for <linux-raid@archiver.kernel.org>; Tue, 15 Aug 2023 01:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbjHOBd4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 21:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbjHOBdb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 21:33:31 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFE410D1
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 18:33:29 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RPv112LHsz4f3tP0
        for <linux-raid@vger.kernel.org>; Tue, 15 Aug 2023 09:33:25 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAXp6nl1dpkcs_xAg--.59748S3;
        Tue, 15 Aug 2023 09:33:26 +0800 (CST)
Subject: Re: [PATCH 1/2] md/raid0: Factor out helper for mapping and
 submitting a bio
To:     Jan Kara <jack@suse.cz>, Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20230814091452.9670-1-jack@suse.cz>
 <20230814092720.3931-1-jack@suse.cz>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <15c8b08c-96f3-e862-73e8-e5a25228e87f@huaweicloud.com>
Date:   Tue, 15 Aug 2023 09:33:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230814092720.3931-1-jack@suse.cz>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAXp6nl1dpkcs_xAg--.59748S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGw4DXr45ZF4UWw4fCF4fuFg_yoWrGF48pw
        4ag3ZxZFWrJFW3t3W5Ja4DK3WFyryFqrW7tFW7u34xGrn7urnrKF15Ww1FvF15CFy5Gry3
        Jw1kCrsrCasxKFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
        6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUrNtxDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

ÔÚ 2023/08/14 17:27, Jan Kara Ð´µÀ:
> Factor out helper function for mapping and submitting a bio out of
> raid0_make_request(). We will use it later for submitting both parts of
> a split bio.
> 
LGTM

Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>   drivers/md/raid0.c | 79 +++++++++++++++++++++++-----------------------
>   1 file changed, 40 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index d1ac73fcd852..d3c55f2e9b18 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -557,54 +557,21 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
>   	bio_endio(bio);
>   }
>   
> -static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
> +static void raid0_map_submit_bio(struct mddev *mddev, struct bio *bio)
>   {
>   	struct r0conf *conf = mddev->private;
>   	struct strip_zone *zone;
>   	struct md_rdev *tmp_dev;
> -	sector_t bio_sector;
> -	sector_t sector;
> -	sector_t orig_sector;
> -	unsigned chunk_sects;
> -	unsigned sectors;
> -
> -	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
> -	    && md_flush_request(mddev, bio))
> -		return true;
> -
> -	if (unlikely((bio_op(bio) == REQ_OP_DISCARD))) {
> -		raid0_handle_discard(mddev, bio);
> -		return true;
> -	}
> -
> -	bio_sector = bio->bi_iter.bi_sector;
> -	sector = bio_sector;
> -	chunk_sects = mddev->chunk_sectors;
> -
> -	sectors = chunk_sects -
> -		(likely(is_power_of_2(chunk_sects))
> -		 ? (sector & (chunk_sects-1))
> -		 : sector_div(sector, chunk_sects));
> -
> -	/* Restore due to sector_div */
> -	sector = bio_sector;
> -
> -	if (sectors < bio_sectors(bio)) {
> -		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
> -					      &mddev->bio_set);
> -		bio_chain(split, bio);
> -		submit_bio_noacct(bio);
> -		bio = split;
> -	}
> +	sector_t bio_sector = bio->bi_iter.bi_sector;
> +	sector_t sector = bio_sector;
>   
>   	if (bio->bi_pool != &mddev->bio_set)
>   		md_account_bio(mddev, &bio);
>   
> -	orig_sector = sector;
>   	zone = find_zone(mddev->private, &sector);
>   	switch (conf->layout) {
>   	case RAID0_ORIG_LAYOUT:
> -		tmp_dev = map_sector(mddev, zone, orig_sector, &sector);
> +		tmp_dev = map_sector(mddev, zone, bio_sector, &sector);
>   		break;
>   	case RAID0_ALT_MULTIZONE_LAYOUT:
>   		tmp_dev = map_sector(mddev, zone, sector, &sector);
> @@ -612,13 +579,13 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
>   	default:
>   		WARN(1, "md/raid0:%s: Invalid layout\n", mdname(mddev));
>   		bio_io_error(bio);
> -		return true;
> +		return;
>   	}
>   
>   	if (unlikely(is_rdev_broken(tmp_dev))) {
>   		bio_io_error(bio);
>   		md_error(mddev, tmp_dev);
> -		return true;
> +		return;
>   	}
>   
>   	bio_set_dev(bio, tmp_dev->bdev);
> @@ -630,6 +597,40 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
>   				      bio_sector);
>   	mddev_check_write_zeroes(mddev, bio);
>   	submit_bio_noacct(bio);
> +}
> +
> +static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
> +{
> +	sector_t sector;
> +	unsigned chunk_sects;
> +	unsigned sectors;
> +
> +	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
> +	    && md_flush_request(mddev, bio))
> +		return true;
> +
> +	if (unlikely((bio_op(bio) == REQ_OP_DISCARD))) {
> +		raid0_handle_discard(mddev, bio);
> +		return true;
> +	}
> +
> +	sector = bio->bi_iter.bi_sector;
> +	chunk_sects = mddev->chunk_sectors;
> +
> +	sectors = chunk_sects -
> +		(likely(is_power_of_2(chunk_sects))
> +		 ? (sector & (chunk_sects-1))
> +		 : sector_div(sector, chunk_sects));
> +
> +	if (sectors < bio_sectors(bio)) {
> +		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
> +					      &mddev->bio_set);
> +		bio_chain(split, bio);
> +		submit_bio_noacct(bio);
> +		bio = split;
> +	}
> +
> +	raid0_map_submit_bio(mddev, bio);
>   	return true;
>   }
>   
> 

