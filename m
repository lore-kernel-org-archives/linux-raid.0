Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF4D334C04;
	Thu,  5 Feb 2026 07:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770276197; cv=none; b=sSX6RZ+fFLyNrcHkkSevdPhfK7B9MeId9r64qw+TSaS2T2O9hSm4AUKEg73v2T607LhXzwuRVzLM3QXimvyJXFG6g8Z4YaiEftJlW5U3reEAaieCznSeAgIcSv9X5ogtLfVRqn9VBdLPY1KvUCIB3joqbtnn3b+xEG5TlOGtRsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770276197; c=relaxed/simple;
	bh=HP6lOJ4MUhAJ1BGtY9QAXPWxTSUFNeafa2SmKzpCGQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vFizQsD1Jr8NoHjpK7SA6vcHcnd/BbzSB79B2PXVMAoaRNrp5SwzRZ+316VlXNw0UXdjeg8CefWRoFUap9Vo7GoyES4Q6+lbhyo2fV7tMiFDPp5oEx9owxYfG3yaMlC566nazeMQfWuTmQJHWvYkGP9qhRpiSPj4x+HUZWvMGOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f67wM3S2nzKHMZd;
	Thu,  5 Feb 2026 15:22:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E90FA4058F;
	Thu,  5 Feb 2026 15:23:07 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXxfVZRYRp2llPGQ--.48240S3;
	Thu, 05 Feb 2026 15:23:07 +0800 (CST)
Message-ID: <4b57e9b4-e660-a7df-4655-93c2815ec758@huaweicloud.com>
Date: Thu, 5 Feb 2026 15:23:05 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 03/14] md/raid1: use folio for tmppage
To: yukuai@fnnas.com, linan666@huaweicloud.com, song@kernel.org
Cc: xni@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yangerkun@huawei.com, yi.zhang@huawei.com
References: <20260128075708.2259525-1-linan666@huaweicloud.com>
 <20260128075708.2259525-4-linan666@huaweicloud.com>
 <b19b6eb8-b5c1-4ca2-a80e-f177370085bf@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <b19b6eb8-b5c1-4ca2-a80e-f177370085bf@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXxfVZRYRp2llPGQ--.48240S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAw4fur18GF17ZF4rWry5XFb_yoWrJrWrpa
	n8G3Z0yr4UJr9xAr1DJFWku3WSgw4xKayUCFsrGa4IvFsaqF95Kayjk34j9r1DZFyUJ3W8
	XFW5t39xZF1rtFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9E14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbsYFJUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/2/5 0:45, Yu Kuai 写道:
> Hi,
> 
> 在 2026/1/28 15:56, linan666@huaweicloud.com 写道:
>> From: Li Nan <linan122@huawei.com>
>>
>> Convert tmppage to tmpfolio and use it throughout in raid1.
>>
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> Reviewed-by: Xiao Ni <xni@redhat.com>
>> ---
>>    drivers/md/raid1.h |  2 +-
>>    drivers/md/raid1.c | 18 ++++++++++--------
>>    2 files changed, 11 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
>> index c98d43a7ae99..d480b3a8c2c4 100644
>> --- a/drivers/md/raid1.h
>> +++ b/drivers/md/raid1.h
>> @@ -101,7 +101,7 @@ struct r1conf {
>>    	/* temporary buffer to synchronous IO when attempting to repair
>>    	 * a read error.
>>    	 */
>> -	struct page		*tmppage;
>> +	struct folio		*tmpfolio;
>>    
>>    	/* When taking over an array from a different personality, we store
>>    	 * the new thread here until we fully activate the array.
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 407925951299..43453f1a04f4 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -2417,8 +2417,8 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>>    			      rdev->recovery_offset >= sect + s)) &&
>>    			    rdev_has_badblock(rdev, sect, s) == 0) {
>>    				atomic_inc(&rdev->nr_pending);
>> -				if (sync_page_io(rdev, sect, s<<9,
>> -					 conf->tmppage, REQ_OP_READ, false))
>> +				if (sync_folio_io(rdev, sect, s<<9, 0,
>> +					 conf->tmpfolio, REQ_OP_READ, false))
>>    					success = 1;
>>    				rdev_dec_pending(rdev, mddev);
>>    				if (success)
>> @@ -2447,7 +2447,8 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>>    			    !test_bit(Faulty, &rdev->flags)) {
>>    				atomic_inc(&rdev->nr_pending);
>>    				r1_sync_page_io(rdev, sect, s,
>> -						conf->tmppage, REQ_OP_WRITE);
>> +						folio_page(conf->tmpfolio, 0),
>> +						REQ_OP_WRITE);
>>    				rdev_dec_pending(rdev, mddev);
>>    			}
>>    		}
>> @@ -2461,7 +2462,8 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>>    			    !test_bit(Faulty, &rdev->flags)) {
>>    				atomic_inc(&rdev->nr_pending);
>>    				if (r1_sync_page_io(rdev, sect, s,
>> -						conf->tmppage, REQ_OP_READ)) {
>> +						folio_page(conf->tmpfolio, 0),
>> +						REQ_OP_READ)) {
>>    					atomic_add(s, &rdev->corrected_errors);
>>    					pr_info("md/raid1:%s: read error corrected (%d sectors at %llu on %pg)\n",
>>    						mdname(mddev), s,
>> @@ -3120,8 +3122,8 @@ static struct r1conf *setup_conf(struct mddev *mddev)
>>    	if (!conf->mirrors)
>>    		goto abort;
>>    
>> -	conf->tmppage = alloc_page(GFP_KERNEL);
>> -	if (!conf->tmppage)
>> +	conf->tmpfolio = folio_alloc(GFP_KERNEL, 0);
>> +	if (!conf->tmpfolio)
>>    		goto abort;
>>    
>>    	r1bio_size = offsetof(struct r1bio, bios[mddev->raid_disks * 2]);
>> @@ -3196,7 +3198,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
>>    	if (conf) {
>>    		mempool_destroy(conf->r1bio_pool);
>>    		kfree(conf->mirrors);
>> -		safe_put_page(conf->tmppage);
>> +		folio_put(conf->tmpfolio);
> 
> Is this safe? folio_put() can't be called with NULL.
> 

Yeah, should we introduce safe_put_folio()? Or just check NULL here.

>>    		kfree(conf->nr_pending);
>>    		kfree(conf->nr_waiting);
>>    		kfree(conf->nr_queued);
>> @@ -3310,7 +3312,7 @@ static void raid1_free(struct mddev *mddev, void *priv)
>>    
>>    	mempool_destroy(conf->r1bio_pool);
>>    	kfree(conf->mirrors);
>> -	safe_put_page(conf->tmppage);
>> +	folio_put(conf->tmpfolio);
> 
> Same here.
> 

In raid1_free(), setup_conf() is successful, and conf->tmpfolio must not be
NULL. It is safe.

>>    	kfree(conf->nr_pending);
>>    	kfree(conf->nr_waiting);
>>    	kfree(conf->nr_queued);
> 

-- 
Thanks,
Nan

