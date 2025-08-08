Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C07C1BFE00
	for <linux-raid@vger.kernel.org>; Fri,  8 Aug 2025 06:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754635259; cv=none; b=fghOu8Nl3M33MyQY+kRPAj60aarm4QkF2O8blML4eL94b5EnPouquHdjVDKINZ8usbi0N52X20l1NTLKdlw7wTT6oChBKglMkJwYAqzoQbNrr9HebHUpk1BIj91Bm+AfUSQyUjXAp2WWMpz5RGzda7rQsjPt9k12ImAEVCu3Z8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754635259; c=relaxed/simple;
	bh=3FCFt69NYtaKYTrEObywwjRR9vshtqHxyDiSj3l/D3c=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ol6JMGFU/ZEZPQZNqnv/hpBsF8z6kkbjVMCskJDK9fBcNU1Wpb93mZTOxQ/4cxwjB9R9+Uarzoy3erWFyECv9Okoy8ZBSoeWo/S+Qs3IB+KVvjziupGYcMwLGwKLRwfhys9+R5O7WCliUiP06DdURlGl2o7ENeK/iupNW+0Djkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4byvYd6rr5zKHLxk
	for <linux-raid@vger.kernel.org>; Fri,  8 Aug 2025 14:40:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 16DF01A01A2
	for <linux-raid@vger.kernel.org>; Fri,  8 Aug 2025 14:40:53 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAHgxPzm5Vozc7cCw--.34839S3;
	Fri, 08 Aug 2025 14:40:52 +0800 (CST)
Subject: Re: md regression caused by commit
 9e59d609763f70a992a8f3808dabcce60f14eb5c
To: Xiao Ni <xni@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Luca Boccassi <luca.boccassi@gmail.com>, Song Liu <song@kernel.org>,
 linux-raid@vger.kernel.org, vkuznets@redhat.com, yuwatana@redhat.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <f654db67-a5a5-114b-09b8-00db303daab7@redhat.com>
 <CALTww28TpRRTzjqsOXGoUrLHEk=ca85zRcDanGqgTyytA-34ow@mail.gmail.com>
 <CAMw=ZnTosW4OecBCFdVNqiw9VjSL6msUx6yYBE=9vsEn7JeKqA@mail.gmail.com>
 <8c1bf191-a741-cd7a-29dc-babf24a13777@redhat.com>
 <CALTww28y-cuJMAGfWjgVdjhkFB8w-z7SR48nNvdRHM01L0TGow@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <81648e41-fe3e-1be8-2e0e-f1f5c39564cf@huaweicloud.com>
Date: Fri, 8 Aug 2025 14:40:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww28y-cuJMAGfWjgVdjhkFB8w-z7SR48nNvdRHM01L0TGow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHgxPzm5Vozc7cCw--.34839S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGr1DZw17WFWDuw1fuF15urg_yoW5trW5pF
	W7AF45tr4DtrZ7t3s7Kw18uFy0krZ3JrW5Jr1ktrWrAa98Kr1a9F10gw4a9FZF9rn7ur4j
	vF48Xw13JayayFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwx
	hLUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/



在 2025/08/08 13:28, Xiao Ni 写道:
> On Thu, Aug 7, 2025 at 10:18 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
>>
>>
>>
>> On Thu, 7 Aug 2025, Luca Boccassi wrote:
>>
>>> On Thu, 7 Aug 2025 at 01:04, Xiao Ni <xni@redhat.com> wrote:
>>>>
>>>> Hi all
>>>>
>>>> It needs to use the latest upstream mdadm
>>>> https://github.com/md-raid-utilities/mdadm/ which has fixed this
>>>> problem. And for fedora, it hasn't updated to the latest upstream. So
>>>> it has this problem. I'll update fedora mdadm to latest upstream.
>>>>
>>>> Best Regards
>>>> Xiao
>>>
>>> Thank you for looking into it and providing a solution - however,
>>> isn't it against the rules to break existing released userspace
>>> components and requiring new versions to be released in order to use a
>>> new kernel version? Is there any way this kernel patch could be
>>> amended to avoid breaking the existing userspace as it is?
>>>
>>> Thanks
>>
>> I also think that the misbehavior should be fixed in the kernel.
>>
>> We shouldn't use arbitrary timeouts to clean up the sysfs entries, because
>> it would introduce race conditions.
>>
>> What about destroying the sysfs entries when the file descriptor is
>> closed? (instead of on the STOP_ARRAY ioctl) That wouldn't interfere with
>> other code trying to stop the array and it would make it work with the
>> buggy mdadm that calls STOP_ARRAY and then tries to find the sysfs entries
>> and then calls SET_ARRAY_INFO.
>>
>> Mikulas
>>
> 
> Hi all
> 
> The assemble process is:
> 1. create array
> 2. stop it (STOP_ARRAY). Before the kernel change, del_gendisk is
> called at the last release of mddev rather than in STOP_ARRAY ioctl
> 3. access /sys/block/md0/md
> 
> The kernel change tries to call del_gendisk in STOP_ARRAY. So /dev/md0
> can be removed and no one can access it. If not, the array can be
> created again because md supports create on open.
> 
> After the kernel change, the assemble process is:
> 1. create array
> 2. stop it (del_gendisk runs and /sys/block/md0 is removed)
> 3. acces /sys/block/md0/xx (it fails)
> 
> So del_gendisk destroys sysfs entries. If we destroy sysfs entries at
> the last release of mddev, it will return to the old state that
> /dev/md0 can be opened after stop. I don't want to return back.
> Because some customers encounter bugs that shutdown is stuck because
> /dev/md0 can't be stopped and the regression test usually fails
> because of this too.

Yes, from kernel side, we think after succeed stop_array ioct, the
kernel disk should be removed in the end. We used to call del_gendisk
asynchronously, leaves a race window that sysfs entries still visible
to user.

We decide to fix this in the last merge window, however, it's true mdadm
has to be fixed together.

> 
> I know it's not good to break mdadm by a kernel change. But sometimes
> it needs userspace tool and kernel work together to fix a problem,
> right?
> Sorry for bringing the problem, and thanks for the suggestions. Any
> more good suggestions?
> 

Idealy, we should fix mdadm first, then after a release, fix kernel.
Sadly the transition stage is missing now. :(

If we want to just avoid this problem in kernel, what I can think of is
adding a switch and mark it deprecated for now. And in new mdadm
releases enable that switch, and after sometime, remove mdadm legacy
code to stop array, and finally remove the deprecated switch in kernel
then everyone will be happy :)

Thanks,
Kuai

> Best Regards
> Xiao
> 
> 
> .
> 

