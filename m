Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB87018D643
	for <linux-raid@vger.kernel.org>; Sun,  2 Mar 2025 04:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740890428; cv=none; b=Y0WHMXHb/UFjHHLaKy8T91+9poWhwvynNfy3Eai/44uhD2BHx9Co+6Rn4aDnstJXo760ygWs5Ejgxmb1d738nN3GrSIRlqL2ILj/wqpCVM3sjH3ew4J8dB99Ltr31aJ4JgUXTqYMHHi59hZ2TfqfihJ+AUPJ0SO/T4LvuTtePA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740890428; c=relaxed/simple;
	bh=Icz1Gib9xrpABlhvA2stpKME0V77VXSlA/2yCknejt0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=FJJkOVE/sIAibzLpV0Wgv5MfmjwGj/iKXn/52aCqVHZUPDvlK88YznEKZCUop+vBEKpaPwPzWrQe8kICjyduI+w4l7S3aXVQOI1t3pbWp4uImXtr2BxpEu7tWwB69USrckhCowtJjW7oxIXBdAv3YzUrIAGqrDNbA/foBh+n+sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=T8ZwaVZ8; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="T8ZwaVZ8"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-390f69f8083so1109122f8f.0
        for <linux-raid@vger.kernel.org>; Sat, 01 Mar 2025 20:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1740890423; x=1741495223; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8iozxZ7Yf+WXaE1B7tgovoqMdbCygv2X25mgds3l6GM=;
        b=T8ZwaVZ8aETqnuruZTvqncW6VwFGsWmAgHKkBo+mmsvOsqd3+fhYq2XaQA5m967sw/
         P8ajaXH61tWO80x/iYdEIlVsX+3EEd5WdVOYv393JXcqrLyYK/O7qyKT6eGohE5BPRpA
         5yC65uaIji5pkiDqqFCth+YpDPfEGiPztdsY/PIGNZZAbH8VRwhNeKaP83LwrYyqoTSy
         Qy5ZZ0oB/PyhmDh8ALoInZFcymnLAqQciuWUA7KM1YnJLmicLy02tPpX5VXuRPBtLKMh
         zJvF3AacpVMb3Eij0fLmF2g7EQX3a0BOUCTiSZZrgbA5RnNTiG/LJ7f94Wb9zkWnplJW
         reCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740890423; x=1741495223;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8iozxZ7Yf+WXaE1B7tgovoqMdbCygv2X25mgds3l6GM=;
        b=R+NAdujQ5k7d+6CseonpYL/zYmpfakaS0ZJi9pTN5AHa8SLZLMqY+rQ/KdFhP/J6Nv
         Gqzu17qN/dKnzPDlGFR9EqnmqenvlfdGFhDSsS+m4xzZ7NP3PB7OBqOwEOPsiRwgejWa
         ibX8ZRYGsMhchqBDC9ZKZg3BaJmYYM9O6FRkNN4rqZne53lxUvn5fCUPTEKXwA9H/j34
         CgcMyy19mLqGtHle9472COHkgGDb1si+4IZZiGZDdTcLNuuXJciIA+fVyGHKaWwE5/tL
         +WaQxhCyDtpBWckt3BDMAwvj2L1xVPp5fpWJHI8K+ZV14oP+CZy4mumGSOUns6BrWEGI
         uCwQ==
X-Gm-Message-State: AOJu0Yw0YvE5pEjHwy1Dw6ybaBdskGgPSL8LIuexIBN7tLE3rSLvG/Xe
	ZAbVni9Hcvckum7/mQtSLZwjrSS3aCOurrUH4eer7ZTRaR9oeDpbEsBFPSZHplCmeXuhecWwi4x
	ZsSA=
X-Gm-Gg: ASbGnculdSOLMyakDJfODJWvdLlIqStn+HTh736KA1hNg9lP/lOE9zwlJdnOZo9cC7E
	Dm00sNjfD2osP9I/EeyBrVdjjZd7OJP1bK4u/ceslVnFsjsDJFFW+5XTXy5pB0xSJvYZThYtBNA
	qJ8HB9JLaD5IhPa1nAumxwzfWXDtryKEwA5MiWXhiXzTINwAyGrvV62wzpbU9DzADRuVdB8Jt4T
	Ukxs129ZZPk8jOsmuPy1mRBfGZzBINZcrT7zpXSJrOJiiLLNCgVRjK15GVSmXMSkadsx3GvITU6
	STfxSl4lvYyGKfjYYJRd462+/j41saapbZERl5KA0ld7uQ4=
