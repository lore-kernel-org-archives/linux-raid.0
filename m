Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9438143896
	for <linux-raid@vger.kernel.org>; Thu, 16 May 2024 11:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715858447; cv=none; b=Y8TKAmKyaWMkto45XLja5UpWzYRo/yu7qG4F9FbUP49fBIhz8gQnQnX+zVYAWwPI/suFzsnoIEqhXsJqUefjLfvQj2M9ZiPFa3qDxGLWv7iBbS5FGjGibLKge2nnwyvCA8Cdyt74hfsfcGF3gMdx0B0iF1qhVSEZbs5cne1MWtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715858447; c=relaxed/simple;
	bh=cvMPUaFqd2SbZthHzuFDf2rYGdPFhdWdAe/PdpjzR1I=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=sGI1g7hHoynrete9tYb1LZ/SRhFeJJQHvi7tlk5DOva5Q77+HfJdK4ktolHvnlOZn3RttZKIC9LJq/qyMdIM6XTU7vJfBd+F30M/1QBRPgI5XgKk+glgFDnkYG604OTqJpx84lu4ThnsCMMABXhnEw7ZQSp8wZ+T1weARMomTy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Vg71S3XLDz4f3mJG
	for <linux-raid@vger.kernel.org>; Thu, 16 May 2024 19:20:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id B2CE91A0182
	for <linux-raid@vger.kernel.org>; Thu, 16 May 2024 19:20:38 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBnOBEC7EVmmxZHMw--.42957S3;
	Thu, 16 May 2024 19:20:36 +0800 (CST)
Subject: Re: raid5 hang on kernel v6.1 in combination with ext4lazyinit
To: Gustav Ekelund <gustav.ekelund@axis.com>,
 Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org, dan@danm.net,
 junxiao.bi@oracle.com
Cc: linux-raid@vger.kernel.org, kernel@axis.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <3bb2549f-846a-4179-9e23-407235a06753@axis.com>
 <8c4b871d-83cc-8f1a-c409-2ed8ec79dba5@huaweicloud.com>
 <39b79a1d-17cb-479f-b5c2-629e66436f07@axis.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <40102c57-9197-fc54-c8d0-5c6e906aa38a@huaweicloud.com>
Date: Thu, 16 May 2024 19:20:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <39b79a1d-17cb-479f-b5c2-629e66436f07@axis.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBnOBEC7EVmmxZHMw--.42957S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtr45uw4kur1rAF17Ww15urg_yoWxXr1kp3
	4jva43XrWjqa4kZa12vw4UAFy8Gw47GFyDua9YgF1UKws8XFy0qFy5t3WUuF1UJ3yUAry8
	ua9Yy3Zag3Wjq3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/05/16 17:36, Gustav Ekelund 写道:
