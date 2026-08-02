Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A515314B6E
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785702663; cv=none; b=g8IiTnuzktle6A4jJEXNi1f6NARDLHTqUFBt9EmW+RoUyEAGNkTYyglWGWZ5Tf7iTDdgC0L7Rlc5TuvvpYDg4/ll/Y6kxmp7et08b5IrA2JiRCN2wXUK1tAbFTh+UZ6egOtH3F+nR8iEC4Yet/6I0tHq8D26+XiONjC5lwauvg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785702663; c=relaxed/simple;
	bh=EOpXd84JTRnqT/FDjNQrS59yx9vsKKu6hDwi98cpIUg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VunD5Y561Y2ElFdhd0ZN/bJln0CphKcLcgOJIJojlmtBngy3hXmKNyfYLZ19tlVBSBi5t4hWcN4BDTTerTxVymabhwmk14qXUEU6TVHphztQbWTxfFrxPNNCnEY48+Q2FQCpLPBf0onVIlgoGq+cvajoXtBPCVvqAuqxq+dGjxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KtP5AGyA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KtP5AGyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D5A1F000E9;
	Sun,  2 Aug 2026 20:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785702661;
	bh=BQDFmLFw2kVWQqZFislkPAPtbsUSp88mmgM2OhEFcKo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KtP5AGyAs7fJQLV5JDKgw2Cv+0MnzjtYhTbP5LS0F3lwZwDZNPS9UX85aTdZRPwCe
	 0aWebNV1zOaPd7X5CC/OVt6pUpUL1yo73WAiXpBOCx+3Vm21vz3TCdDr7pgvTBNOBW
	 cEMFK4zDj6RVN2gRa8mMVfJ68NFQzAcHCzTb6XdshOxEXz2UV2U6fhn97f5mfuegUe
	 X6OIKNjY2YT0jmGL7vTwxoHjAW2TTfIwLmwfQAcCdZDwYX7Rgrlew2LkDkVXU12Y9a
	 Adj1xRgjm+gsiH92wfO0p5TRnrZpo/KvqoYmDpQlz0/8JB3dcSSgxc5rBglx7X2Jg1
	 A8/cdy9o5FbAA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 20/29] md/md-llbitmap: don't skip reshape ranges from
 bitmap state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260802195038.164272-21-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-21-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:31:01 +0000
Message-Id: <20260802203101.92D5A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] This problem wasn't introduced by this patch, but a lockless r=
ace condition in `llbitmap_set_page_dirty` causes dirty bitmap blocks to be=
 lost in memory and never flushed to disk.
- [High] This problem wasn't introduced by this patch, but integer truncati=
on of `blocks` can cause an infinite loop in the `md_do_sync` thread.
--

--- Patch [20]: [PATCH v5 20/29] md/md-llbitmap: don't skip reshape ranges =
from bitmap state ---
commit c6db76f6bc970107f68d37fc602584cc2c0e0a1b
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: don't skip reshape ranges from bitmap state

This commit modifies md-llbitmap to stop using stale bitmap state for
skipping reshape ranges. It ensures that reshape progress is tracked purely
by array metadata. This prevents data loss after a restart before checkpoin=
ts
are persisted to disk.

Tested-by: Mykola Marzhan <mykola@meshstor.io>

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index fa16a4224c45a..a20e55fdf82b0 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -1707,6 +1707,14 @@ static sector_t llbitmap_skip_sync_blocks(struct m=
ddev *mddev, sector_t offset)

[Severity: High]
This isn't a bug introduced by this patch, but can integer truncation of
blocks cause an infinite loop in the md_do_sync() thread?

In llbitmap_skip_sync_blocks(), blocks is declared as an int:

    int blocks =3D llbitmap->chunksize - (offset & (llbitmap->chunksize - 1=
));

If the array size and bitmap space require chunksize to exceed INT_MAX (e.g=
.,
a >8TB array with a small bitmap space), chunksize will be >=3D 2^31. Can t=
he
subtraction yield a value >=3D 2^31, which truncates into a negative 32-bit=
 int
(e.g., -1024)?

When this negative int is returned as a 64-bit sector_t, does it sign-extend
to a massive positive value? If md_do_sync() adds this value to the current
sync sector index, could it cause the index to overflow and decrease, loopi=
ng
endlessly back and forth?

>  		return 0;
>  	c =3D llbitmap_read(llbitmap, p);
> =20
> +	/*
> +	 * Reshape progress is tracked by array metadata rather than llbitmap.
> +	 * Skipping reshape ranges from stale bitmap state can lose data after a
> +	 * restart before the corresponding bits are checkpointed to disk.
> +	 */
> +	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
> +		return 0;
> +
>  	/* always skip unwritten blocks */
>  	if (c =3D=3D BitUnwritten)
>  		return blocks;

[Severity: Critical]
This is a pre-existing issue, but a lockless race condition in
llbitmap_set_page_dirty() can cause dirty bitmap blocks to be lost in memory
and never flushed to disk.

Can this sequence actually occur? If llbitmap_set_page_dirty() is called
concurrently with the llbitmap_unplug_fn() flusher thread, the writer sets
the LLPageDirty flag before setting the specific block bit:

drivers/md/md-llbitmap.c:llbitmap_set_page_dirty() {
    ...
    if (!test_bit(LLPageDirty, &pctl->flags))
        set_bit(LLPageDirty, &pctl->flags);
   =20
    // race window here
   =20
    set_bit(block, pctl->dirty);
    ...
}

If the flusher thread clears LLPageDirty and checks pctl->dirty between the=
se
two operations:

drivers/md/md-llbitmap.c:llbitmap_unplug_fn() {
    ...
    if (!test_bit(LLPageDirty, &llbitmap->pctl[i]->flags) ||
        !test_and_clear_bit(LLPageDirty, &llbitmap->pctl[i]->flags))
        continue;
    ...
}

Will it miss the dirty block? The writer then sets the block bit, but
because LLPageDirty is now 0, the flusher will ignore this page indefinitely
until another block happens to be dirtied.

If a dirty block is not flushed to the disk bitmap, will the array fail to
resync that block after a crash or unclean shutdown, leaving stale data on
one of the drives?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D20
