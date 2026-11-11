Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794366123;
	b=Ll/AiFZL4WE/6q0OoK6LSYAFoTatiNKxIFsn1T/k3Q51GNv8QzrdNgMTsB+tjtO9Q9Ul
	 VAMe7Y5D1d2MJCgF8YoPWVV+fJJKa2JVoiHsAUTVWHXDVTyR0UQIsgZjri/KXhoiAsmMT
	 Azv5pPdOlyd3PaM36SAGfyP4N7/oiROB2lp4LDwock2n8G67gQCcn0C0herjvkF/HB90M
	 w9I+uzIc6HA26Vx9UmK5nyue9zhWwJ46awtkOtJnzcTL66aS4JcpTnNq2/y9SQS10sren
	 lMJtxTXhxWW9AOxPoC5IoCrQHWu8MR3mAZ4+hiotNnDnpvRmnJ0lH0qyKG64K93WS3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794366123;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4mAzhO6NBc7UuXdwl3nEv5tilm2XylncuHwnTiMga/0=;
	b=IK/+oGycOIbOH3n7/FA+dadcFfXCWjmXudOFLx8ekbBDJV3fbZMpOEwvFyI9ODyRpxYM
	 yhFExGcjlg4OX6xUMa/aECln5BjsI/7z3sOEVsaJO6PiJBJofFqNLA415NScvwFOtnskm
	 FkMFgKnjuGMnwuSe1UViRx6a84rjKr4qbQBDzINgdHM8tqoh3DDfY09Vbu4xHXoqXTxvu
	 EsqoCrN4/vZEqiL9BK/31U6T3Dx8LCovHllcrkUvXOqM6Go9+dr1xcr/xcJFZW6/YevzB
	 6nLfyEgBUslc1EwXorh90uShM5MbDaMejfxPnUi4UD1/kt6SQvcBSm8cSpaDkC5pt1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nzdqr1mA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0D7606A31C
	for <linux-raid@vger.kernel.org>; Wed, 11 Nov 2026 03:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nzdqr1mA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1311F0093C;
	Wed, 11 Nov 2026 03:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794366123;
	bh=4mAzhO6NBc7UuXdwl3nEv5tilm2XylncuHwnTiMga/0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Nzdqr1mA/+jwLCu4zvEPEgJ/8yTuHeiG5+GzEzcNUf9aKnbxCkrtqWqpxBciuy7JM
	 4efHG1QcvLvS6ojGIr6EosaIOHv9zAA7JRlK1W4/vqkKUkyBYyghTW0MuAessOFu9i
	 gFT/NCwpJu14oKl6bQEKbs8sEMte5hjAL0g3i0r2TXJDvTbCGq0gInWZbULnNJr1s8
	 61xnTle+Lss/auZk+r+pTSPYFH4CxmmMM9h88m5umtKTV7Pv8e7+m3b3g2TfkZrCVN
	 oU1gYCFBAdgu35qDzbXU7CYYHpL96H+uVepi0eQmCtncCXbwqXDCSpu4HPmFJzORNW
	 ZhlEmla6jOpOw==
Message-ID: <sashiko-outbox-208147@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] md: fix sync_work vs array teardown races
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Youhong" <dayou5941@163.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261111015027.4029184-1-dayou5941@163.com>
References: <20261111015027.4029184-1-dayou5941@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 03:02:02 +0000
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
- [Medium] md: race and hang in stop_sync_thread() after unlocking
  before checking RUNNING
- [Medium] md: uninhibited event_work queueing in md_stop() causes UAF
  in raid_ctr()
- [Medium] md: stop_sync_thread() drops reconfig_mutex in do_md_stop()
  when pers is NULL
--

commit b6cbc8aaba39ff07f410f3dd2b9e501cae035502
Author: Li Youhong <liyouhong@kylinos.cn>

md: fix sync_work vs array teardown races

