Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0066D311583;
	Thu, 16 Apr 2026 06:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776322031; cv=none; b=FisCRudIIgjHA+YqbPrrocNsu9d/pbm9ppiiw7uaPD0718lxUGO6qeKG8XWYLqmsN53eGvkKVUJxOz6dwgdJaUENrL2+9NgZjLA+p2U7g2yNzIJs60IPys9no52DYCdTgBW5bgIZkou5QYaASGUPNpQ0kmZKEqP+B+eJpIkTS8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776322031; c=relaxed/simple;
	bh=taOsdaefx/FsQrpBqMCLvmTKz933grn53Ja5MDLfrv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nYYjyzztmP4ZvC8qJ9v3RaLq4HX5Yxz73ZkP3eMzYwS5j4XGXSWK8/s2LWcz5yAnFrdFiKoA3FhCc66pCxPO2vXDrYws0rVMO5p1+tndzXImydqfVA1KK45NspyNHI3XuMYKnSCMPf74UQ3IqNJd+asx07t9o6DJ1zUVwZtRDLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fx7p31qVBzYQtjf;
	Thu, 16 Apr 2026 14:46:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 8C72A40573;
	Thu, 16 Apr 2026 14:47:06 +0800 (CST)
Received: from [10.174.178.255] (unknown [10.174.178.255])
	by APP3 (Coremail) with SMTP id _Ch0CgB3JL7nheBpNLhYAg--.945S3;
	Thu, 16 Apr 2026 14:47:04 +0800 (CST)
Message-ID: <7f82e3ae-bb2b-96fc-af9c-632fa6ae07af@huaweicloud.com>
Date: Thu, 16 Apr 2026 14:47:03 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] md: use md_free_cloned_bio() in md_end_clone_io()
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>, song@kernel.org,
 yukuai@fnnas.com, linan666@huaweicloud.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260415081941.352389-1-abd.masalkhi@gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260415081941.352389-1-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgB3JL7nheBpNLhYAg--.945S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CF4rJryrXFy3JryktF18Krg_yoW8Xw43pF
	Z7uFWYyr45JF40gay7Ga1q9F95Xa1qqrW0ya4xJw1rZF9xAF9Y9r4xuasYqFy5GFW7CFZ2
	q3WkWF17W3WUtrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9E14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIF
	xwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI4
	8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
	AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbsYFJUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/4/15 16:19, Abd-Alrhman Masalkhi 写道:
> md_end_clone_io() and md_free_cloned_bio() share identical teardown
> logic. Use md_free_cloned_bio() in md_end_clone_io() for cleanup and
> call bio_endio() afterwards.
> 
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> ---
> Changes in v2:
>   - Reuse md_free_cloned_bio() instead of introducing a new helper
>   - Link to v1: https://lore.kernel.org/linux-raid/20260414103813.307601-1-abd.masalkhi@gmail.com
> ---
>   drivers/md/md.c | 13 +------------
>   1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ac71640ff3a8..8565566a447b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9212,20 +9212,9 @@ static void md_end_clone_io(struct bio *bio)
>   {
>   	struct md_io_clone *md_io_clone = bio->bi_private;
>   	struct bio *orig_bio = md_io_clone->orig_bio;
> -	struct mddev *mddev = md_io_clone->mddev;
> -
> -	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
> -		md_bitmap_end(mddev, md_io_clone);
> -
> -	if (bio->bi_status && !orig_bio->bi_status)
> -		orig_bio->bi_status = bio->bi_status;
> -
> -	if (md_io_clone->start_time)
> -		bio_end_io_acct(orig_bio, md_io_clone->start_time);
>   
> -	bio_put(bio);
> +	md_free_cloned_bio(bio);
>   	bio_endio(orig_bio);

Is it safe to end orig_bio after putting active_io?

> -	percpu_ref_put(&mddev->active_io);
>   }
>   
>   static void md_clone_bio(struct mddev *mddev, struct bio **bio)

-- 
Thanks,
Nan

