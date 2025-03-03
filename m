Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80C6156237
	for <linux-raid@vger.kernel.org>; Mon,  3 Mar 2025 03:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740973210; cv=none; b=EaKz6qSMXmFPPECUC8h2WH16Bu+lNodn89kcX3g/ODV46zPo3E8hG/NTLv3wL/i40zUxqFPXdX1rV2aMuvYrHWRjYgEJLyX2HV0RIzuCa3538jlupD6Kyk+9n/YHm1A+TUxz5q1iJfE74fcAz8yFiRBWADlPk7arv8XvH8Vw2Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740973210; c=relaxed/simple;
	bh=Ui4ci3zf/9L6Vh8J/Jn5o9tkuI6s4Gw3F3u/PVnfQ2A=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=j7Y0NnXtfmsltxkatehJs8l/4ZqWJ64qWMpnhisTWthtuwjsx/Aw0cwQM2AU+QBtXoaphUynt8WkT7k7cJFzLmhzSlA6/piNIrOV2bYVyhAq7aZQeopWKvFu2WuDqeeFPZgy7ZBaMNid6tbnfbmkQl20+Mhqt4nSdNlMDvBFj1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RVgaa1ht; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RVgaa1ht"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5e4ad1d67bdso6172891a12.2
        for <linux-raid@vger.kernel.org>; Sun, 02 Mar 2025 19:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1740973206; x=1741578006; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JSCsl51IpQ8LmMv/MOYk61/iDDMpBI9YvUrQpkXRbpQ=;
        b=RVgaa1htD0nffLfM3n6vlFhUUhWfsJ4VjIB2f1XQdEkJ63GwLwKJpa3+nG5Ms1BTgD
         opq1rqt0rP4P9eDHwMNvLSzcwFlBLUCIKJsj8FbOAFmbBB4xfPi0DSzUYJ7g9Q5t1XRt
         vF6RxRN/PKxmeA5z4ybYgLTAAC+QpHhRLv4f2ob1u3m1gI53auzKBUbpxyEn35DkaJqm
         aWk7+e0UgI6aE3cixHjBzdlhtVWrcjVtmN2tj2sKRVCnOjUZ+E+I3mNzcdkpNefyLzgT
         7nv7RAEF03zVXfqRmNk9jUfYiqzNQj55UKJGHNqX1P19yw6NG5ezKpVzZIbIP/qZt4U1
         8XLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740973206; x=1741578006;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JSCsl51IpQ8LmMv/MOYk61/iDDMpBI9YvUrQpkXRbpQ=;
        b=nRn6yy5hk7628DV+5K6hdMJlBib3V2YgPyxR+M43G8rpuS/38zTs2I50Umbt1JCV9n
         zSI7LX7olBFcIgCs/GhfaZj/gqXfyC+biJQHccAtFieAKJwnYxCT8xYvIaaZd3YUJxJZ
         YNtfOoIZY1GsLSC2DqClaiHhUAerQugiizlbhAhh0cKxuqpnMrgMXk04N/pTvfQ6f2oP
         THZAheFv7kHZb2OZLj6THYIVomx5LtDWIE5pnOZoIUhofR+NV2e3rk6Muom5DIMcFlq/
         c6GLqzW9lYFJddGFqfbmSVx92Ei8azQaR2xZvj3w/4d34pzRopgIFCtVGitwRYAPqRLx
         npRw==
X-Gm-Message-State: AOJu0YzCIRBb0rBVx5R+mSmN/91PwN5KbHRU3d2biByAmKUCA9Ub0B4E
	idfvVZqed+bI66KH8qz1vagZ7lmJv8Srkei4MmbOFt2aXtVAagAoaWVak583fwM=
X-Gm-Gg: ASbGncv7+Af4GhsxqdKkoWt5px5/T2Pwtqtcn5nrihtxgx+k8FajB0yKRxDie7VPGPr
	aS3of7E48XWQV/9mSUVJYCRXvYDAgiKdDbqhmq+3hlUSgDUPWxyFwn8ncyZwm/2zftZf8SXbayH
	MKzC21OHsp2NXVH2YKvHbby5zzxW7KGKJ0NFtOGgHO73l0DzDbYkYJQ3o2HdpylUh9OrpA6nLfo
	LrlmV9ikikdYRhL3OHDgYyjFLXa//2Gby5RJAoiU1KeMGIj+65FuQmtP3Z8OmEU4h74ogMEGCLu
	+VIp9eORqG08/n22REcr4U9/QiwCmQpZT7t0AusPeaSTsvjn
