Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6BD433C0
	for <linux-raid@vger.kernel.org>; Mon, 10 Mar 2025 01:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741570704; cv=none; b=K3KZa2uGtiGqUUpPpPbZEbb1GGOn5/E9Tck7YJ6lnhHZCaSNu/ous9LxBmP5lkVETySWCRb8sSXstiZSnv44iKB/B5i8b95xOaJOyIQLP3ePmDPynYD8rv3oXur2ZaS0d2eDrR6N7OhJ/+hcP+Hr+f3LHaDlM54AZyKb0LbVen0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741570704; c=relaxed/simple;
	bh=GZZ5t6cgohbTnFBWiZ3aJAX6ot1xsHBK3Xh6djZ3Nvw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Q9YI6FurRqL4uLiZ6R86Mm6zE5lgSAnFqHNDNh7eoALHKB1og4/RAaygmFxQxQ+/cMdreigOksII0K015XMZZXzp4/C6YH1LO1vCVuAIYihDJcAy3S9Epw22ztyY6W1Nam0VHzWjCCDTZbF19YVUIldJDFrA7IxP9Q39HGSAN5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Z9zzd1Q5Nz4f3kFD
	for <linux-raid@vger.kernel.org>; Mon, 10 Mar 2025 09:37:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 791151A1327
	for <linux-raid@vger.kernel.org>; Mon, 10 Mar 2025 09:38:11 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAHa1+BQs5npzkvGA--.64920S3;
	Mon, 10 Mar 2025 09:38:11 +0800 (CST)
Subject: Re: [PATCH] mdadm: Don't set bad_blocks flag when initializing
 metadata
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Wu Guanghao <wuguanghao3@huawei.com>,
 Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, ncroxon@redhat.com,
 linux-raid@vger.kernel.org, liubo254@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <d78cbb12-9a9c-7965-db9a-70b4b277f908@huawei.com>
 <42e56670-e595-1c66-208c-40c103262890@huaweicloud.com>
 <CALTww2_yMs_QYSWaQgRFNRgkaZi15KDmdH_00QeTOJWmp1YHcQ@mail.gmail.com>
 <CALTww2-AnS+t3-W=6cAwTn-oQooOo2Svv-=ozSg7PthsEO9-UQ@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <f2ecb825-e8a9-7c18-eb8f-55bd5c0ced7f@huaweicloud.com>
Date: Mon, 10 Mar 2025 09:38:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww2-AnS+t3-W=6cAwTn-oQooOo2Svv-=ozSg7PthsEO9-UQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHa1+BQs5npzkvGA--.64920S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZF4DGrWDWFWkJrW3AFykuFg_yoWrJrWrpF
	yDt3WYkrZ8Gw1jkasFq34xXr10vw47ZFWUWw1UJryUC3s0yr1xXr4xtF15ua4DXrnxta1j
	vF1UWa9xXFyFyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/03/08 13:27, Xiao Ni 写道:
> On Sat, Mar 8, 2025 at 11:06 AM Xiao Ni <xni@redhat.com> wrote:
>>
>> Hi Guanghao
>>
>> Thanks for your patch.
>>
>> On Tue, Mar 4, 2025 at 8:27 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>
>>> Hi,
>>>
>>> 在 2025/03/04 14:12, Wu Guanghao 写道:
>>>> When testing the raid1, I found that adding disk to raid1 fails.
>>>> Here's how to reproduce it:
>>>>
>>>>        1. modprobe brd rd_nr=3 rd_size=524288
>>>>        2. mdadm -Cv /dev/md0 -l1 -n2 -e1.0 /dev/ram0 /dev/ram1
>>>>
>>>>        3. mdadm /dev/md0 -f /dev/ram0
>>>>        4. mdadm /dev/md0 -r /dev/ram0
>>>>
>>>>        5. echo "10000 100" > /sys/block/md0/md/dev-ram1/bad_blocks
>>>>        6. echo "write_error" > /sys/block/md0/md/dev-ram1/state
>>>>
>>>>        7. mkfs.xfs /dev/md0
>>
>> Do we need this step7 here?
> 
> I confirmed myself. The answer is yes.
>>
>>>>        8. mdadm --examine-badblocks /dev/ram1  # Bad block records can be seen
>>>>           Bad-blocks on /dev/ram1:
>>>>                       10000 for 100 sectors
>>>>
>>>>        9. mdadm /dev/md0 -a /dev/ram2
>>>>           mdadm: add new device failed for /dev/ram2 as 2: Invalid argument
>>>
>>> Can you add a new regression test as well?
>>>
>>>>
>>>> When adding a disk to a RAID1 array, the metadata is read from the existing
>>>> member disks for synchronization. However, only the bad_blocks flag are copied,
>>>> the bad_blocks records are not copied, so the bad_blocks records are all zeros.
>>>> The kernel function super_1_load() detects bad_blocks flag and reads the
>>>> bad_blocks record, then sets the bad block using badblocks_set().
>>>>
>>>> After the kernel commit 1726c7746("badblocks: improve badblocks_set() for
>>>> multiple ranges handling"), if the length of a bad_blocks record is 0, it will
>>>> return a failure. Therefore the device addition will fail.
>>
>> Can you give the specific function replace with "it will return a failure" here?
> 
> I know, you mean badblocks_set which is called in super_1_load. It's
> better to describe clearly in a commit message.
>>
>>>>
>>>> So, don't set the bad_blocks flag when initializing the metadata, kernel can
>>>> handle it.
>>>>
>>>> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
>>>> ---
>>>>    super1.c | 3 +++
>>>>    1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/super1.c b/super1.c
>>>> index fe3c4c64..03578e5b 100644
>>>> --- a/super1.c
>>>> +++ b/super1.c
>>>> @@ -2139,6 +2139,9 @@ static int write_init_super1(struct supertype *st)
>>>>                if (raid0_need_layout)
>>>>                        sb->feature_map |= __cpu_to_le32(MD_FEATURE_RAID0_LAYOUT);
>>>>
>>>> +             if (sb->feature_map & MD_FEATURE_BAD_BLOCKS)
>>>> +                     sb->feature_map &= ~__cpu_to_le32(MD_FEATURE_BAD_BLOCKS);
>>>
>>> There are also other flags that is per rdev, like MD_FEATURE_REPLACEMENT
>>> and MD_FEATURE_JOURNAL, they should be excluded as well.
>>
>> Hmm, why do we need to remove these flags too? It's better to use a
>> separate patch rather than using this patch and describe it in detail.
>> It's better to give an example also.

This MD_FEATURE_REPLACEMENT should be removed, because this is per-rdev
flag, means this rdev is an replacement, and this should never be copied
to new rdev:

         if (le32_to_cpu(sb->feature_map) & MD_FEATURE_REPLACEMENT)
                 set_bit(Replacement, &rdev->flags);

This is exactaly the same as MD_FEATURE_BAD_BLOCKS, means this rdev has
bad blocks.

And I'm wrong about MD_FEATURE_JOURNAL, this doesn't not mean this rdev
is journal.

Thanks,
Kuai

> 
> Please answer this question.
> 
> Regards
> Xiao
>>
>> Best Regards
>> Xiao
>>>
>>> Thanks,
>>> Kuai
>>>
>>>> +
>>>>                sb->sb_csum = calc_sb_1_csum(sb);
>>>>                rv = store_super1(st, di->fd);
>>>>
>>>
>>>
> 
> 
> .
> 

