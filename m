Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6849E38AC90
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 07:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782284841; cv=none; b=DTPPdgttGrBm0++OutIaXhqkf/s/ejzbUweHk8kt+UCvKgYGD9a/KiDd17Fm9IvgMZa3ei1uPlb18iEg7L0iRR4ObDMHUJHlCptnAN3j86xp1MFiGVyP43RWilCAJwfl0JVJFfyq7yIDbG6f1fsCffPKd2aI+sWEaqMyw5nFDzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782284841; c=relaxed/simple;
	bh=RpcXHeejJP5VLG52h9meRUiotcxNZPdhb0mKUG/2WFE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fyJTIay/uhT+LcO8vNXs7ksbJWB7/XIvclhZ3mzpqgAmgW4BVSj0ct/eyIwBd2VdVlODDbsx6EHSE/RkYJzGws1JaUj2gzLaSAFTEuBNnNz8T2ReKUYSmpQ9uCFZNWyE9aZAsVVa7SXgVOWMSWz5eUJMdCayUAsZfIBl/Nsc8wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JXm/KD+/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JXm/KD+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457371F000E9;
	Wed, 24 Jun 2026 07:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782284839;
	bh=nH0p2VVfkeFV1s9RMg4MCpEc6GP0SshmwI/TzWhcGfs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JXm/KD+/L82Dm1ikYugTiAyNiYzY+o+98KfbH4x2Fs5/dIBIzfvEtfM7gp87bRrgO
	 fNC3riSyoUUGnawjSeRPTET3fLEwAAbysjTR22rCkI3ctXfiGr14PqDXUijqmVtHK/
	 LT+rbSfTa0e9rq5i6L1TKm+k/scRY7t8r3B3xsIcxPM7XgWwbkzC3akQFTE/8SnQ7w
	 44W5rYNnyPOgMwLLIKnTrv7+X/o2JrlCtPFd651tLqtMvyRwEigBBWfdZBNZ+PymON
	 3j4JVJFsSl2ASJf6TigZuhyONDrcaTLyGB3QUxyuZHfEbthFkegXqxSb2ybXC96uKr
	 Wie/RUM12XZKw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/20] md/md-llbitmap: track target reshape geometry
 fields
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <5440f676d6637f4c0262862252191c2244363087.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
 <cover.1782282042.git.yukuai@kernel.org>
 <5440f676d6637f4c0262862252191c2244363087.1782282042.git.yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 07:07:18 +0000
Message-Id: <20260624070719.457371F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incomplete teardown of the `pending_timer` and `daemon_work` cycle=
 in `llbitmap_destroy` leads to a Use-After-Free.
- [High] Concurrent array resize causes Use-After-Free on the `llbitmap->pc=
tl` array due to lack of I/O suspension.
--

commit 2a89e33f120722b7687d6b24f4bf95273fa7a498
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: track target reshape geometry fields

Track llbitmap bookkeeping for the target reshape geometry while keeping
a single live bitmap instance.

Add the reshape geometry fields, refresh helper, and update the load and
resize paths to keep the target geometry in sync.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 98e7824c7362e..cdced2126e975 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -289,6 +289,9 @@ struct llbitmap {
>  	unsigned long chunks;
>  	/* total number of sectors tracked by current bitmap geometry */
>  	sector_t sync_size;
> +	unsigned long reshape_chunksize;
> +	unsigned long reshape_chunks;
> +	sector_t reshape_sync_size;
>  	unsigned long last_end_sync;
>  	/*
>  	 * time in seconds that dirty bits will be cleared if the page is not

[Severity: High]
This isn't a bug introduced by this patch, but is there a use-after-free ri=
sk
during llbitmap teardown?

If a user removes the bitmap via the location sysfs node,
llbitmap_destroy() deletes the pending_timer and flushes the I/O workqueue:

drivers/md/md-llbitmap.c:llbitmap_destroy() {
    ...
    timer_delete_sync(&llbitmap->pending_timer);
    flush_workqueue(md_llbitmap_io_wq);
    ...
}

However, it doesn't seem to set a shutdown flag to prevent re-arming.
If the daemon work is executing and finds unexpired dirty pages, it will set
restart =3D true and unconditionally re-arm the timer:

drivers/md/md-llbitmap.c:md_llbitmap_daemon_fn() {
    ...
    if (restart)
        mod_timer(&llbitmap->pending_timer,
                  jiffies + llbitmap->mddev->bitmap_info.daemon_sleep * HZ);
}

Once the work finishes, the flush_workqueue() call in llbitmap_destroy()
returns and the llbitmap structure is freed. Can the re-armed timer then
fire on the freed llbitmap structure?

[Severity: High]
This is a pre-existing issue, but can concurrent array resizing cause a
use-after-free on the llbitmap->pctl array?

When expanding the array size via sysfs, update_size() invokes the
personality resize hook without suspending the array:

drivers/md/md.c:update_size() {
    ...
    rv =3D mddev->pers->resize(mddev, num_sectors);
    ...
}

This eventually calls llbitmap_expand_pages(), which allocates a new
pointer array and immediately frees the old one:

drivers/md/md-llbitmap.c:llbitmap_expand_pages() {
    ...
    kfree(llbitmap->pctl);
    llbitmap->pctl =3D pctl;
    ...
}

Since update_size() only holds the mddev_lock and does not drain in-flight
I/O, new I/O can still be issued.

Could a concurrent I/O path calling llbitmap_raise_barrier() fetch the old
llbitmap->pctl array pointer just before it is freed:

drivers/md/md-llbitmap.c:llbitmap_raise_barrier() {
    struct llbitmap_page_ctl *pctl =3D llbitmap->pctl[page_idx];
    ...
}

and then dereference it, accessing freed memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1782282042.gi=
t.yukuai@kernel.org?part=3D7
