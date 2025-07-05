Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA922E3704;
	Sat,  5 Jul 2025 09:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751708760; cv=none; b=TwOVT15o5oTkAv5XXLg4WJSSI8IDrxLdMxmXogEVBEuNWbzwHac1ktoMYO9JET7ulf8CMegSqCOVcxviqCiDaBsX6kBrL3tC3Gqnfd9VuNmFs8iMCQCHgoH91W9AxtE2KIZzDRN06u4mJgmaoQ0dx+uYHnPqIrx1gNgT400jO0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751708760; c=relaxed/simple;
	bh=qv2NMxz9OB1JhEvPxPN1iRI+9Zz1qV8M7OIoBAnJYJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YNxtEOckWRd70Gg1S/EuWfv+faemPcXQ2w6A0mfw+Nj2zi0IMqQjAMEf0kHvI7jEyCxfTQ5zZ/nE0SzEa32GjeiEArQ0FMjq2Va7MGQRSyda1feWSrTYktFf+jieVwNmSIznoooVSwQ41Dg4I7C1eS61sr7u3Ww0JHvS23uzXGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bZ5Gp3dHkzYQtqJ;
	Sat,  5 Jul 2025 17:45:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 568F41A083E;
	Sat,  5 Jul 2025 17:45:53 +0800 (CST)
Received: from [10.174.178.72] (unknown [10.174.178.72])
	by APP3 (Coremail) with SMTP id _Ch0CgCHNSNP9GhoMR_iAg--.24882S3;
	Sat, 05 Jul 2025 17:45:53 +0800 (CST)
Message-ID: <e198d33c-7b02-4585-81d4-544911729051@huaweicloud.com>
Date: Sat, 5 Jul 2025 17:45:51 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid1,raid10: strip REQ_NOWAIT from member bios
To: Zheng Qixing <zhengqixing@huaweicloud.com>, song@kernel.org,
 yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com
References: <20250702102341.1969154-1-zhengqixing@huaweicloud.com>
From: Zheng Qixing <zhengqixing@huaweicloud.com>
In-Reply-To: <20250702102341.1969154-1-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCHNSNP9GhoMR_iAg--.24882S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw4ftw4xZFy5ZF45GF15Jwb_yoW8KF1fpw
	srGa4rZ3y5G3y0vF1UtayDuayFqwsFg39FkrWxJ3yfZryavFyDWa1UJ3yrKrn8XFn8ury7
	X3Z0ywsrWFW3WFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkv14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_JF0_
	Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUBVbkUUUUU=
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

Hi,


Add fix tag.


在 2025/7/2 18:23, Zheng Qixing 写道:
> From: Zheng Qixing <zhengqixing@huawei.com>
>
> RAID layers don't implement proper non-blocking semantics for
> REQ_NOWAIT, making the flag potentially misleading when propagated
> to member disks.
>
> This patch clear REQ_NOWAIT from cloned bios in raid1/raid10. Retain
> original bio's REQ_NOWAIT flag for upper layer error handling.
>
> Maybe we can implement non-blocking I/O handling mechanisms within
> RAID in future work.


Fixes: 9f346f7d4ea7 ("md/raid1,raid10: don't handle IO error for 
REQ_RAHEAD and REQ_NOWAIT")


> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> ---
>   drivers/md/raid1.c  | 3 ++-
>   drivers/md/raid10.c | 2 ++
>   2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 19c5a0ce5a40..213ad5b7e20b 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1399,7 +1399,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
>   	}
>   	read_bio = bio_alloc_clone(mirror->rdev->bdev, bio, gfp,
>   				   &mddev->bio_set);
> -
> +	read_bio->bi_opf &= ~REQ_NOWAIT;
>   	r1_bio->bios[rdisk] = read_bio;
>   
>   	read_bio->bi_iter.bi_sector = r1_bio->sector +
> @@ -1649,6 +1649,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   				wait_for_serialization(rdev, r1_bio);
>   		}
>   
> +		mbio->bi_opf &= ~REQ_NOWAIT;
>   		r1_bio->bios[i] = mbio;
>   
>   		mbio->bi_iter.bi_sector	= (r1_bio->sector + rdev->data_offset);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index b74780af4c22..951b9b443cd1 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1221,6 +1221,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>   		r10_bio->master_bio = bio;
>   	}
>   	read_bio = bio_alloc_clone(rdev->bdev, bio, gfp, &mddev->bio_set);
> +	read_bio->bi_opf &= ~REQ_NOWAIT;
>   
>   	r10_bio->devs[slot].bio = read_bio;
>   	r10_bio->devs[slot].rdev = rdev;
> @@ -1256,6 +1257,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
>   			     conf->mirrors[devnum].rdev;
>   
>   	mbio = bio_alloc_clone(rdev->bdev, bio, GFP_NOIO, &mddev->bio_set);
> +	mbio->bi_opf &= ~REQ_NOWAIT;
>   	if (replacement)
>   		r10_bio->devs[n_copy].repl_bio = mbio;
>   	else

