Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BFB1EFFA1
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 07:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787815026; cv=none; b=vAkSpZuSAtF5zWGtI7y412lOC/RNWkYw1VkndIGrYAEfl/BErrSjVrCGx69IOOVhHW/hxERcp5sPIOO8ds0rsv+/+SpbCvwdW7mtcAHO0R9UYVRskWWsuMPdHIech0SLhhjuAUZSQ5huwCVlTmDbKYN7ftF7RyaSwDzWm1JTcvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787815026; c=relaxed/simple;
	bh=4Q6Pbcx6oWtq1r9AOe+Fq5s5rZTVbckAzDw6SxowCR0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KnV9j07y891LUUcPonLWHSnuQhp61eJY33cB1/vcQbgWYi7m0HOCabk574BDUyxBu1e2Q0YiSCxqDq1ftxA85DEVVnw2kCRMPtzuEW8a7DGNcMBQ5tuhKidhpv/7QpgE9VP0BE1o4DD0Gju+1dVXLSw1y2BY/45mvxr9KU2GVfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ms/hrcxx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ms/hrcxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B651F000E9;
	Thu, 27 Aug 2026 07:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787815024;
	bh=O32VYOlwwmsABXzT5spu+CquPc1WYtaNV6CscD8Kh4Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ms/hrcxxNNQKnzcBsjoMsHVbYvPfY1FBTbmtLjuhv569uNuhohCwLS2wfMP0KfP3U
	 N50FrelYMKhGE3V/a276SR0mk/SvcGNqWQ3zAcVsFY+PJ+exSFKsMAS7QIgH4OTNWD
	 FLDjU049QdyMhq0U9x0HGZuCNTdUswJQhcTiqLg6VUQpN57qio+9XVe52mi0kHCYLO
	 i6DViAVcMma9R8uOlBMjkAo2DpN1GiGZaXb9YSMQadKrwL0UiJlFDeixQSu2mIYt24
	 G1yXjKnl2oKUUud2CAYirSSI94Y/ObJu6Lxfby8OVSP55qSHovMbVgUpYcLgj7WU26
	 CCPs1CGGqEkhw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/3] md/raid5: fix NULL pointer dereference in
 raid5_free_percpu
Reply-To: sashiko-reviews@lists.linux.dev
To: ghuicao@163.com
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260827063235.85375-3-ghuicao@163.com>
References: <20260827023803.36602-1-ghuicao@163.com>
 <20260827063235.85375-1-ghuicao@163.com>
 <20260827063235.85375-3-ghuicao@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 07:17:03 +0000
Message-Id: <20260827071704.25B651F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing workqueue flush before freeing worker structures during ar=
ray teardown.
--

commit 7455143ee1b52af0e50fb9ef4f12b3a32d0dc0c2
Author: Cao Guanghui <caoguanghui@kylinos.cn>

    md/raid5: fix NULL pointer dereference in raid5_free_percpu
   =20
    If cpuhp_state_add_instance() fails in raid5_alloc_percpu(), conf->node=
 is
    never added to the cpuhp instance list and its pprev remains NULL. This
    patch guards the removal with hlist_unhashed_lockless() so that the cpu=
hp
    instance is only removed if it was actually added, preventing a kernel =
panic.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index e481c48b45093..31417c91ab248 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7548,7 +7548,8 @@ static void raid5_free_percpu(struct r5conf *conf)
>  	if (!conf->percpu)
>  		return;
> =20
> -	cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
> +	if (!hlist_unhashed_lockless(&conf->node))
> +		cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
>  	free_percpu(conf->percpu);
>  }

While reviewing the array teardown path modified here, I noticed a separate
issue in the nearby free_thread_groups() function:

drivers/md/raid5.c:free_thread_groups() {
    ...
	if (conf->worker_groups)
		kfree(conf->worker_groups[0].workers);
	kfree(conf->worker_groups);
    ...
}

[Severity: High]
This isn't a bug introduced by this patch, but is a pre-existing issue.

Does this sequence miss a workqueue flush before freeing the worker structu=
res?

During array teardown in md_stop(), raid5_quiesce() waits for active_stripes
to reach 0. This decrement and the subsequent wake_up(&conf->wait_for_quies=
cent)
can occur inside release_inactive_stripe_list(). This is called by
handle_active_stripes() (executed by raid5_do_work() on the worker thread)
after temporarily dropping conf->device_lock.

Once woken, raid5_quiesce() finishes and teardown proceeds to
free_thread_groups(). This function frees the memory backing worker->work
without calling flush_workqueue() or cancel_work_sync().

Meanwhile, the worker thread in raid5_do_work() could still be executing its
trailing loop and workqueue core cleanup code. Could this result in a
use-after-free of the worker structures, leading to memory corruption or a
kernel panic?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827063235.8537=
5-1-ghuicao@163.com?part=3D3
