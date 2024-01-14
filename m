Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBC21102
	for <linux-raid@vger.kernel.org>; Sun, 14 Jan 2024 03:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4TCKzb2R3Zz4f3jpq
	for <linux-raid@vger.kernel.org>; Sun, 14 Jan 2024 11:11:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 65E661A01E9
	for <linux-raid@vger.kernel.org>; Sun, 14 Jan 2024 11:11:09 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAX5g7LUKNl_doYAw--.15174S3;
	Sun, 14 Jan 2024 11:11:09 +0800 (CST)
Subject: Re: [PATCH] mdadm: stop using 'idle' for sysfs api "sync_action" to
 wake up sync_thread
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org, song@kernel.org,
 yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20240111120505.4135257-1-yukuai1@huaweicloud.com>
 <20240112124434.00005e3c@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <7401d872-a28a-e4a0-f0c1-a1dc151b5153@huaweicloud.com>
Date: Sun, 14 Jan 2024 11:11:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240112124434.00005e3c@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAX5g7LUKNl_doYAw--.15174S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGrWDXw13uFW3Cry7Kw13twb_yoW5tFWUpF
	W5Kw4Fyr4UArsay3ykXa1xWFySk3s5XFy5Kas8Wr1fJr1kWF92qF43JFs7uF9rAr93X34j
	93yYyF98CF4vvaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/01/12 19:44, Mariusz Tkaczyk Ð´µÀ:
> On Thu, 11 Jan 2024 20:05:05 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Echo 'idle' to "sync_action" is supposed to stop sync_thread while new
>> sync_thread can still start. However, currently this behaviour is not
>> correct, echo 'idle' will actually try to stop sync_thread and then
>> start a new sync_thread. And mdadm relies on this wrong behaviour in
>> some places.
>>
>> In kernel, if resync is not done yet, then recovery/reshape/check/repair
>> can't not start in the first place, and if resync is done, echo 'resync'
>> behaves the same as echo 'idle' for now.
> 
> Hi Kuai,
>>From the last part I understand that in case of resync/reshape frozen thread is
> unblocked, not restarted.
> 
> I miss some explanation about that here. So far I understand is:
> 
> "Setting "resync" or "reshape" allow to continue frozen sync_thread instead
> restarting it. Setting "resync" if resync is done, has same effect as "idle" so
> it is safe."
> 
> Please describe setting "reshape", I can see that you use it in one place, I
> think that with reshape we need to be more careful but you are the expert here,
> maybe it is same as "resync"?

The only place to use "reshape" is that reshape is frozed before, and
echo "reshape" can continue the interrupted reshape. Of coures, echo
"idle/resync" can also continue the interrupted reshape.
> 
>>
>> Hence replace echo 'idle' with echo 'resync/reshape' when trying to
>> continue frozed sync_thread. There should be no functional changes and
>> prevent regressions after fixing that echo 'idle' will start new
>> sync_thread in kernel.
> 
> Ok, so this is kind of preparing for kernel fix. Got it.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
> 
> I think that I understand purpose of the change. You are trying to avoid thread
> restarting if not needed and remove reference to incorrect "idle" usage of
> mdadm.
> Unfortunately, the changes you need to make have strong reference to kernel
> implementation. It requires to well describe them because blame is volatile.
> 
> I would like to propose separate enum to not rely on kernel states naming, some
> proposals:
> 
> /* So far I understand write "resync" for both cases */
> SYNC_ACTION_RESYNC_START
> SYNC_ACTION_RESYNC_CONTINUE
> 
> /* So far I understand write "reshape" for both cases *
> SYNC_ACTION_RESHAPE_START
> SYNC_ACTION_RESHAPE_CONTINUE
> 
> /* Highlight known bug in comment and use "resync"? /*
> SYNC_ACTION_IDLE
> /* If needed? */
> SYNC_ACTION_ABORT

The enum sounds good, and I thought about enum in kerenl as well,
currently resync/recovery/reshape/... status is determined by
combination of flags, which is hard to follow.
> 
> It needs to be handled by proper function which will have comments describing
> what is written to kernel and why. In userspace, I need more user/reader
> friendly code.
> I want to know what we exactly requested from kernel. In some cases we would
> expect to restart thread is some other cases just to continue frozen one. I
> would like to know what was a purpose of request in the particular case even if
> now the same action is used behind.

Sounds like a good plan, and looks like the first thing to do is to sort
out all the places to use sysfs api 'sync_action' in mdadm, then we'll
know to define the new helper(I just grep the case 'idle' for now).

Thanks,
Kuai

> 
> Let me know what you think.
> 
> Thanks,
> Mariusz
> 
> .
> 

