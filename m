Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3A01369B4;
	Wed, 13 Aug 2025 00:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755046749; cv=none; b=YbQNH4qtn5ulLyP5kt2CM2cdxUO6fvRaXGn/XmInu6mGDipRJMlxAcf4sYdBkyLBbIs/x8bQ+6QgFXIiWC+uVG4V92WcKDpMi6f6AfovvOwKDAGIcglbO1Drd0OCW8AH4jBlo6W73Z2si1ihUpkkBDUUKX4Y4uFPUxqH4fAYQhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755046749; c=relaxed/simple;
	bh=KgbJjZqy3+Qc0ujKU4H4F688rCeeSnX8mFHbg43gxQ8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=uZOHnXyw6d9csUpn1jeQT570U2pgxT0XzT6o4Pq0ddL63tmdcV00C+eHeOK//FRKt3ZA7jzoHB9QzcyBsbg8qMf0utWeSPO7nlPeUbO+vyJfMuQqplXdYNSDFNRZCRG0nwFa6m3QGouLJb8dOMXOqMOb6F0PIfmE9/X19+YrLL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c1qky1xLVzYQv5L;
	Wed, 13 Aug 2025 08:59:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DADA91A0E99;
	Wed, 13 Aug 2025 08:59:04 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB3QBFX45toebz4DQ--.25375S3;
	Wed, 13 Aug 2025 08:59:04 +0800 (CST)
Subject: Re: [PATCH] md/raid1,raid10: don't broken array on failfast metadata
 write fails
To: Kenta Akagi <k@mgml.me>, Song Liu <song@kernel.org>,
 Mariusz Tkaczyk <mtkaczyk@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250812090119.153697-1-k@mgml.me>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <36f78ba0-ac3b-5d97-89f3-2b09d49d1701@huaweicloud.com>
Date: Wed, 13 Aug 2025 08:59:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250812090119.153697-1-k@mgml.me>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3QBFX45toebz4DQ--.25375S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw4rCF45KrWxGFW3AF4DXFb_yoW8tw4Upa
	yIqFW5Cr90yr42y3W7ua48Way5W3W7trWUKrW3A3s7ZFy3Jry0gr4DKFyDKFyq9Fyfuw4D
	tr15tas8Wayvqw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2N
	tUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/08/12 17:01, Kenta Akagi Ð´µÀ:
> It is not intended for the array to fail when a metadata write with
> MD_FAILFAST fails.
> After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
> when md_error is called on the last device in RAID1/10,
> the MD_BROKEN flag is set on the array.
> Because of this, a failfast metadata write failure will
> make the array "broken" state.
> 
> If rdev is not Faulty even after calling md_error,
> the rdev is the last device, and there is nothing except
> MD_BROKEN that prevents writes to the array.
> Therefore, by clearing MD_BROKEN, the array will not become
> "broken" after a failfast metadata write failure.

I don't understand here, I think MD_BROKEN is expected, the last
rdev has IO error while updating metadata, the array is now broken
and you can only read it afterwards. Allow using this broken array
read-write might causing more severe problem like data loss.

Thanks,
Kuai

> 
> Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
> Signed-off-by: Kenta Akagi <k@mgml.me>
> ---
>   drivers/md/md.c | 1 +
>   drivers/md/md.h | 2 +-
>   2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ac85ec73a409..3ec4abf02fa0 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1002,6 +1002,7 @@ static void super_written(struct bio *bio)
>   		md_error(mddev, rdev);
>   		if (!test_bit(Faulty, &rdev->flags)
>   		    && (bio->bi_opf & MD_FAILFAST)) {
> +			clear_bit(MD_BROKEN, &mddev->flags);
>   			set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
>   			set_bit(LastDev, &rdev->flags);
>   		}
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 51af29a03079..2f87bcc5d834 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -332,7 +332,7 @@ struct md_cluster_operations;
>    *			       resync lock, need to release the lock.
>    * @MD_FAILFAST_SUPPORTED: Using MD_FAILFAST on metadata writes is supported as
>    *			    calls to md_error() will never cause the array to
> - *			    become failed.
> + *			    become failed while fail_last_dev is not set.
>    * @MD_HAS_PPL:  The raid array has PPL feature set.
>    * @MD_HAS_MULTIPLE_PPLS: The raid array has multiple PPLs feature set.
>    * @MD_NOT_READY: do_md_run() is active, so 'array_state', ust not report that
> 

