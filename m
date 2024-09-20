Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0682055887;
	Fri, 20 Sep 2024 06:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726815496; cv=none; b=EM2mjGKNRgXNv/s/yQrT3ChrOkuNosD2MsdLusJFzx45zWsvris7bpb0TxUactlJjPGrgOTpCaQvk6OShK84YzS5/ZLexhTB04PxihZXn2g2K6gXvaRpPRapOTKf0OYEzsZkhcgYiSTqnNWHIeGqepOVwhXkZzf12h2uXf+q2/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726815496; c=relaxed/simple;
	bh=IIvsMXaLeg0qRAVTfpic+BSoaYnupJy0Fsa5vsxOLe0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=CPq1HwXUR7Wz4EZRmm1JLQzgRQI8l5Wryjkn1kHnHP0zdsRTIEVz1/TlnO60GOMTolDV5o/Tec/xwHIQGu0J2qUQX11Hgxk0obmdEVGKscIeZfoy68PlVxlAu6G9Xl8/N5ZCz4VsKPySENgqUkhXWhU4sYTMgEPmJrfOK0U/r8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4X939s4KSrz4f3kw0;
	Fri, 20 Sep 2024 14:57:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 498711A08DC;
	Fri, 20 Sep 2024 14:58:10 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCn28cAHe1ma5lVBw--.14598S3;
	Fri, 20 Sep 2024 14:58:10 +0800 (CST)
Subject: Re: [PATCH RFC 5/6] md/raid1: Handle bio_split() errors
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 "yukuai (C)" <yukuai3@huawei.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
 <20240919092302.3094725-6-john.g.garry@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <bc4c414c-a7aa-358b-71c1-598af05f005f@huaweicloud.com>
Date: Fri, 20 Sep 2024 14:58:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240919092302.3094725-6-john.g.garry@oracle.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCn28cAHe1ma5lVBw--.14598S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw13Jr45KryUJF13Aw1fJFb_yoW8JFWrpr
	4UWa4avrW5JFW7KwsxJay29F95ZF10qFyUArWxuw4kArnFqa9rKa1UXr18W3s8ury7G34U
	Awn5Ganxu3ZFyFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AK
	xVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU17KsU
	UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/09/19 17:23, John Garry Ð´µÀ:
> Add proper bio_split() error handling. For any error, call
> raid_end_bio_io() and return;
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/md/raid1.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 6c9d24203f39..c561e2d185e2 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1383,6 +1383,10 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
>   	if (max_sectors < bio_sectors(bio)) {
>   		struct bio *split = bio_split(bio, max_sectors,
>   					      gfp, &conf->bio_split);
> +		if (IS_ERR(split)) {
> +			raid_end_bio_io(r1_bio);
> +			return;
> +		}

This way, BLK_STS_IOERR will always be returned, perhaps what you want
is to return the error code from bio_split()?

Thanks,
Kuai

>   		bio_chain(split, bio);
>   		submit_bio_noacct(bio);
>   		bio = split;
> @@ -1576,6 +1580,10 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   	if (max_sectors < bio_sectors(bio)) {
>   		struct bio *split = bio_split(bio, max_sectors,
>   					      GFP_NOIO, &conf->bio_split);
> +		if (IS_ERR(split)) {
> +			raid_end_bio_io(r1_bio);
> +			return;
> +		}
>   		bio_chain(split, bio);
>   		submit_bio_noacct(bio);
>   		bio = split;
> 

