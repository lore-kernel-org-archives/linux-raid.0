Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.129.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792762169;
	b=m4kdc8uNbuAI9KM6a3psHl6HsaT2nkGfozFNpo/h8RQ8BoT5rtCeXMr6tWqUUjpe/VMd
	 D+GuUHblkiH3ht1wPi5jdfsJFw36NhRZww7dk6bavqU9lBsL7IKHNg8y3yCga+6qEsZxf
	 SP2Zx/Je+bhYlx3rGuu0feHnwyxwMDUNlCZSLrSXxc92Vb2oV442tvJg2iBbyKUkuZblF
	 ZDaJOmH+ZB56m0T829dLMnHqfcK6WdSd63/HAKXaJnPp4u/iuqwZUY2X1k9bRZ9Pq9Ltx
	 PD/yw2+3+VKGy6XHsQUBHXm0to4K6mZrJH7o2zvrD0nabBXQjBhnt6iNUbqW2IN+zUQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792762169;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=WJ+grZ4lbWZ8KaHJYCpBfwtWw/sRlKb2fRhe/pAbeJg=;
	b=GFgrnH/AWig3wKHo0gwpp/W3carLsZAkDKEN2D+084ywqMWkA1jHLsCGmgbxwd0rLtNu
	 AmtFVxHOqZL/9f7zw7dMWf1GNvM0a7EOVvUH4s5WBv0EMFWLKn1/1qQyCcD4s6oJ1Zgel
	 jU3Pz4bOcalf6nXqEzouRsONYO7qHHGD4Hokbyu5FDhK+eNNC97IPpzKUtXdmk0hIoCPK
	 DFJB8aliKbsTWpZ1rqwym5igD5rT5DjNuEfnwtnFyedkSB6MVkZT5zwJr9m0TsI8M6dIS
	 onma313aC6vEUi5U4/q1yHMgigIXfZzPyJ1/qgmAtm1yXGyzui1V/8jjhyMUFEEPS3Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Er3itx01;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=AjTieBTk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36A7606A31A
	for <linux-raid@vger.kernel.org>; Fri, 23 Oct 2026 13:29:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C36A7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Er3itx01;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=AjTieBTk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792762167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WJ+grZ4lbWZ8KaHJYCpBfwtWw/sRlKb2fRhe/pAbeJg=;
	b=Er3itx01WYCmHtup5PUNZqwTiIde4OymtN5130lxIQm39xpJUytsvBqcrw6PJNoA6V1IzP
	vOsy2K7z+jIF52kEh200xXiHjASp1Y9c/+4HTAkUC+hwYU3ruKfrD+LCdeHprBL5x+d7tN
	UJP3fhO6t2sf8SMhqXLferfJb0b/i18=
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com
 [74.125.82.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-h4apXzW4OtOy5CvLZXhXZA-1; Fri, 23 Oct 2026 09:29:26 -0400
X-MC-Unique: h4apXzW4OtOy5CvLZXhXZA-1
X-Mimecast-MFC-AGG-ID: h4apXzW4OtOy5CvLZXhXZA_1792762165
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3548cdfd2fbso1310889eec.1
        for <linux-raid@vger.kernel.org>; Fri, 23 Oct 2026 06:29:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792762165; cv=none;
        d=google.com; s=arc-20260327;
        b=F8RMqLY9HgB9leEWivsEaPba9XtZrTi5/+j4lsEAOJCEUBbOO8B+SPpozh8ORBw/ua
         2IrRfYjsyYa6pOlL0f8ZxQt7nvcQ+0/f007JzbBTr0ZUeDHVFu08Di74w9nXHoSXJHjU
         piNfSFbtr0RmQZ8tHu/m2orv52IXChEjbVzkAAsWQQp2G6l9g1kCzTnar0jECqvtJHes
         YuIzimI9HisOFkQDM8yA9E9NeYFTf2y1d+/cwK3RNaC9ns6UixhvWllWVlapO/w0H+yx
         JOZLBEbOKP1fUMxdB307QXiTHtLwIRG9MkCtxADMaYs2VCqzwHait79LLyQOpkH3jveG
         mgpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WJ+grZ4lbWZ8KaHJYCpBfwtWw/sRlKb2fRhe/pAbeJg=;
        fh=zFX6AcOjsvVTtpAM6P7u8MF6Y+8ckAzoq5kp2Sa6QSE=;
        b=MhH2vBz1j8ja2zyWmchNUA6HSfIzJ4aLL8XRAhZIRo0Sv2pl6GbDTdFXkXpzr2YPRm
         9OntU39R8yO6AMnifK+iQyqJvMw7Kk/TBhtZFloSxdADl2wbus4mcB+lvNDoTcZzgcDe
         2L0eG05cdBP7u6sdW8McCuXfECJRGJHC6lZIc9CCq695rExjmhZZd4gFo4FbLIZ8FHFh
         d0FuGOHQ8PbVzkdVjgrIBI+QJ/pSnIcmjb8d273cypRYRhnloc3fk/cfU/bN8y9lIYla
         9w9OeQVogUn0RmK3opFFoKV+WHAXxN2ZKOWn1qNRRwYUMFddqiDFW7SqD/q4FQ0oQY7x
         d+zg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792762165; x=1793366965; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WJ+grZ4lbWZ8KaHJYCpBfwtWw/sRlKb2fRhe/pAbeJg=;
        b=AjTieBTka2G8Eml4GMw4XK4ado1H4L5O0wrOEGxtrMbwwaq7NfG4IwjKOz5soXqQrf
         pdoXQHMP7xNtWeqgHeVb2hGXtqWxL+L10VfNG7HDHDGa11Q4nBOCGrx0NhHIW9SYOYuG
         9NQkGfMZjNPIngxOPBZsIeNWqmDL/pzszL2+aRgNS9LiswMKZWa/biK0YuZc5QtHIfUh
         agEkTWEooQBhv2v3Pg+ky2OXLEwJ8/muaMqCn69SBacevLk28flRa2W2VZFD9PCOIeRB
         ulD3+3gx/P8mY3Q+eNwwZbeUhaqDo7bz57uUVsgRgf6FplF8hc0+AOEqdb8nWeXO2xRt
         7AnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792762165; x=1793366965;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WJ+grZ4lbWZ8KaHJYCpBfwtWw/sRlKb2fRhe/pAbeJg=;
        b=f9LbDQ1XJktxd/a/7fBp7XahyWJ8lhHyxytTK21RVYPSnFlvPAsPqMBf83YdJbJuSr
         Zt+0MRtCmgn5O0WOnjBJERAQgVV/5nKy/v2gKNWFW380LUbEkJw+GQUurFpXV5duPsav
         jMGUyNQrTAh+H5lLhjAoIA6eqyCzC1fQ0/Mn0fqRv0bZCJEmWuio8/HpPgbMujusk6n1
         ZmvO/AKygwbQlrOpjs6+khDNueV9Oc3ncKjUl9Pf/M50zdELGzrLDNhPquodTE+2XHDU
         LuIiSrDUA25HQ+wrt4WNU7Xc2wxSZcgQgnvR52jak9UvJg2syFYA7KyNbNjH63IJiZCk
         STcQ==
X-Forwarded-Encrypted: i=1; AKwUvBxxQbK9srJ5ySeQBOPF693TdAM0C3v2m9FVbUcf7CaLcKuLSwtk4fjk6aFLIgVom78Gi6w95maw5/H6@vger.kernel.org
X-Gm-Message-State: AFq9FYI9VwGg52LEIy69mlOg+JNdmgpioK4t2kQL1VQ0asYHS0VIOilB
	EXErxrn2R/OEDgzhDD4Q7upDMdorH6oC2VZ2JL0YZ8kUOjGBJ5N+JPiZxfQRTuf9jxEuoXU8kJa
	9zC1v8j/mamQxBHnFVsNQ55oI5fyXWZrniggWie7Hd0RyPjh0UZL80taL61lWDcPIetuQXWN7tj
	PoSag5STyRwKeVXO4v1yPmviWb4aXKh98ZQdqivw==
X-Gm-Gg: AYBFou15DURvAVcPvwT7cem8I3f/EYcT1RGqUU4Vft83WbJVR+MiJAa0o8y2eHFt3mh
	phPKeVpzbgtDMio1wP6Vi87vzP3DmDCiHMi20MupU/vnuYWGasvm5QCjblxVq5UPsXLllGQxqUr
	qhs6Ndqzc3VP2UX30Pf31PKBWzKhTJOYOriBt85nTJVOIYc1c63DNn7Sc=
X-Received: by 2002:a05:7023:d0d:b0:18e:5292:2670 with SMTP id a92af1059eb24-19598c7823emr3524659c88.23.1792762164528;
        Fri, 23 Oct 2026 06:29:24 -0700 (PDT)
X-Received: by 2002:a05:7023:d0d:b0:18e:5292:2670 with SMTP id
 a92af1059eb24-19598c7823emr3524616c88.23.1792762163694; Fri, 23 Oct 2026
 06:29:23 -0700 (PDT)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261019010827.2922617-1-wozizhi@huaweicloud.com> <20261019010827.2922617-2-wozizhi@huaweicloud.com>
In-Reply-To: <20261019010827.2922617-2-wozizhi@huaweicloud.com>
From: Bruce Johnston <bjohnsto@redhat.com>
Date: Fri, 23 Oct 2026 09:29:12 -0400
X-Gm-Features: AclHuK-yTLpqARnkRDI7dk5n00WjVv97rLiODDTXduGe6PENvnMBjX29F5aKlcM
Message-ID: <CAOjDE+C8KFcTsaWjMfmcWcQOwv8qetm-QKvYts+cUGFzgUB8uA@mail.gmail.com>
Subject: Re: [PATCH V2 1/6] md/raid0: don't leave mddev in an inconsistent
 state when takeover fails
To: Zizhi Wo <wozizhi@huaweicloud.com>
Cc: song@kernel.org, yukuai@fygo.io, magiclinan@didiglobal.com, 
	xiao@kernel.org, linux-raid@vger.kernel.org, yangerkun@huawei.com, 
	chengzhihao1@huawei.com, wozizhi@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 18, 2026 at 9:16=E2=80=AFPM Zizhi Wo <wozizhi@huaweicloud.com> =
wrote:
>
> From: Zizhi Wo <wozizhi@huawei.com>
>
> raid0_takeover_raid45(), raid0_takeover_raid10() and raid0_takeover_raid1=
()
> update mddev before create_strip_zones(), which can fail.
>
> On failure, level_store() only rolls back new_level, new_layout,
> new_chunk_sectors, raid_disks and delta_disks. The old personality is
> therefore left with a reset resync_offset, cleared feature flags, and, fo=
r
> raid1, the wrong chunk size.
>
> Set only what create_strip_zones() needs before calling it, and move the
> rest after it succeeds.
>
> create_strip_zones() also rounds rdev->sectors, but the old levels do not
> use it for I/O, so that is harmless. And mddev->degraded is already reset
> by level_store() on success, so drop the redundant assignment in
> raid0_takeover_raid10().
>

The rounding of sectors is not too much of a concern of mine. I'm more conc=
erned
about rdev->sectors getting set to mddev->dev_sectors in the
raid0_takeover_raid45.
While I think I understand why it is done and I agree rdev->sectors
isn't used by the 4/5 raid
level I/O, I'm pretty sure the field is still used in sysfs fields and
things like mdstat. On
a takeover failure, I feel like we are losing what the old
rdev->sectors value was when
we go back to raid 4/5 (rdev->sectors and mddev->dev_sectors can be
different values)

Do you have any thoughts on this? I know it would be a pain to backup
/ restore every
rdev.

> Fixes: 9af204cf720c ("md: Add support for Raid5->Raid0 and Raid10->Raid0 =
takeover")
> Fixes: fc3a08b85b7a ("Add raid1->raid0 takeover support")
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> ---
>  drivers/md/raid0.c | 36 +++++++++++++++++++++++-------------
>  1 file changed, 23 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 35e103f0c2c3..8157e1058a24 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -669,15 +669,16 @@ static void *raid0_takeover_raid45(struct mddev *md=
dev)
>         mddev->new_level =3D 0;
>         mddev->new_layout =3D 0;
>         mddev->new_chunk_sectors =3D mddev->chunk_sectors;
>         mddev->raid_disks--;
>         mddev->delta_disks =3D -1;
> -       /* make sure it will be not marked as dirty */
> -       mddev->resync_offset =3D MaxSector;
> -       mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
>
> -       create_strip_zones(mddev, &priv_conf);
> +       if (!create_strip_zones(mddev, &priv_conf)) {
> +               /* make sure it will be not marked as dirty */
> +               mddev->resync_offset =3D MaxSector;
> +               mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FL=
AGS);
> +       }
>
>         return priv_conf;
>  }
>
>  static void *raid0_takeover_raid10(struct mddev *mddev)
> @@ -711,23 +712,25 @@ static void *raid0_takeover_raid10(struct mddev *md=
dev)
>         mddev->new_level =3D 0;
>         mddev->new_layout =3D 0;
>         mddev->new_chunk_sectors =3D mddev->chunk_sectors;
>         mddev->delta_disks =3D - mddev->raid_disks / 2;
>         mddev->raid_disks +=3D mddev->delta_disks;
> -       mddev->degraded =3D 0;
> -       /* make sure it will be not marked as dirty */
> -       mddev->resync_offset =3D MaxSector;
> -       mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
>
> -       create_strip_zones(mddev, &priv_conf);
> +       if (!create_strip_zones(mddev, &priv_conf)) {
> +               /* make sure it will be not marked as dirty */
> +               mddev->resync_offset =3D MaxSector;
> +               mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FL=
AGS);
> +       }
> +
>         return priv_conf;
>  }
>
>  static void *raid0_takeover_raid1(struct mddev *mddev)
>  {
>         struct r0conf *priv_conf;
>         int chunksect;
> +       int old_chunk_sectors;
>
>         /* Check layout:
>          *  - (N - 1) mirror drives must be already faulty
>          */
>         if ((mddev->raid_disks - 1) !=3D mddev->degraded) {
> @@ -748,22 +751,29 @@ static void *raid0_takeover_raid1(struct mddev *mdd=
ev)
>
>         if ((chunksect << 9) < PAGE_SIZE)
>                 /* array size does not allow a suitable chunk size */
>                 return ERR_PTR(-EINVAL);
>
> +       /* Save for rollback if create_strip_zones() fails */
> +       old_chunk_sectors =3D mddev->chunk_sectors;
> +
>         /* Set new parameters */
>         mddev->new_level =3D 0;
>         mddev->new_layout =3D 0;
>         mddev->new_chunk_sectors =3D chunksect;
>         mddev->chunk_sectors =3D chunksect;
>         mddev->delta_disks =3D 1 - mddev->raid_disks;
>         mddev->raid_disks =3D 1;
> -       /* make sure it will be not marked as dirty */
> -       mddev->resync_offset =3D MaxSector;
> -       mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
>
> -       create_strip_zones(mddev, &priv_conf);
> +       if (!create_strip_zones(mddev, &priv_conf)) {
> +               /* make sure it will be not marked as dirty */
> +               mddev->resync_offset =3D MaxSector;
> +               mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FL=
AGS);
> +       } else {
> +               mddev->chunk_sectors =3D old_chunk_sectors;
> +       }
> +
>         return priv_conf;
>  }
>
>  static void *raid0_takeover(struct mddev *mddev)
>  {
> --
> 2.52.0
>
>

