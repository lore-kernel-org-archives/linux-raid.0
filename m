Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795602492;
	b=kW+ld0+JRwrh5DiSwQSnmAc2/UTVwFUobnZhIPWVmDWsqa6D+ZaEACvCntZR3pVxa6/u
	 g+S21tn0XwKfnKFiSQwERofzO8klDJLWc/FpW4Zu8SU2H9xjk9b8Ju9CUj/tdPfCQo9d/
	 rl+JBh1c1awGMlT8apxgjJsUTfshZe3eLKTX+Ab9l0tKwKBH2mn1h2AyjTc4ZVevXlcOq
	 4Y+hgljy94g7c095/a/DpQn0Wssh0pWyWuGEswdirqNgxJ0mFM7FimshjSj0QdvLjpdn/
	 U51IcNeKjt4t+cdoETi8+DUQAWFlEJaYMsesmV9WsDQ2qglVvU/2vFIzdY7yEu1TWQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602492;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YZ2kjqI7cQlUMNSx5Awk0oaw3gWSpl0UzE5IjhNRdx0=;
	b=HdCEOzGJG2MRyKjk4aowxBWAZ+5gvxdFI7JuFODHxhtgbcmJh0+s5Rz4mIkBTiT2IOsk
	 /9PNN4n7WGK7lsVkkabiBfSHYiq68WLN3hIZV/rXd97TP9UDcVd+jy2GlL7+ezSXvf8Yr
	 Z3Lj/ir36F5MqzteccgLjpKGWM8K2GcZ6CNeBS68OkLPQBXTgtONInev3liEzugMnCFhl
	 kr55zQGO/3JxYZHCg1eJbP0R33rIv7vbkXJDj40x1PK+/zVBULmiW67QzgHcX+Ry36AtX
	 N6PTmIX0s0up6qhMszK/FGrZ9qX+fzyz/lDRHR/RHhwDzT2JHDMHJlVrQ+a84/iskgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OdLo+EVX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFA2606A330
	for <linux-raid@vger.kernel.org>; Wed, 25 Nov 2026 10:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OdLo+EVX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1611F000C6;
	Wed, 25 Nov 2026 10:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795602492;
	bh=YZ2kjqI7cQlUMNSx5Awk0oaw3gWSpl0UzE5IjhNRdx0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OdLo+EVXpaI6yliWqyyFS0rULa6vzXHLRJE3sJ3cABaSHhTlEIcyvPXeXlanKfHyE
	 d2yhzWAM5afxKYAFmz8EN9yBj+7p5LdZ8PMDGJOgA/2tKlNJoTxcqkFSWZ81g5+tzw
	 a+bd+3+/b2OZQd4VokUu8EbMQJWPYuvnTY5eht347hSrk0pmNw+m/7qsVBQ+WUWaZe
	 7l0mPCDCCRR4fd2UaVu3dKV+Z0yGq5MsFswMs9XTQDxBC6y/y1nFHEM34RyhiqioAM
	 ma7KB2+Sg/6A4qSbRKFfN5Gam0OZgpFc+5b7gCiHpiaAy0anBhm14QTjkbxPlwtbgc
	 UhTtJZ1BMCsKg==
Message-ID: <sashiko-outbox-233122@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: fix use-after-free of mddev in md_start_sync
 workqueue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shuai Liu" <847807867@qq.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <tencent_FD9B3C56D33F6E8298C044857BB7342DCB06@qq.com>
References: <6b04e83f.9a2182b0.37b108.0036.GAE@google.com>
 <tencent_FD9B3C56D33F6E8298C044857BB7342DCB06@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 10:28:11 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] md: stop_sync_thread() still races with in-flight
  md_start_sync()
--

commit 956e002b3dd32e5ec98ffbeb74b91b8f0d27187f
Author: Shuai Liu <847807867@qq.com>

md: fix use-after-free of mddev in md_start_sync workqueue

This commit increments mddev->active before queueing mddev->sync_work in
md_check_recovery() and drops the reference via mddev_put() when
md_start_sync() finishes.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 47da9edc1c606..4b9d7ba63efa6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -10361,6 +10361,7 @@ static void md_start_sync(struct work_struct *ws)
>  	md_wakeup_thread(mddev->sync_thread);
>  	sysfs_notify_dirent_safe(mddev->sysfs_action);
>  	md_new_event();
> +	mddev_put(mddev);
>  	return;
> =20
>  not_running:
> @@ -10385,6 +10386,7 @@ static void md_start_sync(struct work_struct *ws)
>  	if (test_and_clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery) &&
>  	    mddev->sysfs_action)
>  		sysfs_notify_dirent_safe(mddev->sysfs_action);
> +	mddev_put(mddev);
>  }

[Severity: High]
Can stop_sync_thread() still return while md_start_sync() is executing its
post-unlock tail?

drivers/md/md.c:stop_sync_thread() {
	...
	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
		if (!locked)
			mddev_unlock(mddev);
		return;
	}

	mddev_unlock(mddev);

	set_bit(MD_RECOVERY_INTR, &mddev->recovery);\
	...
	if (work_pending(&mddev->sync_work))
		flush_work(&mddev->sync_work);
	...
}

Because the workqueue core clears WORK_STRUCT_PENDING_BIT before invoking
md_start_sync(), work_pending(&mddev->sync_work) is false once the work
callback is already running.  When md_start_sync() takes the not_running
path, it clears MD_RECOVERY_RUNNING before calling mddev_unlock(mddev), and
stop_sync_thread() also returns early without flushing sync_work whenever
MD_RECOVERY_RUNNING is already clear:

CPU0                                  CPU1 (md_misc_wq)
                                      md_start_sync()
                                        mddev_lock_nointr(mddev)
stop_sync_thread()
  mddev_unlock(mddev)
  set_bit(MD_RECOVERY_INTR, ...)
  work_pending(&mddev->sync_work)
    -> false
  wait_event(resync_wait,
    !test_bit(MD_RECOVERY_RUNNING))
                                        md_choose_sync_action() -> false
                                        goto not_running
                                        clear_bit(MD_RECOVERY_RUNNING, ...)
                                        mddev_unlock(mddev)
                                          mutex_unlock(&reconfig_mutex)
  mddev_lock_nointr(mddev)
  /* returns to caller */
  raid_dtr() / do_md_stop()
    raid_set_free(rs)
                                        wake_up(&resync_wait)
                                        mddev_put(mddev)  <-- use-after-free

In dm-raid, struct mddev is embedded in struct raid_set, and raid_dtr()
frees the raid_set via raid_set_free() without waiting on mddev->active, so
the in-flight md_start_sync() and the added mddev_put() access freed memory.
Even on standard md arrays where mddev->active delays freeing struct mddev
itself, do_md_stop() proceeds while md_start_sync() is still running, so
md_start_sync() can race with do_md_stop() tearing down mddev->sysfs_action
or setting MD_DELETED before md_start_sync() finishes mddev_unlock() and
__mddev_resume().  In addition, on a read-only array, md_check_recovery()
queues sync_work when md_spares_need_change() is true without checking
MD_RECOVERY_FROZEN, allowing a new sync_work to be queued while
stop_sync_thread() drops reconfig_mutex.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_FD9B3C56D33=
F6E8298C044857BB7342DCB06@qq.com?part=3D1
