Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E475B37C0E5
	for <linux-raid@vger.kernel.org>; Mon,  7 Sep 2026 04:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788756744; cv=pass; b=RMiLsQGnZhf/xRt3JWf67IFO5dlwA302PDdIKxCvd38KmlvoSQSwfLx/nT7OPLsIgCBP/syCvTwVxDa87FfBy15ueT/mpuULBulPGFz/OUBrVw05usP+xwHOwQ3Jo8tcmzrI8HL7yOQe8pgP+tU1G9p4IPjZDea9J33aybQcwEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788756744; c=relaxed/simple;
	bh=H5uB0o1IQQ2Ai2UstFirBKAmWMPJ2aetH1bW2y1qmYk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bitsHn68y4sT9iLNesr4Nk37ddDXxWXBrkxMFvp52Aj0PgGj5qe7plaAyJ55fhYfToYNF4HP3ry38VrydlL05b2Slw38eg+UFYzyt/mCmHgKbAQve1eVVG9rV0N+SSe0swuVaL8kjhTIrnbOPPHYS023nSVGrRC2rWQXkh6fTNg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=QeOy6yAa; arc=pass smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="QeOy6yAa"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a6048732fcso345406a12.3
        for <linux-raid@vger.kernel.org>; Sun, 06 Sep 2026 21:52:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788756740; cv=none;
        d=google.com; s=arc-20260327;
        b=gCMmluDVHtnOPKsUjMRz5YotKuDhlK9G1dhV0E0tuzY0lWCjJS14sjATlp6HhGgJz/
         RytvXdZlK5jtxVIAKlBAeqNX9DOLghHm8WucbnhmUlmo+YG0O0sWlpGmoNtaRjtGLt4R
         bV8APb77iOZ2nfWKmDviy8ww3OQAaGyAsNmW5s3YkAYJJEeUP785xBxhiHVvIpwXWm+a
         2Hjo18HxgrgOVvU44pT8m/C47zyOD3Rz0auvUZujGHL9pDI/mnZOJCzTSGaGI6W04T9U
         TFMr3LwCrX0ABfI1XtW4EmiYsPK7pnyll/8Ce3AHZJ2tPM6bQjECVtsW8XMdJBcb7Kpe
         58kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UCFQqWGyc7AcaVv9IiMrGhuzKb26VOf1M4KgRvKSBJc=;
        fh=YIdDe2HDVNrAgtnNq2APPRTZRdTZqQ+xx1XRlwJEM1g=;
        b=DK7JartRIiUoRvf1UpnBgk3kCSN+6mFIwcQyY/ibaSf+7goSKPDhCr9987IDxDDyUv
         mrjhb+9XabsD2iJGmKO0cN1oVGCZ5DU8Sh+rv2wj5ITvCD2A6Kfw2H7niZrWaN9lp9iE
         3QBaCyR0/Y2kyoqOOPjqGsYuHK4+wOn98skMzl6AUjcTwWLMLM5eQ6i5gYCbRGtfrnvM
         hvjdY28JF8PXz4KO0fnUDRvxCouUQJloWV8HmP1D8i1HT/uKGau4qznXbkiDUO9UU9Yc
         igY9953CBINHKc9bCW9vI0mTVwh6YKUUkfz9637vNSpj9eeI7MxqdNHrgFCcikgLHTMC
         DmLw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1788756740; x=1789361540; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UCFQqWGyc7AcaVv9IiMrGhuzKb26VOf1M4KgRvKSBJc=;
        b=QeOy6yAa91LxmdgpUwa59GC5pL1Xk0j9UHHzxuWJS5EbyYkWCOc4ouFFc4CwMqLvNh
         ocO9UsCONAlzM07vn83ddzIidMRqEM/QA6KyFK1eML2E+15csnUesystkiWjp+jWTz8G
         7fE7Q4CBQCbJAIgGhgS3xADsfDmVWCCVbda0+Sn4/sOID55fYlv5k1YMwc1ix6uh5umB
         Y50RZ5ionPUTpc+9ykDVEgcov1FPMDriv4MDBKFVYGIys44td8I8SOTydyA8duq7K689
         CUs7oqTL9ZwXublTtGpq3IM/llGiXqA7Y9cbrFc1nE1ilh0vevZ10KoHZyTu4njG6sZ2
         J6VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788756740; x=1789361540;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UCFQqWGyc7AcaVv9IiMrGhuzKb26VOf1M4KgRvKSBJc=;
        b=bDVtw3V/v1lGmADyMXQIEAUaazvUjkMfRpt73izSPf1pTMBEN5ZdHwD0P9wX1NieRe
         ieQz8SAcoMvOAi6XSsJ2KyDzautVWsfLaYtlFsf5aaIDkzIuib9nG3vxYdETkLNqWfEg
         2BHKd06RLzr4+BNWpWIYS8ynqPzUZdaCntomYQmty6ehDHZ1emEX4vu6Iy5bwcTbRpWM
         aZGucEzmv0m4igOKkOaaeqTVmKxoerdqSJcWINCmLjyfJGpaqmpsR7LL7cWMnAK3VLWV
         hDm3e2527rI4sSz7TlP3wxpHjBE1QzSU7jUULgnNQUKV3I6QHRCgOgw+M+GALn8n7X0o
         3Epw==
