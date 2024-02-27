Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9483D1B94E
	for <linux-raid@vger.kernel.org>; Tue, 27 Feb 2024 02:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709002267; cv=none; b=DbFSsGv97edZd4ar+TBVsRVy1yBWevUsFmXbVa9eTKBGOgQKIMgqdlTZkeSKbVKnyNu+8/wtLzGw9yeZy0tim6lubt1RPRVxLhKWubeCL/JwzG1fNh6sLtGNqbioD+XWHAK92sXCrtaqnZ/Bv0C/Hijo/QLj/bExvBnH83MHx8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709002267; c=relaxed/simple;
	bh=U/XHXDOGjGRtu7Zat0ygQtxQS1t7iwL7Yg7Y91AKsns=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ME4TXrXTcn7sdz4y3WBoS4ymM1uGlykL5dFpB11VjcHw2InheBOkqNqYIdvNp/thYdJzc3WBu48J6gj7O09raiAZbwx6xsRYIzhtDHqSGra+PYl8+kLaptPE22KzmP26ZvuWLdnCEpuw/WPLqEk6KMA8MpbNZcS1cI6m6NpvqaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BqJVcFtq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BqJVcFtq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709002264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vpZgE6clvZWD75nXVL0V/D78BHRhI8wsvydCtMH9T+U=;
	b=BqJVcFtqS1v/ioSk6JK59b+hw3WVPMxZRnazCW2uC80UbiGXuQwgiur2vduWtYSn+O47Mc
	pkBTy7HdkPm1eT1A/FzKo2g5gl6EF3XZubG2GkP5NvuCE6a66tP8zo07969NiI43nZqf0G
	TmsmlRFXofo/G1XX5nHRWg1F9HoZhsU=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-fxSBYnPxOtCmGlV5v5B_Rg-1; Mon, 26 Feb 2024 21:51:00 -0500
X-MC-Unique: fxSBYnPxOtCmGlV5v5B_Rg-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2998838289aso2831287a91.1
        for <linux-raid@vger.kernel.org>; Mon, 26 Feb 2024 18:50:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709002258; x=1709607058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vpZgE6clvZWD75nXVL0V/D78BHRhI8wsvydCtMH9T+U=;
        b=KjJmVsJnLy8yRVCsBcKu+G9btnW4CJORGejThhTkOnLSBLMnogBcYOtDA3OAhxrWAo
         WYPCD3tBqB0Cj7RlZSJ9IlVvLSTbyZC7GZoBhuoiahfanj6CN40E0orWgTcA59PA5M6w
         SB6oLz6YidDRb53k1+eLovjebkjVjYPLTVwjSXyi+Tnx2y35ytzyiU1Bi2VmA9auQcgu
         UyCt61rPSKNnlDtbMLOLJk0snQ/Nihv3mpvWO+KnxPRJfUpiWqW+LFfDwWhS8Unxyplz
         WCOjBuEIF+5hTx7XaDjAcnh8HBT70wXgCr1slFGy0PxNs/rWlMpBSp7ko4fTYzHQsDoU
         7HXg==
X-Forwarded-Encrypted: i=1; AJvYcCX6bKNwSVtp5X0biI5LTRw7qj491lGtCfkXm1TNujzq9N5KwxrbQjQNZ48LHoBDBSO7MG1Srh9/CRi9L4KWfAOi9v3pFYjXcidpig==
X-Gm-Message-State: AOJu0YxG/paONWtbybZHd7D70R0BUPAD5YtEIlAUdBtGK+hGxL19KYAD
	wkaKio1nV1t4AbeMh6G8b/6F9Gb0qYA4CUF5w5itixuR3+MndVhOUw3snhpnyYY6q3Cbhn6HE6x
	Yz6jDUY8UWmjccCsaHLuAQ8tjK1a+TC0p7NPJgxr5oRGeqaiZNVIpiNibR3iR205FF0e9IKLB/L
	YNpKTKLq+eB8QdVLI0n3eTeIYvGcAnrnetqQ==
X-Received: by 2002:a17:90a:f40e:b0:299:29a5:d575 with SMTP id ch14-20020a17090af40e00b0029929a5d575mr6247135pjb.12.1709002257879;
        Mon, 26 Feb 2024 18:50:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGgA4UWYqugXYnE2RHMnk9v7sxupo/ZIE74edXnvwUFagR9H+PC97imV2YN+umUgkuMAUKzUrn+hdIAffXDwz8=
X-Received: by 2002:a17:90a:f40e:b0:299:29a5:d575 with SMTP id
 ch14-20020a17090af40e00b0029929a5d575mr6247123pjb.12.1709002257598; Mon, 26
 Feb 2024 18:50:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222075806.1816400-1-yukuai1@huaweicloud.com> <20240222075806.1816400-7-yukuai1@huaweicloud.com>
In-Reply-To: <20240222075806.1816400-7-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 27 Feb 2024 10:50:46 +0800
Message-ID: <CALTww2-6s-yvQfSmSLSQ78CgfDdOW-aNHJVqyofBoCqvS25hzg@mail.gmail.com>
Subject: Re: [PATCH md-6.9 06/10] md/raid1: factor out read_first_rdev() from read_balance()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: paul.e.luse@linux.intel.com, song@kernel.org, neilb@suse.com, shli@fb.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, 
	yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 22, 2024 at 4:04=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> read_balance() is hard to understand because there are too many status
