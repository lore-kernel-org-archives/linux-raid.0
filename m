Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172F83C109E
	for <linux-raid@vger.kernel.org>; Sun,  6 Sep 2026 04:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788670718; cv=pass; b=hYP8DirlZU9QNP5b6HOfMnC1R6cMrYIv1Dp8WrJaK89j3yWG/VzOFRmyruUjtNLgGOooUo3PCmePWjQv1FKhIK9oU4X2kzdavHkOgZ9TTjH3CC2XPy0+E+aQhQzBwD03IW/GiUeyZ7s/udsQ3yb7AbrvUF6eFmsgjywIJBE/90s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788670718; c=relaxed/simple;
	bh=FeKYGJD+P5KLgdKVb7TSeBLiYYMathVLkhofXFSuJz4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=cslMZ39YA363kaxJEWe3z7GwphjPED1OPyHwZqiUMiKXXhryOV++RFCGRO7lHA1/ZvvTKOeaI5/Zv11vKGrdi0e6gR9Su7Leix0lm3ga73cXuAcAx79bn7hgK/nA7jw9XYz/Yxg4GwNJBw4cyIcsheoz5NIGPZ1ibjr7MhTiDjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=Z4zv7iMF; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="Z4zv7iMF"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c252fb14159so25643966b.1
        for <linux-raid@vger.kernel.org>; Sat, 05 Sep 2026 21:58:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788670714; cv=none;
        d=google.com; s=arc-20260327;
        b=f6mcNc2Cq830EfnrUpnmdtgZSwV3AJ6SgEf7kyIv8K9PNj/y7e+gQLQa35EJqwZsci
         if+zuvvJPAhoFiG6MCBJ7aWnOE5MHgPpKVmokWBhfEKAR7186Tz+xyuog22Ic1fAvSMT
         LVwoe6MPUU/rZm4N1xfg3/y/0+QUds57/OdapZuvE/YHYhIAUghOB4uxNRu1QleFUwC0
         5plQZO+c7fIGOIzGvWOgkpfKVe5VGakG6Ulh0O8iNU0sym1G/sh0V4Vi94xePqJIzKzv
         jj6EqdQjOSYuupjQ5FJEvUi93AdHsiS4Lcb+4slpZ//xKfKB0dWPZ4WvXbJFzZEMWlNv
         7BSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=FD4fHjH+/hAcEAEmosA2Z9AtkoH1qwcqK2ut86B8Btc=;
        fh=tirF9Ogh7kg4UUTMubPCiQa4dbH1wQLwG0kxQit9dE4=;
        b=bEjry/rhtEwW/6N9QZR5eRbVpv5EIn8g+MwXcZz3EV3mGjuEbLaYXncptsWoxILI9L
         S1S/vHFjsfTWdd4U4hM6/EwwVxiwGoqlTE4Yye//KgNh4h/WZJPRA59SDj1mRTgzeDrH
         caGvAGkGSEcbTn89GBlaO6KLWzrWPawsDKiDcARBw0ChKgoscBWaWItRDcCxZ9NXOldq
         J0gYPbCEocJuVqErHucuwyD4NGyJVC4/XHi+XaPSUR+mE7JwfpJ0TuPfgHA5kHuLphrS
         JANuxND6a21jywn+hGPibe4LYgdECUvLpN/jCeuq2u2ncAOuCtENzB9N6Zh4KOW0QPaK
         9Nrw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1788670714; x=1789275514; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FD4fHjH+/hAcEAEmosA2Z9AtkoH1qwcqK2ut86B8Btc=;
        b=Z4zv7iMFC+e62sdUfp1uxPZMKhVj5RnSYD84oJ/P7NCGNFKzbkOANJCIn4Qfhybee9
         GHDyW+XYCinPWlqUk2oD99LV7XhA3QTFoaCrJIHC1CDVDmQvWBKccTkE2uohMwE6OR2K
         xQ4/PlE7hkYyBhKw/mTpnJk47A6EoUaz/2GaRAreo1lcsbgjs5ZwXPjjSd0RPWRUxErS
         nXykTVpc09YpvIp0Mv8ng8VfQmkeA2ep5Y68D+2I3WKRLhAXQQU/bZnCmApU7xwkuA6/
         7BSo4y169baznl+b7d8FOo0BXxi3Ri4NmsmtIisNl32xyMKfFgxjD8rF2eQKxJ+uhbrO
         DqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788670714; x=1789275514;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FD4fHjH+/hAcEAEmosA2Z9AtkoH1qwcqK2ut86B8Btc=;
        b=Y1LqIeaBd+1O7TU8PB3Ff3MJz19qdx1H9UcNMcJcZphVibvDPuNi2Oi7iM0c7TFEQP
         6ZtIyGP8Cqa50Zp+EE61NHHR9IkA9bSTxKETvPVsP9S/dV3lQBr/PvLx8U0R6GGQy6P1
         sAQ0f0cVT5GrGnjzm7HgQVYhcrpKvdX4gy8VUo2U6YCmZFBh4riTGeBUlcr6nMqssmjL
         +YL80WWu/diSYp/vepwf9j7WWZxgu641SM5dQPUnKvFIGk8jTHf+UWdUqRLWAgv4lO5s
         NihbDCVGSyzc9KWEAA1/B8HYHnncqgjlnuYISzeZYcyRkVFR/uCEnb9hS76qakRD0PBs
         F/2Q==
