Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D531802DD
	for <linux-raid@vger.kernel.org>; Mon, 17 Feb 2025 10:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739788157; cv=none; b=sp46+cZQ94URBMm6IFbctYMHbB8b9QpFtRRg6ibINhn836xMY9WBQ/QtEAxPXbwQXJAWdwJe5S0mcDIP85rKVo21Bga3ApDqnz/yXR4nur6jbuubTqAhBZJnkqAOKV/sNDJhDre5xcvxrlBBKsKEgkg/8dg1rFaFwKmQVnIvBjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739788157; c=relaxed/simple;
	bh=7y33fDb0wMIs6o3xh7SVgy+AZNBArbTifjA3ejNW29o=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Pp7qMetVOqwCVXfzYi9RdxFdYthGZKlCI+SkohWJwX855TzvZoI6cXr9FZwlnPcETlAXM8lnT46MXWS/IZQcM0hBzoXaPIllSXCahtX0JhgA342oD8JkIDdaMmLQ1GNCiRX6eaO56NWtdQB3O7g8R2T4sV/e6WbyYNTcbVslzYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=g9cwu4C3; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="g9cwu4C3"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-439714a799aso16527965e9.2
        for <linux-raid@vger.kernel.org>; Mon, 17 Feb 2025 02:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739788154; x=1740392954; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XzKQkD8qOhvMp4rRnOtjNfMjGk7qhy8jucg/scdAJ2Y=;
        b=g9cwu4C3lQ/wGzgPwQqKUz1B0OCbC9vtjPl5uy+Hq2UM9OMu0abfoZjtbTqphIwyse
         86I+OxVuh8o3vUpSDT8t71RKZDuFkKpjoLPKzU+sH3hyZ4bK4qssaWkH+EHSvhUSgp17
         513UD1WqIndTIDJV0rdbuDDAqhDmO6KWra6cOrzzT4a5ChV/+K1ZzM/RezHirnfCGwK0
         KtJBGc+MbN7jXSftKND5X5dJwaZy0AhGbSYqbM//cZ2RNVrs6a0yK+qoNKEU361Fmivv
         fTQBCQ0ZHXo87NUBIxYeaYr8FzWOwhEdM430IFEc0oLSz+HnOLKwir9p3qdORBt4YO4i
         54Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739788154; x=1740392954;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XzKQkD8qOhvMp4rRnOtjNfMjGk7qhy8jucg/scdAJ2Y=;
        b=wJBqSOndmNW4898BKnRzXEtZbq4P2M4ySc9oFmLL9zhVEH+dc72fixkfoiUTO9qzzo
         eCJyNERSVoSH2pUMUJR0899H8RSlUqCR5fPjEyr9Gs0Ku0qp7tZGcpdYoGWQM1yPs2Yk
         a/EP50pKKgIoTTV9Nd0r9+iNcK+Im2j1AKEHYcIWcXSVboFv7sMitL/q1XlNIfsE72kX
         bEhnTcEgdnoK2Lqqhav8hHO2lXkinHD1JV68LblR0u2D3KoY92ODMpu9UnxrMiuzXm+7
         2pXeGoKPIglX/BiGeZip6pHA/45YzbwmKRdEcDsy7yqVJYwfGby3ds2SKzQoKx4CS/Jz
         Ox1A==
X-Forwarded-Encrypted: i=1; AJvYcCWcMVKJN5Kv0Xe/jEOqmDeGirInMonJB296we3Pf06c0iGpDKm3ikTBHOtABpujR67maQsimvOBxh5N@vger.kernel.org
X-Gm-Message-State: AOJu0YyjKKDhjMf7vbio/3x4tNroWcfT38xpbTqjKq4DmgyTxMXurqZx
	TSsF7kv/oUCRUxnQfwbNju0qleK0oNElFuK0evIPUxTChs6yQ1vmAUml2GJ9GNmTiDpRSvbW6PA
	R
X-Gm-Gg: ASbGncvGHbJok6fnoq++Heo555q9FE6cVW8gHa7CPZhvpJmuPL1Wdesxss+SlO1pHyK
	vPz1NK+bkTANv93uHs8Gz3SlY0PQYDPyZVJtMUytPxZFBoVybwKHnxATc6gb5mOH+M/3N/3Jk/X
	zwUw4e29ZTnwYyA/1uhayU4q1v9p7jHXIICgCjPF587zsNstYRPAa1sG/fl9J5yoDnyJ/3k/XBH
	07PRShhcVZ+L7Y3Ak0JWBZzhUC3EbJWGGdI6b1Hacs8b0N9Qunh3V3wsltvp1o3uYSPb87yd/Gr
	YeA4/b2YFQpLiWHhnw==
X-Google-Smtp-Source: AGHT+IFXGWNmh521iDjtAP/Y/ccforECaRdDAMLzD71tuBAY1iklUiezWqR45f+ndyEc6d1qLKHfjQ==
X-Received: by 2002:a5d:610e:0:b0:38d:e481:c680 with SMTP id ffacd0b85a97d-38f33f29144mr7171984f8f.18.1739788154012;
        Mon, 17 Feb 2025 02:29:14 -0800 (PST)
Received: from smtpclient.apple ([23.247.139.15])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-471f6674aafsm3167381cf.76.2025.02.17.02.29.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Feb 2025 02:29:12 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH md-6.15 5/7] md/md-cluster: cleanup md_cluster_ops
 reference
From: Glass Su <glass.su@suse.com>
In-Reply-To: <20250215092225.2427977-6-yukuai1@huaweicloud.com>
Date: Mon, 17 Feb 2025 18:28:54 +0800
Cc: song@kernel.org,
 yukuai3@huawei.com,
 linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com,
 yangerkun@huawei.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <406FA5FC-9D33-45BF-9EC5-36114C846B4F@suse.com>
References: <20250215092225.2427977-1-yukuai1@huaweicloud.com>
 <20250215092225.2427977-6-yukuai1@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mailer: Apple Mail (2.3826.400.131.1.6)



> On Feb 15, 2025, at 17:22, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
> From: Yu Kuai <yukuai3@huawei.com>
>=20
> md_cluster_ops->slot_number() is implemented inside md-cluster.c, just
> call it directly.
>=20
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Reviewed-by: Su Yue <glass.su@suse.com>
> ---
> drivers/md/md-cluster.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 6595f89becdb..6fd436a1d373 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -1166,7 +1166,7 @@ static int resize_bitmaps(struct mddev *mddev, =
sector_t newsize, sector_t oldsiz
> struct dlm_lock_resource *bm_lockres;
> char str[64];
>=20
> - if (i =3D=3D md_cluster_ops->slot_number(mddev))
> + if (i =3D=3D slot_number(mddev))
> continue;
>=20
> bitmap =3D mddev->bitmap_ops->get_from_slot(mddev, i);
> @@ -1216,7 +1216,7 @@ static int resize_bitmaps(struct mddev *mddev, =
sector_t newsize, sector_t oldsiz
>  */
> static int cluster_check_sync_size(struct mddev *mddev)
> {
> - int current_slot =3D md_cluster_ops->slot_number(mddev);
> + int current_slot =3D slot_number(mddev);
> int node_num =3D mddev->bitmap_info.nodes;
> struct dlm_lock_resource *bm_lockres;
> struct md_bitmap_stats stats;
> --=20
> 2.39.2
>=20
>=20

