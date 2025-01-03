Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7344E8F66
	for <linux-raid@vger.kernel.org>; Fri,  3 Jan 2025 01:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735866879; cv=none; b=csbvju/TMEycxjAT918B1KnnUflhDLhwIw/t1RC8SfKdo8QYa4/NlCCtduBTYW5GabxxKk4rVoBQEPgT/uB0XBYdKvaOKu3BZ2R7Lu0dk6mXdck5bdzDf0Z1NGLsLiQOURowJdtMaSyoKtRZAT0qJaj96ReZ/tl922DmVeQ/iEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735866879; c=relaxed/simple;
	bh=2NKKjZIYuHBK8Nkg/aGeu+8c2f8sXfJYm3cHK0eeILA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=R5pU1OS+gYobIBPckm+6SQ9ZN43xwkzfEiJxSJ1buM/qT559/eHYST6turmYMWGCF+OPB4HuvQG9h6le1YyG+y4sMkjSdsAvBeIV2rHUY6pT1k2IHshqmgBdwIlXJ+BxeN/1UfBnbHjhyczLF0z3xP+enkRslnbYnRogr7IIi5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YPQZr0v6lz4f3jMf
	for <linux-raid@vger.kernel.org>; Fri,  3 Jan 2025 09:14:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 20F351A08B8
	for <linux-raid@vger.kernel.org>; Fri,  3 Jan 2025 09:14:32 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgAHMYX2OXdnCi2OGQ--.37034S3;
	Fri, 03 Jan 2025 09:14:32 +0800 (CST)
Subject: Re: [PATCH] Export MDRAID bitmap on disk structure in UAPI header
 file
To: Tomas Mudrunka <tomas.mudrunka@gmail.com>, yukuai1@huaweicloud.com
Cc: linux-raid@vger.kernel.org, mtkaczyk@kernel.org, song@kernel.org,
 yukuai@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <b541044b-7550-313d-4252-1a13068c2fd7@huaweicloud.com>
 <20250102114844.633313-1-tomas.mudrunka@gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <65347b89-a7ef-927f-c6e7-0a1a08971248@huaweicloud.com>
Date: Fri, 3 Jan 2025 09:14:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250102114844.633313-1-tomas.mudrunka@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHMYX2OXdnCi2OGQ--.37034S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tr4kAFy5tr1xZF4DKw45ZFb_yoW8ArWUpa
	y2gryYkr4kJr4xuws7Ww4xuayfK3W8W3y5Jr13t3y3Zr4Ygrn29F4a9rWFvFWI9FWFgry2
	qFnrJryjgFs0qFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/01/02 19:48, Tomas Mudrunka Ð´µÀ:
>> Just curious, what you guys do for filesystems like ext4/xfs, and
>> they just define the same structure in user-space tools.
>>
>> looks like your tool do support to create ext4 images, and it's using
>> ext4's use-space tools directly. If it's true, do you consider to use
>> mdadm directly?
>>
>> Thanks,
>> Kuai
> 
> Yes, we do use external tools when possible. It is not possible with mdadm.
> Mdadm cannot create disk image of MD RAID array. Kernel does this.

I'm a bit confused here, if you mean metadata, I think it's mdadm that
write init metadata to disk, the only exception is dm-raid.

> We want/need purely userspace generator, so we don't have to care about
> permissions, losetup, kernel-side mdraid runtime, etc... We just want
> to generate valid image without involving kernel in any way.

I believe mdadm can do this, Mtkaczyk what do you think?

The problem is that system service will recognize raid disks and
assemble the array automatically, you might what to disable them.

Thanks,
Kuai

> I was using mdadm before switching to genimage and it adds complexity of
> handling all the edge cases of kernel states.
> Mkfs.ext4 can create image without involving kernel, mdadm cannot, it always
> instructs kernel to create the metadata for it when creating array.
> 
> In my opinion we should decide whether it makes sense for kernel to export
> the structures in header file and either provide all of them, or provide none.
> That might be valid reasoning to say every userspace program should include
> its own definitions of structures. But providing half does not make any sense.
> 
> I wonder if mdadm needs some of definitions that i have omitted from UAPI.
> 
> Tom
> 
> .
> 

