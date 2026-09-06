Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60B32EC090
	for <linux-raid@vger.kernel.org>; Sun,  6 Sep 2026 13:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788700968; cv=none; b=Tyfb4TZ4RcrmaARSayOdCfZRk/BTkHLaBftK/HUwgsQ7h+PzJjVx4Qswj8iA1dBj2jSwzMVhyhDzEzIbGLFwkYWOfPJPdks9zBuxeiLwUI1yZ5NW/wdjHU4SN8WNAeyva3+ubfFHhMsOv8LqQllvtUB4+G7QVVVN+sIhi/o7o20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788700968; c=relaxed/simple;
	bh=TN48gfAD+iP/BbuTXiw3TGQX/mZeORvIfLXRz9gxCGI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=O8w5yEVdl0LIJMVpt+OYyAsG4gThYAYN6fO2v0IBmqrBUvT9IwU2aKMU+6c6pHQmnG7lZlEq9PCU9LKr9piloERnCi9RlsqqK0/Y14Ns6iQDB+tpAkoOwCd0pKDPgnl52fz8iR+mAH6y82QNTuG+/Po8GD2GOTJKYgaRrH2Wbo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fgIlrYA7; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fgIlrYA7"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49d0d2d37ceso1654345e9.0
        for <linux-raid@vger.kernel.org>; Sun, 06 Sep 2026 06:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788700965; x=1789305765; darn=vger.kernel.org;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xGMx1hxcqQv5YhxgiEUavmBXn/V3/g7fRKgYE76rark=;
        b=fgIlrYA7O5H2r01yffxpZDjG0c+aPHwsVqzpKAybJTZ007Ud0u+5MCjvK3IuecRvHQ
         E1dkfrGEQxnZZ5ajonXR3BsR9Rej8HI2ZE5haECaAUudYoysuK5KWPbeT/xpyP9cf8MU
         HgPLDHj6Y6fK6Yy6H8n3oFsfoDM1ngAq/WfSgaEzbLW/83UNn9wrBfv5lSFANNnz2zGQ
         NuDzyGqTNrhIYprmr8CX+mK4ng1OXpO00yBSBFDpbbBeS394eBE7osKEyHvbvcmDpMJQ
         xSYQNizCbz0a3gw85fHZNcS5TmTcyfDavngt8sw4yAMFkUdnsT/Sqh8Q8ZoSeelCaEQj
         wq+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788700965; x=1789305765;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xGMx1hxcqQv5YhxgiEUavmBXn/V3/g7fRKgYE76rark=;
        b=e0yER3hP9Qc+2eFcEQJMIT4lZLPDn2bKujl0OSZ7i0S6PVAGZeUWN8l2h1/Q8q9gb8
         FhWoToChZ5QxJYTPg8OizUs9bs0tBJZYrAFM2eXq13sChcIbwYZ2JVWlerwCUtfghNyo
         1ShfP7djTwD/usnKm6F4ra/8OZdtat7nGniCM0tb8SqwqlezelibTYTDC83VjyThM7vB
         ubQAgc8WcaBIglaq/UWpZwKof2DSBhSgGHiN/nhCITYBofU1I3mbh5TC6Bqi2NdVXv0G
         RraplM/w+kOLnwmV7ADA1h8/bAHyqrU6W3THPX92NoiirJzsFBujgioiCQreon1TDa8h
         r8MA==
X-Forwarded-Encrypted: i=1; AKwUvByS3gEHX+MOYqJTWBABSMoG/Ir5+3CYTFUlUbcHTT9TM6ewiGf6vwFecTZZqsVsWn6gsQyk7/CmaEqv@vger.kernel.org
X-Gm-Message-State: AFuF++mRSAZ5UmwTwlg5/qyY/ir33ceJyjoofd9xggPFY1dUaNdGFKSP
	UM4MgAQH/WShjT+0zFNoGPvf10ypChtEQTx3U6xgiFBUjsCBn0WS9cpK
