Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132A4EACE
	for <linux-raid@vger.kernel.org>; Wed,  1 Jan 2025 05:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735709831; cv=none; b=RveM8D1yTZuThEjXQJ0HnV01vOYfjR20z+pXbPGaQMxVrT8QIOH5AYvcJj0EAZKlJlXJ5ZpNLIOzjy1PbU2nfJHpUcGco5js5TTbVU41S77zz/S15NMX3IqIagxcCV631E0seUsftIWXQO+Bb4sBOld6nLLv73ZVjCY9NWnXR4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735709831; c=relaxed/simple;
	bh=SaJ3jW9H22T/UCrtQSpoc67sDM60Vay4IxMbsRBg0Cw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cHvRTrIYeuUOhI8H8ox/wNwKwsyo6AM2Kqo588JKrmDqubEV6BVeSGOiSybVigWzsW22hv9NoUa+j+BLM2/h8kNv4WC1+AqJU0chsMum9gMl3Qok4RmVbM7qkhBBvpgeucII33fcBc5nyavy/uhLsvQfm4R7gGtT0senaArTlGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bo/Bke/F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bo/Bke/F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735709827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wpDDazGHCmf+PRnkXpxbOQW+scPzOlHiiLuw7ounQzI=;
	b=Bo/Bke/FNzL0H0LkDBCwNKtQ7fpXPUQB3tbRP+VyXMorAbMjJTNwMRqD62YIdwXMDL2rny
	bzKihXcB+CbVibp6pO+z2FLDJZip9b9C84CsBsvbYW3MkHDqgLSPUzwUZYZZ5M5f5xvxAX
	6ywTzZfmoTwsdNz/dKz0g/3mBrmQwmc=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-115-fuDLbcq8MSaRSBEa1yWogg-1; Wed, 01 Jan 2025 00:37:06 -0500
X-MC-Unique: fuDLbcq8MSaRSBEa1yWogg-1
X-Mimecast-MFC-AGG-ID: fuDLbcq8MSaRSBEa1yWogg
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-54019e668bfso4639021e87.0
        for <linux-raid@vger.kernel.org>; Tue, 31 Dec 2024 21:37:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735709825; x=1736314625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wpDDazGHCmf+PRnkXpxbOQW+scPzOlHiiLuw7ounQzI=;
        b=Z4lcSh4en68uy2OJyjVGaxhB9H7HM/8OK6Hjs/S5hI+VQgD3Y8woEhOZK/2pSwjPIs
         EoRhTTEzgxf5M6c/wwyw2QYGnW7juuyBQbk2+l6N/oORbnLVn8Q8mUo4dRQp+7GoM2Wr
         d25bUI+TqiVtIpdgrvvFUEGlHeshDnEx4WnUIGoedqt7RtxUKb9vxf9ZXfyzTZFzuoUB
         vE9J7amJJqqqN5HxbvHboEzv4hGGV17Aa3T9obi9PmNYuNXB9y8wxaLaGfXDfCUFIXjh
         KTg2AaOi3CGmIriEz8qhZaEtZoD7PvrAyHqR8Nbu2dB0ORbev3CzBW7rN4bNhTl2BzbO
         Tm6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWwOOcKza7NK1Qh9ruXfzcUzmFJKQ3pugWpONUbsEq/xobWNXgUDipwYxObQFT1vMymgtiiUlDBrIsL@vger.kernel.org
X-Gm-Message-State: AOJu0YyvkpTDCvIRJBiJXOoXV2kfmBKc9gkW8uvS4edD74CtSk3o2o/o
	ILN/ADxW52C87FJvz6eg5g5QOt0xyP6epML/vK7Z+dfmLgWODAxzfCDYlnGs8HMQtJk5GKuRE3L
	BTWcwAAu7QhMuiCXndCzJDnQpkR7IpSWxMO7xs3OWRyVp4n3gqDuFLCVbtx41fo+hFjtW/sJZ27
	8w0rUqxcaUNkL+87U/06WvkbsvQWZCjW8G2w==
X-Gm-Gg: ASbGncscqUxLuKXka6CeZfLselavU6Xq6mxtay8+n8MQ2BffH3CD9t2kNdeAZ/iysCN
	rHab4rzCjY8N29jHDlKMMimGuyFFNt3f1DiEwHPY=
