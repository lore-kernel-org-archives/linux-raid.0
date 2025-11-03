Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE25136658
	for <linux-raid@vger.kernel.org>; Mon,  3 Nov 2025 01:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762134467; cv=none; b=W2LFrFO/U45RGrPvZysGWxHxf1VnOgKfb9xgW3ZPsSIpQN0hFHA8tix3iA1xiIQEOqjhPb8khe0Sw4WytvvrlNXkWbOzPO5g1ycxpBUeUW0zDZj3IZ7ypnV+WKQC6l0Rr1r/WaDU2YdG5IzYa6jkiHhMwF/lr/tlRYmME6J8HOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762134467; c=relaxed/simple;
	bh=DZ/KiMq7wWJ8uPyNXpIdNz0w5pQFBc9zI5smcnaaiB0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pL9SBQcvL2h65HZtrURXWr2RE/jtHBeMoBOkQ/h2Nuf4Zl9fashSuSdLFWLNcNaFT8rZJMfTeN3rnRfuc/ez+KqeSJb8QTQGtIyurbpHEtHrKq8OvglXgqFfSePYr6bH5qDj5RUYTYUHoWghpvfdfwGXm5Ncs3RdspfI6FSU/KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SBuBF0Nf; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=h3eUvJrw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SBuBF0Nf";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="h3eUvJrw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762134464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DS23ySq+vPb5Ayo6+abelT4SHGq2SoMsLQTkVaSuuRo=;
	b=SBuBF0NfmiEAmskiJ6BG8F9JDWbtoOxdrNWriscf7/qEKzt7DPvjwjmLiJg0e6SK+hcPZi
	DsWQv9RKinnlZp9eraxIfdlm60faE5wExtJnCmU7inYs8jWTsIcURM1TIOpw3VpEU5IcTq
	6+oTAZkCkGOsa13Z432l4/1lfsp44Ms=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204--DkggU_dNgO67lknE-c9og-1; Sun, 02 Nov 2025 20:47:42 -0500
X-MC-Unique: -DkggU_dNgO67lknE-c9og-1
X-Mimecast-MFC-AGG-ID: -DkggU_dNgO67lknE-c9og_1762134461
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-592bd7da031so1809778e87.2
        for <linux-raid@vger.kernel.org>; Sun, 02 Nov 2025 17:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762134461; x=1762739261; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DS23ySq+vPb5Ayo6+abelT4SHGq2SoMsLQTkVaSuuRo=;
        b=h3eUvJrw/IrXM943TWCMfLZSG2xXhrrG5N/qweL10nJoVfb0zjbFI20+DHAy6EFOrb
         Ffl1ym7Ef03Lp5+S0N2CV8Fzma2gr3mIeyvnu7tDkL8Z76z4Sluk22vLRAzUfZb95Zjg
         /K2cCyo4wGen2yf5cbg1m+PN/P/RNyp5qV02pywmYVFAzF/abLeHstalao/9Yq8sMgyw
         cn8nNug7tAumBFnP0aoq7x2wstwrbd0e7EqUG94jSOaLPasaeHCTJ3ezZ8UQFlsSGhNc
         m/NLFRVynESjetZZuiiY6rexzLwK0AUOhsd/a0ZrY5qqeUzHBsFigOzb5sb3aLqNdslE
         4ZTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762134461; x=1762739261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DS23ySq+vPb5Ayo6+abelT4SHGq2SoMsLQTkVaSuuRo=;
        b=EyQvdB6ttVeX0ipYILCXU9ZFHVxmqNhxbvhcWbfdpy7MT5yXskfTtsLTx04rPKOkHI
         1bZX7WfnVsExFHwe8q4dVXNykMp1sBOvtQjLazSOTMDXweVhf0/3umlP3Dxuu+hocYMg
         OombPM6pIWZkgKlOmO1K/a5eAI/ArCE0dETFiIEYJX38OswsMXDBkkOom9HBoLta0Nn3
         tvjrC7L9dZJOxx62CiP7NhhiDTIUz3SfTeLX+3CNuFiWSF6OqvZcyBYXUHKv4sSidb5+
         5WJuNl3ZIV/R05P3Xn22Yk74aoWljyilaprVZWTtUfJWBCSiblHLLAG7SfHIkGHmnIwf
         DkWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVViBgvsXqYm2ubyvIfxIaNqS2ZfbYTPGf6qje9jojersx+kL7B4EUNWpI01coCzT9TZ0MlgP0h5hhc@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2J+9+z0+6MNgMqxF70AV9EnxGHNuVliNvVrOtumuXtfFFEh8V
	jD3UoiI6x2uyPJYzfQOnYAD3tN3JIPi8rO/1vUAZyEFzCR9dsngQFX++jyzwUPHgL2mnT0p62eW
	35fEfysXE/SVC+l9JoDVAMPvmGY8NibOWv2Yr2IiYJ1DAlAJ2n1+L0Y4g5pXQzUtHEIbRAVXoCB
	MVKs43k5ingxikYwZePoeX7JdQv/VAyO9MRW6Zuw==
