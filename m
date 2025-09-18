Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D182E41E;
	Thu, 18 Sep 2025 07:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758181144; cv=none; b=sBJe1LPb9b5vWR/3pbZR4jQK24U0AwSonRs6hENDV/VZLEeI4vZB5pOTZp4gJolGAklzVi/IJsevxT2xqr8NCsN06WuPE4Y0sJOo6opDzCV4+qVPz8qQOgk3JnxzFvDnr+CukoxjFl6WJRa0a1lgUPFH9znJnVOXK5SSMJEtXPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758181144; c=relaxed/simple;
	bh=949zSqbVjOVom2XPQbpIAe7xvLbSvxROVyQvBnVyfDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UhXvPQ+KN1P7h/13xfkFxEaUSSDVMLX9fxJzV+7Kd72cX9CGxf76OAz1ugGUcG90uN4FlK1KjuJhx4XJ9rJeRyuZo3Vw73w0uoooqBFvkCZhlCi7gIrJ9JXCQ9lobt1u6N13oSg7F7qM2qwlbKUgxHN9AYEYWRBHf+lXONr0F4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cS6vm1ZwdzYQvTY;
	Thu, 18 Sep 2025 15:39:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D16881A01A5;
	Thu, 18 Sep 2025 15:38:58 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgB3wY0Rt8toS7CdCw--.6401S3;
	Thu, 18 Sep 2025 15:38:58 +0800 (CST)
Message-ID: <e7031446-88be-cd4d-ca00-7ce95da5f55a@huaweicloud.com>
Date: Thu, 18 Sep 2025 15:38:57 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 7/9] md/raid10: fix failfast read error not rescheduled
To: Kenta Akagi <k@mgml.me>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
 Shaohua Li <shli@fb.com>, Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250915034210.8533-1-k@mgml.me>
 <20250915034210.8533-8-k@mgml.me>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20250915034210.8533-8-k@mgml.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3wY0Rt8toS7CdCw--.6401S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr4Dur18Xr18tw48GF1Dtrb_yoW8Ww15p3
	ykAFy3uryUC34UA3ZrWryUZFyFkwsxta43ZrW8K34xXa43ZFZakFWUG34a9rWqva15u3W7
	ZF45Jw4DGa1jyFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Yb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjxUwGQDUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/9/15 11:42, Kenta Akagi 写道:
> raid10_end_read_request lacks a path to retry when a FailFast IO fails.
> As a result, when Failfast Read IOs fail on all rdevs, the upper layer
> receives EIO, without read rescheduled.
> 
> Looking at the two commits below, it seems only raid10_end_read_request
> lacks the failfast read retry handling, while raid1_end_read_request has
> it. In RAID1, the retry works as expected.
> * commit 8d3ca83dcf9c ("md/raid10: add failfast handling for reads.")
> * commit 2e52d449bcec ("md/raid1: add failfast handling for reads.")
> 
> I don't know why raid10_end_read_request lacks this, but it is probably
> just a simple oversight.

Agreed, these two lines can be removed.

Other than that, LGTM.

Reviewed-by: Li Nan <linan122@huawei.com>

> 
> This commit will make the failfast read bio for the last rdev in raid10
> retry if it fails.
> 
> Fixes: 8d3ca83dcf9c ("md/raid10: add failfast handling for reads.")
> Signed-off-by: Kenta Akagi <k@mgml.me>
> ---
>   drivers/md/raid10.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 92cf3047dce6..86c0eacd37cb 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -399,6 +399,11 @@ static void raid10_end_read_request(struct bio *bio)
>   		 * wait for the 'master' bio.
>   		 */
>   		set_bit(R10BIO_Uptodate, &r10_bio->state);
> +	} else if (test_bit(FailFast, &rdev->flags) &&
> +		 test_bit(R10BIO_FailFast, &r10_bio->state)) {
> +		/* This was a fail-fast read so we definitely
> +		 * want to retry */
> +		;
>   	} else if (!raid1_should_handle_error(bio)) {
>   		uptodate = 1;
>   	} else {

-- 
Thanks,
Nan

