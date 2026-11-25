Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795603957;
	b=p4gUh23AprcItm0EE9JCY7oGmW+Q/nRuiUh3BR/APm4GUvE8TB34ppgxhTWB4dLoSo1E
	 0pSKbSNfzq9akQFZCXY7Ndubi/K1WX4qIEEbwP1Y2wwTKGc10epuAYwooLUE794dAnTA+
	 HAuOCwmqUmotjnKmFmNCqzpzkougXkSfBTRR/chmv1pV+FbbArGVJ3RaS9SMFuckAbemi
	 0beekzKuT+woJBlgAYn5lg22N2uFNGKWACUm4j7sEm/vv2anmr8H1Ozvj+Dun586rvc2j
	 b7yeJ5ZT9ZG/YGh/QxyJ37dA8a1SFp6hOWDbXce6KPRf1H9a/v72vU4Ns8M+VaDjgMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795603957;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XDSXEAtd5tmCxeIOOXJS3F5FL+B9RgtrnibHefwFMzM=;
	b=NParrp6LNcrhYJCOEfu8C5VOdyvJhz7JqIX3dOOitAYRQNms7yBnhdygRzUCYf2QfD2B
	 5jOCulD8rSuwEfmupNbB0i6ZRXJ4jrRloW+t5qNYyxJSaOfxP/RRENghOLTurvWML4iW5
	 VUenqqLIDi/0WlEnLEIxXfGjTdga17t60pYGeg53rr395Jsns90CuST+bHKYLUjog9Sfs
	 K2Dsk02nmB/yhoOQe6GIE9qXN1OyJqAMDRtQXP1fxxYSFlCqZx1EKM7cqFcHMFXvPSMAP
	 sa3GOYZfGLaIBhRIirbGDlRuWm94LIqrIpBNiYV0dzHqestI8/a7Yr+P1SUFXbE0W4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SxTKs+e5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEFD606A31E
	for <linux-raid@vger.kernel.org>; Wed, 25 Nov 2026 10:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SxTKs+e5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898B81F000CA;
	Wed, 25 Nov 2026 10:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795603956;
	bh=XDSXEAtd5tmCxeIOOXJS3F5FL+B9RgtrnibHefwFMzM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SxTKs+e5SoISWW/lIjBlu98pjmOWI6IanwWXKsipHNsJIZCTtYrF2AnBgPFT5tmaU
	 Z1t0digLNlYQatUWkKQj49tYa4sgR2KuDukx3JD3PMV2pJahRn2Z4KdTDCFfmrsVg3
	 DZUNGqMgXpPWeEl1yosTbwJbuHO1H2Eiai3MGjuEaTKTF5cmadoB0YJtg3aJb142Cz
	 TYJiuY0qn/Mvk4I+dxSQfu0In0Byg0rF1ddTyYVLn4ge7UqmaB9b+Sj+fQUGKZ4LlI
	 Hj3URN8CxERui8gm1dPPUwrZvNmQlXiuk89vpIJpj9WCzksR6AuyARMCwGEnbpZz8j
	 ZyPWSKbpG8L0A==
Message-ID: <sashiko-outbox-233172@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] md: fix use-after-free of mddev in md_start_sync
 workqueue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shuai Liu" <847807867@qq.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <tencent_72E3228BE54C78B91F4B5BB1A4C84B34090A@qq.com>
References: <6b04e83f.9a2182b0.37b108.0036.GAE@google.com>
 <tencent_72E3228BE54C78B91F4B5BB1A4C84B34090A@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 10:52:36 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] md: stop_sync_thread() skips mddev_unlock() when locked is
  false
- [Medium] md: clearing MD_RECOVERY_RUNNING unlocked in md_start_sync()
  loses recovery
- [Medium] md: stop_sync_thread() sets MD_RECOVERY_INTR when idle,
  breaking dm-raid
--

commit caec665a679c8ea640cd24d1ebf83696517d0cc9
Author: Shuai Liu <847807867@qq.com>

md: fix use-after-free of mddev in md_start_sync workqueue

This commit takes an mddev reference when queueing sync_work, flushes
sync_work unconditionally in stop_sync_thread(), moves the clearing of
MD_RECOVERY_RUNNING to the end of md_start_sync(), and checks
MD_RECOVERY_FROZEN in the read-only path of md_check_recovery().

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 47da9edc1c606..29b8eb3082ff5 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5210,13 +5210,13 @@ static void stop_sync_thread(struct mddev *mddev,=
 bool locked)
>  {
>  	int sync_seq =3D atomic_read(&mddev->sync_seq);
> =20
> -	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
> -		if (!locked)
> -			mddev_unlock(mddev);
> -		return;
> -	}
> -
> -	mddev_unlock(mddev);
> +	/*
> +	 * Release reconfig_mutex before flushing sync_work or waiting on
> +	 * resync_wait. md_start_sync() needs reconfig_mutex via
> +	 * mddev_lock_nointr(), so holding it here would deadlock.
> +	 */
> +	if (locked)
> +		mddev_unlock(mddev);

[Severity: High]
Does gating mddev_unlock(mddev) on locked leave reconfig_mutex held when
locked is false?

All callers of stop_sync_thread() enter with reconfig_mutex held; the
locked parameter indicates whether reconfig_mutex should be re-acquired
before returning or left unlocked.  When md_set_readonly() calls
stop_sync_thread(mddev, false), reconfig_mutex is never released:

