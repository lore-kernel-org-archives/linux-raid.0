Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293423;
	b=h42svcw+6xCZ6DrYdPEhfEo566a0NPVtFzW7SVGBFKx4NU3vdObQyJQFjBWa8zYjm04d
	 8OWm/OQdPByy0ToFvUXgnKEC0V8IS6wNa3NY93pWBJTv3/zoWUofbu3A4Ur8uQMhRPWfq
	 TcmNddsACB3mj4aQL6WWJFaJc5ZHstIrQrVEnVZQUuQdXq0i1EMx4tqTCL1hkTTfnRyvx
	 XisVyxlbIGALjIB2alFuQ5E7HKwBBFfWslzt9SHRb+hAcSTaqfxnksFQVJwsP6bLrkB0z
	 HLaFxNkuk14/rxsAo+72Z6yFRZPhyAeTLdOb+csBCTRnPpWakim39QoMzaz9PAsv5eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293423;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TNnI6cCYwYUGZWeCkl6XxQReR/l4QVW/7rDUT8zJgVE=;
	b=Ap/z9EEtSb/u88lUxS9ppgmDE220fx0QT1/bvZDiMpAP4JVsMo10huE1JAobNBs2f2TC
	 A5MwOPSLoeFKxb/PHBpdr9CmyBQbq85Se8LtN+3pKMFO2ay/cPwNkMHWLOQKDFgEYeM5d
	 Mbx2UtnL2tUSti+SoWu9l8SKUcWGU+3apPR157vjEUflcWr+ISOIhYLA/9/M1miVKpV/y
	 efDLFlzLhA9eYcpDk9StXwUE0L4ttIQUYfeN1B8F910ZlJlqbx+RirXfXe+/zEbDYOWWL
	 wil/NaeCm69+92AgJy9KSMKklZ2p2qE2j3yPO2I1dF054t9zSi6XEacCdQuUqOl6UmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tbve3okS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E75606A33A
	for <linux-raid@vger.kernel.org>; Tue, 10 Nov 2026 06:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tbve3okS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A592E1F008A5;
	Tue, 10 Nov 2026 06:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794293422;
	bh=TNnI6cCYwYUGZWeCkl6XxQReR/l4QVW/7rDUT8zJgVE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Tbve3okSSyMzF0roR2yKGI8CdI1KX/WVJofuPlYNHGOaxnjVuX78wbxwSSpWbHR1X
	 Mu4b/KD9m4pR/Tu0VGWITC2P6gJCojWo2sh58qcMyiblVWADCrA51edSSbsBhGXPpZ
	 OF0I0Yn+hIyI44Oi7GQS0z1Sana5s4hIYUSRoMc6Gbc5jly/5b8fVSnuIWQFvw4P1V
	 I3yS6xrZ1j/95VVwqwR/cxeI2LqW7wBpVW+RKibl7wouwU0vdjyJifhWWpCXdUx8Q7
	 2xlUq92n8OZulRWABW+DhVByaGfEn6nzbxk8+PVaH1Zxc51tw1b90c6mQNV4ZRaqdS
	 e/NEPw/FAdgQw==
Message-ID: <sashiko-outbox-206450@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] md: fix sync_work vs array teardown races
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Youhong" <dayou5941@163.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261110063045.912703-1-dayou5941@163.com>
References: <20261110063045.912703-1-dayou5941@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 06:50:22 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] md: post-unlock mddev UAF in md_start_sync() on normal sync
  startup path
- [Medium] md: clearing MD_RECOVERY_RUNNING unlocked in md_start_sync()
  loses recovery
--

commit 20468c000d2b07f235e4306894a52f2c0937b056
Author: Li Youhong <liyouhong@kylinos.cn>

md: fix sync_work vs array teardown races

This commit calls stop_sync_thread() in md_stop(), delays clearing
MD_RECOVERY_RUNNING on the not_running path of md_start_sync(), and checks
MD_RECOVERY_FROZEN before queueing sync_work on read-only arrays.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 03e35386a8028..38df5aababac7 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7133,6 +7133,13 @@ void md_stop(struct mddev *mddev)
>  	/* stop the array and free an attached data structures.
>  	 * This is called from dm-raid
>  	 */
> +	/*
> +	 * md_check_recovery() may have queued sync_work; that work accesses
> +	 * pers. Wait for it here before __md_stop() clears pers, as
> +	 * do_md_stop()/md_stop_writes() do.
> +	 */
> +	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +	stop_sync_thread(mddev, true);
>  	__md_stop_writes(mddev);
>  	__md_stop(mddev);
>  }

[Severity: Medium]
Can md_start_sync() still suffer a use-after-free on mddev on its normal
sync startup path?

