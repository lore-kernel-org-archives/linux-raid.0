Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A08D35971;
	Thu, 31 Jul 2025 07:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753945339; cv=none; b=g2Xx2AOtlMilECdAUgWGS6uRV4621NM8RZEZmH2nodrUI1Q0YkSiLU/uue2fYh94fmjaBJlm2SJT5+r2UFrCx4RSrJZaDXALn+E4hYAfq8SwSImIkrv03BbeLAM4Q4ducUFFXOhBGSdaseMbgNicoXYQs16beYZt38GW0lF/wZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753945339; c=relaxed/simple;
	bh=yxe0l18y3O4qidbKd8FYdmHMrYfSbaqAiyFTErZAIZQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=oAbIEldbqiBdG/LvrcL/p9xCe/ZA62bHgG3igJzqW9HsOtsiKrICDeL8RMEY5MRM2UDrLRvm3URfD493MsMgw9bc3gEXBmBMsN+c00DRj7GrjVdpAXa0uIySDg9YDNLW49PGcddx4REoE7QdC2FbZRaMUI/W/YQ1M6y2V/YjXEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bt0Py13RmzYQv9P;
	Thu, 31 Jul 2025 15:02:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CE3901A01A5;
	Thu, 31 Jul 2025 15:02:12 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBn4hLyFIto0alOCA--.62609S3;
	Thu, 31 Jul 2025 15:02:12 +0800 (CST)
Subject: Re: [PATCH v2 2/3] md: allow configuring logical_block_size
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linan666@huaweicloud.com
Cc: song@kernel.org, hare@suse.de, axboe@kernel.dk,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 bvanassche@acm.org, hch@infradead.org, filipe.c.maia@gmail.com,
 yangerkun@huawei.com, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250719083119.1068811-1-linan666@huaweicloud.com>
 <20250719083119.1068811-3-linan666@huaweicloud.com>
 <yq1zfcleyqv.fsf@ca-mkp.ca.oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <177acc30-7f28-547b-225e-167c60434e3f@huaweicloud.com>
Date: Thu, 31 Jul 2025 15:02:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <yq1zfcleyqv.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBn4hLyFIto0alOCA--.62609S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJr17Kr17KF13WryxGr15Jwb_yoW8Xw13pF
	W2qF1rtrsrXF40gws7ZF47Wr1rAan5Cay8GFyfGryUZry2kryxZrnrtry5Xayjqrs3Jw4j
	va98Ar97Gw18W3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/07/31 13:36, Martin K. Petersen Ð´µÀ:
> 
>> Simply restricting larger-LBS disks is inflexible. In some scenarios,
>> only disks with 512 LBS are available currently, but later, disks with
>> 4k LBS may be added to the array.
> 
> Having to have the foresight to preemptively configure a larger logical
> block size at creation time also seems somewhat inflexible :)

I think the main reason we want to do this is that, for example, if user
create array with 512 lbs disks, and later they may want be able to add
new disk with 4k lbs.
> 
> In general I am not a big fan of mixing devices with different
> properties. I have regretted stacking the logical block size on several
> occasions.
> 
> I am also concerned about PI breaking if the logical block size facing
> upwards does not match the actual logical block size of the component
> devices below. In theory it should work with the PI interval exponent
> but it is something that needs to be tested.
> 
> What if the MD device's configured logical block size is larger than the
> physical block size of the underlying devices? Then we'll end up
> reporting a logical block size larger than the physical block size. Ugh.

I think this is not expected, from blk_validate_limits(), if lbs is
larger than pbs, pbs will be set to lbs, which is called from
queue_limits_commit_update().

> 
> Oh, and what about atomics?

Do you mean atomic writes? I didn't check the code yet, however, I think
the atomic_writes stacking code should notice if the high level lbs is
conflict with atomic_writes limits.

Thanks,
Kuai

> 

