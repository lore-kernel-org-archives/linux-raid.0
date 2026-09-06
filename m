Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DEC2AD37;
	Sun,  6 Sep 2026 12:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788698013; cv=none; b=PdJFSgdSH4cBF6s93KQ6+SWYqTdLII3GyS9cjiSsC8j1weGlDOs72W1sbK3PSmTpJdO5AtobuIZxJgLtK3y+UuH5bEnuoSDDiW6+8UPU8z9YmivdZ4mVv3aeyH/WGkmt5lpNH4rdvDKCn75xz5TuXrV8E09z8UaNsXW0e+BZ0RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788698013; c=relaxed/simple;
	bh=somuM+eaMEnkiwPnFSuej0Dm93sycak+aJ93yAV6124=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V1yq+199jlwP9haCq1tcupQXIXTMmlrI1XIOnWjTK0iBhsC5c6v5G3m74eY1MFUDDR6V8mf18SLFUibDPHsQr52gMPnmzQ+uxsph+MxAVruxN9rSdl1D5PrvE3hu0XnHHbgRqCbnB4fkhC67ExpGxMXcLVVmm39kSnSBHe6GScU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ODmwNUKb; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ODmwNUKb"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6861ZRJ11939195;
	Sun, 6 Sep 2026 12:33:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=2NpOcW
	ftRxphBVO0G/hFO2XB1PP0Jv8MMg3hYGnnECo=; b=ODmwNUKbWSgIrtVfbuJNea
	A2EtaQoteHnAnZJ0DX8F68a8UBslTNSjhz5wdr16HsuFds7ZFpckClLV18ajBBgf
	kYHAP+gfmiJqncg6M/YqPrENBrjaLsM216TeVZ4WHhtLU+jX75WLIdS7UOxewHYn
	7Y0/yrtYgGvnZ1rxfzb1A73RU1M8bPs5OdgEV2IKcXNsHY3UfgdiWtpLkRraI25I
	0OcZbwT3LNXN1Cr0J7CwHiTv+3IQ9vciQLR4SiqhBESKT8iXJUAtwfangbuLH3LL
	vyOqq5JBaRR7ZDm+QzGSyAxlAh8ktAAvt0z1tjH2pqDppBcaToqxagKQjIYp2unA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbhem3qv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 06 Sep 2026 12:33:17 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 686CUwna011168;
	Sun, 6 Sep 2026 12:33:16 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ggxdjhd53-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 06 Sep 2026 12:33:16 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 686CXFSN20906706
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 6 Sep 2026 12:33:16 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E033C58056;
	Sun,  6 Sep 2026 12:33:15 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0EAAC58052;
	Sun,  6 Sep 2026 12:33:13 +0000 (GMT)
Received: from [9.61.37.159] (unknown [9.61.37.159])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sun,  6 Sep 2026 12:33:12 +0000 (GMT)
Message-ID: <41929544-cae1-4c94-95f1-9a7058d741b1@linux.ibm.com>
Date: Sun, 6 Sep 2026 18:03:11 +0530
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] md/raid1: deadlock between a queue limits sysfs store and a
 spare re-add
To: Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Damien Le Moal <dlemoal@kernel.org>
References: <CAMGffEn0RcbyEcgCCVdxEf8Zwd6hnrjnYPdqrMsf8TL8qEBKRA@mail.gmail.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <CAMGffEn0RcbyEcgCCVdxEf8Zwd6hnrjnYPdqrMsf8TL8qEBKRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GRQpuG5raK5bOgbrdtZsVnbjkSBSz2q2
X-Authority-Analysis: v=2.4 cv=RIaD2Yi+ c=1 sm=1 tr=0 ts=6a9d5d8d cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=mkmGXtlolwtV-ghP:21 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22
 a=A1Vf8vhOEPj2D0dwdewA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA2MDEzOSBTYWx0ZWRfXyN2q7f2QGsnD
 8n6889PycSuFmrpKTkNxZoeJDbci2mxV858z5shXU9flMaBW1uUTkKwClAYOVWg1kQatOURPopr
 CPKlkLrLSo396AKujdtE+07wviP2BFY=