> On 5/16/24 03:10, Yu Kuai wrote:
>> Hi,
>>
>> 在 2024/05/15 19:57, Gustav Ekelund 写道:
>>> Hi,
>>>
>>> With raid5 syncing and ext4lazyinit running in parallel, I have a high
>>> probability of hanging on the 6.1.55 kernel (Log from blocked tasks
>>> below). I do not see this problem on the 5.10 kernel.
>>>
>>> In thread [4] patch [2] is described an regression going from 6.7 to
>>> 6.7.1, so it is unclear to me if this is the same issue. Let me know if
>>> I should reply on [4] if you think this could be the same issue.
>>>
>>> Cherry-picking [2] into 6.1 seems to resolve the hang, but following
>>> your discussion in [4] you later revert this patch in [3]. I tried to
>>> follow the thread, but I cannot figure out which patch is suggested to
>>> be used instead of [2].
>>>
>>> Would you advice against running with [2] on v6.1? Should it be used in
>>> combination with [1] in that case?
>>
>> No, you should try this patch:
>>
>> https://lore.kernel.org/all/20240322081005.1112401-1-yukuai1@huaweicloud.com/
>>
>> Thanks,
>> Kuai
>>
>>>
>>> Best regards
>>> Gustav
>>>
>>> [1] commit d6e035aad6c0 ("md: bypass block throttle for superblock
>>> update")
>>> [2] commit bed9e27baf52 ("Revert "md/raid5: Wait for
>>> MD_SB_CHANGE_PENDING in raid5d"")
>>> [3] commit 3445139e3a59 ("Revert "Revert "md/raid5: Wait for
>>> MD_SB_CHANGE_PENDING in raid5d""")
>>> [4]
>>> https://lore.kernel.org/linux-raid/20240123005700.9302-1-dan@danm.net/
>>>
>>> <6>[ 5487.973655][ T9272] sysrq: Show Blocked State
>>> <6>[ 5487.974388][ T9272] task:md127_raid5     state:D stack:0
>>> pid:2619  ppid:2      flags:0x00000008
>>> <6>[ 5487.983896][ T9272] Call trace:
>>> <6>[ 5487.987135][ T9272]  __switch_to+0xc0/0x100
>>> <6>[ 5487.991406][ T9272]  __schedule+0x2a0/0x6b0
>>> <6>[ 5487.995742][ T9272]  schedule+0x54/0xb4
>>> <6>[ 5487.999658][ T9272]  raid5d+0x358/0x56c
>>> <6>[ 5488.003576][ T9272]  md_thread+0xa8/0x15c
>>> <6>[ 5488.007723][ T9272]  kthread+0x104/0x110
>>> <6>[ 5488.011725][ T9272]  ret_from_fork+0x10/0x20
>>> <6>[ 5488.016080][ T9272] task:md127_resync    state:D stack:0
>>> pid:2620  ppid:2      flags:0x00000008
>>> <6>[ 5488.025278][ T9272] Call trace:
>>> <6>[ 5488.028491][ T9272]  __switch_to+0xc0/0x100
>>> <6>[ 5488.032813][ T9272]  __schedule+0x2a0/0x6b0
>>> <6>[ 5488.037075][ T9272]  schedule+0x54/0xb4
>>> <6>[ 5488.041047][ T9272]  raid5_get_active_stripe+0x1f4/0x454
>>> <6>[ 5488.046441][ T9272]  raid5_sync_request+0x350/0x390
>>> <6>[ 5488.051401][ T9272]  md_do_sync+0x8ac/0xcc4
>>> <6>[ 5488.055722][ T9272]  md_thread+0xa8/0x15c
>>> <6>[ 5488.059812][ T9272]  kthread+0x104/0x110
>>> <6>[ 5488.063814][ T9272]  ret_from_fork+0x10/0x20
>>> <6>[ 5488.068225][ T9272] task:jbd2/md127-8    state:D stack:0
>>> pid:2675  ppid:2      flags:0x00000008
>>> <6>[ 5488.077425][ T9272] Call trace:
>>> <6>[ 5488.080641][ T9272]  __switch_to+0xc0/0x100
>>> <6>[ 5488.084906][ T9272]  __schedule+0x2a0/0x6b0
>>> <6>[ 5488.089221][ T9272]  schedule+0x54/0xb4
>>> <6>[ 5488.093135][ T9272]  md_write_start+0xfc/0x360
>>> <6>[ 5488.097676][ T9272]  raid5_make_request+0x68/0x117c
>>> <6>[ 5488.102695][ T9272]  md_handle_request+0x21c/0x354
>>> <6>[ 5488.107565][ T9272]  md_submit_bio+0x74/0xb0
>>> <6>[ 5488.111987][ T9272]  __submit_bio+0x100/0x27c
>>> <6>[ 5488.116432][ T9272]  submit_bio_noacct_nocheck+0xdc/0x260
>>> <6>[ 5488.121910][ T9272]  submit_bio_noacct+0x128/0x2e4
>>> <6>[ 5488.126840][ T9272]  submit_bio+0x34/0xdc
>>> <6>[ 5488.130935][ T9272]  submit_bh_wbc+0x120/0x170
>>> <6>[ 5488.135521][ T9272]  submit_bh+0x14/0x20
>>> <6>[ 5488.139527][ T9272]  jbd2_journal_commit_transaction+0xccc/0x1520
>>> [jbd2]
>>> <6>[ 5488.146400][ T9272]  kjournald2+0xb0/0x250 [jbd2]
>>> <6>[ 5488.151194][ T9272]  kthread+0x104/0x110
>>> <6>[ 5488.155198][ T9272]  ret_from_fork+0x10/0x20
>>> <6>[ 5488.159608][ T9272] task:ext4lazyinit    state:D stack:0
>>> pid:2677  ppid:2      flags:0x00000008
>>> <6>[ 5488.168811][ T9272] Call trace:
>>> <6>[ 5488.172026][ T9272]  __switch_to+0xc0/0x100
>>> <6>[ 5488.176291][ T9272]  __schedule+0x2a0/0x6b0
>>> <6>[ 5488.180618][ T9272]  schedule+0x54/0xb4
>>> <6>[ 5488.184538][ T9272]  io_schedule+0x3c/0x60
>>> <6>[ 5488.188714][ T9272]  bit_wait_io+0x18/0x70
>>> <6>[ 5488.192947][ T9272]  __wait_on_bit+0x50/0x170
>>> <6>[ 5488.197384][ T9272]  out_of_line_wait_on_bit+0x74/0x80
>>> <6>[ 5488.202604][ T9272]  do_get_write_access+0x1e4/0x3c0 [jbd2]
>>> <6>[ 5488.208326][ T9272]  jbd2_journal_get_write_access+0x80/0xc0 [jbd2]
>>> <6>[ 5488.214683][ T9272]  __ext4_journal_get_write_access+0x80/0x1a4
>>> [ext4]
>>> <6>[ 5488.221392][ T9272]  ext4_init_inode_table+0x228/0x3d0 [ext4]
>>> <6>[ 5488.227298][ T9272]  ext4_lazyinit_thread+0x410/0x5f4 [ext4]
>>> <6>[ 5488.233066][ T9272]  kthread+0x104/0x110
>>> <6>[ 5488.237069][ T9272]  ret_from_fork+0x10/0x20
>>>
>>> .
>>>
>>
> Thanks for the patch Kuai,
> 
> I ramped up the testing on multiple machines, and it seems I can still
> hang with the patch, so this could be another problem. As mentioned
> before I run on the 6.1.55 kernel, and never saw this on 5.10.72.
> 
> The blocked state is similar each time, with these same four tasks
> hanging in the same place each time. Do you recognize this hang?

Okay, can you first clarify if it's still true that you said "Cherry-
picking [2] into 6.1 seems to resolve the hang".

There was another problem match the hang tasks, however, both 5.10 and
6.1 have this problem:

https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#m62766c7d341eca35d6dcd446b6c289305b4f122e

BTW, using attr2line tool to change the offset from stack into code line
will be much better to locate the problem. And can you check if mainline
kernel still have this problem.

Thanks,
Kuai
> 
> Best regards
> Gustav
> .
> 

