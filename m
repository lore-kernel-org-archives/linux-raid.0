Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2011A5B9D
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 17:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785606223; cv=none; b=F/zfieP0B46khKmiDU2lQl1DJlDNI177vOyekLA9tJJfCQjdplp+GzrPGC4oMCgD+EG2qj5XhndpgeODmEetiocWiv4H3dG6+Ji3vQREZ8LiZx0ngThdJxbms5cOW3nBx1uGnEumjuvf16ufOdpvnmcFgz+D7pP5AuAeN1WuXAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785606223; c=relaxed/simple;
	bh=ECjtca+jzIPPrqrHp+3/ppKG7+cqQV2HPZdLtQp3bdY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XH1UphLzJznFIh3OuzSx5CDVj/kZlg0PdWVUMByR6EKzLwiL2uMV85bJWOJhUAtr5sNBytWDGTVwgI/xfpudxURCW8mE2eg8HMsW+RukxueQWToXNU14grPdJd6yyl+zmMO7DKAX8pykRp7PUy1hYk8VlWHdxOySCvtQR66UNow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H/2Dw3Hl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H/2Dw3Hl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028771F00AC4;
	Sat,  1 Aug 2026 17:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785606222;
	bh=Wg7ZmvXWZJMvOOKxSxm5l9GwZ093xPpYwTU0Jwl+Q8M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H/2Dw3HlMM0Xoh5ItATpvhM2mTUKDSZo2qPiwSRw+JNvIN773KFLppVSIc8lb4V5I
	 MURhUq6TGK/fprvUhllYK5uGui7E5MSB2pEiz6TgsEtbrVgFY41zxOWjXtwkPGo7Og
	 oviJ521wtX4+5F+IGVUmUugbKCvmH4G4GJxQOpc6kykuofMNjlzi7co78lmMb4bMBB
	 tEBnhjvgcVxD5yXFcyqSRA+pQqZUKI+b7fuq8Wq+p+SJU1Ai5AxQbDbG8E0BcLyfE9
	 dFprPJcbvi3WFi0J5lzNSuBz4FHJZoLqlqVA5xGgAD8WcQHyXVvpGYlhQ1RNOP/feb
	 3cfWxqgySXU6Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 01/25] md/md-llbitmap: clear flush state after daemon
 flush
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260801172519.2982121-2-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-2-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 17:43:41 +0000
Message-Id: <20260801174342.028771F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Consuming LLPageFlush in the daemon introduces a race condition th=
at re-arms the timer during array shutdown, leading to a Use-After-Free of =
the llbitmap struct.
--

--- Patch [1]: [PATCH v4 01/25] md/md-llbitmap: clear flush state after dae=
mon flush ---
commit abba2aa11371c8630f75f9bd27a43851e99339eb
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: clear flush state after daemon flush

This commit clears the LLPageFlush bit in md_llbitmap_daemon_fn() rather
than leaving it set. This prevents previously flushed pages from bypassing
the barrier_idle expiry check on subsequent daemon runs, making new writes
wait for the full idle window.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 5a4e2abaa7577..131582724e7e9 100644
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

[Severity: High]
Could clearing the flush bit here introduce a race condition during array
shutdown that leads to a use-after-free of the llbitmap struct?

If llbitmap/daemon_sleep is configured to a small value, stopping the array
invokes llbitmap_flush(), which sets LLPageFlush and queues the daemon:

llbitmap_flush()
    ...
    queue_work(md_llbitmap_io_wq, &llbitmap->daemon_work);
    flush_work(&llbitmap->daemon_work);

If the daemon is concurrently running, it can consume the newly set
LLPageFlush bits via test_and_clear_bit(). The explicitly queued daemon run
would then see flush =3D=3D false, evaluate the unexpired pages, set restar=
t =3D
true, and re-arm the timer.

If disk flushing takes longer than the sleep interval, the timer can fire
and queue the work again.

Later, llbitmap_destroy() calls:

llbitmap_destroy()
    ...
    timer_delete_sync(&llbitmap->pending_timer);
    flush_workqueue(md_llbitmap_io_wq);

Because the timer already fired, timer_delete_sync() does nothing. Then
flush_workqueue() executes the queued daemon work, which incorrectly re-arms
the timer after the deletion point. The struct is then freed, and the timer
subsequently fires on freed memory.

>  			restart =3D true;
>  			continue;
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D1
