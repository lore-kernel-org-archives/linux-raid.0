Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E4A747F
	for <linux-raid@vger.kernel.org>; Mon, 17 Nov 2025 00:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763339783; cv=none; b=LgPDjTlbavb3NS7SeCzC0xz+o4CqI2yQ6Iyd6CAAjiLi4kbcm/EnWKMMBmMw5uOJWPtD6YlFoJ6zeKuEJc9KzXK6k35xyWNSi4JGQCCXrFh0/7Ewsfi69xojx4hNmuAvDseTxV7C/twpkpHs0HHTx2I6ZwkQRXAtzt4DBWPgzAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763339783; c=relaxed/simple;
	bh=bubkb9hxB7VyJVZghKmvBmoEfkgt/eg0mV9Ox94E3RU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fHM+hdBCAwEXaKRgJvfWvSwHr0j9LfcTD7jO7ne6anCyRB9vVjdE0uCUUFmBLlIHRzab1UowCqXdUp6+CfrMP3TVYR2rWFhnQGJkJ57kKrhi1RszAHrwVmKXsNW0VgEdynHIsMD9aEW83Wd5/nincZEkivTQemYTSLoWy0VFZzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bxL6W/HG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lfc0YbCP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bxL6W/HG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lfc0YbCP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763339779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CN7a9X5xOR8X3n/h4U2c2AKrVfux+CmxLMEOikBMt/g=;
	b=bxL6W/HGRREh56ndOxzw7BTfyFnVae5INORFmxyNbXqZOaih/lBXq4By4LQSf7BhJUZQ6t
	OWL+jLV7HpSYnREz8j534FGWvHYZaMW+jrMu98FZbbCmdTImpc03usmIDDYgv7s0mes4vu
	7R76njeIfUywipJ15qtdjvsOA6TYoE8=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-0YG44FK2Mq2Gp3J_rc3E9g-1; Sun, 16 Nov 2025 19:36:18 -0500
X-MC-Unique: 0YG44FK2Mq2Gp3J_rc3E9g-1
X-Mimecast-MFC-AGG-ID: 0YG44FK2Mq2Gp3J_rc3E9g_1763339777
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-37a34f910f8so12220191fa.0
        for <linux-raid@vger.kernel.org>; Sun, 16 Nov 2025 16:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763339776; x=1763944576; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CN7a9X5xOR8X3n/h4U2c2AKrVfux+CmxLMEOikBMt/g=;
        b=Lfc0YbCPzanxia8zCPZtbEbBwpolEEe3PLZsp/8wL4NJYYEc7EgW5eueo/JnByDLkt
         0Hsy730uH90h/8R0FEZzY9x5B8f4Jn1sLHpD/H+m7aqxUskDWefhr0frsxLNp3tCYMc4
         N2BJjKa6UiIdFmNrFYmM8bezf5POp2oSI/vVSiIYGTMyD7hhukUxNgbkjxS8grQhHi/N
         /omm7EEUUXM4Ni2853MvTF7ll3er4ssMkwDs2JVfxtMFeJ1IXhluz0LbNuq0c1rmowjA
         XMcEEz9hqLO44HBpuwLtfgU9sxrOKOCrlsRt9G1Mq2BWOl2BJxS9rKbFnOX02JVr2pRX
         JCCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763339776; x=1763944576;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CN7a9X5xOR8X3n/h4U2c2AKrVfux+CmxLMEOikBMt/g=;
        b=Qj4cYkNaWUP2OAlY4n0mifaYLw6IKbXHZ3Hs0TThaETvhMQ+Hvi3D7pQBvZj1n49IN
         mS9tAvlJ95lHTlk/uMVmhc6Vd9iaN3LxYa60+q+I5J1xP+1X/kkAiXLV9ZJEwC8ZdCGw
         P9fC3PHcjVsWAcHzj9DdtlB7YVHZ+65rj3wEPDyBT+l9l2fFNeSLSobVWi1nXqpbG/jk
         Qfp9UOdHPkTNKa2eb2BLmxn6D0NczmTCcffCuH1MifL5kX7SCspiYlTHCczVNqLYlLKD
         92jSZ7ykT4X42aqLYF476YMaPeyQepBE1B81kFrNxLVaCugFEwxeA6wiJBVMiP03aI+R
         1YBg==
