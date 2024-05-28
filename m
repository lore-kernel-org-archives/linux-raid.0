Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DC814F70;
	Tue, 28 May 2024 02:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716861986; cv=none; b=es2S4O9RPOthdvD9KTaD+K2zP9ckg4e9FnzA8EWkYE5RwUakfgL3pKIkwQQuNT5udtx3Ag9xloDnSAx6SCi4qBmW7HHsXQqHrRvZldVm0k0db8NT3XEtkP5P37wYUOOu8t0aM2dApNOgsjjr1UCpnz+WjkoxP1nCFQI4jy52A9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716861986; c=relaxed/simple;
	bh=qFQYLqRvYr8xduvDIUWv7wCWp0h5jU7YoMZ7xFOLKo4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U5FkZIKLFw+1XPkiG+4m2YLL9pN/UP0MVvyEYidwc7RqxWThz3Shw/jPZ75m0Iiksaq6Wbg1yJxrJfRiWoelq05U0EedTg0HPdmc0Jtttax+hDGLDGVos5mIfYg0WaZvZNrIVRdg5sPFwAyRFAGe8iC4zc+mJj7gu1y/0KL7yK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VpG8Q4gDDz4f3jYh;
	Tue, 28 May 2024 10:06:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id A1AAC1A0572;
	Tue, 28 May 2024 10:06:20 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP2 (Coremail) with SMTP id Syh0CgDnCw8YPFVmUdjgOA--.60087S3;
	Tue, 28 May 2024 10:06:20 +0800 (CST)
Message-ID: <143ec153-fe71-7a03-a10a-589ecd63eb71@huaweicloud.com>
Date: Tue, 28 May 2024 10:06:16 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md: make md_flush_request() more readable
To: Christoph Hellwig <hch@infradead.org>
Cc: song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
 houtao1@huawei.com, yangerkun@huawei.com
References: <20240525185622.3896616-1-linan666@huaweicloud.com>
 <ZlL4rxKqcV5ePLXu@infradead.org>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <ZlL4rxKqcV5ePLXu@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgDnCw8YPFVmUdjgOA--.60087S3
X-Coremail-Antispam: 1UD129KBjvdXoWrur48tF47JF1Uuw18uF15Jwb_yoWDCFgEga
	92q34DGrsrt397Gr1UAw4kK395JaykA3WDWFZ8Kay7ZFy5A348trWrWws5Aa17Ja93GF48
	KrWjg3y7WrW3KjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxxYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67
	AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07Al
	zVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUFf
	HjUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2024/5/26 16:54, Christoph Hellwig 写道:
> On Sun, May 26, 2024 at 02:56:22AM +0800, linan666@huaweicloud.com wrote:
>> -		bio = NULL;
>> -	}
>> -	spin_unlock_irq(&mddev->lock);
>> -
>> -	if (!bio) {
>> +		spin_unlock_irq(&mddev->lock);
>>   		INIT_WORK(&mddev->flush_work, submit_flushes);
>>   		queue_work(md_wq, &mddev->flush_work);
>>   	} else {
>>   		/* flush was performed for some other bio while we waited. */
>> +		spin_unlock_irq(&mddev->lock);
>>   		if (bio->bi_iter.bi_size == 0)
>>   			/* an empty barrier - all done */
> 
> This stil looks like a somwwhat odd flow  Why not go all the way
> and turn it into:
> 
> 
> 	...
> 		queue_work(md_wq, &mddev->flush_work);
> 		return true;
> 	}
> 
> 	/* flush was performed for some other bio while we waited. */
> 	spin_unlock_irq(&mddev->lock);
> 	if (bio->bi_iter.bi_size == 0) {
> 		/* pure flush without data - all done */
> 		bio_endio(bio);
> 		return true;
> 	}
> 	bio->bi_opf &= ~REQ_PREFLUSH;
> 	return false;
> }

Yeah, it looks better. I will changed it in v2.

Thansk for your suggestion.

-- 
Thanks,
Nan

