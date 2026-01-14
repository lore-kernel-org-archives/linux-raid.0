Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40E1173;
	Wed, 14 Jan 2026 03:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768360321; cv=none; b=cUhAIYXT5I5y1Tl9dzNteLUISzFw396uYH7FqoWSgluK4LQySLRqT52mK+a81WRGDmVADdJmQMLoWy8shZP73kA6xYtxTCMdMYYHJNFoNroOmDVDxEc46OlR8u5T2HvmiJZzWhVBq4+Cikp5yf+MarK+CAdUkWTnaAiB494CrOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768360321; c=relaxed/simple;
	bh=zxNTIZXRwTirMRjRBpeJw0E+IwmCEPx5xrXbjRVq+KA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JnOh/CsSkkGW002MWErBkHUk5c+1Gt1Gc66PLzCFoACPKcKadR9IDaAPvslnxdGJVn1s7+l/bUEfP8VqZ7I+2ZXW2QMr2RY+tCuJvZ8HabENWZ4JEZeKNIDtWbrYhWmb0zEAgqVfeRs5LHZHleEy4hVmJ/bf3DbyaC+IJQDbOjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4drWN737MNzKHLyZ;
	Wed, 14 Jan 2026 11:11:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D9E7540591;
	Wed, 14 Jan 2026 11:11:54 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgAHaPh5CWdpXpntDg--.52245S3;
	Wed, 14 Jan 2026 11:11:54 +0800 (CST)
Message-ID: <434dd5ec-1cd9-4893-feb6-7936a0e82749@huaweicloud.com>
Date: Wed, 14 Jan 2026 11:11:53 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC PATCH 5/5] md/raid1: introduce rectify action to repair
 badblocks
To: Zheng Qixing <zhengqixing@huaweicloud.com>, song@kernel.org,
 yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 zhengqixing@huawei.com, linan122@h-partners.com
References: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
 <20251231070952.1233903-6-zhengqixing@huaweicloud.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20251231070952.1233903-6-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHaPh5CWdpXpntDg--.52245S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCFyUXr1DZrW3Cw45AFyUtrb_yoW5Grykpa
	y7GF93CrZ8WFy5uFn8KFyUG393Kw15GF47Z3y8Gw13twn0kr95Ka18Wry5Gr98Cr1UWrW7
	Z3Z5GwsrG3y2yFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7
	AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VU122
	NtUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/12/31 15:09, Zheng Qixing 写道:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> Add support for repairing known badblocks in RAID1. When disks
> have known badblocks (shown in sysfs bad_blocks), data can be
> read from other healthy disks in the array and written to repair
> the badblock areas and clear it in bad_blocks.
> 
> echo rectify > sync_action can trigger this action.
> 
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>

> +static void end_rectify_read(struct bio *bio)
> +{
> +	struct r1bio *r1_bio = get_resync_r1bio(bio);
> +	struct r1conf *conf = r1_bio->mddev->private;
> +	struct md_rdev *rdev;
> +	struct bio *next_bio;
> +	bool all_fail = true;
> +	int i;
> +
> +	update_head_pos(r1_bio->read_disk, r1_bio);
> +
> +	if (!bio->bi_status) {
> +		set_bit(R1BIO_Uptodate, &r1_bio->state);
> +		goto out;
> +	}
> +
> +	for (i = r1_bio->read_disk + 1; i < conf->raid_disks; i++) {
> +		rdev = conf->mirrors[i].rdev;
> +		if (!rdev || test_bit(Faulty, &rdev->flags))
> +			continue;
> +
> +		next_bio = r1_bio->bios[i];
> +		if (next_bio->bi_end_io == end_rectify_read) {
> +			next_bio->bi_opf &= ~MD_FAILFAST;

Why set MD_FAILFAST and clear it soon?
And submit_rectify_read() will clear it again.

> +static void rectify_request_write(struct mddev *mddev, struct r1bio *r1_bio)
> +{
> +	struct r1conf *conf = mddev->private;
> +	struct bio *wbio = NULL;
> +	int wcnt = 0;
> +	int i;
> +
> +	if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
> +		submit_rectify_read(r1_bio);
> +		return;
> +	}
> +
> +	atomic_set(&r1_bio->remaining, 0);
> +	for (i = 0; i < conf->raid_disks; i++) {
> +		wbio = r1_bio->bios[i];
> +		if (wbio->bi_end_io == end_rectify_write) {
> +			atomic_inc(&r1_bio->remaining);
> +			wcnt++;
> +			submit_bio_noacct(wbio);
> +		}
> +	}
> +
> +	if (unlikely(!wcnt)) {
> +		md_done_sync(r1_bio->mddev, r1_bio->sectors);
> +		put_buf(r1_bio);
> +	}

How can 'wcnt' be 0?

> +}
> +
> +static void handle_rectify_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
> +{
> +	struct md_rdev *rdev;
> +	struct bio *bio;
> +	int i;
> +
> +	for (i = 0; i < conf->raid_disks; i++) {
> +		rdev = conf->mirrors[i].rdev;
> +		bio = r1_bio->bios[i];
> +		if (bio->bi_end_io == NULL)
> +			continue;
> +
> +		if (!bio->bi_status && bio->bi_end_io == end_rectify_write &&
> +		    test_bit(R1BIO_MadeGood, &r1_bio->state)) {
> +			rdev_clear_badblocks(rdev, r1_bio->sector,
> +					     r1_bio->sectors, 0);
> +		}

Reuse handle_sync_write_finished() seems better.

> +	}
> +
> +	md_done_sync(r1_bio->mddev, r1_bio->sectors);
> +	put_buf(r1_bio);
> +}
> +

-- 
Thanks,
Nan

