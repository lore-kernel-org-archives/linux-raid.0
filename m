Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EEE52B1F2;
	Tue,  8 Sep 2026 18:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788891972; cv=none; b=Q95beOSBNwQsvZR/GUrkMXAuQmovQrRnQKdZ4bEdRYadUDctGEBfkLj8xD6MKfjobvWL9cUwLxl8DQskGOQBFdsmITpFq6283JsFhNj9NEkh2+EH3cljE/0I4QgHpzFDdwHeqnxvlGfpT91TsnrsgT1hFJ0/Q7re0WDNJ9Yfep8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788891972; c=relaxed/simple;
	bh=JotacaC8Yi6RB3Wh1xuZinZf/eembXM8GBApBE0Q6J8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=npmRjVcrAoc35fhZTCbih0i8L1aeme7ZO5KgG1OYKH/kk7sL0Srbfp4JJekoh+SR50pxZZwjhYCFow1BZESlxoURnXmqe34qKnQuT3j7Y2gT2/jVEi98ClUtIoZ2/VzKcU/V/IE8DSk3A0Ifh8t6xDqLGIQPvuOahpqrFNAxlCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SM4eteF3; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SM4eteF3"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688F1gkO080739;
	Tue, 8 Sep 2026 18:25:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=RvgaXF
	H6uOhXgX48Gwaka3u/f8LEurm0LC9LjU6CT+U=; b=SM4eteF3Ab47gTuP78zAsC
	JeoHEnWCt6GgWYFNDplzlQD8594SytEigB81ok+qt5p2TwClMzyUETbs5BCYj/dS
	kUNL7SeQOb7WLJFz6DRe903m5N2VI0Ai6aTY5B06YGN6jhc3mxmHnNSJi9Kj1Ewk
	mgOiXbXLcLObzsM6ZaCwprrDJa8eeAuB8j8ZMEZh4I6kBCbn+EdvBXwk3e7moEvu
	mz31PMToCCfcj/q0iFGAkngou+Rm9xTXvlTtG1Da601fo6MX9BGXI7YfpIhhHbK0
	JH/zSXJFQaJbJbUXsNVkngQw1uxfWJZAFmHE0wtsR1+ef7Cp1H5k6swe8ZgcpJZQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbjrrt3u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Sep 2026 18:25:55 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 688IBGrm015513;
	Tue, 8 Sep 2026 18:25:54 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ggwsw5sey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Sep 2026 18:25:54 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 688IPrpR24707834
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 8 Sep 2026 18:25:53 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8001A58062;
	Tue,  8 Sep 2026 18:25:53 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 51DE058054;
	Tue,  8 Sep 2026 18:25:50 +0000 (GMT)
Received: from [9.61.40.182] (unknown [9.61.40.182])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  8 Sep 2026 18:25:50 +0000 (GMT)
Message-ID: <70108fa1-d290-44d9-966f-b50a220562cf@linux.ibm.com>
Date: Tue, 8 Sep 2026 23:55:48 +0530
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] md: don't wait for q->limits_lock while md holds back
 I/O
To: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Cc: abd.masalkhi@gmail.com, linux-raid <linux-raid@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>, Song Liu <song@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>, Yu Kuai <yukuai@fygo.io>,
        tom.leiming@gmail.com
References: <20260907133929.1081540-1-jinpu.wang@ionos.com>
 <e6ad5b61-0ba2-49fa-96c7-e821defe45a7@linux.ibm.com>
 <CAMGffEmKrqcxYAtdTxg6GnwwFjJJg50wxpTfBobps-_QwQAoGg@mail.gmail.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <CAMGffEmKrqcxYAtdTxg6GnwwFjJJg50wxpTfBobps-_QwQAoGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=E7T9Y6dl c=1 sm=1 tr=0 ts=6aa05333 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=UgJECxHJAAAA:8 a=ymsFPWhVC54ODViv0ewA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=-El7cUbtino8hM1DCn8D:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE5NiBTYWx0ZWRfX2/xszqn6q+cm
 HuynDT+87VNeE114lHHA6Okmj58Cj8j4ivXajmXunSjdJ47b1uBBdL9eE0UhI+lbmzr6dD/dBT3
 ioswykhE3TpQZjHmq3ozn1xUi9uPPRQ=
