Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A1E51E420;
	Tue,  8 Sep 2026 11:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788866188; cv=none; b=qtr0SygdbOs84bfGofdILNTY8VsBcfS11gsl7QTvQs99o2y8Yne6UwKCEjZUZmiIxbo/bmEiKus4/K5Qs/F7CLW6Ph45HmBKfI60HAXqZpNSKhi+g8ktHI76cXPcNQwKA5+J8hIyCYBNns8bWAMig9UWG18DmO2c1tgxs/Num/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788866188; c=relaxed/simple;
	bh=ukWda3sQpe2UydN7SWq7N60urKJgxTCzO7x956cGMeA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KBxSubTS6s8AJ7+i2BpYAk1vfCCe6NgUOUsJAJEmnLiGmnVbAKO8FfbJTwqkKNOaWrqi8WPcjYMOYZziZXicdZeq2BlbuWc1TeW4w3BeTObvD1bVzpIkmgJLSQH6vKTHfUMjgOsQlr+auumGh0dCmlSshFbtRzjGN0P0yylixSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Hqs1MRAg; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Hqs1MRAg"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688AVdAW641762;
	Tue, 8 Sep 2026 11:16:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=yQxjK5
	qBjDmFrDgWsSBuUckS2l88boNgtBsEhHEge/4=; b=Hqs1MRAgW/V9nRXPEhRjm1
	tEhZb5sSHNQPG0U96xAwAJRW13RnBWoj0ClHSIA6zkNIDkmH6CPhtAl/DipATGIL
	3yGpYSGxuACdjGHazJech9qsdoDmVGBUhwhTFU4aUUKJY/khzrLdUoroOnnB6FC4
	JL8MYUIV4s3Ou+M/d4XBHrF+mUBU+KhJ96l+nkaGr7Hx42jc4qRQdNL7bH9eDXos
	D9RCk+gyG2vr3DdluodTdUxyk8k2vumltu55J4LS08Phhw+xCJkErMOKNUMde1mB
	1CyE28UKSQq2U+y6P87t6oPAwKrZtVxbG64E4mtqJhQQEEcoveBo8PvtIIg15h3g
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbhkpfad-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Sep 2026 11:16:02 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 688BBJVB014838;
	Tue, 8 Sep 2026 11:16:01 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ggwdqbjre-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Sep 2026 11:16:01 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 688BG15X27788008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 8 Sep 2026 11:16:01 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2769358066;
	Tue,  8 Sep 2026 11:16:01 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CE9FA5805D;
	Tue,  8 Sep 2026 11:15:57 +0000 (GMT)
Received: from [9.61.40.182] (unknown [9.61.40.182])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  8 Sep 2026 11:15:57 +0000 (GMT)
Message-ID: <e6ad5b61-0ba2-49fa-96c7-e821defe45a7@linux.ibm.com>
Date: Tue, 8 Sep 2026 16:45:56 +0530
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] md: don't wait for q->limits_lock while md holds back
 I/O
To: Jack Wang <jinpu.wang@ionos.com>, abd.masalkhi@gmail.com
Cc: linux-raid <linux-raid@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>, Song Liu <song@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>, Yu Kuai <yukuai@fygo.io>,
        tom.leiming@gmail.com, Jack Wang <jinpu.wang@cloud.ionos.com>
References: <20260907133929.1081540-1-jinpu.wang@ionos.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260907133929.1081540-1-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDExNyBTYWx0ZWRfX48JdSobunMrn
 YpYtnvdCwkb/xORpSuiQtnt1sZd3Z5u1plFEBIBCjMRBFV0TyqxApAmq7ci619W0mt0llbZ8yw3
 QQIorOMxXZktfvCJj5mhcNBi76Qgq+Q=
X-Proofpoint-ORIG-GUID: TOiKzpEhKUCrmAwyTdzVzodUldHbpQ6_
X-Authority-Analysis: v=2.4 cv=NMDlPU6g c=1 sm=1 tr=0 ts=6a9fee73 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=UgJECxHJAAAA:8 a=1-PxtTbHQn0DX_ZaItgA:9 a=QEXdDO2ut3YA:10
 a=-El7cUbtino8hM1DCn8D:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDExNyBTYWx0ZWRfX5ep1/8+X7YrE
 x5YpnIX3M1Q3xs3nvoz5RyXjMtbm0WBvbGRqwaAizw0zZfhn0clFxXkQVC90uujheelVecm8D5y
 0+smnQvedjU5KYisDKpsGnvDWCeXAlUFZTsloGUApt56MWh4ua2y1S25zNJ1/Bb46I6+t6K69Vp
 8CVN6L4Mztj91rv7vU9zfLA3QVn/ytz7eJGd20E+Zd+HKNKBeqyzBjjUQIvOxnPITCAaesHfCR5
 3erIuSV+rF89CbakphprnA5QHk+ycKtNUOKRDKJn47HAWHhmNBh7Reo9hfOwXLy96tMWSRGH6QY
 OgzgOCnvEUeMmFI/QPz3LjhLWw76YguMyZfW3012hSQfhxX5QuYMLM2ZUP4MWm4CuOapjtNzZPy
 ne1gAyxyiM28JIsp8G7uIu6kaqwIFgYZcSH5KxOFuX3wARPJxj8Ns2dS91hhUE2lgAtO3LEriNf
 5sPWyBMX1O8bi+NklUA==