X-Received: by 2002:a05:6512:159c:b0:53e:3aaa:5c7c with SMTP id 2adb3069b0e04-54229597ceemr15169070e87.51.1735709825242;
        Tue, 31 Dec 2024 21:37:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHRfNHBDT41+BJTOvhaYJ9OSWEZAVgbU1taktAqSpv7XtA/npxW8T4Wz6IMTx6tiTaC/pjMZMU/ghIoMIDW+Q0=
X-Received: by 2002:a05:6512:159c:b0:53e:3aaa:5c7c with SMTP id
 2adb3069b0e04-54229597ceemr15169065e87.51.1735709824900; Tue, 31 Dec 2024
 21:37:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241218121745.2459-1-yukuai@kernel.org> <20241218121745.2459-5-yukuai@kernel.org>
In-Reply-To: <20241218121745.2459-5-yukuai@kernel.org>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 1 Jan 2025 13:36:53 +0800
Message-ID: <CALTww2_7rfHO-B_bBTgk0iZig_qyMJhoEoiqaSci1i_Ao4MUHQ@mail.gmail.com>
Subject: Re: [PATCH v2 md-6.14 4/5] md/raid5: implement pers->bitmap_sector()
To: yukuai@kernel.org
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@hauwei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2024 at 8:22=E2=80=AFPM <yukuai@kernel.org> wrote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Bitmap is used for the whole array for raid1/raid10, hence IO for the
> array can be used directly for bitmap. However, bitmap is used for
> underlying disks for raid5, hence IO for the array can't be used
> directly for bitmap.
>
> Implement pers->bitmap_sector() for raid5 to convert IO ranges from the
> array to the underlying disks.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Yu Kuai <yukuai@kernel.org>
> ---
>  drivers/md/raid5.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 6eb2841ce28c..b2fe201b599d 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2950,6 +2950,23 @@ static void raid5_error(struct mddev *mddev, struc=
t md_rdev *rdev)
>         r5c_update_on_rdev_error(mddev, rdev);
>  }
>
> +static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
> +                               unsigned long *sectors)
> +{
> +       struct r5conf *conf =3D mddev->private;
> +       int sectors_per_chunk =3D conf->chunk_sectors * (conf->raid_disks=
 -
> +                                                      conf->max_degraded=
);
> +       sector_t start =3D *offset;
> +       sector_t end =3D start + *sectors;
> +       int dd_idx;
> +
> +       start =3D round_down(start, sectors_per_chunk);
> +       end =3D round_up(end, sectors_per_chunk);
> +
> +       *offset =3D raid5_compute_sector(conf, start, 0, &dd_idx, NULL);
> +       *sectors =3D raid5_compute_sector(conf, end, 0, &dd_idx, NULL) - =
*offset;
> +}

Hi Kuai

This function needs to think about reshape like make_stripe_request does.

Regards
Xiao
> +
>  /*
>   * Input: a 'big' sector number,
>   * Output: index of the data and parity disk, and the sector # in them.
> @@ -8972,6 +8989,7 @@ static struct md_personality raid6_personality =3D
>         .takeover       =3D raid6_takeover,
>         .change_consistency_policy =3D raid5_change_consistency_policy,
>         .prepare_suspend =3D raid5_prepare_suspend,
> +       .bitmap_sector  =3D raid5_bitmap_sector,
>  };
>  static struct md_personality raid5_personality =3D
>  {
> @@ -8997,6 +9015,7 @@ static struct md_personality raid5_personality =3D
>         .takeover       =3D raid5_takeover,
>         .change_consistency_policy =3D raid5_change_consistency_policy,
>         .prepare_suspend =3D raid5_prepare_suspend,
> +       .bitmap_sector  =3D raid5_bitmap_sector,
>  };
>
>  static struct md_personality raid4_personality =3D
> @@ -9023,6 +9042,7 @@ static struct md_personality raid4_personality =3D
>         .takeover       =3D raid4_takeover,
>         .change_consistency_policy =3D raid5_change_consistency_policy,
>         .prepare_suspend =3D raid5_prepare_suspend,
> +       .bitmap_sector  =3D raid5_bitmap_sector,
>  };
>
>  static int __init raid5_init(void)
> --
> 2.43.0
>
>

