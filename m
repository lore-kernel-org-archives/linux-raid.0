Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B078C30F816;
	Tue,  6 Jan 2026 11:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767698083; cv=none; b=ezocDrhxobszljHDanmDxzt7d+KqI59UOVsuDCYj7Iy2NK17Yq8NRX2X0j9i8PSeclcbOj6wTUGiRPkyZMwgYUT01/qTBQqppZcDX626Nc/Lu9BoqFCCUwtiNFRwIuXeZRx1Sk/fcGDpX6YTRTUaJvW60NnFLsIX35bAvqoqZXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767698083; c=relaxed/simple;
	bh=qZ+/TwKzMWbPfhebYsFiJQYkKldKKQ8YmqLsInRWHpc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fTZ3nTONvv8DPWJ4K/TTo5vQ1b/yDdF3RcRudioreBnfSfqqdwYjdCdV9nl+UsdKY0+SLrZdk51H4qkxsOvEoxB8TbUZNwz8QXhZqtcz39Yl+fH0nXVnRZZKaYfeZS/iDmj7jIRvCldpWCJ8dSnZu3dYUox+w9PupJTKQ0AyEpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dlpSd25LmzYQvPX;
	Tue,  6 Jan 2026 19:13:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AF5574056C;
	Tue,  6 Jan 2026 19:14:37 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPmb7lxp+jVTCw--.10166S3;
	Tue, 06 Jan 2026 19:14:37 +0800 (CST)
Message-ID: <3a3f341e-fe6f-1c5c-a435-beafc9307ea1@huaweicloud.com>
Date: Tue, 6 Jan 2026 19:14:35 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 1/2] md: Don't set MD_BROKEN for RAID1 and RAID10 when
 using FailFast
To: Xiao Ni <xni@redhat.com>, Li Nan <linan666@huaweicloud.com>
Cc: Kenta Akagi <k@mgml.me>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai@fnnas.com>, Shaohua Li <shli@fb.com>,
 Mariusz Tkaczyk <mtkaczyk@kernel.org>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260105144025.12478-1-k@mgml.me>
 <20260105144025.12478-2-k@mgml.me>
 <7944a042-2e1e-1487-1b42-529768afbbd0@huaweicloud.com>
 <CALTww2_j--2wA16=eM=2V8XXghwWrH9ARwi9vizZ0TOT3LnXnA@mail.gmail.com>
 <e32e34aa-bc07-25bd-f361-424ec01c14d1@huaweicloud.com>
 <CALTww2-6F8+TMqLTzQYEhSiWL+cFLn4JQqd1GXai5ekTxo8=3w@mail.gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <CALTww2-6F8+TMqLTzQYEhSiWL+cFLn4JQqd1GXai5ekTxo8=3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPmb7lxp+jVTCw--.10166S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4fCw1xAr1furW5Gw1rJFb_yoWrGry8pa
	y8Ja1qkFs8JFy5tw4jgryUXa4Fvr47JrW3Wr15C342gwn0yr1ftr4jgr1Y9Fyjyr1ruFyU
	tw4UK343Zas8ZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU6c_3UUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/6 17:25, Xiao Ni 写道:
> On Tue, Jan 6, 2026 at 5:11 PM Li Nan <linan666@huaweicloud.com> wrote:
>>
>>
>>
>> 在 2026/1/6 15:59, Xiao Ni 写道:
>>> On Tue, Jan 6, 2026 at 10:57 AM Li Nan <linan666@huaweicloud.com> wrote:
>>>>
>>>>
>>>>
>>>> 在 2026/1/5 22:40, Kenta Akagi 写道:
>>>>> After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
>>>>> if the error handler is called on the last rdev in RAID1 or RAID10,
>>>>> the MD_BROKEN flag will be set on that mddev.
>>>>> When MD_BROKEN is set, write bios to the md will result in an I/O error.
>>>>>
>>>>> This causes a problem when using FailFast.
>>>>> The current implementation of FailFast expects the array to continue
>>>>> functioning without issues even after calling md_error for the last
>>>>> rdev.  Furthermore, due to the nature of its functionality, FailFast may
>>>>> call md_error on all rdevs of the md. Even if retrying I/O on an rdev
>>>>> would succeed, it first calls md_error before retrying.
>>>>>
>>>>> To fix this issue, this commit ensures that for RAID1 and RAID10, if the
>>>>> last In_sync rdev has the FailFast flag set and the mddev's fail_last_dev
>>>>> is off, the MD_BROKEN flag will not be set on that mddev.
>>>>>
>>>>> This change impacts userspace. After this commit, If the rdev has the
>>>>> FailFast flag, the mddev never broken even if the failing bio is not
>>>>> FailFast. However, it's unlikely that any setup using FailFast expects
>>>>> the array to halt when md_error is called on the last rdev.
>>>>>
>>>>
>>>> In the current RAID design, when an IO error occurs, RAID ensures faulty
>>>> data is not read via the following actions:
>>>> 1. Mark the badblocks (no FailFast flag); if this fails,
>>>> 2. Mark the disk as Faulty.
>>>>
>>>> If neither action is taken, and BROKEN is not set to prevent continued RAID
>>>> use, errors on the last remaining disk will be ignored. Subsequent reads
>>>> may return incorrect data. This seems like a more serious issue in my opinion.
>>>>
>>>> In scenarios with a large number of transient IO errors, is FailFast not a
>>>> suitable configuration? As you mentioned: "retrying I/O on an rdev would
>>>> succeed".
>>>
>>> Hi Nan
>>>
>>> According to my understanding, the policy here is to try to keep raid
>>> work if io error happens on the last device. It doesn't set faulty on
>>> the last in_sync device. It only sets MD_BROKEN to forbid write
>>> requests. But it still can read data from the last device.
>>>
>>> static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>> {
>>>
>>>       if (test_bit(In_sync, &rdev->flags) &&
>>>           (conf->raid_disks - mddev->degraded) == 1) {
>>>           set_bit(MD_BROKEN, &mddev->flags);
>>>
>>>           if (!mddev->fail_last_dev) {
>>>               return;  // return directly here
>>>           }
>>>
>>>
>>>
>>> static void md_submit_bio(struct bio *bio)
>>> {
>>>       if (unlikely(test_bit(MD_BROKEN, &mddev->flags)) && (rw == WRITE)) {
>>>           bio_io_error(bio);
>>>           return;
>>>       }
>>>
>>> Read requests can submit to the last working device. Right?
>>>
>>> Best Regards
>>> Xiao
>>>
>>
>> Yeah, after MD_BROKEN is set, read are forbidden but writes remain allowed.
> 
> Hmm, reverse way? Write requests are forbidden and read requests are
> allowed now. If MD_BROKEN is set, write requests return directly after
> bio_io_error.
> 
> Regards
> Xiao
> 

Apologies for the typo... The rest of the content was written with this
exact meaning in mind.

>> IMO we preserve the RAID array in this state to enable users to retrieve
>> stored data, not to continue using it. However, continued writes to the
>> array will cause subsequent errors to fail to be logged, either due to
>> failfast or the badblocks being full. Read errors have no impact as they do
>> not damage the original data.
>>

-- 
Thanks,
Nan

