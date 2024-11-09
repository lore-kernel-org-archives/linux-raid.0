Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5AC18037;
	Sat,  9 Nov 2024 01:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731116643; cv=none; b=bGXvEFdNVO57A19qKPmxzgUn6FHQngKiu/3g8JLth5hDT6rehYOJ/LwUe0+pPIBAsyKkHzUes7MXr1se9ZdqfuuO62clqY08JnGnyoXAaHkjcfTdiNJQlK/5DN3yWI8bdVI4kh/43qUdSEnZExjyeS7pd4G/J4SV3SixD7PsKFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731116643; c=relaxed/simple;
	bh=Gfoz0P3wspaae2W/C3bUx6NUcI0Wvx9RM8kGmhuj/WI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=h2b+hALobcXfpiQ/un9GkaSQxjwQ+htMCz0Y7+Hy1SarQBxWsatpNPh0+K2GvwJyZwZvUxN9gSMHu20ozxQY6sD0sQbf4CRzzDT202Pa3cmJBn6/X/Tg4LM4LvD3B5dmUq/3BirB91AOYdJcJmtMFJP138BcYQZNUJRQbz4orko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XldrB59vYz4f3kFL;
	Sat,  9 Nov 2024 09:43:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C8E8B1A0196;
	Sat,  9 Nov 2024 09:43:56 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCXc4davi5nsIEFBQ--.60179S3;
	Sat, 09 Nov 2024 09:43:56 +0800 (CST)
Subject: Re: [PATCH md-6.13] md: remove bitmap file support
To: =?UTF-8?Q?Dragan_Milivojevi=c4=87?= <galileo@pkm-inc.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241107125911.311347-1-yukuai1@huaweicloud.com>
 <CAPhsuW7Ry0iUs6X7P4jL5CX3+8EGfb5uL=g-q_8jVR-g19ummQ@mail.gmail.com>
 <ef4dcb9e-a2fa-d9dc-70c1-e58af6e71227@huaweicloud.com>
 <CAPhsuW4tcXqL3K3Pdgy_LDK9E6wnuzSkgWbmyXXqAa=qjAnv7A@mail.gmail.com>
 <CALtW_agCsNM66DppGO-0Trq2Nzyn3ytg1t8OKACnRT5Yar7vUQ@mail.gmail.com>
 <8ae77126-3e26-2c6a-edb6-83d2f1090ebe@huaweicloud.com>
 <CALtW_ajYN4byY_hWLyKadAyLa9Rmi==j6yCYjLLUuR_nttKMrQ@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <36659c34-08bf-2103-a762-ce9e75e8262e@huaweicloud.com>
Date: Sat, 9 Nov 2024 09:43:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALtW_ajYN4byY_hWLyKadAyLa9Rmi==j6yCYjLLUuR_nttKMrQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXc4davi5nsIEFBQ--.60179S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CrWDWFy7WrWkuFW8Xw1kZrb_yoW8Xr1Upr
	4xuFyrGFn5J3Z0vwn2qa42qFW5XrZ3JryxGr1vyrn5G34Yvr90qF4xKF1rWa4qyF4DWa4j
	yw15Ja4Sy34vvFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUOgAwDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/11/09 6:19, Dragan Milivojević 写道:
> On Fri, 8 Nov 2024 at 07:07, Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
> 
>> I don't think external bitmap can workaround the performance degradation
>> problem, because the global lock for the bitmap are the one to blame for
>> this, it's the same for external or internal bitmap.
> 
> Not according to my tests:
> 
> 5 disk RAID5, 64K chunk
> 
> 
> 
> Test                   BW         IOPS
> bitmap internal 64M    700KiB/s   174
> bitmap internal 128M   702KiB/s   175
> bitmap internal 512M   1142KiB/s  285
> bitmap internal 1024M  40.4MiB/s  10.3k
> bitmap internal 2G     66.5MiB/s  17.0k
> bitmap external 64M    67.8MiB/s  17.3k
> bitmap external 1024M  76.5MiB/s  19.6k

This is not what I expected, can you give the tests procedures in
details? Including test machine, create the array and test scrpits.

> bitmap none            80.6MiB/s  20.6k
> Single disk 1K         54.1MiB/s  55.4k
> Single disk 4K         269MiB/s   68.8k
> 
> 
> 
> Full test logs with system details at: pastebin. com/raw/TK4vWjQu
> 
> 
>>
>> Do you know that is there anyone using external bitmap in the real
>> world? And is there numbers for performance? We'll have to consider
>> to keep it untill the new lockless bitmap is ready if so.
> 
> Well I am and it's a royal pain but there isn't much of an alternative.

Bitmap file will be removed, the way it's implemented is problematic. If
you have plans to upgrade kernel to v6.13+, I can keep it for now,
untill the other lockless bitmap is ready.

Thanks,
Kuai

> .
> 

