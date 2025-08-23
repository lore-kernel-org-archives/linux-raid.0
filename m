Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A301E9B3A;
	Sat, 23 Aug 2025 01:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755914059; cv=none; b=Yp6U4hlzKaXRovhDP2g3cYG91SnyliL5WwTGzmLHFlk2rOGhrxsEqJ871TikRoflMVT/mJvPJ7cIyvmgCsuG5ktx/ySTo017c6p/0CTK2NbRFGFRfH5cLzcKcHHmmN5nNWtG09HX//bXjDmjXZpmG28/gLGU45F3ea3c/UvebEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755914059; c=relaxed/simple;
	bh=DgTo2BZfWzgSjCLXwCnWeSheHL00fFzbA5pcQ7qaLMo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BkoBFVwUWDXO5JEFj+iAhOmTSI9NqFXKNmWFMly+FJd+1KBknCexadxFRLthj3zCxQL51UKOIsfXg88/8U5xzuLE3q8gI4RmAHlTerYph4F2okORi/tLmW/NI1Ha/OC1NoxOWgvyhnHS/kWagHPePwXsC5FhfY58KODZt+Y+PyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c80Ty2Q0fzKHMXN;
	Sat, 23 Aug 2025 09:54:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D6A591A142F;
	Sat, 23 Aug 2025 09:54:13 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgBn4hJDH6loiZ1xEg--.61271S3;
	Sat, 23 Aug 2025 09:54:13 +0800 (CST)
Message-ID: <725043ad-2d50-be78-7cc3-8c565ab364e0@huaweicloud.com>
Date: Sat, 23 Aug 2025 09:54:11 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 1/3] md/raid1,raid10: don't broken array on failfast
 metadata write fails
To: Kenta Akagi <k@mgml.me>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
 Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250817172710.4892-1-k@mgml.me>
 <20250817172710.4892-2-k@mgml.me>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20250817172710.4892-2-k@mgml.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBn4hJDH6loiZ1xEg--.61271S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGr1xuF4DJFykKF47Jr45GFg_yoW5Aw15pF
	ZrAayDCrWqq34Dt3WUAFyxWa909r4FkrZxK34fC347urn8Wr1xKFs0ga4jqryqy34fuw1U
	Xa98Z3y7AFyjgwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU90b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIda
	VFxhVjvjDU0xZFpf9x07UMnQUUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/8/18 1:27, Kenta Akagi 写道:
> A super_write IO failure with MD_FAILFAST must not cause the array
> to fail.
> 
> Because a failfast bio may fail even when the rdev is not broken,
> so IO must be retried rather than failing the array when a metadata
> write with MD_FAILFAST fails on the last rdev.
> 
> A metadata write with MD_FAILFAST is retried after failure as
> follows:
> 
> 1. In super_written, MD_SB_NEED_REWRITE is set in sb_flags.
> 
> 2. In md_super_wait, which is called by the function that
> executed md_super_write and waits for completion,
> -EAGAIN is returned because MD_SB_NEED_REWRITE is set.
> 
> 3. The caller of md_super_wait (such as md_update_sb)
> receives a negative return value and then retries md_super_write.
> 
> 4. The md_super_write function, which is called to perform
> the same metadata write, issues a write bio without MD_FAILFAST
> this time.
> 
> When a write from super_written without MD_FAILFAST fails,
> the array may broken, and MD_BROKEN should be set.
> 
> After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
> calling md_error on the last rdev in RAID1/10 always sets
> the MD_BROKEN flag on the array.
> As a result, when failfast IO fails on the last rdev, the array
> immediately becomes failed.
> 
> This commit prevents MD_BROKEN from being set when a super_write with
> MD_FAILFAST fails on the last rdev, ensuring that the array does
> not become failed due to failfast IO failures.
> 
> Failfast IO failures on any rdev except the last one are not retried
> and are marked as Faulty immediately. This minimizes array IO latency
> when an rdev fails.
> 
> Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
> Signed-off-by: Kenta Akagi <k@mgml.me>


[...]

> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1746,8 +1746,12 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
>    *	- recovery is interrupted.
>    *	- &mddev->degraded is bumped.
>    *
> - * @rdev is marked as &Faulty excluding case when array is failed and
> - * &mddev->fail_last_dev is off.
> + * If @rdev is marked with &FailfastIOFailure, it means that super_write
> + * failed in failfast and will be retried, so the @mddev did not fail.
> + *
> + * @rdev is marked as &Faulty excluding any cases:
> + *	- when @mddev is failed and &mddev->fail_last_dev is off
> + *	- when @rdev is last device and &FailfastIOFailure flag is set
>    */
>   static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>   {
> @@ -1758,6 +1762,10 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>   
>   	if (test_bit(In_sync, &rdev->flags) &&
>   	    (conf->raid_disks - mddev->degraded) == 1) {
> +		if (test_bit(FailfastIOFailure, &rdev->flags)) {
> +			spin_unlock_irqrestore(&conf->device_lock, flags);
> +			return;
> +		}
>   		set_bit(MD_BROKEN, &mddev->flags);
>   
>   		if (!mddev->fail_last_dev) {

At this point, users who try to fail this rdev will get a successful return
without Faulty flag. Should we consider it?

-- 
Thanks,
Nan

