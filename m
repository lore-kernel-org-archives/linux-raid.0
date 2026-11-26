Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655188;
	b=ulbRphj88sUrXLlmCAZ1B6lnH69OJAU3fuD2l7q44JUkmqjRTjk60FtTq3mcln+/RBv+
	 ErLylS3XvQaJiNZ1QeIxClnxH1YIZM8bAlpLP9udXIzn0knOCdsr4MyZlgI8h80fEktSt
	 DyylB9eF+wqJW9MiE2F2w6svJunEmAaxEZUAVqRZMfwby5Yzw7Dr9rsqU8UUei8YOkAzi
	 D6HvfWOl0MmN92a2+eeMhQYb6Ce5B4FJNVjpn6vwHQeAeusasMMnh2ootQE/QrYKI7w6V
	 pKAdgBdtXKXkJ9ZYf/o0iaexlt9ZUIUBI6bITacYAblIPPOiZLIH1GShScjNetdeI0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655188;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bPdBesdf78Mwjm6CwQD2CVf7V0uA23/wQ14Uon08LSQ=;
	b=USQ28fdEPDSTgBz2zWKGKzeHEwFcI3mBY8kVrvu2CpWt4Ibo1zRTSAKyOGWfNkii4ROi
	 iuge6dwIcbrDT4CE7lEPOWIZNU6rfzV7+3gJLv7N+uOHjLzs8mL5YhhNCLFOM+6THe3yw
	 VKbdOK4+Wfx3QfD8GpXXIRKaY+le8q5bgxS7L0/qQh93vdxz1fhjzjQtyKuD9iu+MABVv
	 zANl02iUGNh76+d/FkXM3xyvjrPjB5jaC4olJjDte961naHBDDbIvwRJR/OppA32YF6S+
	 mTrn8tt1dkOtW4nVKHx66RfgAPGg00QmLp5g9F53ZEIaffCGQ2NJZHjBnv1y79yg87A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dfj1T2gC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6273D606A31E
	for <linux-raid@vger.kernel.org>; Thu, 26 Nov 2026 01:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dfj1T2gC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE481F000D0;
	Thu, 26 Nov 2026 01:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795655187;
	bh=bPdBesdf78Mwjm6CwQD2CVf7V0uA23/wQ14Uon08LSQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Dfj1T2gCPDjgnZNdGKafSsMVP8rS4qmmGFpTBdJeBii/u4//ZmYOHkDVOI3psamf3
	 Zo4tUl9Bd44TQrR7UZfT2Ru5I7AYOUxbC+jzsrQ228H73OyJu5xpp/SiAuTZ9+7Tq1
	 es92YKvXypA+qK/ktJI3IisvusuDyk+kbUb94/mW+5RY+McJJC7wa59swFrn7zH0md
	 YnGyhtkg2c14JGMxTCEvMRJqGuHZK0KkUQm6apaJ2BH5ep6DUXIZPKiC/blRG0ZuHP
	 4pAHdr8y8SeqMj7hdTsyBdF/zpt6hnzhNfd7CNVO/IYX66WTfOP5E5+lzR2YaSBpvQ
	 kMMH3RaXr2j3g==
Message-ID: <sashiko-outbox-234521@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] md: fix use-after-free of mddev in md_start_sync
 workqueue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shuai Liu" <847807867@qq.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <tencent_B6137BEEFCD26A2CCBF27D4DF0B81D622608@qq.com>
References: <tencent_B6137BEEFCD26A2CCBF27D4DF0B81D622608@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 01:06:27 +0000
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
- [Medium] md: stop_sync_thread() skips flush_work() after
  MD_RECOVERY_RUNNING clears
--

commit cae588baa1080f65953ef30de3a815480f1b5d39
Author: Shuai Liu <847807867@qq.com>

md: fix use-after-free of mddev in md_start_sync workqueue

This commit takes an mddev reference when queueing sync_work, checks
MD_RECOVERY_FROZEN in the read-only branch of md_check_recovery(), and
flushes sync_work unconditionally in stop_sync_thread() and raid_dtr().

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 47da9edc1c606..dfad785da26b5 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5224,8 +5224,7 @@ static void stop_sync_thread(struct mddev *mddev, b=
ool locked)
>  	 * never happen
>  	 */
>  	md_wakeup_thread_directly(&mddev->sync_thread);
> -	if (work_pending(&mddev->sync_work))
> -		flush_work(&mddev->sync_work);
> +	flush_work(&mddev->sync_work);
> =20
>  	wait_event(resync_wait,
>  		   !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||

[Severity: Medium]
Can stop_sync_thread() still return without calling flush_work() while
md_start_sync() is running?

stop_sync_thread() returns early when MD_RECOVERY_RUNNING is clear:

drivers/md/md.c:stop_sync_thread() {
	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
		if (!locked)
			mddev_unlock(mddev);
		return;
	}
    ...
}

In md_start_sync(), the not_running path clears MD_RECOVERY_RUNNING
before calling mddev_unlock(), __mddev_resume(), and
sysfs_notify_dirent_safe(mddev->sysfs_action) (and on the normal path,
the newly woken sync_thread can finish and be reaped before
md_start_sync() reaches sysfs_notify_dirent_safe()).  Once
reconfig_mutex is released in mddev_unlock(), a concurrent stop or
reconfiguration caller sees MD_RECOVERY_RUNNING clear and skips
flush_work(&mddev->sync_work):

kworker (md_start_sync)           CPU1 (do_md_stop, mode =3D=3D 2)
-----------------------           ----------------------------
not_running:
  clear_bit(MD_RECOVERY_RUNNING)
  mddev_unlock(mddev)
                                  mddev_lock(mddev)
                                  __md_stop_writes(mddev)
                                    stop_sync_thread(mddev, true)
                                      !test_bit(MD_RECOVERY_RUNNING)
                                      return;  <-- skips flush_work()
                                  mddev->to_remove =3D &md_redundancy_group
                                  mddev_unlock(mddev)
                                    sysfs_put(mddev->sysfs_action)
  if (test_and_clear_bit(MD_RECOVERY_RECOVER) &&
      mddev->sysfs_action)
    sysfs_notify_dirent_safe(mddev->sysfs_action)  <-- use-after-free
                                    mddev->sysfs_action =3D NULL

In addition to the mddev->sysfs_action use-after-free, if
md_start_sync() suspended the array and has not yet reached
__mddev_resume(mddev, false), __md_stop() -> mddev_detach() sees
is_md_suspended(mddev) true and skips mddev->pers->quiesce().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_B6137BEEFCD=
26A2CCBF27D4DF0B81D622608@qq.com?part=3D1