X-Proofpoint-ORIG-GUID: X3KH50dQw882Km4FrvIbuPD4rN2jbXzf
X-Proofpoint-GUID: D5c61sM_gB0ibo8SEeViA1o2HxIfVVjD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE5NiBTYWx0ZWRfX47zNikqvAGJT
 0dDWkWLxGwInMSU/y4PCTD7ujD8O/nMgSSp3rMknYQQT0+DnV5NkATMo7D24f5cqgSqhKvRIUym
 MkEJgy4PaEqPFfU3/8+iYpU+zjqTBcGn9CFDDGnQL+jYYgenE1vJqOSn+vpoUYz53kysfPqsE9p
 Ki6Vf7/fKJg8r4mr3lHn3YNlJI7taKtNsgmyrfu6dKqPvAOKmDvKILMtupk+3jNje/LXBTkLK/r
 U7mEPaTeHbxtR8GplgG8hfwttyQPrLYJ3WGjN4AWx6iCNz1gmy3L069VGMgsxImJXEG41P6Mf5J
 ExPyhnx4jxsmGo6h1jcsZNazZ7WagtQUG9wnaM6bsqnLjP+Wg0/fwGPpRhxbHfb1rBft9IwhD7A
 aFeyyCw7B/AsFURf9naPPQC1P2F2+glWexGKSYtRrO0p2/Ey7WBN5EUZQCXmrZ320dtRI6Atnj5
 cdzwr2/IQgu3xkqfWFw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080196

