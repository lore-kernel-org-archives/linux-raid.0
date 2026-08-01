Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60E83BB10B
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 17:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785606132; cv=none; b=gYined4tvWXm38xmur1ETpIOI76jZqsCIxuVLYyhS6JCAyu+bbByLA52B5M8qRYEuQ+C2Ig/U6yu3cqmTgcM2FkREKrkRSuKuEBgKN3uLal6Hf9E8BypxmUJlQiDzaueHlk7iVP0HBVlVd21m3F+eYPNF8QhHpcmIpctXWX5fmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785606132; c=relaxed/simple;
	bh=ytYbBuzSuK53tI8Y39KwMfg187KCBPbz6CAXHCANFr4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hLh/TkFQ0UQh9Mjktjdd5o7lhNYyqqGdck/LCaoQaaMv+b/YmwNHud2Hngmjw41GkBDyT3tiIrqvGxjIMzLshfg6HObDrbEuLOlz3TIooMABgtjVtaPXyP7L+EaNdIG95+Zl35B85xuB0LDQg884I18S2yU5c24SamMeoS225Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ju1OxXDi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ju1OxXDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDD31F00AC4;
	Sat,  1 Aug 2026 17:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785606131;
	bh=Uj5CP0gIyRwRSsqW43EU4xdXXVNi2b5a9g5M4Is2Xm8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ju1OxXDicGMycjcGk5xmYpNUqS29Ej1fg/Q65jloZAsIJRweWoZW2Imz+xBxo1nsf
	 eJAQdgYdXuImsFOBDslSoXCEUVXqsrcphzNGP+zW05i7c54dgpGIrQUGv5E6o6kUHO
	 xpuZWId5DHCN58Zw1gw/QnZqB7giNVxQFfzgrS7Af6cn0b9jYDbI6QwV0wJSn7mCVd
	 aqqeOWGzhtMkQWfyflxgY+kWR2F14KcOW2jSB6gbizvBzxOOpNmqS2DHgL+Bdy9BSN
	 GQen0L8BOc0+2r67WoVpPPLLZ9GmRTUm2a1RkXEHJjn9PM05kdLwVlgeTpmSR2bGEa
	 BrSDfz9N718ew==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 03/25] md/md-llbitmap: only end fully synced chunks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260801172519.2982121-4-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-4-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 17:42:10 +0000
Message-Id: <20260801174211.2DDD31F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Mutually re-arming timer and workqueue are not safely torn down in=
 llbitmap_destroy(), leading to a Use-After-Free.
- [High] Missing wait for behind writes in llbitmap_destroy() leads to a NU=
LL pointer dereference or UAF when inflight behind writes complete.
--

--- Patch [3]: [PATCH v4 03/25] md/md-llbitmap: only end fully synced chunk=
s ---
commit e6e3673364dedea74baaa7ed43c3fb7a3c397e90
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: only end fully synced chunks
   =20
llbitmap_cond_end_sync() is called with the sync thread's current sector,
which is an exclusive progress boundary where the chunk containing it can
still be in progress. The old code converted that sector directly to the la=
st
bit, which allowed in-progress chunks to be mistakenly marked as synced. Th=
is
patch fixes the issue by rounding the sector down to the nearest chunk
boundary and ending only fully synced chunks.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 6ab2188bba279..be580601d5b91 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

[ ... ]

[Severity: High]
This isn't a bug introduced by this patch, but I noticed a preexisting
issue where the mutually re-arming timer and workqueue are not safely torn
down in llbitmap_destroy().

drivers/md/md-llbitmap.c:llbitmap_destroy() {
...
	timer_delete_sync(&llbitmap->pending_timer);
	flush_workqueue(md_llbitmap_io_wq);
...
}

If md_llbitmap_daemon_fn() is executing concurrently, it finishes its loop,
sets restart to true, and unconditionally re-arms the timer without checking
if the bitmap is being destroyed:

drivers/md/md-llbitmap.c:md_llbitmap_daemon_fn() {
...
	if (restart)
		mod_timer(&llbitmap->pending_timer,
			  jiffies + llbitmap->mddev->bitmap_info.daemon_sleep * HZ);
...
}

Can this lead to a Use-After-Free when flush_workqueue() completes and the
llbitmap struct is freed, leaving an active timer pointing to freed memory?


[Severity: High]
This is a pre-existing issue, but I also noticed missing synchronization for
inflight behind writes before destroying the bitmap.

drivers/md/md-llbitmap.c:llbitmap_destroy() {
	struct llbitmap *llbitmap =3D mddev->bitmap;
...
}

The destroy function does not wait for inflight behind writes to complete
(atomic_read(&llbitmap->behind_writes) > 0). The caller then sets
mddev->bitmap_ops to NULL.

If an inflight behind write later completes in raid1.c:

drivers/md/raid1.c:close_write() {
...
	if (test_bit(R1BIO_BehindIO, &r1_bio->state))
		mddev->bitmap_ops->end_behind_write(mddev);
...
}

Does this cause a NULL pointer dereference (or UAF) since mddev->bitmap_ops
has been cleared concurrently?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D3
