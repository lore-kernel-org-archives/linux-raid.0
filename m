Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C084429D26E
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785702520; cv=none; b=LQoRvVNlRWDsIC//218sPgb4xIqh2PZ5/3rg36bGG11aGbsiEd3s4p+gZ/6RDEKVwwgTysyulUyDkVTdwLbYg6Ai0AtnPTYtfCs1bcVeOrFCuhu8Tqv+laOjUneVw2uGoAInYj4xdgWpdxN99dAFZnfyG5rGpzOSKe3k2MBctKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785702520; c=relaxed/simple;
	bh=f9A6S6hVfFbJxDkPOeEq3gNfhX8y9ci9IDL50zMjzgI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=T3Bk3Otpn0TelPV7DbYsUzFgKobj4I16JEOP4HZ0dYk6W6SblwxZkU4v5dLLm7VnrWJ8w48XYS+1k4fIBjwVReHAA/mfpTWi6QZj4cFpPO4IxGHHepzphDnwG7A3VzhKQWvPJFfZgw7yLu6ATb+fuTHPHVvF7sQNhhDuGp1MhaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wzpxq61l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wzpxq61l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD8F1F000E9;
	Sun,  2 Aug 2026 20:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785702519;
	bh=tnAMkSgUITgGxfbkSYkY7QTsPiM6FAjQXfGiRgLRDck=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Wzpxq61l4D1QsiG0bZRGuTbWAJRGe439gPd7g1+ztQYngN3Hljy4sAjtcp24kKn/I
	 BJMPWeUaqfI6LvBKCmj8HIa6nJgfONQJaSJjBlJ6FedA91HCWJeIJ+nDyOSLa/BTtx
	 zin14n3K1Y4K/oYVkSkHbZyQXOi7JjvILmPXteugjbxT76Jcx36CqEpZSQBJNbiODE
	 L8/sxKXNv3S18kYszKLqGNVhupZyMX09R6hifSsyt0mLlFxYAQiBnzx3nMNY8iI1CV
	 95jinAWgteKPrPA4GHsyGdAOBreIRAceCtbRApqTGu6UZPid90QJLxvfp5aSDJ4yda
	 DabztSZxHEedw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 01/29] md/md-llbitmap: clear flush state after daemon
 flush
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260802195038.164272-2-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-2-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:28:38 +0000
Message-Id: <20260802202839.2BD8F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The patch unmasks a use-after-free of `llbitmap` during array tear=
down by allowing the daemon worker to re-arm the timer after it has been de=
leted.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but threads waiting =
for IO barriers will hang indefinitely if page suspension times out.
--

--- Patch [1]: [PATCH v5 01/29] md/md-llbitmap: clear flush state after dae=
mon flush ---
commit 5b6bbbac2eb163d696a69aa1800138e01de10a7e
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: clear flush state after daemon flush

This patch changes the llbitmap daemon to consume the LLPageFlush bit using
test_and_clear_bit() instead of just testing it. This ensures that after an
explicit flush, subsequent dirty bits on the same page will correctly wait
for the barrier_idle window before being cleaned.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -1066,14 +1066,14 @@ static void md_llbitmap_daemon_fn(struct work_str=
uct *work)
> =20
>  	for (idx =3D 0; idx < llbitmap->nr_pages; idx++) {
>  		struct llbitmap_page_ctl *pctl =3D llbitmap->pctl[idx];
> +		bool flush =3D test_and_clear_bit(LLPageFlush, &pctl->flags);
> =20
>  		if (idx > 0) {
>  			start =3D end + 1;
>  			end =3D min(end + PAGE_SIZE, llbitmap->chunks - 1);
>  		}
> =20
> -		if (!test_bit(LLPageFlush, &pctl->flags) &&
> -		    time_before(jiffies, pctl->expire)) {
> +		if (!flush && time_before(jiffies, pctl->expire)) {
		    ^^^^^^

[Severity: High]
Does consuming the LLPageFlush bit here expose a use-after-free during
array teardown?

During normal array teardown, llbitmap_flush() sets LLPageFlush and queues
daemon_work. Because this patch consumes LLPageFlush, a subsequent execution
of the work can see LLPageFlush as clear. It will then evaluate
time_before(jiffies, pctl->expire) as true, set restart =3D true, and blind=
ly
call mod_timer() at the end of md_llbitmap_daemon_fn().

If this work runs via flush_workqueue(md_llbitmap_io_wq) in
llbitmap_destroy(), it arms the timer after timer_delete_sync() has already
finished:

drivers/md/md-llbitmap.c:llbitmap_destroy() {
    ...
    timer_delete_sync(&llbitmap->pending_timer);
    flush_workqueue(md_llbitmap_io_wq);
    ...
}

The llbitmap is then freed, and the timer can fire on freed memory.

>  			restart =3D true;
>  			continue;
>  		}

[Severity: High]
This isn't a bug introduced by this patch, but threads waiting for IO
barriers will hang indefinitely if page suspension times out.

If llbitmap_suspend_timeout() times out (e.g., due to slow IO), it resurrec=
ts
the percpu_ref but skips calling wake_up(&pctl->wait):

drivers/md/md-llbitmap.c:llbitmap_suspend_timeout() {
    ...
    percpu_ref_resurrect(&pctl->active);
    return -ETIMEDOUT;
    ...
}

The daemon then continues and skips llbitmap_resume() which normally does t=
he
wakeup. Threads waiting in llbitmap_raise_barrier() for the dying state to
clear will never be woken up:

drivers/md/md-llbitmap.c:llbitmap_raise_barrier() {
    ...
    wait_event(pctl->wait, !percpu_ref_is_dying(&pctl->active));
    ...
}

Can this lead to a permanent hang of IO threads accessing the md array?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D1
