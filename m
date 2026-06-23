Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7B93769FE
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 10:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782210048; cv=none; b=sRVAXyXTrGVMbEpcl2pnwXwhNc6pTxpejSIapCm042NyaxPAa6Q/5Qe5UUIVq+k7DcLR2X7+DjLrwo28D4yTK32OW5zJRHWrk7cYM6lCy3U1a+xSb72b5PPkN7CuoYEqmoZainP9UgEO325L/a/EHNspahygv0+hzC3r4d9/dC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782210048; c=relaxed/simple;
	bh=KB5kq+Lb+SJzdN6PKOyVW8lcgKFRGKEOYzXcXIgoc5c=;
	h=Cc:References:Message-Id:From:Content-Type:In-Reply-To:To:Subject:
	 Date:Mime-Version; b=ixsw1Z2Zsld4gBFjHwLbZtK4SIcMQ7s9n6yDrpEJNcq5xbKCQoBt7XulURtrrCJWORHxh9chr9/Ssuk1+AGB7k2TVlzM+c4DuhzfK+lk+vVy+6oAZdKnZYTq5fqK0HD0y0W3rirqlTi9S0618IZrnqjehsmlp2pNlpiCpdxNOv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=RSvbm7mu; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="RSvbm7mu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782210039;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=5YdYUXPymFMjuROW4lLeX68ou59KMxvnjfqYggwilv0=;
 b=RSvbm7muGr+YllMyIVeRS7ysQUnjmgoYJ9wFvPmpOw/N1FIIyW4w/MwTcOLQa8uw3jHr79
 N44BDl5WLOFNsBGJSh/Li+IxxrLyOpqh6bvrIvsX4m2SWujLz2DxgKy31WFjcJ+z6r37ht
 jrTO23q2E30m5BvQYy0SQ8WTZ/idCP0XVk7+NIzyqJcczeJ5AkSf52rK5T+Wu26oLD1xqV
 AjAWsHtVXPQNjC2LAiZuPrTnqOvdCAxRQqNWSVyZIN6znD0JtdGQlidNNpQNOKCBxEYV9h
 MuUJoAqfZxBE9u3O6FCo1RnBoOAIbEJD4BmaCtdFnctmeNJtXtcdYgH0MNDZog==
