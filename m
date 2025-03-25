Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585C325B67C;
	Tue, 25 Mar 2025 13:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742909738; cv=none; b=CTqy4mJivbfNE6OYq1ii9fEbEiPs0u5cN2gYt+kvpMvT1MgUOUXzmlQIObZHTWF4J+WipSG8ZRiBHSRpI/3p4HerGQdjgrty3rrCl0QDrktgHtsqKaBvlpob1Ol+uTR8MewOlUgIWUQkRo0jBCGG0qqU5uA7TuSv3oxSa6E5Ohs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742909738; c=relaxed/simple;
	bh=BPHjMB74A5Bi9+WEFFN/XLrQfBhc3kgTbltg/BK51QE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=EJHta/mKPq6Te5a90i4EV0xdqlt8FFE6rtC5Qx1DDapv7QdMHNc+B3jfuS88U8qRnLVcGTR9k0DOpZb3jDforiwMUuGKRsdnuymTLX4kw7Yvs75rRJHxjDgMLlgYwTHkdzvFsk+Xw0JDzw4RVeY/89VbsPKzQRnsSFJTTiWuPKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZMWBM0G5Kz4f3lgS;
	Tue, 25 Mar 2025 21:35:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6922A1A0841;
	Tue, 25 Mar 2025 21:35:31 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB3218hseJnlbghHg--.50030S3;
	Tue, 25 Mar 2025 21:35:31 +0800 (CST)
Subject: Re: [PATCH] md/raid10: fix missing discard IO accounting
To: Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org, jgq516@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250325015746.3195035-1-yukuai1@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <2ff3047e-3783-9511-e87a-8b406bcdcc31@huaweicloud.com>
Date: Tue, 25 Mar 2025 21:35:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250325015746.3195035-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3218hseJnlbghHg--.50030S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GrWDJw47JF48tFWfZr1rtFb_yoWktrgEgF
	nxWryfCryxtr1Skw1FvF1Ivry29w109FZ7Wry5GFWrXFy5ury0yryj9rWUtr45uF95Zwn8
	Aa1kuF109Fyv9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CEbIxv
	r21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/03/25 9:57, Yu Kuai Ð´µÀ:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> md_account_bio() is not called from raid10_handle_discard(), now that we
> handle bitmap inside md_account_bio(), also fix missing
> bitmap_startwrite for discard.
> 
> Test whole disk discard for 20G raid10:
> 
> Before:
> Device   d/s     dMB/s   drqm/s  %drqm d_await dareq-sz
> md0    48.00     16.00     0.00   0.00    5.42   341.33
> 
> After:
> Device   d/s     dMB/s   drqm/s  %drqm d_await dareq-sz
> md0    68.00  20462.00     0.00   0.00    2.65 308133.65
> 
> Fixes: 528bc2cf2fcc ("md/raid10: enable io accounting")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/raid10.c | 1 +
>   1 file changed, 1 insertion(+)
> 
Applied to md-6.15
Thanks

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 9d8516acf2fd..6ef65b4d1093 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1735,6 +1735,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>   	 * The discard bio returns only first r10bio finishes
>   	 */
>   	if (first_copy) {
> +		md_account_bio(mddev, &bio);
>   		r10_bio->master_bio = bio;
>   		set_bit(R10BIO_Discard, &r10_bio->state);
>   		first_copy = false;
> 

