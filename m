Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED2F33EC
	for <linux-raid@vger.kernel.org>; Thu,  2 Jan 2025 01:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735782212; cv=none; b=BkjcW5tbAyHLxRDnm/QnmKdW6hn7YSRkvhAJUKUtboQUCbpASd8KPj1KMTIH48KqOxrL+zyMOfTzY3+up2bEg5rO19Ve6GGgoiiRqX97I4M7BoKKTgJFK/8RoWOFpCi+7d+I0vOz/8Phv5QGbPolphhQrbuEYw02kuqg+55AKts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735782212; c=relaxed/simple;
	bh=MUIkyEgLcGacIK+rXM9R1tJc6Z2ylD2p0CRziB+ZFfY=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Lw8QiiXFGxkolSYuuh2hdYdyGYejua9v0iZRwKc4MywOfwzVEBzpJ4Djo8WyQEH8sX/w6khGM0attDaffebJk8jhcrP2YkSWLtF8y0eFzNzTWUKDozvxlcZxnO970VlgE20YtifdcZZUhnA1aE7a/+/xG2PaloTn/E5LwzO7gZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YNqGc4XJrz4f3lWD
	for <linux-raid@vger.kernel.org>; Thu,  2 Jan 2025 09:43:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B8EB21A06DD
	for <linux-raid@vger.kernel.org>; Thu,  2 Jan 2025 09:43:25 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgDnwoY873VnPqIxGQ--.22900S3;
	Thu, 02 Jan 2025 09:43:25 +0800 (CST)
Subject: Re: [PATCH] Export MDRAID bitmap on disk structure in UAPI header
 file
To: Mariusz Tkaczyk <mtkaczyk@kernel.org>,
 =?UTF-8?B?VG9tw6HFoSBNdWRydcWIa2E=?= <tomas.mudrunka@gmail.com>,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, yukuai@kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241231030929.246059-1-tomas.mudrunka@gmail.com>
 <ebbec264-7669-03fd-7ffd-3c728168cdd5@huaweicloud.com>
 <20241231095942.446f4d4a@mtkaczyk-private-dev>
 <CAH2-hc+QK0SZgDjOScegsDk8R8gQEZgJ5Vg1M1J_v-yDEym=Dw@mail.gmail.com>
 <20241231123108.215cc05e@mtkaczyk-private-dev>
 <20241231152302.3dc7a710@mtkaczyk-private-dev>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <b541044b-7550-313d-4252-1a13068c2fd7@huaweicloud.com>
Date: Thu, 2 Jan 2025 09:43:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241231152302.3dc7a710@mtkaczyk-private-dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnwoY873VnPqIxGQ--.22900S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJFWrWF1xCF15uF1kZFW5KFg_yoW5KF4kpa
	yDGF1Ykr4DJr45Zw4v9r48ZayIgwn3Ary3Grn8Gwn0yF90gFn7Jr10kF45uFWDWws5K3ZF
	vay5AFy3W34qqaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwx
	hLUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/12/31 22:23, Mariusz Tkaczyk 写道:
> Sorry missclick, adding linux-raid now.
> I think we don't need to spam on linux-kernel as these are MD internals.
> 
> Kuai please take a look again.
> 
> Thanks,
> Mariusz
> 
> On Tue, 31 Dec 2024 12:31:08 +0100
> Mariusz Tkaczyk <mtkaczyk@kernel.org> wrote:
> 
>> On Tue, 31 Dec 2024 12:00:31 +0100
>> Tomáš Mudruňka <tomas.mudrunka@gmail.com> wrote:
>>
>>>>> Thanks for the patch, however, Why do you want to directly
>>>>> manipulate the metadata instead of using mdadm? You must first
>>>>> provide an explanation to convince us that what you're doing
>>>>> makes sense, and it's best to show your work.
>>>
>>> I am adding MD RAID support to genimage tool:
>>> https://github.com/pengutronix/genimage/
>>>
>>> It is used to generate firmware/disk images. Without such a tool it
>>> is impossible to build disk image containing md raid metadata
>>> without actually assembling it in the kernel via losetup or
>>> something...
>>>
>>> I am already using #include <linux/raid/md_p.h> which includes
>>> references to bitmap structures:
>>>
>>> $ grep -ri bitmap /usr/include/linux/raid/md_p.h
>>> #define    MD_SB_BITMAP_PRESENT    8 /* bitmap may be present nearby
>>> */ __le32    feature_map;    /* bit 0 set if 'bitmap_offset' is
>>> meaningful */ __le32    bitmap_offset;    /* sectors after start of
>>> superblock that bitmap starts
>>>                       * NOTE: signed, so bitmap can be before
>>> superblock #define MD_FEATURE_BITMAP_OFFSET    1
>>> #define    MD_FEATURE_RECOVERY_BITMAP    128 /* recovery that is
>>> happening
>>>                           * is guided by bitmap.
>>> #define    MD_FEATURE_ALL            (MD_FEATURE_BITMAP_OFFSET    \
>>>                      |MD_FEATURE_RECOVERY_BITMAP    \
>>>
>>> But when i use those, the resulting metadata is invalid, unless i
>>> populate the structures from drivers/md/md-bitmap.h so i had to
>>> copypaste its contents to my code, but i am not happy about it
>>> (including half and copypasting half):

Just curious, what you guys do for filesystems like ext4/xfs, and
they just define the same structure in user-space tools.

looks like your tool do support to create ext4 images, and it's using
ext4's use-space tools directly. If it's true, do you consider to use
mdadm directly?

Thanks,
Kuai

>>
>> https://github.com/md-raid-utilities/mdadm/blob/main/bitmap.h
>>
>> Correct me if I'm wrong but looks like it is what we did in mdadm.
>> Well, If you don't want to care about it, you can consider adding
>> mdadm as submodule in your application and use mdadm's headers.
>>
>> Just an option, I have no hard feelings here.
>>
>> Looking into that now make me more feeling that we should export this
>> header long time ago instead of reimplementing it in mdadm. Kuai, what
>> do you think?
>>
>>>
>>> https://github.com/Harvie/genimage/blob/master/image-mdraid.c
>>>
>>>> I'm with Kuai here. I would also add that for such purposes you
>>>> can use externally managed metadata, not native. External
>>>> management was proposed to address your problem however over the
>>>> years it turned out to not be good conception (kernel driver
>>>> relies on userspace daemon which is not secure).
>>>>
>>>> Thanks,
>>>> Mariusz
>>>
>>> Hope my reply is sufficient.
>>>
>>> Thank you guys!
>>> Tom
>>
>> Looks like old problem we get used to. If Kuai agrees too, I'm open to
>> add this but.. as a mdadm maintainer (primary tool to manipulate
>> mdraid) I would like you to handle this on mdadm site too to make sure
>> we have it consistent and we exported exactly what is needed.
>>
>> Hope, it has some sense now!
>> Thanks,
>> Mariusz
> 
> 
> .
> 

