Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5B423CE;
	Mon, 30 Jun 2025 03:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751255197; cv=none; b=dVDt2J93ek/IQVAFLwx/QejAVvgBvloGspslRrb5IUe0MCyoSl7btTL3xWI58QzepQcXtVMLByyWAiZ5UJB4eSLrGsulGu+MGSFTaksso+1iDTiDDCA5liPl9sOVVwicazWmicL+0/ZRzR8K+PqNkeBVwdXBdNyNc72Ia7Im4ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751255197; c=relaxed/simple;
	bh=yAXaKn4rgIL1+zIFgYjCifLgc8t8L/Q8dLG6TlCajuk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=qn923JkZ7kJmalZsrEGBHL+UNQrz8zFTCzgMO7xx3/rk9x8TDVS2W6mQY19wtDHBI6kgaBNKrpFJB1XXWPqciMU7lo3FsSwTzC5gPw6qtIJ96mtIfL10CTcpqgOJdI4seSwDzsySpx4+lD/CVZYqxUoKD/7PGPEpA4bCRAX3s6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bVsXS0qH5zYQtFq;
	Mon, 30 Jun 2025 11:46:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id EE2FE1A0C78;
	Mon, 30 Jun 2025 11:46:30 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP3 (Coremail) with SMTP id _Ch0CgDnSCaVCGJoAQWxAA--.48506S3;
	Mon, 30 Jun 2025 11:46:30 +0800 (CST)
Subject: Re: [PATCH 00/23] md/llbitmap: md/md-llbitmap: introduce a new
 lockless bitmap
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, colyli@kernel.org, song@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <808d3fb3-92a9-4a25-a70c-7408f20fb554@redhat.com>
 <288be678-990b-86f9-1ffd-858cee18eef3@huaweicloud.com>
 <CALTww28grnb=2tpJOG1o+rKG4rD7chjtV3Nmx9D1GJjQtVqWhA@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <3836a568-20c0-c034-7d7f-42a22fe77b4e@huaweicloud.com>
Date: Mon, 30 Jun 2025 11:46:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww28grnb=2tpJOG1o+rKG4rD7chjtV3Nmx9D1GJjQtVqWhA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgDnSCaVCGJoAQWxAA--.48506S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4fXryxXr15ur1DKFyrtFb_yoW5CFWkpa
	nrZF13Krs8JFWSqr9FvryqvF40kr9xJrsrXFn8t3s3G3Z8WrnagF4FgFWUuw1jgryDX3Wj
	va1rJFZ3CF45WFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

在 2025/06/30 11:25, Xiao Ni 写道:
> On Mon, Jun 30, 2025 at 10:34 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2025/06/30 9:59, Xiao Ni 写道:
>>>
>>> After reading other patches, I want to check if I understand right.
>>>
>>> The first write sets the bitmap bit. The second write which hits the
>>> same block (one sector, 512 bits) will call llbitmap_infect_dirty_bits
>>> to set all other bits. Then the third write doesn't need to set bitmap
>>> bits. If I'm right, the comments above should say only the first two
>>> writes have additional overhead?
>>
>> Yes, for the same bit, it's twice; For different bit in the same block,
>> it's third, by infect all bits in the block in the second.
> 
> For different bits in the same block, test_and_set_bit(bit,
> pctl->dirty) should be true too, right? So it infects other bits when
> second write hits the same block too.

The dirty will be cleared after bitmap_unplug.
> 
> [946761.035079] llbitmap_set_page_dirty:390 page[0] offset 2024, block 3
> [946761.035430] llbitmap_state_machine:646 delay raid456 initial recovery
> [946761.035802] llbitmap_state_machine:652 bit 1001 state from 0 to 3
> [946761.036498] llbitmap_set_page_dirty:390 page[0] offset 2025, block 3
> [946761.036856] llbitmap_set_page_dirty:403 call llbitmap_infect_dirty_bits
> 
> As the debug logs show, different bits in the same block, the second
> write (offset 2025) infects other bits.
> 
>>
>>    For Reload action, if the bitmap bit is
>>> NeedSync, the changed status will be x. It can't trigger resync/recovery.
>>
>> This is not expected, see llbitmap_state_machine(), if old or new state
>> is need_sync, it will trigger a resync.
>>
>> c = llbitmap_read(llbitmap, start);
>> if (c == BitNeedSync)
>>    need_resync = true;
>> -> for RELOAD case, need_resync is still set.
>>
>> state = state_machine[c][action];
>> if (state == BitNone)
>>    continue
> 
> If bitmap bit is BitNeedSync,
> state_machine[BitNeedSync][BitmapActionReload] returns BitNone, so if
> (state == BitNone) is true, it can't set MD_RECOVERY_NEEDED and it
> can't start sync after assembling the array.

You missed what I said above that llbitmap_read() will trigger resync as
well.
> 
>> if (state == BitNeedSync)
>>    need_resync = true;
>>
>>>
>>> For example:
>>>
>>> cat /sys/block/md127/md/llbitmap/bits
>>> unwritten 3480
>>> clean 2
>>> dirty 0
>>> need sync 510
>>>
>>> It doesn't do resync after aseembling the array. Does it need to modify
>>> the changed status from x to NeedSync?
>>
>> Can you explain in detail how to reporduce this? Aseembling in my VM is
>> fine.
> 
> I added many debug logs, so the sync request runs slowly. The test I do:
> mdadm -CR /dev/md0 -l5 -n3 /dev/loop[0-2] --bitmap=lockless -x 1 /dev/loop3
> dd if=/dev/zero of=/dev/md0 bs=1M count=1 seek=500 oflag=direct
> mdadm --stop /dev/md0 (the sync thread finishes the region that two
> bitmap bits represent, so you can see llbitmap/bits has 510 bits (need
> sync))
> mdadm -As

I don't quite understand, in my case, mdadm -As works fine.
> 
> Regards
> Xiao
>>
>> Thanks,
>> Kuai
>>
>>
> 
> 
> .
> 