X-Forwarded-Encrypted: i=1; AJvYcCXnlD5e/18KhQkZERC0mjGkD/RmXxq8SXNPPxmp7q/0pgYfPPe4nE9fY+/TiFn6D4S9W9mRMa+dcxHx@vger.kernel.org
X-Gm-Message-State: AOJu0Yz46Qako8Y3klsS0y6wLb2H9d8I3CTyhYz+di/irs5u2YgfMBvY
	EDjA4C4BTqfjvMJ25W0G/LTB+QC50RO0g/4tQWTPO2oOEos5HPZSaHo1cjf/ZvpiZCooRjW/4dj
	1IMIUfiLe0ydyCfr5VBg26ARxC2M66NlZ0kpF9WefaLpzjLC9M+9SOlaiVrDX6aPyHrIxYkDHUA
	vbZ2p3PjyknR7n9lUMPyyn7smyB+0aj813TQbdLw==
X-Gm-Gg: ASbGncvnXqd7nblXhjBuUTRp/twgjhbin9gpe2q2dhkWxDGAAYpX8QisqMrr1eJb6fK
	mB33FSTovQ+22WvvA4T4NSkjSEndH8w+K0bknevyNMvEjDqu9LOx1pKnCPqUG61fs5w0fOubV4i
	Usl7zG7uITChQwaybn6N53gCQmvWX24wFPE1f/fhPW28xoPWIDpGajg7Hl
X-Received: by 2002:a05:6512:3e04:b0:57b:7c83:d33b with SMTP id 2adb3069b0e04-59584224b88mr3467604e87.47.1763339776360;
        Sun, 16 Nov 2025 16:36:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFyyLwPd3RY0fQBb9bZB6POfs9oaURyd/CrMZh+ua833iue6x/XrRrOqQgmC3w9+TyAAl8h2BxAMuIABaNhnfA=
X-Received: by 2002:a05:6512:3e04:b0:57b:7c83:d33b with SMTP id
 2adb3069b0e04-59584224b88mr3467599e87.47.1763339775942; Sun, 16 Nov 2025
 16:36:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251116021816.107648-1-yukuai@fnnas.com>
In-Reply-To: <20251116021816.107648-1-yukuai@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 17 Nov 2025 08:36:03 +0800
X-Gm-Features: AWmQ_bkeYgPw8dyIFE6bFm7M13mtC7IQ5kfYKbz3cIhrZnJZ8RuCtH2CdMcfMXI
Message-ID: <CALTww29aXdadamz1TrNtG560ZCsOpakqXYK0cMKLvi+0j1gfbA@mail.gmail.com>
Subject: Re: [PATCH] md/raid0: fix NULL pointer dereference in
 create_strip_zones() for dm-raid
To: Yu Kuai <yukuai@fnnas.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linan122@huawei.com, czhong@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 16, 2025 at 10:18=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Commit 2107457e31fa ("md/raid0: Move queue limit setup before r0conf
> initialization") dereference mddev->gendisk unconditionally, which is
> NULL for dm-raid.
>
> Fix this problem by reverting to old codes for dm-raid.
>
> Fixes: 2107457e31fa ("md/raid0: Move queue limit setup before r0conf init=
ialization")
> Reported-and-tested-by: Changhui Zhong <czhong@redhat.com>
> Closes: https://lore.kernel.org/all/CAGVVp+VqVnvGeneUoTbYvBv2cw6GwQRrR3B-=
iQ-_9rVfyumoKA@mail.gmail.com/
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>  drivers/md/raid0.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 47aee1b1d4d1..985c377356eb 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -68,7 +68,10 @@ static int create_strip_zones(struct mddev *mddev, str=
uct r0conf **private_conf)
>         struct strip_zone *zone;
>         int cnt;
>         struct r0conf *conf =3D kzalloc(sizeof(*conf), GFP_KERNEL);
> -       unsigned int blksize =3D queue_logical_block_size(mddev->gendisk-=
>queue);
> +       unsigned int blksize =3D 512;
> +
> +       if (!mddev_is_dm(mddev))
> +               blksize =3D queue_logical_block_size(mddev->gendisk->queu=
e);
>
>         *private_conf =3D ERR_PTR(-ENOMEM);
>         if (!conf)
> @@ -84,6 +87,10 @@ static int create_strip_zones(struct mddev *mddev, str=
uct r0conf **private_conf)
>                 sector_div(sectors, mddev->chunk_sectors);
>                 rdev1->sectors =3D sectors * mddev->chunk_sectors;
>
> +               if (mddev_is_dm(mddev))
> +                       blksize =3D max(blksize, queue_logical_block_size=
(
> +                                     rdev1->bdev->bd_disk->queue));
> +
>                 rdev_for_each(rdev2, mddev) {
>                         pr_debug("md/raid0:%s:   comparing %pg(%llu)"
>                                  " with %pg(%llu)\n",
> --
> 2.51.0
>

Hi all, the patch looks good to me.

Reviewed-by: Xiao Ni <xni@redhat.com>