X-Gm-Gg: AYBFou0fKpfoynoHCZn6jvC+oZr3J/Z+8Mk71wAvajVwbF8Q1HZFWLh3HPoYAXSr8OU
	kWGWplzYtrI9pQGxMBOoLLNp3WERG3uarMdEe0DWGbfFpG7bt13HEmLnQhpenYRe4ZhqGIE0JT3
	iagBOLOWepJMnJmB8VPHX63VfYsdR+WFCRjkvyR/mHKSZZSwp57UwUjEE8fGddUuZNROveP+Bj9
	4MOZyp89JFonIIyaxONbMc6FZ+BfR+rYkzDlC3DYGVZ8QTj63vyMLUsePAjRFCCK20/WlDrjbp3
	+hbT2M29hyaNG1tpXi9qOu/fW898iXth/vjq9LU8zeHcNegg8EeeGxG8xV2MM7wBlXBwf6hMFir
	aMxMfLOB29cTleN/Ik6zUrMHl6asDxczfWz+j4bBzOx9Z67KhLCgXgFOezF9DUGp4p/SAhQ+gX6
	qmapFAnnbgONRULrsacCZa6vOyIS2OV3UhvQZqR5/FG96QLs98r6qRrLAGlFQplnrLVwpwL4a3D
	ADomHCnokQwk8WDv9IQ3kMyDbkP1D4=
X-Received: by 2002:a05:600c:c48f:b0:497:fecd:5b00 with SMTP id 5b1f17b1804b1-49cf825d507mr177339265e9.9.1788700964867;
        Sun, 06 Sep 2026 06:22:44 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:26b:8dd9:70ba:6dc3:6d92:e139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf7740d44sm527677145e9.15.2026.09.06.06.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 06:22:44 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Jinpu Wang <jinpu.wang@cloud.ionos.com>, linux-raid
 <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, Jens Axboe
 <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Ming Lei
 <ming.lei@redhat.com>, Damien Le Moal <dlemoal@kernel.org>, Nilay Shroff
 <nilay@linux.ibm.com>
Subject: Re: [BUG] md/raid1: deadlock between a queue limits sysfs store and
 a spare re-add
In-Reply-To: <m2h5k2661v.fsf@gmail.com>
References: <CAMGffEn0RcbyEcgCCVdxEf8Zwd6hnrjnYPdqrMsf8TL8qEBKRA@mail.gmail.com>
 <m2h5k2661v.fsf@gmail.com>
