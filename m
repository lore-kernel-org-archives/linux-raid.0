Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C4125B093
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785701946; cv=none; b=LVGDzb7Dojy+soOoS+t52qed2+vrrahjQWN9ofaxH8XQIar8a4xLhlJdXfj0aiBbvLD3GmutkkoSukbfyn5WEEFcDmViJVvaQMVQ1KwaRZWsYi6GKFBT5fPhnSsDInn/m4+w/GHvsCQpXu8Bfzpb0DKkqjfLRPo0JyPwWwR2c6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785701946; c=relaxed/simple;
	bh=+QR+WJNGbPheLXN+mvDD6ewHpcMT0F5R2KKT9US4AvE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=seUk4TkvwhNQDi4vg7h7xsnc+UsaRNbR4g5pLqJQqjTujP0+fauq3UQydLxoWpUSkR6hC8Csg942zuNmdC7HRJxOJypgTJCYHQmozT6bSEo63pZbJ5oADdBTsjwvqjm0hsy1b3GYc0GqmHX9r+H9V6XFdAvifEwkkxtMOCBE1QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EQI5tOuN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EQI5tOuN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BD81F000E9;
	Sun,  2 Aug 2026 20:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785701944;
	bh=pLpk7DewT5xvGBYwNvc6xgRuUc3ZeNd3WDO8tCbUxD4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EQI5tOuNdaxVihFctbEt8S0BVXsFhf874AbnU7gCD3yd2LH2oJzhek6MtCEh7RuZ0
	 rsmVG2WGs/eBbDgez1Dug+PKKC4SmNoP9XrxN6YtA2jJUkHFlq9NitB9NgF0Z1M887
	 sJapDHwUgzpdBy34qIIx0r/23GJ0Mk+oUnCDUaveOpFwxWgHAbORsTE2ggDfvrSvcr
	 4xOyq8fWziwhR5zl5Xp2OjOWim5tT2Z89j0MHl3VcHN+FhBsQPEud01xGbSxYHQgf7
	 DwDZzg+TD48F0dM6ZWdqBXt4J46EkCA2/m/s9f6RPymR6a8GerSlgkeMqPfTqdhS+j
	 M4eaXG12lriLw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 09/29] md/md-llbitmap: stop daemon timer rearm on
 destroy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260802195038.164272-10-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-10-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:19:03 +0000
Message-Id: <20260802201904.53BD81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Time-of-check to time-of-use (TOCTOU) race in the teardown path al=
lows the timer to be re-armed after deletion, causing a use-after-free.
--

--- Patch [9]: [PATCH v5 09/29] md/md-llbitmap: stop daemon timer rearm on =
destroy ---
commit ea383c856bd9022c7e57c7a025fcf8fb539acf1e
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: stop daemon timer rearm on destroy

This commit attempts to fix a race where the daemon timer is re-armed
during array teardown. It adds a BITMAP_SHUTDOWN flag, sets it before
deleting the timer and canceling the daemon work, and checks the flag
before queuing or rearming the work.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

[ ... ]

> @@ -1096,7 +1103,7 @@ static void md_llbitmap_daemon_fn(struct work_struc=
t *work)
>  		goto retry;
> =20
>  	/* If some page is dirty but not expired, setup timer again */
> -	if (restart)
> +	if (restart && !test_bit(BITMAP_SHUTDOWN, &llbitmap->flags))
>  		mod_timer(&llbitmap->pending_timer,
>  			  jiffies + llbitmap->mddev->bitmap_info.daemon_sleep * HZ);
>  }

[ ... ]

> @@ -1179,7 +1186,9 @@ static void llbitmap_destroy(struct mddev *mddev)
> =20
>  	mutex_lock(&mddev->bitmap_info.mutex);
> =20
> +	set_bit(BITMAP_SHUTDOWN, &llbitmap->flags);
>  	timer_delete_sync(&llbitmap->pending_timer);
> +	cancel_work_sync(&llbitmap->daemon_work);
>  	flush_workqueue(md_llbitmap_io_wq);
>  	flush_workqueue(md_llbitmap_unplug_wq);

[Severity: High]
This isn't a bug introduced by this patch, but does this teardown sequence
still leave a race condition that can result in a use-after-free?

Since the BITMAP_SHUTDOWN check and mod_timer() in md_llbitmap_daemon_fn()
are not atomic, a worker can evaluate BITMAP_SHUTDOWN as false but get
preempted before arming the timer.

Concurrently, llbitmap_destroy() sets BITMAP_SHUTDOWN, calls
timer_delete_sync() (which returns immediately if the timer isn't pending),
and blocks in cancel_work_sync().

When the preempted worker resumes, it executes mod_timer(), re-arming the
timer. Once the worker finishes, cancel_work_sync() unblocks and
llbitmap_destroy() frees llbitmap, leaving the timer armed and able to
access freed memory when it fires.

Would replacing timer_delete_sync() with timer_shutdown_sync() safely
prevent any subsequent mod_timer() calls from succeeding?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D9