X-Proofpoint-GUID: FF9qI-TEveaD-AxznJ2j46QRC8BHY3zF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_02,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 lowpriorityscore=0 clxscore=1011 adultscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080117

On 9/7/26 7:09 PM, Jack Wang wrote:
> From: Jack Wang<jinpu.wang@cloud.ionos.com>
> 
> Writing to a queue limits attribute of an md array while a spare is
> being re-added deadlocks the array.  I reported this earlier here:
> 
>    https://lore.kernel.org/linux-raid/CAMGffE=heGA3y8FjQ0Sm1jj-kd-=H9Y54WozKASSEZhc9UNKjA@mail.gmail.com/
> 
> Four tasks, one array:
> 
>    udev-worker    queue_attr_store() holds q->limits_lock, waits in
>                   blk_mq_freeze_queue() for q_usage_counter to drain
>    fio            holds a q_usage_counter reference, parked in
>                   md_handle_request()'s is_suspended() loop
>    mdadm          suspended the array, waits for reconfig_mutex
>    md_start_sync  holds reconfig_mutex, waits for q->limits_lock
> 
> The last leg is mddev_stack_new_rdev() from ->hot_add_disk().  Since
> commit c99f66e4084a ("block: fix queue freeze vs limits lock order in
> sysfs store methods") the sysfs store holds q->limits_lock across the
> freeze, so md must not block on that lock while it is holding back the
> I/O the freeze waits for.  That is the same hazard mddev_suspend()
> already documents for reconfig_mutex.
> 
> The rule this series applies is that q->limits_lock nests outside both
> reconfig_mutex and the suspend.  Where md cannot arrange that, because
> it is called with reconfig_mutex already held or from the sync thread,
> it takes the update with a trylock and does without one on a contended
> pass.
> 
> Patches 1, 2 and 4 are plumbing with no functional change.  Patches 3
> and 5 convert the two callers that cannot own an update.  Patch 6 does
> the hoists, all in one patch because a mix of the two lock orders is an
> ABBA.
> 
> Two callers still take q->limits_lock inside reconfig_mutex, both with
> the array suspended, and patch 6 says why: ->start_reshape() from
> action_store(), which suspends before flushing sync_work, and
> raid*_run() -> queue_limits_set() from level_store(), which already
> hangs on its own because it freezes the queue while suspended.  Both
> need more restructuring than belongs here.
> 
> The patches are based on v7.3-rc2.
> 
> Tested there with a raid1 of two ram devices, fio in flight and a loop
> writing queue/max_sectors_kb: 20 fail/remove/add cycles complete,
> where the same test wedges the array before the series.  Every patch
> builds on its own.  A reshape and a level change are not covered by that
> test.

Overall, I think the direction looks good. With this series, we now have the
locking order where q->limits_lock is acquired before the suspend and
reconfig_mutex.

However, when I ran these changes through blktests, I hit the lockdep splat[1],
which exposes an ABBA dependency between disk->open_mutex and q->limits_lock.

Looking at the existing dependency chain, disk->open_mutex is expected to
be acquired before q->limits_lock. However, with this change, md_ioctl()
acquires q->limits_lock first and subsequently reaches md_import_device(),
which acquires disk->open_mutex. This reverses the existing lock ordering
and introduces the ABBA dependency, so I think this needs to be addressed.

Please find the lockdep splat below for reference:

[1]
======================================================
WARNING: possible circular locking dependency detected
7.0.0+ #33 Not tainted
------------------------------------------------------
mdadm/15956 is trying to acquire lock:
c000000144f14358 (&disk->open_mutex){+.+.}-{4:4}, at: bdev_open+0x94/0x504

but task is already holding lock:
c000000122a13370 (&mddev->reconfig_mutex){+.+.}-{4:4}, at: md_ioctl+0xb18/0x1f44

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&mddev->reconfig_mutex){+.+.}-{4:4}:
        lock_acquire+0x16c/0x498
        __mutex_lock+0xc8/0xf1c
        md_ioctl+0xb18/0x1f44
        blkdev_ioctl+0x5e8/0x1950
        sys_ioctl+0x494/0x11c0
        system_call_exception+0x138/0x380
        system_call_vectored_common+0x15c/0x2ec