On 9/8/26 5:39 PM, Jinpu Wang wrote:
> On Tue, Sep 8, 2026 at 1:16 PM Nilay Shroff <nilay@linux.ibm.com> wrote:
>>
>> On 9/7/26 7:09 PM, Jack Wang wrote:
>>> From: Jack Wang<jinpu.wang@cloud.ionos.com>
>>>
>>> Writing to a queue limits attribute of an md array while a spare is
>>> being re-added deadlocks the array.  I reported this earlier here:
>>>
>>>     https://lore.kernel.org/linux-raid/CAMGffE=heGA3y8FjQ0Sm1jj-kd-=H9Y54WozKASSEZhc9UNKjA@mail.gmail.com/
>>>
>>> Four tasks, one array:
>>>
>>>     udev-worker    queue_attr_store() holds q->limits_lock, waits in
>>>                    blk_mq_freeze_queue() for q_usage_counter to drain
>>>     fio            holds a q_usage_counter reference, parked in
>>>                    md_handle_request()'s is_suspended() loop
>>>     mdadm          suspended the array, waits for reconfig_mutex
>>>     md_start_sync  holds reconfig_mutex, waits for q->limits_lock
>>>
>>> The last leg is mddev_stack_new_rdev() from ->hot_add_disk().  Since
>>> commit c99f66e4084a ("block: fix queue freeze vs limits lock order in
>>> sysfs store methods") the sysfs store holds q->limits_lock across the
>>> freeze, so md must not block on that lock while it is holding back the
>>> I/O the freeze waits for.  That is the same hazard mddev_suspend()
>>> already documents for reconfig_mutex.
>>>
>>> The rule this series applies is that q->limits_lock nests outside both
>>> reconfig_mutex and the suspend.  Where md cannot arrange that, because
>>> it is called with reconfig_mutex already held or from the sync thread,
>>> it takes the update with a trylock and does without one on a contended
>>> pass.
>>>
>>> Patches 1, 2 and 4 are plumbing with no functional change.  Patches 3
>>> and 5 convert the two callers that cannot own an update.  Patch 6 does
>>> the hoists, all in one patch because a mix of the two lock orders is an
>>> ABBA.
>>>
>>> Two callers still take q->limits_lock inside reconfig_mutex, both with
>>> the array suspended, and patch 6 says why: ->start_reshape() from
>>> action_store(), which suspends before flushing sync_work, and
>>> raid*_run() -> queue_limits_set() from level_store(), which already
>>> hangs on its own because it freezes the queue while suspended.  Both
>>> need more restructuring than belongs here.
>>>
>>> The patches are based on v7.3-rc2.
>>>
>>> Tested there with a raid1 of two ram devices, fio in flight and a loop
>>> writing queue/max_sectors_kb: 20 fail/remove/add cycles complete,
>>> where the same test wedges the array before the series.  Every patch
>>> builds on its own.  A reshape and a level change are not covered by that
>>> test.
>>
>> Overall, I think the direction looks good. With this series, we now have the
>> locking order where q->limits_lock is acquired before the suspend and
>> reconfig_mutex.
>>
>> However, when I ran these changes through blktests, I hit the lockdep splat[1],
>> which exposes an ABBA dependency between disk->open_mutex and q->limits_lock.
>>
>> Looking at the existing dependency chain, disk->open_mutex is expected to
>> be acquired before q->limits_lock. However, with this change, md_ioctl()
>> acquires q->limits_lock first and subsequently reaches md_import_device(),
>> which acquires disk->open_mutex. This reverses the existing lock ordering
>> and introduces the ABBA dependency, so I think this needs to be addressed.
>>
> 
> Thanks for running this through blktests.
> 
> You are right, and it is worse than the one path you hit.  The import is
> not the only offender: everything in the mddev->pers branch of
> md_add_new_disk() that opens or closes a component device runs with
> q->limits_lock held.  Besides md_import_device() there are four
> export_rdev() calls and one md_kick_rdev_from_array(), and export_rdev()
> ends in fput(rdev->bdev_file), so it takes disk->open_mutex too.
> rdev_attr_store() looks like a second instance: it starts the update for
> every state_store() write, and "remove" reaches
> md_kick_rdev_from_array().
> 

I think fput() doesn't immediately release the blkdev, as the final __fput()
is deferred through task work or delayed fput work. So that shouldn't be an
issue here. Also, md_kick_rdev_from_array() defers the cleanup until
mddev_unlock(). mddev_unlock() should be called after we release
q->limits_lock, so this should not be an issue here.

> So the rule needs to be stronger than what I wrote: q->limits_lock nests
> outside reconfig_mutex and the suspend, and must not be held across any
> component device open or close.
> 
> Two ways to get there, and I would rather hear which you prefer before
> respinning:
> 
> 1) Keep the lock outermost, move the open and close out from under it.
>     md_ioctl() imports before taking q->limits_lock and releases after
>     committing and unlocking; md_add_new_disk() hands the rdev back
>     instead of exporting it.  The import then runs without
>     reconfig_mutex, so the superblock format fields need a snapshot and a
>     recheck under the lock.  Only the mddev->pers branch needs this, the
>     other two never reach add_bound_rdev().
> 
> 2) Drop the hoist for ADD_NEW_DISK and stack the leg after resume, with
>     q->limits_lock on its own.  Much smaller, but the leg is live before
>     its limits are stacked and the integrity rejection lands after the
>     add rather than before it.
> 
> Is there a better option?  If ->hot_add_disk() is meant to be callable
> with an update already in flight, that limits how far the open and close
> can move.

I think moving q->limits_lock after md_import_device() in the mddev->pers
branch looks reasonable to me. This reduces code churn, and we can acquire
q->limits_lock after md_import_device() returns, before proceeding with
the queue-limit update.

We should also move the device suspend until after q->limits_lock is acquired
for ADD_NEW_DISK, so that we maintain the intended ordering of q->limits_lock
and suspend.

This also ensures that q->limits_lock is not held across component-device
open/import, avoiding the disk->open_mutex -> q->limits_lock dependency
reversal reported by lockdep.

Thanks,
--Nilay