X-Gm-Message-State: AFuF++lyXnmqRmLJltgAL3KmHw4yYSUpHKycF5YnKBpJb5nOpcX91zcJ
	Pk/dnIshoIOU2AY6NRRneLiSFJ2QN1Jc1eXSNG0KhE9XRaAcSSeAgftMARGkDsNywk0tlwz8kiT
	PKve676AA4KDpM5iJ3Qwq4XJcALkdFn+dBqU++ZpwQ0xT/DxXa/q+XeFYDg==
X-Gm-Gg: AYBFou1xC1ivfM3FEM223ZCGytOw51ZXtqlEo9tksxG0256BqfQ3Xe2jImEO8d0Z+At
	FdW2SVF3eJF6k/DztK8tDedsd34FwfWmS19iTl0v2rvuS0cxqFEqAJ3O/TLNRRqVhumJNToJ0Cw
	Kysv+RE72W20AcBhWMxY/RinHltvSklaFM9Fl8z+mxrMVpkSVqY+rLcrRj89ZrICdA49TZS9XN2
	WwBzqI7WtJF0/crl4/cG4cCstbGa1C7zZul7nz6XNG9x64H0GrCsWHeBMEsFl6cdMipPa5SlPfF
	c43WvZWuKobKQAXDQzejTH+jfmgcRV/gC1s7klU41C06Ae7fz5eR5+oH8F3r1iySr03i4sEYhua
	7
X-Received: by 2002:a17:907:94d3:b0:c16:1290:11a7 with SMTP id
 a640c23a62f3a-c2624f0a534mr299138366b.1.1788670714275; Sat, 05 Sep 2026
 21:58:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Sun, 6 Sep 2026 06:58:23 +0200
X-Gm-Features: AcwNN1W9doqN40vD0Hwq6JXmKiZAN4nJmcc4gmneglTRwRVhLlPeQa5F0c0h1Jo
Message-ID: <CAMGffEn0RcbyEcgCCVdxEf8Zwd6hnrjnYPdqrMsf8TL8qEBKRA@mail.gmail.com>
Subject: [BUG] md/raid1: deadlock between a queue limits sysfs store and a
 spare re-add
To: linux-raid <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>, Damien Le Moal <dlemoal@kernel.org>, 
	Nilay Shroff <nilay@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

writing to a queue limit attribute of an md array while a spare is being
re-added deadlocks the array, with three tasks left unkillable in D state.
The host has to be rebooted to recover.

We hit this in production on 6.12.100 with RAID1 arrays, triggered by a
udev rule writing queue/max_sectors_kb.  Reading the code, v7.2 looks
affected too; see "Which versions" below for exactly what was tested and
what was not.

The cycle
=========

Three tasks, one array:

  udev-worker     queue_attr_store() holds q->limits_lock and waits in
                  blk_mq_freeze_queue() for q_usage_counter to drain

  fio             holds a q_usage_counter reference, waits in
                  md_handle_request()'s is_suspended() loop

  md_start_sync   holds mddev->suspended, waits for q->limits_lock

Nobody can proceed: the freeze needs the in-flight I/O to finish, that
I/O needs mddev->suspended cleared, and clearing it needs the spare add
to finish, which is blocked on the lock the first task holds.

The three legs in v7.2 (8d3ae59288f1):

block/blk-sysfs.c, queue_attr_store():

struct queue_limits lim = queue_limits_start_update(q);

res = entry->store_limit(disk, page, length, &lim);
if (res < 0) {
queue_limits_cancel_update(q);
return res;
}

res = queue_limits_commit_update_frozen(q, &lim);

queue_limits_start_update() takes q->limits_lock, and
queue_limits_commit_update_frozen() calls blk_mq_freeze_queue() with it
still held.  max_sectors_kb is a QUEUE_LIM_RW_ENTRY, so a plain

echo 1024 > /sys/block/mdN/queue/max_sectors_kb

reaches this path.

drivers/md/md.c, md_start_sync():

if (mddev->reshape_position == MaxSector &&
   md_spares_need_change(mddev)) {
suspend = true;
mddev_suspend(mddev, false);
}

mddev_lock_nointr(mddev);

and from there md_choose_sync_action() -> remove_and_add_spares() ->
->hot_add_disk() -> raid1_add_disk() -> mddev_stack_new_rdev(), which
does a blocking

lim = queue_limits_start_update(mddev->gendisk->queue);

while mddev->suspended is set.

drivers/md/md.c, md_handle_request(), where the in-flight I/O waits:

if (is_suspended(mddev, bio)) {
...
wait_event(mddev->sb_wait, !is_suspended(mddev, bio));

So md acquires q->limits_lock while holding a quiescing primitive that
blocks exactly the I/O a concurrent freeze is waiting to drain.

Backtraces
==========

From a 6.12.100 based kernel:

  INFO: task kworker/2:2 blocked for more than 184 seconds.
  Workqueue: md_misc md_start_sync [md_mod]
  Call Trace:
   __mutex_lock.constprop.0+0x31c/0x6d0
   mddev_stack_new_rdev+0x59/0x150 [md_mod]
   raid1_add_disk+0x97/0x180 [raid1]
   remove_and_add_spares+0xe8/0x230 [md_mod]
   md_start_sync+0x14c/0x3e0 [md_mod]
   process_one_work+0x162/0x370

  INFO: task (udev-worker) blocked for more than 184 seconds.
  Call Trace:
   blk_mq_freeze_queue_wait+0x9e/0xd0
   queue_limits_commit_update_frozen+0x12/0x40
   queue_attr_store+0xc9/0x1c0
   kernfs_fop_write_iter+0x133/0x220
   vfs_write+0x29c/0x450

  INFO: task fio blocked for more than 184 seconds.
  Call Trace:
   md_handle_request+0x10d/0x2b0 [md_mod]
   __submit_bio+0x23e/0x2f0
   submit_bio_noacct_nocheck+0x1a3/0x3c0
   blkdev_direct_IO+0x265/0x5d0

/proc/mdstat at that point, with the spare add never completing:

  md0 : active raid1 rnbd0[0] rnbd1[1](S)
        5238784 blocks super 1.2 [2/1] [U_]

Reproducer
==========

On a scratch machine, with two ram devices:

  mdadm -C /dev/md111 --force -e 1.2 --assume-clean -l 1 \
        --bitmap=internal -n 2 /dev/ram0 /dev/ram1

  # keep I/O in flight
  fio --direct=1 --rw=randrw --ioengine=libaio --iodepth=32 --numjobs=4 \
      --time_based=1 --runtime=180 --filename=/dev/md111 --name=repro &

  # stand in for the udev worker
  while :; do
      echo 128 > /sys/block/md111/queue/max_sectors_kb 2>/dev/null
  done &

  # drive spare re-adds
  for i in $(seq 20); do
      mdadm /dev/md111 --fail /dev/ram0
      mdadm /dev/md111 --remove /dev/ram0
      mdadm /dev/md111 --add /dev/ram0
      mdadm --wait /dev/md111
  done

It reproduced on the first iteration for us, though it is a race, so it
may need a few attempts on other machines.

Which versions
==============

Reproduced: 6.12.100 (distro kernel carrying the stable backport of
c99f66e4084a), RAID1, repeatedly, on several hosts.

Not reproduced, code inspection only: v7.2 (8d3ae59288f1).  All three
legs quoted above are from the v7.2 tree and are unchanged there, so it
looks affected, but we have not run the reproducer on a mainline build.
Happy to do that if it helps.

raid10 calls mddev_stack_new_rdev() from raid10_add_disk() in the same
way, so it looks exposed too; we have only tested raid1.

When it started
===============

Before commit c99f66e4084a ("block: fix queue freeze vs limits lock
order in sysfs store methods"), queue_attr_store() froze the queue first
and took limits_lock afterwards, so limits_lock was never held across the
freeze wait and this cycle could not form.  That commit moved the freeze
inside queue_limits_commit_update_frozen(), i.e. under limits_lock:

  Fixes: c99f66e4084a ("block: fix queue freeze vs limits lock order
in sysfs store methods")

That is not an argument for reverting it: it exists so sd_revalidate_disk()
can issue SCSI commands while holding the limits lock, which cannot work
on a frozen queue.  The md side is on the wrong side of the ordering the
block layer expects, as spelled out in commit 06a2ff603f1f ("loop: Fix
recently introduced lock inversion"): all block driver code takes
queue_limits_start_update() before freezing.  md instead takes a
quiescing primitive of its own first.

What we are running
===================

We fixed it on the md side, by taking the limits update in
md_start_sync() before mddev_suspend(), threading the queue_limits
through ->hot_add_disk() so the personality stacks into it without
taking the lock itself, and committing before resuming, so the update
still lands while the array is quiesced.  That removes the inversion
without touching the shared block layer code.

Two approaches we tried first and discarded, in case they save someone
the detour:

- mutex_trylock() in mddev_stack_new_rdev() with a retry on contention.
  A writer that keeps retaking limits_lock wins nearly every time, so
  the retry does not converge: we measured 1132 backoffs against 1
  success, the array staying degraded with an idle spare throughout, and
  md_check_recovery() suspending and resuming the array on every pass.

- Dropping limits_lock around the freeze wait inside
  queue_limits_commit_update_frozen().  This works, but it inverts the
  ordering the block layer has standardised on, and a concurrent update
  committing in the window is then silently overwritten.

We can post the md-side patch if that direction looks right, or defer to
whatever you prefer.  Reproducer script and the full logs are available.

Thanks,
Jack