X-Gm-Message-State: AFuF++lLZOiu0aVqpaWlsz7vUOQVVB5Ct/O+lKuzd94IGs7taYd2Dk+B
	gQsg+rxuV+cy/GVDYIGH7w+EZNN/Q3yNtkwDAofxgDs7Al+nwpTWfy/uoArGGdU7KoXXXowkt+Z
	t+JxefyQn8NwFcEJrPmMdS4lZnInR90BTbAMo5NL3gg==
X-Gm-Gg: AYBFou3t95AxTBI9B0pMcGNjPWkgRfDzLJrCWFIqCBBOy9vypUu3GtnywE1hAZ6+KbQ
	uaWi7O+eYf6RLZ+f69c49jfIEh0ETo4Q+f+7qQ1VX7SyINdwIg7wifWNZhwnuabssaViLInht54
	SQGognz+O7z5aM9cNJrWco2J79/KjeRuxGJQoAyDxGN6WikQCILxecwOya4JI7BullZXZ/BpUMT
	U1M+d+fCh857am24Uw/6Mvjd2jPUBcoapKRb7Uf/WFeRR+28qJwTpNxN+VT4CXjRe2QZDq9vFmc
	Ieh1rnE4PzhOcCPaaxNFGslRP17Jz/COgr16DBNbqNioG0F1RyxKbM+gNjED9YbO0Xnum1bRLTi
	y9nk=
X-Received: by 2002:a17:907:7296:b0:c25:2ded:ad36 with SMTP id
 a640c23a62f3a-c2610e582d2mr689682766b.0.1788756739904; Sun, 06 Sep 2026
 21:52:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMGffEn0RcbyEcgCCVdxEf8Zwd6hnrjnYPdqrMsf8TL8qEBKRA@mail.gmail.com>
 <41929544-cae1-4c94-95f1-9a7058d741b1@linux.ibm.com>
In-Reply-To: <41929544-cae1-4c94-95f1-9a7058d741b1@linux.ibm.com>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Mon, 7 Sep 2026 06:52:09 +0200
X-Gm-Features: AcwNN1VSTViAIs4ZilNYGyrNlmMZ3rKviT7e3RlaQ4HiUXqTScS-hMFxI_upGAc
Message-ID: <CAMGffE=heGA3y8FjQ0Sm1jj-kd-=H9Y54WozKASSEZhc9UNKjA@mail.gmail.com>
Subject: Re: [BUG] md/raid1: deadlock between a queue limits sysfs store and a
 spare re-add
To: Nilay Shroff <nilay@linux.ibm.com>, abd.masalkhi@gmail.com
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, 
	Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, 
	Damien Le Moal <dlemoal@kernel.org>, Yu Kuai <yukuai@fygo.io>, tom.leiming@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Nilay, hi Abd,

Thank you for the feedback. I will test my fix against the upstream
kernel and send it out later today.

Thanks,
Jack