When md_start_sync() succeeds in registering sync_thread, it unlocks
reconfig_mutex and continues accessing mddev in __mddev_resume(),
md_wakeup_thread(mddev->sync_thread), and
sysfs_notify_dirent_safe(mddev->sysfs_action):

drivers/md/md.c:md_start_sync() {
	...
	mddev_unlock(mddev);
	if (suspend) {
		memalloc_noio_restore(noio_flags);
		__mddev_resume(mddev, false);
	}
	md_wakeup_thread(mddev->sync_thread);
	sysfs_notify_dirent_safe(mddev->sysfs_action);
	md_new_event();
	return;
}

Because process_one_work() clears WORK_STRUCT_PENDING_BIT before invoking
md_start_sync(), work_pending(&mddev->sync_work) is false in
stop_sync_thread(), so flush_work(&mddev->sync_work) is skipped.  Once
sync_thread is woken (either inside __mddev_resume() before unlocking
suspend_mutex, by md_wakeup_thread(), or by md_wakeup_thread_directly() in
stop_sync_thread()), it can exit and be reaped before md_start_sync()
returns:

CPU0 (kworker)                    CPU1 (teardown / md_thread)
md_start_sync()
  rcu_assign_pointer(sync_thread, ...)
  mddev_unlock(mddev)
                                  raid_dtr() -> md_stop()
                                    set_bit(MD_RECOVERY_FROZEN, ...)
                                    stop_sync_thread()
                                      /* work_pending(sync_work) is false */
                                      md_wakeup_thread_directly(sync_thread)
                                  md_do_sync()
                                    /* sees FROZEN/INTR, sets DONE */
                                  md_check_recovery()
                                    md_reap_sync_thread()
                                      clear_bit(MD_RECOVERY_RUNNING, ...)
                                      wake_up(&resync_wait)
                                    /* stop_sync_thread() returns */
                                  raid_set_free()
                                    kfree(rs)
  __mddev_resume(mddev, false)
  md_wakeup_thread(mddev->sync_thread)
    <-- use-after-free on mddev

Calling flush_work(&mddev->sync_work) unconditionally in
stop_sync_thread() after wait_event(resync_wait, ...) would ensure
md_start_sync() has completely returned before array teardown proceeds.

> @@ -10369,7 +10376,6 @@ static void md_start_sync(struct work_struct *ws)
>  	clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
>  	clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
>  	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
> -	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
>  	mddev_unlock(mddev);
>  	/*
>  	 * md_start_sync was triggered by MD_RECOVERY_NEEDED, so we should
> @@ -10381,11 +10387,16 @@ static void md_start_sync(struct work_struct *w=
s)
>  		memalloc_noio_restore(noio_flags);
>  		__mddev_resume(mddev, false);
>  	}
> -
> -	wake_up(&resync_wait);
>  	if (test_and_clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery) &&
>  	    mddev->sysfs_action)
>  		sysfs_notify_dirent_safe(mddev->sysfs_action);
> +	/*
> +	 * stop_sync_thread() waits for !RUNNING and may then tear down
> +	 * the array. This path still uses mddev after unlocking, so
> +	 * clear RUNNING only after those uses are done.
> +	 */
> +	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> +	wake_up(&resync_wait);
>  }

[Severity: Medium]
Does clearing MD_RECOVERY_RUNNING after mddev_unlock() and
__mddev_resume() cause md_check_recovery() to drop pending
MD_RECOVERY_NEEDED events?

Both mddev_unlock() and __mddev_resume() wake mddev->thread after
releasing reconfig_mutex while MD_RECOVERY_RUNNING is still set and
MD_RECOVERY_DONE is clear:

CPU0 (kworker)                    CPU1 (mddev->thread)
md_start_sync()
  /* not_running: */
  mddev_unlock(mddev)
    mutex_unlock(&reconfig_mutex)
    md_wakeup_thread(mddev->thread)
                                  md_check_recovery()
                                    mddev_trylock(mddev)
                                    if (test_bit(MD_RECOVERY_RUNNING, ...))
                                      unregister_sync_thread(mddev)
                                        /* !MD_RECOVERY_DONE */
                                        clear_bit(MD_RECOVERY_NEEDED, ...)
  clear_bit(MD_RECOVERY_RUNNING, ...)

Because no sync_thread is running to later re-set MD_RECOVERY_NEEDED in
md_reap_sync_thread(), any MD_RECOVERY_NEEDED set before that point (for
example by md_error() or spare changes) is permanently lost, stalling
recovery or faulty device removal.  Reconfiguration callers acquiring
reconfig_mutex in that window (such as slot_store() or
remove_and_add_spares()) can also observe MD_RECOVERY_RUNNING still set
and fail with -EBUSY.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110063045.9127=
03-1-dayou5941@163.com?part=3D1