> and branches, and it's overlong.
>
> This patch factor out the case to read the first rdev from
> read_balance(), there are no functional changes.
>
> Co-developed-by: Paul Luse <paul.e.luse@linux.intel.com>
> Signed-off-by: Paul Luse <paul.e.luse@linux.intel.com>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/raid1.c | 63 +++++++++++++++++++++++++++++++++-------------
>  1 file changed, 46 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 8089c569e84f..08c45ca55a7e 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -579,6 +579,47 @@ static sector_t align_to_barrier_unit_end(sector_t s=
tart_sector,
>         return len;
>  }
>
> +static void update_read_sectors(struct r1conf *conf, int disk,
> +                               sector_t this_sector, int len)
> +{
> +       struct raid1_info *info =3D &conf->mirrors[disk];
> +
> +       atomic_inc(&info->rdev->nr_pending);
> +       if (info->next_seq_sect !=3D this_sector)
> +               info->seq_start =3D this_sector;
> +       info->next_seq_sect =3D this_sector + len;
> +}
> +
> +static int choose_first_rdev(struct r1conf *conf, struct r1bio *r1_bio,
> +                            int *max_sectors)
> +{
> +       sector_t this_sector =3D r1_bio->sector;
> +       int len =3D r1_bio->sectors;
> +       int disk;
> +
> +       for (disk =3D 0 ; disk < conf->raid_disks * 2 ; disk++) {
> +               struct md_rdev *rdev;
> +               int read_len;
> +
> +               if (r1_bio->bios[disk] =3D=3D IO_BLOCKED)
> +                       continue;
> +
> +               rdev =3D conf->mirrors[disk].rdev;
> +               if (!rdev || test_bit(Faulty, &rdev->flags))
> +                       continue;
> +
> +               /* choose the first disk even if it has some bad blocks. =
*/
> +               read_len =3D raid1_check_read_range(rdev, this_sector, &l=
en);
> +               if (read_len > 0) {
> +                       update_read_sectors(conf, disk, this_sector, read=
_len);
> +                       *max_sectors =3D read_len;
> +                       return disk;
> +               }
> +       }
> +
> +       return -1;
> +}
> +
>  /*
>   * This routine returns the disk from which the requested read should
>   * be done. There is a per-array 'next expected sequential IO' sector
> @@ -603,7 +644,6 @@ static int read_balance(struct r1conf *conf, struct r=
1bio *r1_bio, int *max_sect
>         sector_t best_dist;
>         unsigned int min_pending;
>         struct md_rdev *rdev;
> -       int choose_first;
>
>   retry:
>         sectors =3D r1_bio->sectors;
> @@ -613,10 +653,11 @@ static int read_balance(struct r1conf *conf, struct=
 r1bio *r1_bio, int *max_sect
>         best_pending_disk =3D -1;
>         min_pending =3D UINT_MAX;
>         best_good_sectors =3D 0;
> -       choose_first =3D raid1_should_read_first(conf->mddev, this_sector=
,
> -                                              sectors);
>         clear_bit(R1BIO_FailFast, &r1_bio->state);
>
> +       if (raid1_should_read_first(conf->mddev, this_sector, sectors))
> +               return choose_first_rdev(conf, r1_bio, max_sectors);
> +
>         for (disk =3D 0 ; disk < conf->raid_disks * 2 ; disk++) {
>                 sector_t dist;
>                 sector_t first_bad;
> @@ -662,8 +703,6 @@ static int read_balance(struct r1conf *conf, struct r=
1bio *r1_bio, int *max_sect
>                                  * bad_sectors from another device..
>                                  */
>                                 bad_sectors -=3D (this_sector - first_bad=
);
> -                               if (choose_first && sectors > bad_sectors=
)
> -                                       sectors =3D bad_sectors;
>                                 if (best_good_sectors > sectors)
>                                         best_good_sectors =3D sectors;
>
> @@ -673,8 +712,6 @@ static int read_balance(struct r1conf *conf, struct r=
1bio *r1_bio, int *max_sect
>                                         best_good_sectors =3D good_sector=
s;
>                                         best_disk =3D disk;
>                                 }
> -                               if (choose_first)
> -                                       break;
>                         }
>                         continue;
>                 } else {
> @@ -689,10 +726,6 @@ static int read_balance(struct r1conf *conf, struct =
r1bio *r1_bio, int *max_sect
>
>                 pending =3D atomic_read(&rdev->nr_pending);
>                 dist =3D abs(this_sector - conf->mirrors[disk].head_posit=
ion);
> -               if (choose_first) {
> -                       best_disk =3D disk;
> -                       break;
> -               }
>                 /* Don't change to another disk for sequential reads */
>                 if (conf->mirrors[disk].next_seq_sect =3D=3D this_sector
>                     || dist =3D=3D 0) {
> @@ -760,13 +793,9 @@ static int read_balance(struct r1conf *conf, struct =
r1bio *r1_bio, int *max_sect
>                 rdev =3D conf->mirrors[best_disk].rdev;
>                 if (!rdev)
>                         goto retry;
> -               atomic_inc(&rdev->nr_pending);
> -               sectors =3D best_good_sectors;
> -
> -               if (conf->mirrors[best_disk].next_seq_sect !=3D this_sect=
or)
> -                       conf->mirrors[best_disk].seq_start =3D this_secto=
r;
>
> -               conf->mirrors[best_disk].next_seq_sect =3D this_sector + =
sectors;
> +               sectors =3D best_good_sectors;
> +               update_read_sectors(conf, disk, this_sector, sectors);
>         }
>         *max_sectors =3D sectors;
>
> --
> 2.39.2
>
>
Hi
This patch looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