On Sun, Sep 6, 2026 at 2:33=E2=80=AFPM Nilay Shroff <nilay@linux.ibm.com> w=
rote:
>
> On 9/6/26 10:28 AM, Jinpu Wang wrote:
> > Hi,
> >
> > writing to a queue limit attribute of an md array while a spare is bein=
g
> > re-added deadlocks the array, with three tasks left unkillable in D sta=
te.
> > The host has to be rebooted to recover.
> >
> > We hit this in production on 6.12.100 with RAID1 arrays, triggered by a
> > udev rule writing queue/max_sectors_kb.  Reading the code, v7.2 looks
> > affected too; see "Which versions" below for exactly what was tested an=
d
> > what was not.
> >
> > The cycle
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Three tasks, one array:
> >
> >    udev-worker     queue_attr_store() holds q->limits_lock and waits in
> >                    blk_mq_freeze_queue() for q_usage_counter to drain
> >
> >    fio             holds a q_usage_counter reference, waits in
> >                    md_handle_request()'s is_suspended() loop
> >
> >    md_start_sync   holds mddev->suspended, waits for q->limits_lock
> >
> > Nobody can proceed: the freeze needs the in-flight I/O to finish, that
> > I/O needs mddev->suspended cleared, and clearing it needs the spare add
> > to finish, which is blocked on the lock the first task holds.
> >
> > The three legs in v7.2 (8d3ae59288f1):
> >
> > block/blk-sysfs.c, queue_attr_store():
> >
> > struct queue_limits lim =3D queue_limits_start_update(q);
> >
> > res =3D entry->store_limit(disk, page, length, &lim);
> > if (res < 0) {
> > queue_limits_cancel_update(q);
> > return res;
> > }
> >
> > res =3D queue_limits_commit_update_frozen(q, &lim);
> >
> > queue_limits_start_update() takes q->limits_lock, and
> > queue_limits_commit_update_frozen() calls blk_mq_freeze_queue() with it
> > still held.  max_sectors_kb is a QUEUE_LIM_RW_ENTRY, so a plain
> >
> > echo 1024 > /sys/block/mdN/queue/max_sectors_kb
> >
> > reaches this path.
> >
> > drivers/md/md.c, md_start_sync():
> >
> > if (mddev->reshape_position =3D=3D MaxSector &&
> >     md_spares_need_change(mddev)) {
> > suspend =3D true;
> > mddev_suspend(mddev, false);
> > }
> >
> > mddev_lock_nointr(mddev);
> >
> > and from there md_choose_sync_action() -> remove_and_add_spares() ->
> > ->hot_add_disk() -> raid1_add_disk() -> mddev_stack_new_rdev(), which
> > does a blocking
> >
> > lim =3D queue_limits_start_update(mddev->gendisk->queue);
> >
> > while mddev->suspended is set.
> >
> > drivers/md/md.c, md_handle_request(), where the in-flight I/O waits:
> >
> > if (is_suspended(mddev, bio)) {
> > ...
> > wait_event(mddev->sb_wait, !is_suspended(mddev, bio));
> >
> > So md acquires q->limits_lock while holding a quiescing primitive that
> > blocks exactly the I/O a concurrent freeze is waiting to drain.
> >
> > Backtraces
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >  From a 6.12.100 based kernel:
> >
> >    INFO: task kworker/2:2 blocked for more than 184 seconds.
> >    Workqueue: md_misc md_start_sync [md_mod]
> >    Call Trace:
> >     __mutex_lock.constprop.0+0x31c/0x6d0
> >     mddev_stack_new_rdev+0x59/0x150 [md_mod]
> >     raid1_add_disk+0x97/0x180 [raid1]
> >     remove_and_add_spares+0xe8/0x230 [md_mod]
> >     md_start_sync+0x14c/0x3e0 [md_mod]
> >     process_one_work+0x162/0x370
> >
> >    INFO: task (udev-worker) blocked for more than 184 seconds.
> >    Call Trace:
> >     blk_mq_freeze_queue_wait+0x9e/0xd0
> >     queue_limits_commit_update_frozen+0x12/0x40
> >     queue_attr_store+0xc9/0x1c0
> >     kernfs_fop_write_iter+0x133/0x220
> >     vfs_write+0x29c/0x450
> >
> >    INFO: task fio blocked for more than 184 seconds.
> >    Call Trace:
> >     md_handle_request+0x10d/0x2b0 [md_mod]
> >     __submit_bio+0x23e/0x2f0
> >     submit_bio_noacct_nocheck+0x1a3/0x3c0
> >     blkdev_direct_IO+0x265/0x5d0
> >
> > /proc/mdstat at that point, with the spare add never completing:
> >
> >    md0 : active raid1 rnbd0[0] rnbd1[1](S)
> >          5238784 blocks super 1.2 [2/1] [U_]
> >
> > Reproducer
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > On a scratch machine, with two ram devices:
> >
> >    mdadm -C /dev/md111 --force -e 1.2 --assume-clean -l 1 \
> >          --bitmap=3Dinternal -n 2 /dev/ram0 /dev/ram1
> >
> >    # keep I/O in flight
> >    fio --direct=3D1 --rw=3Drandrw --ioengine=3Dlibaio --iodepth=3D32 --=
numjobs=3D4 \
> >        --time_based=3D1 --runtime=3D180 --filename=3D/dev/md111 --name=
=3Drepro &
> >
> >    # stand in for the udev worker
> >    while :; do
> >        echo 128 > /sys/block/md111/queue/max_sectors_kb 2>/dev/null
> >    done &
> >
> >    # drive spare re-adds
> >    for i in $(seq 20); do
> >        mdadm /dev/md111 --fail /dev/ram0
> >        mdadm /dev/md111 --remove /dev/ram0
> >        mdadm /dev/md111 --add /dev/ram0
> >        mdadm --wait /dev/md111
> >    done
> >
> > It reproduced on the first iteration for us, though it is a race, so it
> > may need a few attempts on other machines.
> >
> > Which versions
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Reproduced: 6.12.100 (distro kernel carrying the stable backport of
> > c99f66e4084a), RAID1, repeatedly, on several hosts.
> >
> > Not reproduced, code inspection only: v7.2 (8d3ae59288f1).  All three
> > legs quoted above are from the v7.2 tree and are unchanged there, so it
> > looks affected, but we have not run the reproducer on a mainline build.
> > Happy to do that if it helps.
> >
> > raid10 calls mddev_stack_new_rdev() from raid10_add_disk() in the same
> > way, so it looks exposed too; we have only tested raid1.
> >
> > When it started
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Before commit c99f66e4084a ("block: fix queue freeze vs limits lock
> > order in sysfs store methods"), queue_attr_store() froze the queue firs=
t
> > and took limits_lock afterwards, so limits_lock was never held across t=
he
> > freeze wait and this cycle could not form.  That commit moved the freez=
e
> > inside queue_limits_commit_update_frozen(), i.e. under limits_lock:
> >
> >    Fixes: c99f66e4084a ("block: fix queue freeze vs limits lock order
> > in sysfs store methods")
> >
> > That is not an argument for reverting it: it exists so sd_revalidate_di=
sk()
> > can issue SCSI commands while holding the limits lock, which cannot wor=
k
> > on a frozen queue.  The md side is on the wrong side of the ordering th=
e
> > block layer expects, as spelled out in commit 06a2ff603f1f ("loop: Fix
> > recently introduced lock inversion"): all block driver code takes
> > queue_limits_start_update() before freezing.  md instead takes a
> > quiescing primitive of its own first.
> >
> > What we are running
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > We fixed it on the md side, by taking the limits update in
> > md_start_sync() before mddev_suspend(), threading the queue_limits
> > through ->hot_add_disk() so the personality stacks into it without
> > taking the lock itself, and committing before resuming, so the update
> > still lands while the array is quiesced.  That removes the inversion
> > without touching the shared block layer code.
> >
> I think you nailed it. We settled on the locking order in the block layer
> with commit c99f66e4084a ("block: fix queue freeze vs limits lock order i=
n
> sysfs store methods"), where we now acquire q->limits_lock before
> freezing the queue. This ordering is followed by the block layer code tha=
t
> updates queue limits, while md appears to be an exception since it still
> uses mddev_suspend() to stall I/O instead of blk_mq_freeze_queue().
>
> So to me, your proposed approach looks reasonable: acquire
> q->limits_lock first and then call mddev_suspend(). This should avoid
> the lock inversion described above while still allowing the queue limits
> update to be performed while the array is quiesced.
>
> > Two approaches we tried first and discarded, in case they save someone
> > the detour:
> >
> > - mutex_trylock() in mddev_stack_new_rdev() with a retry on contention.
> >    A writer that keeps retaking limits_lock wins nearly every time, so
> >    the retry does not converge: we measured 1132 backoffs against 1
> >    success, the array staying degraded with an idle spare throughout, a=
nd
> >    md_check_recovery() suspending and resuming the array on every pass.
> >
> > - Dropping limits_lock around the freeze wait inside
> >    queue_limits_commit_update_frozen().  This works, but it inverts the
> >    ordering the block layer has standardised on, and a concurrent updat=
e
> >    committing in the window is then silently overwritten.
> >
> > We can post the md-side patch if that direction looks right, or defer t=
o
> > whatever you prefer.  Reproducer script and the full logs are available=
.
> >
> I think you should send out the md-side changes so that others can review=
 the
> locking changes and comment on the approach.
>
> Thanks,
> --Nilay
>
>