-> #1 (&q->limits_lock){+.+.}-{4:4}:
        lock_acquire+0x16c/0x498
        __mutex_lock+0xc8/0xf1c
        sd_revalidate_disk+0xe4/0x2d74 [sd_mod]
        sd_open+0x1a8/0x21c [sd_mod]
        blkdev_get_whole+0x54/0x124
        bdev_open+0x3cc/0x504
        bdev_file_open_by_dev+0x114/0x1b4
        disk_scan_partitions+0xc4/0x1d8
        add_disk_fwnode+0x1ec/0x1f0
        sd_probe+0x3a0/0x644 [sd_mod]
        scsi_bus_probe+0x38/0x5c
        really_probe+0x100/0x550
        __driver_probe_device+0xb4/0x224
        driver_probe_device+0x50/0x128
        __driver_attach_async_helper+0x78/0x14c
        async_run_entry_fn+0x5c/0x1f8
        process_one_work+0x2c0/0x8d0
        worker_thread+0x218/0x444
        kthread+0x16c/0x1a0
        start_kernel_thread+0x14/0x18

-> #0 (&disk->open_mutex){+.+.}-{4:4}:
        check_prev_add+0x170/0x1248
        __lock_acquire+0x17d0/0x2144
        lock_acquire+0x16c/0x498
        __mutex_lock+0xc8/0xf1c
        bdev_open+0x94/0x504
        bdev_file_open_by_dev+0x114/0x1b4
        md_import_device+0x15c/0x2c8
        md_add_new_disk+0x130/0x810
        md_ioctl+0x1840/0x1f44
        blkdev_ioctl+0x5e8/0x1950
        sys_ioctl+0x494/0x11c0
        system_call_exception+0x138/0x380
        system_call_vectored_common+0x15c/0x2ec

other info that might help us debug this:

Chain exists of:
   &disk->open_mutex --> &q->limits_lock --> &mddev->reconfig_mutex

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&mddev->reconfig_mutex);
                                lock(&q->limits_lock);
                                lock(&mddev->reconfig_mutex);
   lock(&disk->open_mutex);

  *** DEADLOCK ***

2 locks held by mdadm/15956:
  #0: c0000001629d6a18 (&q->limits_lock){+.+.}-{4:4}, at: md_ioctl+0xa74/0x1f44
  #1: c000000122a13370 (&mddev->reconfig_mutex){+.+.}-{4:4}, at: md_ioctl+0xb18/0x1f44

stack backtrace:
CPU: 3 UID: 0 PID: 15956 Comm: mdadm Kdump: loaded Not tainted 7.0.0+ #33 PREEMPTLAZY
Hardware name: IBM,9105-22A Power11 (architected) 0x820200 0xf000007 of:IBM,FW1120.00 (RB1120_179) hv:phyp pSeries
Call Trace:
[c00000015919f1e0] [c000000001303538] dump_stack_lvl+0xe8/0x150 (unreliable)
[c00000015919f210] [c0000000002f204c] print_circular_bug+0x44c/0x608
[c00000015919f2c0] [c0000000002f23d4] check_noncircular+0x1cc/0x1ec
[c00000015919f390] [c0000000002f3f9c] check_prev_add+0x170/0x1248
[c00000015919f450] [c0000000002f876c] __lock_acquire+0x17d0/0x2144
[c00000015919f580] [c0000000002f9f4c] lock_acquire+0x16c/0x498
[c00000015919f680] [c000000001371fcc] __mutex_lock+0xc8/0xf1c
[c00000015919f7d0] [c0000000009de664] bdev_open+0x94/0x504
[c00000015919f850] [c0000000009debe8] bdev_file_open_by_dev+0x114/0x1b4
[c00000015919f8a0] [c000000000e539a8] md_import_device+0x15c/0x2c8
[c00000015919f930] [c000000000e62718] md_add_new_disk+0x130/0x810
[c00000015919f9c0] [c000000000e6a3a0] md_ioctl+0x1840/0x1f44
[c00000015919fc30] [c000000000a185e4] blkdev_ioctl+0x5e8/0x1950
[c00000015919fd10] [c000000000823274] sys_ioctl+0x494/0x11c0
[c00000015919fe10] [c0000000000318d8] system_call_exception+0x138/0x380
[c00000015919fe50] [c00000000000cedc] system_call_vectored_common+0x15c/0x2ec

