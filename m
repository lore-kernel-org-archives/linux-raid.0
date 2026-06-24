Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE40030674B
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 07:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782284523; cv=none; b=XQZg8/OCwiErFtHpJnm06YIuwZCDszWb9nOw1lJh+RLJYEtfhfN96IhMmL3jfh0Juvp5gyEUfSSTiRwuNFnWq9TGhZPv9scVphktiyipierXHlEsvigThL7hW2Wbu4yyMpfRSfQ0CwO9qarEPGt84GtwMvvixxwNXm7E7p1fkjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782284523; c=relaxed/simple;
	bh=YKIYcsRe+/5Tx4iePTRThaMkZXyvZa+R3N28kUMOMGU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iE/VcQ7QFjcJE+AsfgNJWml4S2TuERBvsEf/h+Yo6biOatZvJvID8M4liAn1cwEgEJxb7BJ+0Zj8Ptvlb+IKTLVvKvLg0F32WhbtjKlY+Ci/WojLyC+K4C3BMQUwBAk2MlreZoHQbeIhrWhXi2EMhB9fRP6dJizAVnYKByUxMmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/+EDPrn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/+EDPrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524001F000E9;
	Wed, 24 Jun 2026 07:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782284522;
	bh=Vyla9jI8vThhmPDGKB6N45IhtYLUqzLBJ6JkrZQd9Os=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R/+EDPrnWwvRal2caiEjZ8chGWz6Iw78i5c9DPWyMxyC3a4baEGLhzEAcuEmgNuTm
	 INuoUUhXXU7AGMw9hn61M3s58UC82LDt3SR21A9Mi1i0NdSmRuHzZHiLmXEg1hlUbo
	 G1ZZBrRIuQ+0oU+nSVj/gqxW5bpkXCNtioTxmupdhDRjvgSXPS6h/Jqsl8AmuHs6xZ
	 5FywQC4+19ymbnAERUtY6za2eMOusSey+lfVswNFBXWo7oBEzrOzR+F9P+aAfyssxe
	 576aHiI9iNbkcS+0JzPguM+JV/FfyLNabiD4HNsBjJi42206HWaMeX6agx0wTqTBf5
	 bBunwMI9yvwfg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/20] md/md-llbitmap: allocate page controls
 independently
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <6e1ca7ea2cb90ae58c47230a90f3f08d51658829.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
 <cover.1782282042.git.yukuai@kernel.org>
 <6e1ca7ea2cb90ae58c47230a90f3f08d51658829.1782282042.git.yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 07:02:01 +0000
Message-Id: <20260624070202.524001F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Eager allocation of physical memory and disk I/O for the entire un=
used reserved bitmap space causes severe memory consumption and I/O stall r=
egressions.

Pre-existing issues:
- [Critical] The bitmap space validation omits BITMAP_DATA_OFFSET, potentia=
lly allowing the bitmap to overflow its physical bounds and corrupt user da=
ta.
--

commit 880054f58bccd2442566ac1e584d6d9c8fc01e7e
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: allocate page controls independently

Allocate one llbitmap page-control object at a time and free each
object through the same model.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index e3500a1a52c07..4c3fc4b35aff0 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

[ ... ]

> +static int llbitmap_alloc_pages(struct llbitmap *llbitmap)
> +{
> +	unsigned int used_pages =3D llbitmap_used_pages(llbitmap, llbitmap->chu=
nks);
> +	unsigned int nr_pages =3D max(used_pages, llbitmap_reserved_pages(llbit=
map));
> +	int i;

[Severity: High]
Does this unconditionally eager-allocate memory and write out the entire=20
reserved space?

By setting nr_pages to the maximum reserved space:
nr_pages =3D max(used_pages, llbitmap_reserved_pages(llbitmap));

and unconditionally allocating a physical 4KB page for every index up to=20
this limit in llbitmap_read_page(), this seems to allocate RAM for all=20
reserved, unused pages.

Furthermore, will functions like __llbitmap_flush() now iterate over all=20
these allocated nr_pages, marking them dirty and synchronously writing them=
=20
to disk, potentially causing severe I/O stalls for arrays with large=20
reserved bitmap spaces?

> +
> +	llbitmap->pctl =3D kcalloc(nr_pages, sizeof(*llbitmap->pctl), GFP_KERNE=
L);
> +	if (!llbitmap->pctl)
> +		return -ENOMEM;

[ ... ]

> @@ -923,7 +948,7 @@ static int llbitmap_init(struct llbitmap *llbitmap)
>  	llbitmap->sync_size =3D blocks;
>  	mddev->bitmap_info.daemon_sleep =3D DEFAULT_DAEMON_SLEEP;
> =20
> -	ret =3D llbitmap_cache_pages(llbitmap);
> +	ret =3D llbitmap_alloc_pages(llbitmap);

[Severity: Critical]
This is a pre-existing issue, but does the bitmap space validation here
omit BITMAP_DATA_OFFSET?

In llbitmap_init() and llbitmap_read_sb(), the validation checks ensure
the total bitmap size (chunks) doesn't exceed the reserved byte length
(space). However, they don't seem to account for the 1024-byte
BITMAP_DATA_OFFSET that is prepended to the bitmap data on disk.

If chunks is close to or exactly equal to space, the total byte size
required (chunks + BITMAP_DATA_OFFSET) could exceed the physical bounds
of the reserved space. During flushes, could llbitmap_write_page() write
across the reserved bitmap boundary and overwrite adjacent user data?

>  	if (ret)
>  		return ret;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1782282042.gi=
t.yukuai@kernel.org?part=3D5