X-Google-Smtp-Source: AGHT+IGMVKi/bWaBhM+baS6QvA2k8DR0//QVL/2EsUznn3cguo1A4ct5fx7nVhl7OXBctQpWjQX+Pg==
X-Received: by 2002:a05:6000:401f:b0:38d:d664:67d8 with SMTP id ffacd0b85a97d-390ec7c6738mr8362572f8f.11.1740890423520;
        Sat, 01 Mar 2025 20:40:23 -0800 (PST)
Received: from smtpclient.apple ([23.247.139.15])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e897634926sm39661016d6.9.2025.03.01.20.40.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Mar 2025 20:40:23 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH] md/md-bitmap: fix wrong bitmap_limit for clustermd when
 write sb
From: Glass Su <glass.su@suse.com>
In-Reply-To: <20250302043423.95503-1-glass.su@suse.com>
Date: Sun, 2 Mar 2025 12:40:08 +0800
Cc: hch@lst.de,
 ofir.gal@volumez.com,
 Heming Zhao <heming.zhao@suse.com>,
 yukuai3@huawei.com,
 Su Yue <l@damenly.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4D915613-1D39-4ADD-8F38-C40A9B3372C3@suse.com>
References: <20250302043423.95503-1-glass.su@suse.com>
To: linux-raid@vger.kernel.org
X-Mailer: Apple Mail (2.3826.400.131.1.6)



> On Mar 2, 2025, at 12:34, Su Yue <glass.su@suse.com> wrote:
>=20
> In clustermd, Separate write-intent-bitmaps are used for each cluster
> node:
>=20
> 0                    4k                     8k                    12k
> -------------------------------------------------------------------
> | idle                | md super            | bm super [0] + bits |
> | bm bits[0, contd]   | bm super[1] + bits  | bm bits[1, contd]   |
> | bm super[2] + bits  | bm bits [2, contd]  | bm super[3] + bits  |
> | bm bits [3, contd]  |                     |                     |
>=20
> So in node 1, pg_index in __write_sb_page() could equal to
> bitmap->storage.file_pages. Then bitmap_limit will be calculated to
> 0. md_super_write() will be called with 0 size.
> That means node the first 4k sb area of node 1 will never be updated
> through filemap_write_page().
> This bug causes hang of mdadm/clustermd_tests/01r1_Grow_resize.
>=20
> Here use (pg_index % num_pages) to calculate bitmap_limit to fix it.
>=20
> Fixes: ab99a87542f1 ("md/md-bitmap: fix writing non bitmap pages")
> Signed-off-by: Su Yue <glass.su@suse.com>
> ---
> drivers/md/md-bitmap.c | 8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 23c09d22fcdb..e055cfac318c 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -426,8 +426,8 @@ static int __write_sb_page(struct md_rdev *rdev, =
struct bitmap *bitmap,
> struct block_device *bdev;
> struct mddev *mddev =3D bitmap->mddev;
> struct bitmap_storage *store =3D &bitmap->storage;
> - unsigned int bitmap_limit =3D (bitmap->storage.file_pages - =
pg_index) <<
> - PAGE_SHIFT;
> + unsigned long num_pages =3D bitmap->storage.file_pages;
> + unsigned int bitmap_limit =3D (num_pages - pg_index % num_pages) << =
PAGE_SHIFT;
> loff_t sboff, offset =3D mddev->bitmap_info.offset;
> sector_t ps =3D pg_index * PAGE_SIZE / SECTOR_SIZE;
> unsigned int size =3D PAGE_SIZE;
> @@ -436,7 +436,7 @@ static int __write_sb_page(struct md_rdev *rdev, =
struct bitmap *bitmap,
>=20
> bdev =3D (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
> /* we compare length (page numbers), not page offset. */
> - if ((pg_index - store->sb_index) =3D=3D store->file_pages - 1) {
> + if ((pg_index - store->sb_index) =3D=3D num_pages - 1) {
> unsigned int last_page_size =3D store->bytes & (PAGE_SIZE - 1);
>=20
> if (last_page_size =3D=3D 0)
> @@ -472,7 +472,7 @@ static int __write_sb_page(struct md_rdev *rdev, =
struct bitmap *bitmap,
> return -EINVAL;
> }
>=20
> - md_super_write(mddev, rdev, sboff + ps, (int)min(size, =
bitmap_limit), page);
> + md_super_write(mddev, rdev, sboff + ps, min(size, bitmap_limit), =
page);

Unintended change. Fixed in v2.

> return 0;
> }
>=20
> --=20
> 2.47.1
>=20

