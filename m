Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB4A1DD0F2
	for <linux-raid@vger.kernel.org>; Mon, 12 May 2025 01:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747013979; cv=none; b=YZ+Zcm1ELiAw56hm/vla5y8pIemNdCEKOMyRkgVr3IJ0PuNc8WElUWYuoR62DP+FAkkduOsju84THhzqLF41aRPcradTvzLiD9OKqoPnT0MfrxQtDM5fzWvc2LUQL+6Q3khIjNHSPh0bNw1Z1h4RbEGu7jEDo5m1JXKLMp6sz0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747013979; c=relaxed/simple;
	bh=C/1PwZ3th37iDRgfzJhH881aY6wJMnAuCESgn1XMwOY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=D9sCnDiW4kHelvlPtI3v+cO4Y8lZLK6w7QPVjhIp3LTs3KPdi92F+22hRhA215Ukd6dLC8u2+4FycNAbM0rFJAPX7yyWeh0Uhfb2CzwCWYH8eVPARIa7CC8cYtIaENftN95nLKrIV4R6HJZUsQgFzeM7V0qNqRXto0dVxAAsEbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4Zwj2Z73LgzYQv8P
	for <linux-raid@vger.kernel.org>; Mon, 12 May 2025 09:39:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 46E161A01A1
	for <linux-raid@vger.kernel.org>; Mon, 12 May 2025 09:39:34 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCH619VUSFoPyCXMA--.47021S3;
	Mon, 12 May 2025 09:39:34 +0800 (CST)
Subject: Re: [PATCH 2/3] md: replace MD_DELETED with MD_CLOSING
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org, ncroxon@redhat.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250507021415.14874-1-xni@redhat.com>
 <20250507021415.14874-3-xni@redhat.com>
 <09d3eb78-d2c9-5c04-bec5-5aae4a19cf83@huaweicloud.com>
 <CALTww29siTuVSpCOJB7j47DxWFMcZV9RHkX=VfdxU0OyA4TsFg@mail.gmail.com>
 <c994b86c-cd40-1778-81d4-fdb3066053ef@huaweicloud.com>
 <CALTww28OBZZYdD_fJdFjmsjo51cn7CvVrKe=yserF+xvMd5f0A@mail.gmail.com>
 <04bc114d-08f8-b703-de7e-2f828f41321b@huaweicloud.com>
 <CALTww294G-r4BtFAnoQayLQgJO4Lm2+WSRac403_ERsLJbesKg@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <2ed2be49-3c48-13d1-2d89-6665d4eb4457@huaweicloud.com>
Date: Mon, 12 May 2025 09:39:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww294G-r4BtFAnoQayLQgJO4Lm2+WSRac403_ERsLJbesKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCH619VUSFoPyCXMA--.47021S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar4DAr17Wr4kAr1fXw4DCFg_yoW8AF4xpr
	48t3WUKF4qkryjk3Z2qw4UWFW0yw1rXrWUXryFqFn8C34qvw1rGF47trWvkFW8Xa4Sgw42
	ga1UJasxZr1rZw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4l
	IxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUG0PhUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/05/09 19:20, Xiao Ni 写道:
> On Fri, May 9, 2025 at 6:26 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2025/05/09 18:20, Xiao Ni 写道:
>>> On Fri, May 9, 2025 at 6:08 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>>
>>>> Hi,
>>>>
>>>> 在 2025/05/09 17:33, Xiao Ni 写道:
>>>>> The two places clear MD_CLOSING rather than setting MD_CLOSING.
>>>>> MD_CLOSING is set when we really want to stop the array (STOP_ARRAY
>>>>> cmd and clear>array_state_store). So the two places clear MD_CLOSING
>>>>> for other situations which look good to me.
>>>>
>>>> No, MD_CLOSING can be set first in the two cases, do something and then
>>>> be cleared, that's why I said temporarily.
>>>
>>> So you mean mddev_get should pass in this case (between setting
>>> MD_CLOSING and clearing MD_CLOSING)? It doesn't allow get mddev now
>>> without this patch. This should be right.
>>
>> I don't understand what you mean "It doesn't allow get mddev now without
>> this patch", for example, the ioctl STOP_ARRAY_RO will set MD_CLOSING
>> temporarily, but never set MD_DELETED, mddev_get() can always pass.
> 
> You're right. I thought of the md_open path and it checks MD_CLOSING.
> There is a short window that will fail to open sysfs files. I want to
> make things easier and clearer here: it can't get mddev when
> MD_CLOSING is set. Is there any problem if we use this rule?

What I can think of is that during the window, user can't access this
array through sysfs or /proc/mdstat after this patch. We'd better not
introduce new restrictions for user, unless we're 100% sure they won't
be affected.

Thanks,
Kuai

> 
> Regards
> Xiao
>>
>> Thanks,
>> Kuai
>>
>>>
>>> Regardes
>>> Xiao
>>>
>>>>
>>>> Thanks,
>>>> Kuai
>>>>
>>>
>>>
>>> .
>>>
>>
> 
> 
> .
> 