X-Proofpoint-ORIG-GUID: GRQpuG5raK5bOgbrdtZsVnbjkSBSz2q2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA2MDEzOSBTYWx0ZWRfXzDwjUnNi9gIO
 aYzj1sBNbhMUa2nP+eEVSts/8IdSjbKUwZhJFbCByQlDsA49ctq2fG9dV/c1hbzne5zADsxATiU
 wGsha+aznVtasTvaidUpStd6BfsqN7NwBrhXUYsmkRKY6dygmpOlabf8jMA+wkfWUsiWtdYjgjQ
 NQzF6DbF8wopm/aw4WQeYv0r2K03ygrSipTNmnjxzHMNmTmjbU7DRDajjX5dyggR+nm6YgLBkt/
 lh11ghMLWBrxbsBdyLIHAoR/8TIstgBf38fKs/hJWPwDbe0bwIOQbFPkksSVvJBePvyrm2cCHg1
 n/GKvVeZYUxSR6vi7DCofyEz+ZngjjWIEV12WqPWJpel9+41QmZ9nrLBRJq2HkvHYyGp1LbYE4K
 yrpRPkjiI42baTkh139zBwEIDEI+jIPH6RPk9Gfi+GpPLYlAyuq2bygOZLjx6sE8h01jKkZhgbj
 LlosIHG4lxR4CgdUb2g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-05_08,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 adultscore=0 phishscore=0 clxscore=1011 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609060139

