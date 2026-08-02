Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D69E311973
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785702308; cv=none; b=NYZp9PyVkGIyr7MUDeRIFFkcguLl7eT7z4OQNxJ8Z5++SqM36KVZcsddhh0AnFG5tM+hEBtgqrb/Ee8Q1MCN0A1ZK4DLdwMyJWgwlPifM3YIeGTfPWHbeEltaEjVHjlO3yTizcCy3M291XVczRJT94lYSmcBgSSikILU1laFBKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785702308; c=relaxed/simple;
	bh=wu36Hm6Xrg8takK/MN210UojS/BebBr44tK+qjtP0wU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kd0vLbEi1luP8XmP1HOUvsubGiggSNtA72CTP6SUFV7Z37/yCRcWj6DMIAC+SGPVu7OJJp8wkQPzUkOv9gamQd7ENgl9SYQ9GJ0YCOgPgTRB96SIIgKZqg8XH5qFVe8yJKL/+yQthitdFCEOqOvtqGj7wuEwD5FGtMk89OCPhH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C1N9lig/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C1N9lig/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478A11F00A3A;
	Sun,  2 Aug 2026 20:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785702306;
	bh=AuTs/PItcMz0jmqhhe+L6NoIJTJiFo7+YHN+eW0HZVI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C1N9lig/ONrboJVsWh9uqkVMBFaBgpAv4l6l4K4VarUivzxZrt0KDpm7GQeVd7OBs
	 W2fPvGTkZZ6oZ/c0ozeH+vB98146nVBMeo6tu3cyzFE/5n3xARSCOVH9HiYrnPac+9
	 0JToZzNv/RAiCh9L+iEvKRIqTOehhFKFRJ5aqIWRCjHM/cXcEwlJsYYDUjIDNOyxd/
	 F6su/KmBcZ3LbZtYfrz9MmTYvDfofLZBVPhM1JEkYIeJibyx53uIf77LqeH/ykGzDS
	 mx3/pNGBhhATsIsb6qs0Piwv3YErPQAZAD/FmBaCnY8zvuyGfN3Mmp/06vfGE2hnGZ
	 WpTOchpQwKSEQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 16/29] md/md-llbitmap: track target reshape geometry
 fields
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260802195038.164272-17-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-17-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:25:05 +0000
Message-Id: <20260802202506.478A11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Out-of-bounds array access and memory corruption during reshaping =
due to stale chunkshift.

Pre-existing issues:
- [High] Use-After-Free (UAF) due to a TOCTOU race between teardown and tim=
er re-arming in daemon work.
--

--- Patch [16]: [PATCH v5 16/29] md/md-llbitmap: track target reshape geome=
try fields ---
commit dabf6384b9392c331f7703e778887a4f5f7bb15c
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: track target reshape geometry fields
   =20
Track llbitmap bookkeeping for the target reshape geometry while keeping
a single live bitmap instance.
   =20
Add the reshape geometry fields, refresh helper, and update the load and
resize paths to keep the target geometry in sync.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index ddeea20989873..71a4903901425 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

[ ... ]

> @@ -1302,6 +1340,9 @@ static int llbitmap_resize(struct mddev *mddev, sec=
tor_t blocks, int chunksize)
>  		goto out;
> =20
>  	if (reshape) {
> +		llbitmap->reshape_sync_size =3D blocks;
> +		llbitmap->reshape_chunksize =3D bitmap_chunksize;
> +		llbitmap->reshape_chunks =3D chunks;
>  		llbitmap->chunks =3D max(old_chunks, chunks);

[Severity: High]
Does this code need to track or update a chunkshift for the reshape path?

During a reshape that increases the array size, bitmap_chunksize might incr=
ease.
While llbitmap->chunks is clamped here, llbitmap->chunkshift is not updated.

Later, if llbitmap_start_write() processes an I/O to the newly extended reg=
ion,
it uses the stale chunkshift to compute the start chunk:

drivers/md/md-llbitmap.c:llbitmap_start_write() {
    ...
    unsigned long start =3D offset >> llbitmap->chunkshift;
    ...
}

Because chunkshift represents the old, smaller chunk size, start can grossly
exceed llbitmap->chunks. Since llbitmap_start_write() lacks bounds checking
against llbitmap->chunks, it calculates an out-of-bounds page_start index
and calls llbitmap_raise_barrier(), which will directly dereference the
llbitmap->pctl array out of bounds. Can this lead to memory corruption?

>  	} else {
>  		if (blocks < old_blocks && chunks < old_chunks)

[ ... ]

[Severity: High]
This is a pre-existing issue, but could the teardown sequence in
llbitmap_destroy() race with md_llbitmap_daemon_fn() and cause a
use-after-free?

In llbitmap_destroy(), the teardown sets the shutdown flag, deletes the
timer, and then cancels the daemon work:

drivers/md/md-llbitmap.c:llbitmap_destroy() {
    ...
    set_bit(BITMAP_SHUTDOWN, &llbitmap->flags);
    timer_delete_sync(&llbitmap->pending_timer);
    cancel_work_sync(&llbitmap->daemon_work);
    ...
}

However, in md_llbitmap_daemon_fn(), the shutdown check and timer re-arming
are not atomic:

drivers/md/md-llbitmap.c:md_llbitmap_daemon_fn() {
    ...
    if (restart && !test_bit(BITMAP_SHUTDOWN, &llbitmap->flags))
        mod_timer(&llbitmap->pending_timer, ...);
    ...
}

If the work thread evaluates the check to true and is preempted,
llbitmap_destroy() could run, set the shutdown flag, and execute
timer_delete_sync() which returns immediately as the timer isn't pending.
llbitmap_destroy() then blocks in cancel_work_sync().

When the work thread resumes, it calls mod_timer() to re-arm the timer
and exits. cancel_work_sync() then unblocks and llbitmap_destroy() frees
the llbitmap object. When the re-armed timer fires, it will access the
freed memory.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D16