drivers/md/md.c:md_set_readonly() {
    ...
	stop_sync_thread(mddev, false);
	wait_event(mddev->sb_wait,
		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
	mddev_lock_nointr(mddev);
    ...
}

Besides holding reconfig_mutex across flush_work(&mddev->sync_work) and
wait_event(resync_wait, ...), stop_sync_thread(mddev, false) returns with
reconfig_mutex still held and md_set_readonly() immediately deadlocks on
mddev_lock_nointr(mddev).  mddev_unlock(mddev) needs to be unconditional
here.

> =20
>  	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>  	/*
> @@ -5224,8 +5224,18 @@ static void stop_sync_thread(struct mddev *mddev, =
bool locked)
>  	 * never happen
>  	 */
>  	md_wakeup_thread_directly(&mddev->sync_thread);
> -	if (work_pending(&mddev->sync_work))
> -		flush_work(&mddev->sync_work);
> +	/*
> +	 * Always flush sync_work so that even an in-flight invocation
> +	 * (already removed from the workqueue's pending list but not yet
> +	 * returned from md_start_sync()) is drained. Previously this was
> +	 * gated on work_pending() which is false for running work, and the
> +	 * whole path could be short-circuited by MD_RECOVERY_RUNNING being
> +	 * already clear =E2=80=94 but md_start_sync() now only clears RUNNING =
after
> +	 * its full tail, and unconditionally flushing handles any remaining
> +	 * race where stop_sync_thread() was entered while sync_work was
> +	 * already in flight.
> +	 */
> +	flush_work(&mddev->sync_work);

[Severity: Medium]
Does removing the !MD_RECOVERY_RUNNING early return leave
MD_RECOVERY_INTR set on an idle array?

In dm-raid, rs_get_progress() checks MD_RECOVERY_INTR when the array is
idle to distinguish an in-sync array from an interrupted sync:

drivers/md/dm-raid.c:rs_get_progress() {
    ...
		if (state =3D=3D st_idle && !test_bit(MD_RECOVERY_INTR, &recovery))
			r =3D mddev->resync_offset;
		else
			r =3D mddev->curr_resync_completed;
    ...
}

When an in-sync, idle dm-raid array is suspended via raid_postsuspend() ->
md_stop_writes() -> stop_sync_thread(), setting MD_RECOVERY_INTR with no
sync running leaves the bit set and causes dm-raid status to report
curr_resync_completed (0 if no sync ran since assembly) instead of
resync_offset.

[ ... ]

> @@ -10368,7 +10379,6 @@ static void md_start_sync(struct work_struct *ws)
>  	clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
>  	clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
>  	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
> -	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
>  	mddev_unlock(mddev);
>  	/*
>  	 * md_start_sync was triggered by MD_RECOVERY_NEEDED, so we should
> @@ -10381,10 +10391,18 @@ static void md_start_sync(struct work_struct *w=
s)
>  		__mddev_resume(mddev, false);
>  	}
> =20
> -	wake_up(&resync_wait);
>  	if (test_and_clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery) &&
>  	    mddev->sysfs_action)
>  		sysfs_notify_dirent_safe(mddev->sysfs_action);
> +	/*
> +	 * Drop RUNNING only after the full tail of md_start_sync()
> +	 * completes so that stop_sync_thread() can't observe !RUNNING and
> +	 * return while md_start_sync() is still mid-execution. The put
> +	 * follows so mddev remains alive while the flag is cleared.
> +	 */
> +	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> +	wake_up(&resync_wait);
> +	mddev_put(mddev);
>  }

[Severity: Medium]
Can clearing MD_RECOVERY_RUNNING after mddev_unlock() and
__mddev_resume() race with md_check_recovery() and drop
MD_RECOVERY_NEEDED?

Commit db5e653d7c9f ("md: delay choosing sync action to md_start_sync()")
cleared MD_RECOVERY_RUNNING before mddev_unlock() in the not_running path
so that it was cleared under reconfig_mutex.  With clear_bit() moved to
the end of md_start_sync(), both mddev_unlock() and __mddev_resume() wake
mddev->thread while MD_RECOVERY_RUNNING is still set:

kworker (md_start_sync)           mddev->thread (md_check_recovery)
not_running:
  mddev_unlock(mddev)
    mutex_unlock(&reconfig_mutex)
    md_wakeup_thread(mddev->thread)
                                  mddev_trylock(mddev)
                                  if (test_bit(MD_RECOVERY_RUNNING, ...))
                                    unregister_sync_thread(mddev)
                                      if (!test_bit(MD_RECOVERY_DONE, ...))
                                        clear_bit(MD_RECOVERY_NEEDED, ...)
                                  mddev_unlock(mddev)
  clear_bit(MD_RECOVERY_RUNNING, ...)

Because MD_RECOVERY_DONE is clear, unregister_sync_thread() assumes a
sync thread is running and clears MD_RECOVERY_NEEDED, expecting
md_reap_sync_thread() to set it again when that thread finishes.  Since
md_start_sync() took the not_running path and never started a sync
thread, the pending recovery is lost.  Since stop_sync_thread() now
calls flush_work(&mddev->sync_work) before waiting on
MD_RECOVERY_RUNNING, MD_RECOVERY_RUNNING can stay cleared before
mddev_unlock().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_72E3228BE54=
C78B91F4B5BB1A4C84B34090A@qq.com?part=3D1