On 9/6/26 10:28 AM, Jinpu Wang wrote:
> Hi,
> 
> writing to a queue limit attribute of an md array while a spare is being
> re-added deadlocks the array, with three tasks left unkillable in D state.
> The host has to be rebooted to recover.
> 
> We hit this in production on 6.12.100 with RAID1 arrays, triggered by a
> udev rule writing queue/max_sectors_kb.  Reading the code, v7.2 looks
> affected too; see "Which versions" below for exactly what was tested and
> what was not.
> 
> The cycle
> =========
> 
> Three tasks, one array:
> 
>    udev-worker     queue_attr_store() holds q->limits_lock and waits in
>                    blk_mq_freeze_queue() for q_usage_counter to drain
> 
>    fio             holds a q_usage_counter reference, waits in
>                    md_handle_request()'s is_suspended() loop
> 
>    md_start_sync   holds mddev->suspended, waits for q->limits_lock
> 
> Nobody can proceed: the freeze needs the in-flight I/O to finish, that
> I/O needs mddev->suspended cleared, and clearing it needs the spare add
> to finish, which is blocked on the lock the first task holds.
> 
> The three legs in v7.2 (8d3ae59288f1):
> 
> block/blk-sysfs.c, queue_attr_store():
> 
> struct queue_limits lim = queue_limits_start_update(q);
> 
> res = entry->store_limit(disk, page, length, &lim);
> if (res < 0) {
> queue_limits_cancel_update(q);
> return res;
> }
> 
> res = queue_limits_commit_update_frozen(q, &lim);
> 
> queue_limits_start_update() takes q->limits_lock, and
> queue_limits_commit_update_frozen() calls blk_mq_freeze_queue() with it
> still held.  max_sectors_kb is a QUEUE_LIM_RW_ENTRY, so a plain
> 
> echo 1024 > /sys/block/mdN/queue/max_sectors_kb
> 
> reaches this path.
> 
> drivers/md/md.c, md_start_sync():
> 
> if (mddev->reshape_position == MaxSector &&
>     md_spares_need_change(mddev)) {
> suspend = true;
> mddev_suspend(mddev, false);
> }
> 
> mddev_lock_nointr(mddev);
> 
> and from there md_choose_sync_action() -> remove_and_add_spares() ->
> ->hot_add_disk() -> raid1_add_disk() -> mddev_stack_new_rdev(), which
> does a blocking
> 
> lim = queue_limits_start_update(mddev->gendisk->queue);
> 
> while mddev->suspended is set.
> 
> drivers/md/md.c, md_handle_request(), where the in-flight I/O waits:
> 
> if (is_suspended(mddev, bio)) {
> ...
> wait_event(mddev->sb_wait, !is_suspended(mddev, bio));
> 
> So md acquires q->limits_lock while holding a quiescing primitive that
> blocks exactly the I/O a concurrent freeze is waiting to drain.
> 
> Backtraces
> ==========
> 
>  From a 6.12.100 based kernel:
> 
>    INFO: task kworker/2:2 blocked for more than 184 seconds.
>    Workqueue: md_misc md_start_sync [md_mod]
>    Call Trace:
>     __mutex_lock.constprop.0+0x31c/0x6d0
>     mddev_stack_new_rdev+0x59/0x150 [md_mod]
>     raid1_add_disk+0x97/0x180 [raid1]
>     remove_and_add_spares+0xe8/0x230 [md_mod]
>     md_start_sync+0x14c/0x3e0 [md_mod]
>     process_one_work+0x162/0x370
> 
>    INFO: task (udev-worker) blocked for more than 184 seconds.
>    Call Trace:
>     blk_mq_freeze_queue_wait+0x9e/0xd0
>     queue_limits_commit_update_frozen+0x12/0x40
>     queue_attr_store+0xc9/0x1c0
>     kernfs_fop_write_iter+0x133/0x220
>     vfs_write+0x29c/0x450
> 
>    INFO: task fio blocked for more than 184 seconds.
>    Call Trace:
>     md_handle_request+0x10d/0x2b0 [md_mod]
>     __submit_bio+0x23e/0x2f0
>     submit_bio_noacct_nocheck+0x1a3/0x3c0
>     blkdev_direct_IO+0x265/0x5d0
> 
> /proc/mdstat at that point, with the spare add never completing:
> 
>    md0 : active raid1 rnbd0[0] rnbd1[1](S)
>          5238784 blocks super 1.2 [2/1] [U_]
> 
> Reproducer
> ==========
> 
> On a scratch machine, with two ram devices:
> 
>    mdadm -C /dev/md111 --force -e 1.2 --assume-clean -l 1 \
>          --bitmap=internal -n 2 /dev/ram0 /dev/ram1
> 
>    # keep I/O in flight
>    fio --direct=1 --rw=randrw --ioengine=libaio --iodepth=32 --numjobs=4 \
>        --time_based=1 --runtime=180 --filename=/dev/md111 --name=repro &
> 
>    # stand in for the udev worker
>    while :; do
>        echo 128 > /sys/block/md111/queue/max_sectors_kb 2>/dev/null
>    done &
> 
>    # drive spare re-adds
>    for i in $(seq 20); do
>        mdadm /dev/md111 --fail /dev/ram0
>        mdadm /dev/md111 --remove /dev/ram0
>        mdadm /dev/md111 --add /dev/ram0
>        mdadm --wait /dev/md111
>    done
> 
> It reproduced on the first iteration for us, though it is a race, so it
> may need a few attempts on other machines.
> 
> Which versions
> ==============
> 
> Reproduced: 6.12.100 (distro kernel carrying the stable backport of
> c99f66e4084a), RAID1, repeatedly, on several hosts.
> 
> Not reproduced, code inspection only: v7.2 (8d3ae59288f1).  All three
> legs quoted above are from the v7.2 tree and are unchanged there, so it
> looks affected, but we have not run the reproducer on a mainline build.
> Happy to do that if it helps.
> 
> raid10 calls mddev_stack_new_rdev() from raid10_add_disk() in the same
> way, so it looks exposed too; we have only tested raid1.
> 
> When it started
> ===============
> 
> Before commit c99f66e4084a ("block: fix queue freeze vs limits lock
> order in sysfs store methods"), queue_attr_store() froze the queue first
> and took limits_lock afterwards, so limits_lock was never held across the
> freeze wait and this cycle could not form.  That commit moved the freeze
> inside queue_limits_commit_update_frozen(), i.e. under limits_lock:
> 
>    Fixes: c99f66e4084a ("block: fix queue freeze vs limits lock order
> in sysfs store methods")
> 
> That is not an argument for reverting it: it exists so sd_revalidate_disk()
> can issue SCSI commands while holding the limits lock, which cannot work
> on a frozen queue.  The md side is on the wrong side of the ordering the
> block layer expects, as spelled out in commit 06a2ff603f1f ("loop: Fix
> recently introduced lock inversion"): all block driver code takes
> queue_limits_start_update() before freezing.  md instead takes a
> quiescing primitive of its own first.
> 
> What we are running
> ===================
> 
> We fixed it on the md side, by taking the limits update in
> md_start_sync() before mddev_suspend(), threading the queue_limits
> through ->hot_add_disk() so the personality stacks into it without
> taking the lock itself, and committing before resuming, so the update
> still lands while the array is quiesced.  That removes the inversion
> without touching the shared block layer code.
> 
I think you nailed it. We settled on the locking order in the block layer
with commit c99f66e4084a ("block: fix queue freeze vs limits lock order in
sysfs store methods"), where we now acquire q->limits_lock before
freezing the queue. This ordering is followed by the block layer code that
updates queue limits, while md appears to be an exception since it still
uses mddev_suspend() to stall I/O instead of blk_mq_freeze_queue().

So to me, your proposed approach looks reasonable: acquire
q->limits_lock first and then call mddev_suspend(). This should avoid
the lock inversion described above while still allowing the queue limits
update to be performed while the array is quiesced.

> Two approaches we tried first and discarded, in case they save someone
> the detour:
> 
> - mutex_trylock() in mddev_stack_new_rdev() with a retry on contention.
>    A writer that keeps retaking limits_lock wins nearly every time, so
>    the retry does not converge: we measured 1132 backoffs against 1
>    success, the array staying degraded with an idle spare throughout, and
>    md_check_recovery() suspending and resuming the array on every pass.
> 
> - Dropping limits_lock around the freeze wait inside
>    queue_limits_commit_update_frozen().  This works, but it inverts the
>    ordering the block layer has standardised on, and a concurrent update
>    committing in the window is then silently overwritten.
> 
> We can post the md-side patch if that direction looks right, or defer to
> whatever you prefer.  Reproducer script and the full logs are available.
> 
I think you should send out the md-side changes so that others can review the
locking changes and comment on the approach.

Thanks,
--Nilay


