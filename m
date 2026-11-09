Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794192688;
	b=OXRHPXV/Fm8rPHLalIWjuopvDin7/IWCwPmJCUCMnQdn1cruDoOJgFSdd7TPlUI0FNAC
	 2FyxDWTpsPV9s9/AJkM0kE3Pn0nnxgYb3mKLDJKT3RTW4bxu7moBXETek5aTawHglfJk8
	 idu4YWPlxXykRhS0bxlkN6HzSJaWP4ZbO45kcuq/6/3kjr5hvA8I6GDq0kYnlGjpWS0+A
	 4p3gcNZICwS0RXKE65nOYz+qT8coD6dRUkf5erV5UQLXBFv3q2LkPM1/wE/SF1QzmbIPF
	 yHNmj55XKCZ7F+TWneVPUmyyiGnlJK4F4A0FrTfZ1ixdUg18J3P3TkrXf0t2HAaRBhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794192688;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EKHJBa3HdwxFSsfDV786ofhmeZT5x5A4nDTs4Jy/qAI=;
	b=Pjr/F6U34Xqbe0fjDtLCRj0wcdcg9OKYdYj1EWit0Rij0mhOl26wmT/jzXA8rh98fk9Y
	 h2qc9+AsHZ7opuvynTL5HLvPmN8Q2tbCLMNoiC0Ox6gnK3CMb4jm+L3c7IESlrG7e33Ri
	 e33YA2IfBTFDJ4AMVFEi8k/4DTzK6YQ++H+hVcvjAwEA4AxyguKN2NOZJXfQt33ZnNHhk
	 F7/rmpC5ZSAkIpIa4zZ7c2NJVSSa0ccEBz89dyLgGfVuFFFtVjY+maXp/T0GLJjz0FKEu
	 qwH5t25Q25/9EmZmBUny/aEsU4TjglC+GxIdcL3zCKZbzST2Cf65N4/Be0459mjm28Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=asBBwYGh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F5C606A31C
	for <linux-raid@vger.kernel.org>; Mon,  9 Nov 2026 02:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=asBBwYGh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F0A1F0089F;
	Mon,  9 Nov 2026 02:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794192687;
	bh=EKHJBa3HdwxFSsfDV786ofhmeZT5x5A4nDTs4Jy/qAI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=asBBwYGh+xnrPPwTwOaukYexuiUW4KaZZtV41Dpxnxfr9HgUK03rl4wFqDGyUuP0w
	 OIL4UxP8BC5MdHXtGAlxWHd5rOST7AiojbLovDAI0/C0bp+G6T6VFUld/Rw3J4C8Pf
	 JzF875YR8exxXdJvg2hJEXorR4yqrCZ6yYdHM/KKFRCAaINySFu82TTwGvv3uP4y8U
	 thuh4WjzRSe61Bty8FfcgqOe9TvRkDmNMprjT25YRMXPlRT04ot5HRllSN2cRkK9B7
	 MdHJ0zPpjOJedxuJMM/1deHDrUT3+kpVEEmELvbQjWyD+H8IE2WF0cd+WAamslBRp4
	 MEis4CHP8ZDBA==
Message-ID: <sashiko-outbox-204355@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] md: stop sync_work in md_stop() before clearing pers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Youhong" <dayou5941@163.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261109023055.2164333-1-dayou5941@163.com>
References: <20261109023055.2164333-1-dayou5941@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 02:51:26 +0000
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
- [Medium] md: stop_sync_thread() in md_stop() races with running
  md_start_sync()
- [Medium] md: md_check_recovery() can re-queue sync_work during
  md_stop()
--

commit 1d5026b108bd24d6a0ff2d1fe48dedbb1f84d4d9
Author: Li Youhong <liyouhong@kylinos.cn>

md: stop sync_work in md_stop() before clearing pers

This commit sets MD_RECOVERY_FROZEN and calls stop_sync_thread() in
md_stop() so that pending sync_work finishes before __md_stop() clears
mddev->pers.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 03e35386a8028..6f0fb2bb1fc2b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
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
Can stop_sync_thread() return while md_start_sync() is still accessing
mddev after dropping reconfig_mutex?

Once a worker dequeues mddev->sync_work and starts md_start_sync(),
work_pending(&mddev->sync_work) is false, so stop_sync_thread() skips
flush_work(&mddev->sync_work).  In the not_running path of
md_start_sync() (such as on a read-only dm-raid array), md_start_sync()
clears MD_RECOVERY_RUNNING and drops reconfig_mutex before resuming the
device and touching mddev:

CPU0 (raid_dtr)                   CPU1 (kworker: md_start_sync)
                                  clear_bit(MD_RECOVERY_RUNNING, ...)
                                  mddev_unlock(mddev)
mddev_lock_nointr(&rs->md)
md_stop(&rs->md)
  stop_sync_thread(mddev, true)
    !test_bit(MD_RECOVERY_RUNNING)
    return
  __md_stop(mddev)
mddev_unlock(&rs->md)
raid_set_free(rs)
  kfree(rs)
                                  __mddev_resume(mddev, false)
                                  test_and_clear_bit(..., &mddev->recovery)
                                    <-- use-after-free

Unconditionally calling flush_work(&mddev->sync_work) after
__md_stop_writes() or after mddev_detach() stops mddev->thread would
ensure md_start_sync() has completely finished before raid_dtr() frees
struct raid_set.

[Severity: Medium]
Can md_check_recovery() re-queue mddev->sync_work while
stop_sync_thread() drops reconfig_mutex in md_stop()?

stop_sync_thread() is called before __md_stop() -> mddev_detach() stops
mddev->thread.  When MD_RECOVERY_RUNNING is set on entry,
stop_sync_thread() unlocks reconfig_mutex (waking mddev->thread) and
waits for MD_RECOVERY_RUNNING to clear before re-locking reconfig_mutex.

On a read-only array (such as dm-raid during raid_dtr() after
raid_postsuspend()), the !md_is_rdwr(mddev) branch of
md_check_recovery() does not check MD_RECOVERY_FROZEN before queuing
sync_work:

drivers/md/md.c:md_check_recovery() {
    ...
		if (!md_is_rdwr(mddev)) {
			...
			if (md_spares_need_change(mddev)) {
				set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
				queue_work(md_misc_wq, &mddev->sync_work);
			}
    ...
}

This allows mddev->thread to queue a new sync_work before
stop_sync_thread() re-acquires reconfig_mutex:

CPU0 (raid_dtr)                   CPU1 (mddev->thread)
md_stop(&rs->md)
  set_bit(MD_RECOVERY_FROZEN, ...)
  stop_sync_thread(mddev, true)
    mddev_unlock(mddev)
    wait_event(resync_wait, ...)
                                  /* previous sync finishes */
                                  md_check_recovery()
                                    mddev_trylock(mddev)
                                    set_bit(MD_RECOVERY_RUNNING, ...)
                                    queue_work(..., &mddev->sync_work)
                                    mddev_unlock(mddev)
    mddev_lock_nointr(mddev)
  __md_stop(mddev)
    mddev->pers =3D NULL
raid_set_free(rs)
                                  /* kworker runs md_start_sync() */
                                  remove_spares()
                                    mddev->pers->hot_remove_disk()
                                      <-- NULL pointer dereference / UAF

Checking MD_RECOVERY_FROZEN in the !md_is_rdwr(mddev) path of
md_check_recovery() (matching the read-write path), or stopping
sync_work after mddev->thread has been stopped, would close this race.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109023055.2164=
333-1-dayou5941@163.com?part=3D1