X-Gm-Gg: ASbGncsBDwA0wR+IpYoAM1JONmMqIQoIIwDt3lpK8p5lE/krvo4YBJEwlkHbOZLqT7s
	jRtg8M6ugHkvZYZmhtT2TvmNhabvkJ87HcGMlaNvMAtsKlkwO5bbb31uy+Ln800j36BQPUTRE8q
	NRFAcO99jhkShk7lvZXhcUrBmqSYBHBcuqLjMhqlr/74nt/CVk8WmZ+Kw=
X-Received: by 2002:a05:6512:3e10:b0:594:2c58:978b with SMTP id 2adb3069b0e04-5942c589ad9mr620631e87.51.1762134461229;
        Sun, 02 Nov 2025 17:47:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEHDOR/3/dEMSprdbAr+vGPJpG0WiUEecPksq7/JieZgEHWe+BMjD1gOgOvmjXIa+VsxvCQ+Uz9nvUL4YhsU+c=
X-Received: by 2002:a05:6512:3e10:b0:594:2c58:978b with SMTP id
 2adb3069b0e04-5942c589ad9mr620618e87.51.1762134460782; Sun, 02 Nov 2025
 17:47:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251030062807.1515356-1-linan666@huaweicloud.com> <20251030062807.1515356-4-linan666@huaweicloud.com>
In-Reply-To: <20251030062807.1515356-4-linan666@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 3 Nov 2025 09:47:28 +0800
X-Gm-Features: AWmQ_bl8wDMCqnoMJ36yUqoXBMkz_wvMmqiObsyO1YtquNOV0cAL5Eti1U9XmlA
Message-ID: <CALTww286rYcR1hFk5GtxuwFqtUo3fwNyixd5N-_MwBX3P6UUBA@mail.gmail.com>
Subject: Re: [PATCH v8 3/4] md/raid0: Move queue limit setup before r0conf initialization
To: linan666@huaweicloud.com
Cc: corbet@lwn.net, song@kernel.org, yukuai@fnnas.com, linan122@huawei.com, 
	hare@suse.de, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2025 at 2:36=E2=80=AFPM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> Prepare for making logical blocksize configurable. This change has no
> impact until logical block size becomes configurable.
>
> Move raid0_set_limits() before create_strip_zones(). It is safe as fields
> modified in create_strip_zones() do not involve mddev configuration, and
> rdev modifications there are not used in raid0_set_limits().
>
> 'blksize' in create_strip_zones() fetches mddev's logical block size,
> which is already the maximum aross all rdevs, so the later max() can be
> removed.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>  drivers/md/raid0.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index e443e478645a..fbf763401521 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -68,7 +68,7 @@ static int create_strip_zones(struct mddev *mddev, stru=
ct r0conf **private_conf)
>         struct strip_zone *zone;
>         int cnt;
>         struct r0conf *conf =3D kzalloc(sizeof(*conf), GFP_KERNEL);
> -       unsigned blksize =3D 512;
> +       unsigned int blksize =3D queue_logical_block_size(mddev->gendisk-=
>queue);
>
>         *private_conf =3D ERR_PTR(-ENOMEM);
>         if (!conf)
> @@ -84,9 +84,6 @@ static int create_strip_zones(struct mddev *mddev, stru=
ct r0conf **private_conf)
>                 sector_div(sectors, mddev->chunk_sectors);
>                 rdev1->sectors =3D sectors * mddev->chunk_sectors;
>
> -               blksize =3D max(blksize, queue_logical_block_size(
> -                                     rdev1->bdev->bd_disk->queue));
> -
>                 rdev_for_each(rdev2, mddev) {
>                         pr_debug("md/raid0:%s:   comparing %pg(%llu)"
>                                  " with %pg(%llu)\n",
> @@ -405,6 +402,12 @@ static int raid0_run(struct mddev *mddev)
>         if (md_check_no_bitmap(mddev))
>                 return -EINVAL;
>
> +       if (!mddev_is_dm(mddev)) {
> +               ret =3D raid0_set_limits(mddev);
> +               if (ret)
> +                       return ret;
> +       }
> +
>         /* if private is not null, we are here after takeover */
>         if (mddev->private =3D=3D NULL) {
>                 ret =3D create_strip_zones(mddev, &conf);
> @@ -413,11 +416,6 @@ static int raid0_run(struct mddev *mddev)
>                 mddev->private =3D conf;
>         }
>         conf =3D mddev->private;
> -       if (!mddev_is_dm(mddev)) {
> -               ret =3D raid0_set_limits(mddev);
> -               if (ret)
> -                       return ret;
> -       }
>
>         /* calculate array device size */
>         md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
> --
> 2.39.2
>

Looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

