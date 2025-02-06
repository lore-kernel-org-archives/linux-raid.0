Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7ED714286
	for <linux-raid@vger.kernel.org>; Thu,  6 Feb 2025 01:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738805726; cv=none; b=oBq4nxDeVwklR4tbbjwRG3k3l550se7iiYx6yAZLswZ3WUbpz3VfVI6UNbtbtNVbmE7xhSy0Zo6KfLJC2seC1V//88XU02lqUTAh6IuLkfKErnf36wJw5LL/G/ffiahQ7vkE4qdE9diAzq5141/g6Lg/u025HA3vY1XdM31T3T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738805726; c=relaxed/simple;
	bh=TONEupetK9a5VrtHCk8cXX4z61yNd5qUkJJlDqsyiNM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=sLGNowX5JtX3+Inz03zqxlegzRbDdcHd9DG14BdBnAv7Vzlk05NOlAGSVE9uD4bneP7K8VAf/RG2Dc5/f0S1TOK8i5xMrRgZTuZJnDCmVelaBQtbOLK9b1ouiymFdIyY88yxJn1tB9uoz52HXhuRGp44csBAwHbbqMKjxGXX24Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YpKR00sDQz4f3jR5
	for <linux-raid@vger.kernel.org>; Thu,  6 Feb 2025 09:34:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 41E831A0DAB
	for <linux-raid@vger.kernel.org>; Thu,  6 Feb 2025 09:35:13 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXu1_PEaRnr_ghDA--.28170S3;
	Thu, 06 Feb 2025 09:35:13 +0800 (CST)
Subject: Re: [PATCH RFC mdadm/master] mdadm: add support for new lockless
 bitmap
To: Mariusz Tkaczyk <mtkaczyk@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250126082714.1588025-1-yukuai1@huaweicloud.com>
 <20250127102547.60a62a4c@mtkaczyk-private-dev>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <79c37ff5-bfb8-51c3-b62b-2fade47478c7@huaweicloud.com>
Date: Thu, 6 Feb 2025 09:35:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250127102547.60a62a4c@mtkaczyk-private-dev>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXu1_PEaRnr_ghDA--.28170S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJry8uw47urWrWFWUtF13urg_yoW8KFWDpF
	4rZFs5Cr1rGrs29FnFqr1kZFWrKr1vqr18AFWqqa4Skrn8XF93Zr1FgF45Z3yfAr1xu34x
	XF4UWa4UW347ZrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUjuHq7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/01/27 17:25, Mariusz Tkaczyk Ð´µÀ:
> On Sun, 26 Jan 2025 16:27:14 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> A new major number 6 is used for the new bitmap.
>>
>> Noted that for the kernel that doesn't support lockless bitmap, create
>> such array will fail:
>>
>> md0: invalid bitmap file superblock: unrecognized superblock version.
> Hi Kuai,
> 
> Please go ahead and create branch on mdadm repo for lockness bitmap
> implementation and keep your changes there. This is for sure not ready
> and cannot be merged yet to main so sending it is not needed.
> 
> What do you think?

Yes, of course, this is just an early RFC version, I'm sending this
for people if they want to test.

I think fork a mdadm repo in my git tree is enough for now. :)

BTW, I still need to send a patch at company before I apply the patch
at home. I can't access my git tree at company, and our company policy
only allow me to send patch to open source community. :( Things will be
easier later after I apply a laptop and skip company's network.

Thanks,
Kuai

>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   Create.c | 5 ++++-
>>   Grow.c   | 3 ++-
>>   bitmap.h | 1 +
>>   mdadm.c  | 9 ++++++++-
>>   mdadm.h  | 1 +
>>   super1.c | 9 +++++++++
>>   6 files changed, 25 insertions(+), 3 deletions(-)
>>
>> diff --git a/Create.c b/Create.c
>> index fd6c9215..105d15e0 100644
>> --- a/Create.c
>> +++ b/Create.c
>> @@ -541,6 +541,8 @@ int Create(struct supertype *st, struct
>> mddev_ident *ident, int subdevs, pr_err("At least 2 nodes are needed
>> for cluster-md\n"); return 1;
>>   		}
>> +	} else if (s->btype == BitmapLockless) {
>> +		major_num = BITMAP_MAJOR_LOCKLESS;
>>   	}
>>   
>>   	memset(&info, 0, sizeof(info));
>> @@ -1182,7 +1184,8 @@ int Create(struct supertype *st, struct
>> mddev_ident *ident, int subdevs,
>>   	 * to stop another mdadm from finding and using those
>> devices. */
>>   
>> -	if (s->btype == BitmapInternal || s->btype == BitmapCluster)
>> {
>> +	if (s->btype == BitmapInternal || s->btype == BitmapCluster
>> ||
>> +	    s->btype == BitmapLockless) {
> 
> This is asking to be moved to common helper function. Is is repeated 3
> times at least so please consider (not sure about naming):
> 
> bool is_bitmap_supported(int btype) {
> 	if (btype == BitmapInternal || btype == BitmapCluster ||
> 	    btype == BitmapLockless)
> 		return true;
> 	return false;
> }
> Just a nit.
> .
> 