This commit stops the sync thread in md_stop(), flushes sync_work
unconditionally in stop_sync_thread(), and checks MD_RECOVERY_FROZEN
before queueing sync_work on the read-only path in md_check_recovery().

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 03e35386a8028..5badcffcffb6b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5199,22 +5199,22 @@ static void stop_sync_thread(struct mddev *mddev,=
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
>  	mddev_unlock(mddev);

[Severity: Medium]
Can dropping reconfig_mutex unconditionally here let do_md_stop() tear
down a newly started and opened array without MD_CLOSING set or the array
suspended?

When array_state_store() handles "clear" while mddev->pers is NULL, it
skips mddev_set_closing_and_sync_blockdev(), takes reconfig_mutex without
suspending the array, and calls do_md_stop(mddev, 0).  Previously,
stop_sync_thread() saw MD_RECOVERY_RUNNING clear and returned without
releasing reconfig_mutex.  Now it drops reconfig_mutex before do_md_stop()
checks mddev->pers or sets MD_DELETED:

CPU0                              CPU1
array_state_store("clear")
  /* mddev->pers is NULL, skips MD_CLOSING */
  mddev_lock(mddev)
  do_md_stop(mddev, 0)
    stop_sync_thread(mddev, true)
      mddev_unlock(mddev)
                                  do_md_run(mddev)
                                    md_run(mddev)
                                      mddev->pers =3D pers
                                  md_open()
      mddev_lock_nointr(mddev)
    if (mddev->pers)
      __md_stop_writes(mddev)
      __md_stop(mddev)            <-- stops active, open, unsuspended array

Tearing down the active array while I/O is in flight can cause a NULL
pointer dereference or use-after-free on mddev->private.

> -	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
> +		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +		/*
> +		 * Thread might be blocked waiting for metadata update which
> +		 * will now never happen
> +		 */
> +		md_wakeup_thread_directly(&mddev->sync_thread);
> +	}
>  	/*
> -	 * Thread might be blocked waiting for metadata update which will now
> -	 * never happen
> +	 * md_start_sync() may still use mddev after unlocking. Always
> +	 * flush so teardown waits for that work to return; checking
> +	 * work_pending() is not enough once the work is running.
>  	 */
> -	md_wakeup_thread_directly(&mddev->sync_thread);
> -	if (work_pending(&mddev->sync_work))
> -		flush_work(&mddev->sync_work);
> +	flush_work(&mddev->sync_work);
> =20
>  	wait_event(resync_wait,
>  		   !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||

[Severity: Medium]
Can unlocking reconfig_mutex before checking MD_RECOVERY_RUNNING cause
md_idle_sync_thread() to block for the entire duration of a newly started
resync, or abort a new sync thread?

md_idle_sync_thread() clears MD_RECOVERY_FROZEN before calling
stop_sync_thread(mddev, true).  If MD_RECOVERY_RUNNING is 0 and
MD_RECOVERY_NEEDED is 1 on entry (for example via raid_message() ->
md_idle_sync_thread()), mddev_unlock() wakes mddev->thread, which can now
start a new resync before stop_sync_thread() reaches wait_event():

CPU0                              CPU1 (mddev->thread)
md_idle_sync_thread(mddev)
  clear_bit(MD_RECOVERY_FROZEN, ...)
  stop_sync_thread(mddev, true)
    sync_seq =3D atomic_read(&mddev->sync_seq)
    mddev_unlock(mddev)
    if (test_bit(MD_RECOVERY_RUNNING, ...)) /* false */
                                  md_check_recovery(mddev)
                                    set_bit(MD_RECOVERY_RUNNING, ...)
                                    queue_work(..., &mddev->sync_work)
    flush_work(&mddev->sync_work)
      /* md_start_sync() registers sync_thread */
    wait_event(resync_wait, ...)  <-- blocks until entire resync finishes

Because no previous sync_thread was reaped, mddev->sync_seq has not
changed and MD_RECOVERY_RUNNING is now set, so wait_event() blocks until
the newly started resync completes across the whole array.  The same hang
happens if MD_RECOVERY_RUNNING was 1 on entry for a sync_work that exited
via not_running in md_start_sync() without incrementing sync_seq, and
md_check_recovery() starts a new sync before wait_event().  Conversely, if
md_check_recovery() reaps a finished sync_thread and starts a new one
between mddev_unlock() and set_bit(MD_RECOVERY_INTR, ...),
stop_sync_thread() sets MD_RECOVERY_INTR on the new sync_thread and aborts
it.

> @@ -7130,6 +7130,14 @@ void md_stop(struct mddev *mddev)
>  {
>  	lockdep_assert_held(&mddev->reconfig_mutex);
> =20
> +	/*
> +	 * md_check_recovery() may have queued sync_work; that work accesses
> +	 * pers. Wait for it here before __md_stop() clears pers, as
> +	 * do_md_stop()/md_stop_writes() do.
> +	 */
> +	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +	stop_sync_thread(mddev, true);

[Severity: Medium]
Can calling stop_sync_thread() in md_stop() cause a use-after-free on
struct raid_set when raid_ctr() fails?

In raid_ctr(), md_run() spawns rs->md.thread and sets MD_RECOVERY_NEEDED
on the read-only array while holding reconfig_mutex.  If a later step in
raid_ctr() fails and jumps to bad_unlock, md_stop() now calls
stop_sync_thread(), which drops reconfig_mutex and wakes rs->md.thread.
Even with MD_RECOVERY_FROZEN set, the read-only branch of
md_check_recovery() still calls md_reap_sync_thread(), which queues
mddev->event_work (do_table_event()):

CPU0                              CPU1 (rs->md.thread)
raid_ctr()
  ...
  goto bad_unlock
  md_stop(&rs->md)
    set_bit(MD_RECOVERY_FROZEN, ...)
    stop_sync_thread(&rs->md, true)
      mddev_unlock(&rs->md)
                                  md_check_recovery(&rs->md)
                                    md_reap_sync_thread(&rs->md)
                                      queue_work(..., &rs->md.event_work)
      mddev_lock_nointr(&rs->md)
    __md_stop(&rs->md)
  mddev_unlock(&rs->md)
  raid_set_free(rs)
    kfree(rs)
                                  do_table_event(&rs->md.event_work)
                                    dm_table_event(rs->ti->table) <-- use-a=
fter-free

raid_ctr()'s error path frees rs without flushing rs->md.event_work (and
raid_dtr() only checks work_pending(&rs->md.event_work), which is false
once the work callback starts running).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111015027.4029=
184-1-dayou5941@163.com?part=3D1
