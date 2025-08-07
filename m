Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3825E2AE68
	for <linux-raid@vger.kernel.org>; Thu,  7 Aug 2025 01:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754530562; cv=none; b=YI7edyzpTFhrwlJV3AByP95JM4eWtz9kdYNYlp5L71v924OojmfhcAJzUh9uTXejLxAhV1H5ydLsZyfo5V1qOFGiHXxPDu+CHFbhm4ZgB+us8jRJ9fTX9N6+/ccGi71UqvGVcVfGQcaAtxAFK0ZGTJMZI5I1hjCs2d82HcB2pQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754530562; c=relaxed/simple;
	bh=DpjgcjJ3ONqYjMZud3cFicrZnbHkShSbj0dXWbMkwLI=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=KGCvyu6X1PQweKnbKlnHLPpUqwvYput4CJImvVXbhyoztCvVPOwlhKLoAhDS5DPZ05DLRdkt4Ih5syMyUjoFGCwIMfzvOXUYTLeY2w2C/XEz27gBJX3atomxfEOZ33pY1FAhHhBHb1/9DXQ/ZLrSdJ4B6aDFGkf8QcukLPKlwiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4by8r23T6zzKHMc0
	for <linux-raid@vger.kernel.org>; Thu,  7 Aug 2025 09:35:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8F2111A018D
	for <linux-raid@vger.kernel.org>; Thu,  7 Aug 2025 09:35:45 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXIBHwApRo08lTCw--.41200S3;
	Thu, 07 Aug 2025 09:35:45 +0800 (CST)
Subject: Re: md: Does the thread entering the wait queue violate the semantics
 of REQ_NOWAIT in raid5_make_request() ?
To: chen cheng <chenchneg33@gmail.com>, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <CAD8sxFLS7A3HLL3diYRU5fHxCUb_y-QJS666k5cPOgQ8wGFDjw@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d1c7de09-7be0-362c-5429-ed09866c8834@huaweicloud.com>
Date: Thu, 7 Aug 2025 09:35:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAD8sxFLS7A3HLL3diYRU5fHxCUb_y-QJS666k5cPOgQ8wGFDjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXIBHwApRo08lTCw--.41200S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtr1Dtr45GrW8Cr45Jw47urg_yoWktrb_Wr
	nFkF1DCw13Xa4kG34avrn5Xrs7Wr15X3WDtFy8tF1xK395Xa17Cr1Sk3s3JrW7Xa43GrZ8
	K3y8XF18X3sY9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbzkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UNvtZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/08/06 21:34, chen cheng 写道:
> static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
> {
>          ...
> 
>          if ((bi->bi_opf & REQ_NOWAIT) &&
>              (conf->reshape_progress != MaxSector) &&
>              get_reshape_loc(mddev, conf, logical_sector) ==
> LOC_INSIDE_RESHAPE) {
>                  bio_wouldblock_error(bi);
>                  if (rw == WRITE)
>                          md_write_end(mddev);
>                  return true;
>          }
> 
>          if (likely(conf->reshape_progress == MaxSector)) {
>                  ...
>          } else {
>                  add_wait_queue(&conf->wait_for_reshape, &wait);
>                  on_wq = true;
>          }
> 
>          ...
> }
> 
> 
> In raid5_make_request(), if a reshape is progressing and the current
> IO request is not within the reshape range and has the REQ_NOWAIT
> flag, does the thread entering the wait queue violate the semantics of
> REQ_NOWAIT?

The mdraid really doesn't support REQ_NOWAIT, for now the flag is just
ignored and I think BLK_FEAT_NOWAIT should be cleared for raid1/10/456.

BTW, support it will require a lot of work, because IO error handling is
too complicated, we don't want to record badblocks for nowait IO
failure, however, if write disk a succeed while write disk b failed,
whatever we do will violate the semantics of nowait.

Thanks,
Kuai

>  
> .
> 