Date: Sun, 06 Sep 2026 15:22:43 +0200
Message-ID: <m2ecf65xb0.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Sun, Sep 06, 2026 at 12:13 +0200, Abd-Alrhman Masalkhi wrote:
> Hi Jack,
>
> On Sun, Sep 06, 2026 at 06:58 +0200, Jinpu Wang wrote:
>> Hi,
>>
>> writing to a queue limit attribute of an md array while a spare is being
>> re-added deadlocks the array, with three tasks left unkillable in D state.
>> The host has to be rebooted to recover.
>>
>> We hit this in production on 6.12.100 with RAID1 arrays, triggered by a
>> udev rule writing queue/max_sectors_kb.  Reading the code, v7.2 looks
>> affected too; see "Which versions" below for exactly what was tested and
>> what was not.
>>
>> The cycle
>> =========
>>
>> Three tasks, one array:
>>
>>   udev-worker     queue_attr_store() holds q->limits_lock and waits in
>>                   blk_mq_freeze_queue() for q_usage_counter to drain
>>
>>   fio             holds a q_usage_counter reference, waits in
>>                   md_handle_request()'s is_suspended() loop
>>
>>   md_start_sync   holds mddev->suspended, waits for q->limits_lock
>>
>> Nobody can proceed: the freeze needs the in-flight I/O to finish, that
>> I/O needs mddev->suspended cleared, and clearing it needs the spare add
>> to finish, which is blocked on the lock the first task holds.
>>
>> The three legs in v7.2 (8d3ae59288f1):
>>
>> block/blk-sysfs.c, queue_attr_store():
>>
>> struct queue_limits lim = queue_limits_start_update(q);
>>
>> res = entry->store_limit(disk, page, length, &lim);
>> if (res < 0) {
>> queue_limits_cancel_update(q);
>> return res;
>> }
>>
>> res = queue_limits_commit_update_frozen(q, &lim);
>>
>> queue_limits_start_update() takes q->limits_lock, and
>> queue_limits_commit_update_frozen() calls blk_mq_freeze_queue() with it
>> still held.  max_sectors_kb is a QUEUE_LIM_RW_ENTRY, so a plain
>>
>> echo 1024 > /sys/block/mdN/queue/max_sectors_kb
>>
>> reaches this path.
>>
>> drivers/md/md.c, md_start_sync():
>>
>> if (mddev->reshape_position == MaxSector &&
>>    md_spares_need_change(mddev)) {
>> suspend = true;
>> mddev_suspend(mddev, false);
>> }
>>
>> mddev_lock_nointr(mddev);
>>
>> and from there md_choose_sync_action() -> remove_and_add_spares() ->
>> ->hot_add_disk() -> raid1_add_disk() -> mddev_stack_new_rdev(), which
>> does a blocking
>>
>> lim = queue_limits_start_update(mddev->gendisk->queue);
>>
>> while mddev->suspended is set.
>>
>> drivers/md/md.c, md_handle_request(), where the in-flight I/O waits:
>>
>> if (is_suspended(mddev, bio)) {
>> ...
>> wait_event(mddev->sb_wait, !is_suspended(mddev, bio));
>>
>> So md acquires q->limits_lock while holding a quiescing primitive that
>> blocks exactly the I/O a concurrent freeze is waiting to drain.
>>
>> Backtraces
>> ==========
>>
>> From a 6.12.100 based kernel:
>>
>>   INFO: task kworker/2:2 blocked for more than 184 seconds.
>>   Workqueue: md_misc md_start_sync [md_mod]
>>   Call Trace:
>>    __mutex_lock.constprop.0+0x31c/0x6d0
>>    mddev_stack_new_rdev+0x59/0x150 [md_mod]
>>    raid1_add_disk+0x97/0x180 [raid1]
>>    remove_and_add_spares+0xe8/0x230 [md_mod]
>>    md_start_sync+0x14c/0x3e0 [md_mod]
>>    process_one_work+0x162/0x370
>>
>>   INFO: task (udev-worker) blocked for more than 184 seconds.
>>   Call Trace:
>>    blk_mq_freeze_queue_wait+0x9e/0xd0
>>    queue_limits_commit_update_frozen+0x12/0x40
>>    queue_attr_store+0xc9/0x1c0
>>    kernfs_fop_write_iter+0x133/0x220
>>    vfs_write+0x29c/0x450
>>
>>   INFO: task fio blocked for more than 184 seconds.
>>   Call Trace:
>>    md_handle_request+0x10d/0x2b0 [md_mod]
>>    __submit_bio+0x23e/0x2f0
>>    submit_bio_noacct_nocheck+0x1a3/0x3c0
>>    blkdev_direct_IO+0x265/0x5d0
>>
>> /proc/mdstat at that point, with the spare add never completing:
>>
>>   md0 : active raid1 rnbd0[0] rnbd1[1](S)
>>         5238784 blocks super 1.2 [2/1] [U_]
>>
>> Reproducer
>> ==========
>>
>> On a scratch machine, with two ram devices:
>>
>>   mdadm -C /dev/md111 --force -e 1.2 --assume-clean -l 1 \
>>         --bitmap=internal -n 2 /dev/ram0 /dev/ram1
>>
>>   # keep I/O in flight
>>   fio --direct=1 --rw=randrw --ioengine=libaio --iodepth=32 --numjobs=4 \
>>       --time_based=1 --runtime=180 --filename=/dev/md111 --name=repro &
>>
>>   # stand in for the udev worker
>>   while :; do
>>       echo 128 > /sys/block/md111/queue/max_sectors_kb 2>/dev/null
>>   done &
>>
>>   # drive spare re-adds
>>   for i in $(seq 20); do
>>       mdadm /dev/md111 --fail /dev/ram0
>>       mdadm /dev/md111 --remove /dev/ram0
>>       mdadm /dev/md111 --add /dev/ram0
>>       mdadm --wait /dev/md111
>>   done
>>
>> It reproduced on the first iteration for us, though it is a race, so it
>> may need a few attempts on other machines.
>>
>> Which versions
>> ==============
>>
>> Reproduced: 6.12.100 (distro kernel carrying the stable backport of
>> c99f66e4084a), RAID1, repeatedly, on several hosts.
>>
>> Not reproduced, code inspection only: v7.2 (8d3ae59288f1).  All three
>> legs quoted above are from the v7.2 tree and are unchanged there, so it
>> looks affected, but we have not run the reproducer on a mainline build.
>> Happy to do that if it helps.
>>
>> raid10 calls mddev_stack_new_rdev() from raid10_add_disk() in the same
>> way, so it looks exposed too; we have only tested raid1.
>>
>> When it started
>> ===============
>>
>> Before commit c99f66e4084a ("block: fix queue freeze vs limits lock
>> order in sysfs store methods"), queue_attr_store() froze the queue first
>> and took limits_lock afterwards, so limits_lock was never held across the
>> freeze wait and this cycle could not form.  That commit moved the freeze
>> inside queue_limits_commit_update_frozen(), i.e. under limits_lock:
>>
>>   Fixes: c99f66e4084a ("block: fix queue freeze vs limits lock order
>> in sysfs store methods")
>>
>> That is not an argument for reverting it: it exists so sd_revalidate_disk()
>> can issue SCSI commands while holding the limits lock, which cannot work
>> on a frozen queue.  The md side is on the wrong side of the ordering the
>> block layer expects, as spelled out in commit 06a2ff603f1f ("loop: Fix
>> recently introduced lock inversion"): all block driver code takes
>> queue_limits_start_update() before freezing.  md instead takes a
>> quiescing primitive of its own first.
>>
>> What we are running
>> ===================
>>
>> We fixed it on the md side, by taking the limits update in
>> md_start_sync() before mddev_suspend(), threading the queue_limits
>> through ->hot_add_disk() so the personality stacks into it without
>> taking the lock itself, and committing before resuming, so the update
>> still lands while the array is quiesced.  That removes the inversion
>> without touching the shared block layer code.
>>
>
> I am working on a bug in slot_store(). It calls remove_and_add_spares()
> without suspending the array. If I just suspend the array without taking
> care of q->limits_lock, it would  trigger the same issue you
> mentioned.

To clarify, I haven't submitted my patch for slot_store() yet. I was 
going to, but your report shows that won't be enough. I'll hold off on
my changes so I can use your queue_limits threading approach.

> 2- state_store() also calls remove_and_add_spares(), while the array is
> suspended by rdev_attr_store(), so it would probably trigger the same
> issue as well.
>
>> Two approaches we tried first and discarded, in case they save someone
>> the detour:
>>
>> - mutex_trylock() in mddev_stack_new_rdev() with a retry on contention.
>>   A writer that keeps retaking limits_lock wins nearly every time, so
>>   the retry does not converge: we measured 1132 backoffs against 1
>>   success, the array staying degraded with an idle spare throughout, and
>>   md_check_recovery() suspending and resuming the array on every pass.
>>
>> - Dropping limits_lock around the freeze wait inside
>>   queue_limits_commit_update_frozen().  This works, but it inverts the
>>   ordering the block layer has standardised on, and a concurrent update
>>   committing in the window is then silently overwritten.
>>
>> We can post the md-side patch if that direction looks right, or defer to
>> whatever you prefer.  Reproducer script and the full logs are available.
>>
>> Thanks,
>> Jack
>>
>
> -- 
> Best Regards,
> Abd-Alrhman

-- 
Best Regards,
Abd-Alrhman