Received: from [192.168.8.62] ([183.34.169.141]) by smtp.feishu.cn with ESMTPS; Tue, 23 Jun 2026 18:20:35 +0800
Cc: <yukuai@fygo.io>, <linux-raid@vger.kernel.org>
User-Agent: Mozilla Thunderbird
References: <20260622121312.1775322-1-chencheng@fnnas.com> <20260622121312.1775322-2-chencheng@fnnas.com> <20260622122554.E43991F000E9@smtp.kernel.org>
X-Original-From: Chen Cheng <chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a3a5df5+ca6c4e+vger.kernel.org+chencheng@fnnas.com>
Message-Id: <44048e05-f7fa-499e-8bb4-bef56da87e86@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260622122554.E43991F000E9@smtp.kernel.org>
To: <sashiko-reviews@lists.linux.dev>
Subject: Re: [PATCH v5 1/3] md: suspend array when sync_action=reshape
Date: Tue, 23 Jun 2026 18:20:34 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2026/6/22 20:25, sashiko-bot@kernel.org =E5=86=99=E9=81=93:
> Thank you for your contribution! Sashiko AI review found 4 potential issu=
e(s) to consider:
>=20
> New issues:
> - [High] Unmatched mddev_resume() on mddev_lock() failure causes mddev->s=
uspended underflow.
> - [High] The retry loop bypasses array re-suspension but leaves the suspe=
nded flag set, causing unprotected reshape and double-resume.
> - [High] Suspending the array before calling flush_work() creates a circu=
lar memory reclaim deadlock.
>=20
> Pre-existing issues:
> - [High] Cross-task corruption of PF_MEMALLOC_NOIO flags when mddev_suspe=
nd() and mddev_resume() are interleaved.
> --
>=20
> commit ec573079e939aa92bfb3fd89247846ae57883ef2
> Author: Chen Cheng <chencheng@fnnas.com>
>=20
> md: suspend array when sync_action=3Dreshape
>=20
> This patch suspends the md array before starting a reshape operation to
> prevent new requests from allocating objects from the old pool during
> the transition. The array is then resumed on exit.
>=20
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 096bb64e87bd5..e139f36e30b92 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -5258,26 +5258,37 @@ static ssize_t
>>   action_store(struct mddev *mddev, const char *page, size_t len)
>>   {
>>   	int ret;
>> +	bool suspended =3D false;
>>   	enum sync_action action;
>>  =20
>>   	if (!mddev->pers || !mddev->pers->sync_request)
>>   		return -EINVAL;
>>  =20
>> +	action =3D md_sync_action_by_name(page);
>> +	if (action =3D=3D ACTION_RESHAPE) {
>> +		ret =3D mddev_suspend(mddev, true);
>=20
> [Severity: High]
> This is a pre-existing issue, but does calling mddev_suspend() and
> mddev_resume() from concurrent contexts risk corrupting the PF_MEMALLOC_N=
OIO
> task flags?
>=20
> When mddev_suspend() is called, it stores the task-specific NOIO flag int=
o
> the global mddev structure:
>=20
> drivers/md/md.c:mddev_suspend() {
>      ...
>      mddev->noio_flag =3D memalloc_noio_save();
>      ...
> }
>=20
> If two tasks concurrently enter mddev_suspend(), the second task incremen=
ts
> the suspend counter without overwriting mddev->noio_flag. If the first ta=
sk
> then resumes (e.g., on a lock failure) it decrements the counter but retu=
rns
> early because the array is still suspended:
>=20
> drivers/md/md.c:__mddev_resume() {
>      if (mddev->suspended) {
>          mutex_unlock(&mddev->suspend_mutex);
>          return;
>      }
>      ...
>      memalloc_noio_restore(mddev->noio_flag);
> }
>=20
> This prevents the first task from restoring its NOIO flag. When the secon=
d
> task later resumes and drops the counter to 0, it incorrectly restores th=
e
> first task's flags onto its own context. Could this leave the first task
> stuck in NOIO mode indefinitely?
>=20
>> +		if (ret)
>> +			return ret;
>> +		suspended =3D true;
>> +	}
>>   retry:
>>   	if (work_busy(&mddev->sync_work))
>>   		flush_work(&mddev->sync_work);
>=20

Looks like a independent problem, I need to sort out the flow.

> [Severity: High]
> Can holding the array suspended while synchronously waiting for the worke=
r
> thread expose the worker's memory allocations to a circular deadlock?
>=20
> If md_start_sync() allocates memory with GFP_KERNEL in the kworker thread
> (for example, when calling md_register_thread()), it can trigger direct
> memory reclaim. Because the worker thread did not transition the array to
> suspended itself, it does not inherit the PF_MEMALLOC_NOIO flag.
>=20
> Consequently, memory reclaim can issue I/O to the md device. Since the ar=
ray
> is now suspended, md_handle_request() will block this I/O indefinitely. T=
he
> worker thread hangs waiting for I/O, and action_store() hangs here in
> flush_work() waiting for the worker thread, permanently deadlocking the
> array. Is it safe to suspend the array before flushing the work?
>=20
>>  =20
>>   	ret =3D mddev_lock(mddev);
>> -	if (ret)
>> +	if (ret) {
>> +		mddev_resume(mddev);
>>   		return ret;
>> +	}
>=20

Seems suspend_and_lock() after flush_work() more reasonable.

> [Severity: High]
> Does this unconditional mddev_resume() risk underflowing the mddev->suspe=
nded
> counter if the array was not actually suspended?
>=20
> If action_store() is called with an action other than ACTION_RESHAPE, the
> array is not suspended. If the subsequent mddev_lock() fails (e.g., if it=
 is
> interrupted by a signal), the error path unconditionally calls mddev_resu=
me().
>=20
> Since the array was not suspended, __mddev_resume() decrements
> mddev->suspended from 0 to -1. Because mddev->suspended is a signed integ=
er
> and -1 evaluates to true, subsequent calls to mddev_suspend() will see
> mddev->suspended !=3D 0, increment it back to 0, and return immediately w=
ithout
> actually pausing I/O. Could this permanently break the suspension mechani=
sm
> for the array?
>=20
>>  =20
>>   	if (work_busy(&mddev->sync_work)) {
>> -		mddev_unlock(mddev);
>> +		if (suspended)
>> +			mddev_unlock_and_resume(mddev);
>> +		else
>> +			mddev_unlock(mddev);
>>   		goto retry;
>>   	}
>=20

sure, my mistake.

> [Severity: High]
> Will the retry loop bypass array re-suspension while leaving the local
> suspended flag set to true?
>=20
> If work_busy(&mddev->sync_work) is true, the code unlocks and resumes the
> array, then jumps back to the retry label. However, the retry label is pl=
aced
> after the mddev_suspend() block.
>=20
> The code will not re-suspend the array, but the local 'suspended' boolean
> remains true. As a result, the reshape operation proceeds on an active,
> unsuspended array. Furthermore, when the function exits, it will call
> mddev_unlock_and_resume() again because 'suspended' is true, leading to a
> double-resume and another mddev->suspended underflow.
>=20
> [ ... ]
>
