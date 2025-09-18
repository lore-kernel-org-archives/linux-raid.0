Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F2A1DDE9;
	Thu, 18 Sep 2025 01:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758157793; cv=none; b=fKgTLWk1tJlahL1DJwiGv5TEds1WO2CmLg05XSF46hVn6CP1AIj5orWpp/sDoxtm3fl341PE90fgorFW1sKtxYU+ltqrS/sBtq2INntfdKfZrI/hkYWzpgnxMLXuhlb9lYhbbzYyvtyT5y9Rxsi7RN3TLm6Y/rQCsz6UdnA5IdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758157793; c=relaxed/simple;
	bh=0jgeHmNmoMPhly98be4XHqrh1ISJjRfZI16iRsEPR2I=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=QWgDo25FdLtuIsA5S12pioQFsTyz6z1RQGp1dvSkTanuLEC1X+XeQYrQBbQd/iXFPSPX+U+zZWEhpmbO2dMY9/xRoj3Ob3wM38vwpIH2pHm4U2xyZFr4Q3OINpEpIoLvqean8f4hUqcXVU9oCvq6aHKlURNXFL9xrGUonSLhJVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cRyGg4krNzYQv7D;
	Thu, 18 Sep 2025 09:09:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4A1211A139C;
	Thu, 18 Sep 2025 09:09:46 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAXYIzZW8toZft+Cw--.47961S3;
	Thu, 18 Sep 2025 09:09:46 +0800 (CST)
Subject: Re: [PATCH v4 3/9] md: introduce md_bio_failure_error()
To: Kenta Akagi <k@mgml.me>, Song Liu <song@kernel.org>,
 Mariusz Tkaczyk <mtkaczyk@kernel.org>, Shaohua Li <shli@fb.com>,
 Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250915034210.8533-1-k@mgml.me>
 <20250915034210.8533-4-k@mgml.me>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <bfe630fa-7668-4a11-6033-20dca0c112f9@huaweicloud.com>
Date: Thu, 18 Sep 2025 09:09:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250915034210.8533-4-k@mgml.me>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXYIzZW8toZft+Cw--.47961S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZryktF45Zw4rWF4fJF4DCFg_yoWrCrWxpa
	yUtasIyrWDZryag3W3ZFyqka4Y9rn3KrWDKry3J347A3sxKrn7GF15Wa1jgr98G3sxu3WU
	Xa15KF4DCFWvgF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUFB
	T5DUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/09/15 11:42, Kenta Akagi Ð´µÀ:
> Add a new helper function md_bio_failure_error().
> It is serialized with md_error() under the same lock and works
> almost the same, but with two differences:
> 
> * Takes the failed bio as an argument
> * If MD_FAILFAST is set in bi_opf and the target rdev is LastDev,
>    it does not mark the rdev faulty
> 
> Failfast bios must not break the array, but in the current implementation
> this can happen. This is because MD_BROKEN was introduced in RAID1/RAID10
> and is set when md_error() is called on an rdev required for mddev
> operation. At the time failfast was introduced, this was not the case.
> 
> Before this commit, md_error() has already been serialized, and
> RAID1/RAID10 mark rdevs that must not be set Faulty by Failfast
> with the LastDev flag.
> 
> The actual change in bio error handling will follow in a later commit.
> 
> Signed-off-by: Kenta Akagi <k@mgml.me>
> ---
>   drivers/md/md.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>   drivers/md/md.h |  4 +++-
>   2 files changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5607578a6db9..65fdd9bae8f4 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8297,6 +8297,48 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
>   }
>   EXPORT_SYMBOL(md_error);
>   
> +/** md_bio_failure_error() - md error handler for MD_FAILFAST bios
> + * @mddev: affected md device.
> + * @rdev: member device to fail.
> + * @bio: bio whose triggered device failure.
> + *
> + * This is almost the same as md_error(). That is, it is serialized at
> + * the same level as md_error, marks the rdev as Faulty, and changes
> + * the mddev status.
> + * However, if all of the following conditions are met, it does nothing.
> + * This is because MD_FAILFAST bios must not stopping the array.
> + *  * RAID1 or RAID10
> + *  * LastDev - if rdev becomes Faulty, mddev will stop
> + *  * The failed bio has MD_FAILFAST set
> + *
> + * Returns: true if _md_error() was called, false if not.
> + */
> +bool md_bio_failure_error(struct mddev *mddev, struct md_rdev *rdev, struct bio *bio)
> +{
> +	bool do_md_error = true;
> +
> +	spin_lock(&mddev->error_handle_lock);
> +	if (mddev->pers) {

With the respect this is only called from IO path, mddev->pers must be
checked already while submitting the bio. You can add a warn here like:

if (WARN_ON_ONCE(!mddev->pers))
	/* return true because we don't want caller to retry */
	return true;
> +		if (mddev->pers->head.id == ID_RAID1 ||
> +		    mddev->pers->head.id == ID_RAID10) {
> +			if (test_bit(LastDev, &rdev->flags) &&
> +			    test_bit(FailFast, &rdev->flags) &&
> +			    bio != NULL && (bio->bi_opf & MD_FAILFAST))
> +				do_md_error = false;
> +		}

As I suggested in patch 1, this can be:
	if (!mddev->pers->lastdev ||
	    !mddev->pers->lastdev(mddev, rdev, bio)) {
		__md_error(mddev, rdev);
		return true;
	}

Thanks,
Kuai

> +	}
> +
> +	if (do_md_error)
> +		_md_error(mddev, rdev);
> +	else
> +		pr_warn_ratelimited("md: %s: %s didn't do anything for %pg\n",
> +			mdname(mddev), __func__, rdev->bdev);
> +
> +	spin_unlock(&mddev->error_handle_lock);
> +	return do_md_error;
> +}
> +EXPORT_SYMBOL(md_bio_failure_error);
> +
>   /* seq_file implementation /proc/mdstat */
>   
>   static void status_unused(struct seq_file *seq)
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 5177cb609e4b..11389ea58431 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -283,7 +283,8 @@ enum flag_bits {
>   				 */
>   	LastDev,		/* This is the last working rdev.
>   				 * so don't use FailFast any more for
> -				 * metadata.
> +				 * metadata and don't Fail rdev
> +				 * when FailFast bio failure.
>   				 */
>   	CollisionCheck,		/*
>   				 * check if there is collision between raid1
> @@ -906,6 +907,7 @@ extern void md_write_end(struct mddev *mddev);
>   extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
>   void _md_error(struct mddev *mddev, struct md_rdev *rdev);
>   extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
> +extern bool md_bio_failure_error(struct mddev *mddev, struct md_rdev *rdev, struct bio *bio);
>   extern void md_finish_reshape(struct mddev *mddev);
>   void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
>   			struct bio *bio, sector_t start, sector_t size);
> 

