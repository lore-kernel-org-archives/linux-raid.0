Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB812126BF7;
	Mon, 30 Jun 2025 11:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751281527; cv=none; b=eoEEYUgOVUBEREfelrBqopZpuuWKaHJprNtgJfFpWvfFOVKg87GAqRzIzR8oi/PZxgL3DzE83cwMHeWhAx3J1zkDU5WgIVG5M5/1Jn3VgoU9aLElqVQ7Es6SAeJm+E1WDhpoAPkFXxeg0LbdnBFPziMzWVBXsLuHWvh3f7Y5vS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751281527; c=relaxed/simple;
	bh=rqtWrchJn6Yk5Gv69Nqyhj2CFwd/ohXdspg7m8OSAd4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ZOE21JHAwxD/A5WbnzNvxnTV3JDQ3tLyQOotWo0ahG/ZztaQF8llCiKAnpATbs0b8UHXQUFPFF/hYK/WvFOdptQby8387RjN8yDFGihD4DpTKUJbs5AVw/F6SgI7U4NDuv3skHLvlXzsrCPV7fqEGcOFd/md6RPMEEThlGLJKlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bW3Gq6mnMzKHNcN;
	Mon, 30 Jun 2025 19:05:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 564B01A0838;
	Mon, 30 Jun 2025 19:05:22 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP3 (Coremail) with SMTP id _Ch0CgB32SZwb2JoMDTRAA--.58247S3;
	Mon, 30 Jun 2025 19:05:22 +0800 (CST)
Subject: Re: [PATCH 16/23] md/md-llbitmap: implement bit state machine
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, colyli@kernel.org, song@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-17-yukuai1@huaweicloud.com>
 <c76f44c0-fc61-41da-a16b-5a3510141487@redhat.com>
 <cf6d7be1-af73-216c-b2ab-b34a8890450d@huaweicloud.com>
 <CALTww2-RT64+twHo3=Djpuj81jArmePQShGynDrRtYab3c1i2w@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <93166d88-710f-c416-b009-5d57f870b152@huaweicloud.com>
Date: Mon, 30 Jun 2025 19:05:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww2-RT64+twHo3=Djpuj81jArmePQShGynDrRtYab3c1i2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgB32SZwb2JoMDTRAA--.58247S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr43Xw18Ww4xKFWkJFWfGrg_yoW8XrWkpa
	yjkF4qkr4DAa47K3s2v3W0gryFkrn2q3y5AFyrtwsxCas8Gr1F93yFg3yYka17Cr93G3ZI
	vFW8t34UZa17AFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

在 2025/06/30 16:25, Xiao Ni 写道:
> On Mon, Jun 30, 2025 at 10:25 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2025/06/30 10:14, Xiao Ni 写道:
>>> For reload action, it runs continue here.
>>
>> No one can concurent with reload.
>>
>>>
>>> And doesn't it need a lock when reading the state?
>>
>> Notice that from IO path, all concurrent context are doing the same
>> thing, it doesn't matter if old state or new state are read. If old
>> state is read, it will write new state in memory again; if new state is
>> read, it just do nothing.
> 
> Hi Kuai
> 
> This is the last place that I don't understand well. Is it the reason
> that it only changes one byte at a time and the system can guarantee
> the atomic when updating one byte?
> 
> If so, it only needs to concern the old and new data you mentioned
> above. For example:
> raid1 is created without --assume-clean, so all bits are BitUnwritten.
> And a write bio comes, the bit changes to dirty. Then a discard is
> submitted in another cpu context and it reads the old status
> unwritten. From the status change table, the discard doesn't do
> anything. In fact, discard should update dirty to unwritten. Can such
> a case happen?

This can happen for raw disk, however, if there are filesystem, discard
and write can never race. And for raw disk, if user really issue write
and discard concurrently, the result really is uncertain, and it's fine
the bit result in dirty or unwritten.

Thanks,
Kuai

> 
> Regards
> Xiao
>>
>> Thanks,
>> Kuai
>>
> 
> 
> .
> 