X-Google-Smtp-Source: AGHT+IEkBp13B3TqJBQpl5Ug9zCozxEW9lJ5NeC7DvG/yeAuED0EU7do0DRQO5s3xBtEFB6c5Q13Cg==
X-Received: by 2002:a17:907:969e:b0:ab7:87ec:79fa with SMTP id a640c23a62f3a-abf265fe422mr1429167466b.51.1740973205987;
        Sun, 02 Mar 2025 19:40:05 -0800 (PST)
Received: from smtpclient.apple ([195.245.241.170])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7363cd5c39bsm3035523b3a.174.2025.03.02.19.40.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Mar 2025 19:40:05 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH v2] md/md-bitmap: fix wrong bitmap_limit for clustermd
 when write sb
From: Glass Su <glass.su@suse.com>
In-Reply-To: <5925f944-be6a-4f49-9946-a77ef4d3c2f3@suse.com>
Date: Mon, 3 Mar 2025 11:39:50 +0800
Cc: linux-raid@vger.kernel.org,
 hch@lst.de,
 ofir.gal@volumez.com,
 yukuai3@huawei.com,
 Su Yue <l@damenly.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C20AD799-0E78-435B-AAC0-EB01E4E2EC93@suse.com>
References: <20250302043905.95887-1-glass.su@suse.com>
 <5925f944-be6a-4f49-9946-a77ef4d3c2f3@suse.com>
To: Heming Zhao <heming.zhao@suse.com>
X-Mailer: Apple Mail (2.3826.400.131.1.6)



> On Mar 3, 2025, at 11:08, Heming Zhao <heming.zhao@suse.com> wrote:
>=20
> Hi Glass,
>=20
> The code looks good to me.
> The commit log needs to be revised.
>=20
> On 3/2/25 12:39, Su Yue wrote:
>> In clustermd, Separate write-intent-bitmaps are used for each cluster
>> node:
>=20
> Change 'Separate' to lowercase 'separate'.
>> 0                    4k                     8k                    12k
>> -------------------------------------------------------------------
>> | idle                | md super            | bm super [0] + bits |
>> | bm bits[0, contd]   | bm super[1] + bits  | bm bits[1, contd]   |
>> | bm super[2] + bits  | bm bits [2, contd]  | bm super[3] + bits  |
>> | bm bits [3, contd]  |                     |                     |
>> So in node 1, pg_index in __write_sb_page() could equal to
>> bitmap->storage.file_pages. Then bitmap_limit will be calculated to
>> 0. md_super_write() will be called with 0 size.
>> That means node the first 4k sb area of node 1 will never be updated
>> through filemap_write_page().
>=20
> "That means node the ...", should remove the word 'node'?

Thanks. Fixed in v3.

=E2=80=94=20
Su
>=20
> - Heming
>=20
>> This bug causes hang of mdadm/clustermd_tests/01r1_Grow_resize.
>> Here use (pg_index % bitmap->storage.file_pages) to calculation of
>> bitmap_limit correct.
>> Fixes: ab99a87542f1 ("md/md-bitmap: fix writing non bitmap pages")
>> Signed-off-by: Su Yue <glass.su@suse.com>
>> ---
>>  drivers/md/md-bitmap.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index 23c09d22fcdb..9ae6cc8e30cb 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -426,8 +426,8 @@ static int __write_sb_page(struct md_rdev *rdev, =
struct bitmap *bitmap,
>>   struct block_device *bdev;
>>   struct mddev *mddev =3D bitmap->mddev;
>>   struct bitmap_storage *store =3D &bitmap->storage;
>> - unsigned int bitmap_limit =3D (bitmap->storage.file_pages - =
pg_index) <<
>> - PAGE_SHIFT;
>> + unsigned long num_pages =3D bitmap->storage.file_pages;
>> + unsigned int bitmap_limit =3D (num_pages - pg_index % num_pages) << =
PAGE_SHIFT;
>>   loff_t sboff, offset =3D mddev->bitmap_info.offset;
>>   sector_t ps =3D pg_index * PAGE_SIZE / SECTOR_SIZE;
>>   unsigned int size =3D PAGE_SIZE;
>> @@ -436,7 +436,7 @@ static int __write_sb_page(struct md_rdev *rdev, =
struct bitmap *bitmap,
>>     bdev =3D (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
>>   /* we compare length (page numbers), not page offset. */
>> - if ((pg_index - store->sb_index) =3D=3D store->file_pages - 1) {
>> + if ((pg_index - store->sb_index) =3D=3D num_pages - 1) {
>>   unsigned int last_page_size =3D store->bytes & (PAGE_SIZE - 1);
>>     if (last_page_size =3D=3D 0)
>=20

