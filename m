Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11481509AB
	for <linux-raid@vger.kernel.org>; Mon,  1 Jun 2026 05:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780293204; cv=pass; b=gB/ChR1GKIeFL4nYCqapALOXxy1eXcgH0CkPEeU9efvqxgcFGAIEBJJDPVQNwYXt3hfhpFH6bTJ8ln/w7kTIdiXtgLKAEpnxMd5HWDHDOI6O5xkOScB+ua/jimHtbYkUj4LFfTNu20A5zpMxjtk25c5qJGGnfD6ebzIqQ7H6EHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780293204; c=relaxed/simple;
	bh=i52V+JvLA43EYqNoUAOjcmZ+6mrPk5mhrQ8LgQoF2kA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GJxn6C9wgnGPrtQspHOlEKmO00sySuVwmdDzKgiTGld6fYx9sUUrkIvQ+rt+ZGBLcEZbTa3KoMI/pPxQuqgW3W/mzylPd6+p7l9Fc9LGFD9ECmZdzkkQlf6a66ITsh0QJDRr1dP3/RQOhsWYM0zx0K22RNMWtywKvruBQ+QRC08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bze+WHxU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=RWAwNi/m; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bze+WHxU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="RWAwNi/m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780293201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yQiXUEFsRv68TjkhnS9mTCD/oWCvmJGni3jFZcoXnC0=;
	b=bze+WHxUTi6FL2LQZR9Hs+2aJCtcX+Ak/LeH5XRBd1fvHR165xWdSrp9rzLHJeuASCEFGV
	Sl/bmNsSBVcPgURHsf71It2kdX27wrZmTXAdM9nBRvZS7eioW5OZJWExC7Dhe6xA4H/zPv
	xI+BQ3i5OIyn6fFhnvpretETZjtN3gg=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-hhZ6dNdANCqWMDfnPwScAQ-1; Mon, 01 Jun 2026 01:53:20 -0400
X-MC-Unique: hhZ6dNdANCqWMDfnPwScAQ-1
X-Mimecast-MFC-AGG-ID: hhZ6dNdANCqWMDfnPwScAQ_1780293199
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5aa5b598829so1490329e87.0
        for <linux-raid@vger.kernel.org>; Sun, 31 May 2026 22:53:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780293199; cv=none;
        d=google.com; s=arc-20240605;
        b=RSI8+MjUwy2olbe8h6U+IY+yyc/FJiETjU0+M1VilecAG9DQh/R+rt6xOh8LhR4xMF
         Ek68Esqb7/2gV8wuiAYqtRp50udHlRcckjpVZad+Eg7zrksYiIxOSvPc63ZnCuftWAeP
         zfrT5AA791pZRKN6eJBhPwWRpTVW0jKsmsOIdcMKvQbEZI+fNIHbPG4O80Vmm6UQnQ+Z
         tqgyqB117M/1a8H7Jg0EP/YOhkyESfCMUMYTadhkpXWiTe2I0Ko2GyJYywtn64mD9mWf
         +LtM3m/gzlXZCyVYrNZitmGuixOWQe55f+l+PC1zW/52AI8vwP3Bs0q2PpNzxN0tCg1a
         bQUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yQiXUEFsRv68TjkhnS9mTCD/oWCvmJGni3jFZcoXnC0=;
        fh=xDIjqrl9aMCPb5lp8HP/uoIsqUjIvtjm2dqBK4OqZuQ=;
        b=KonwkYa/Fq6x6Qa8Xd17Ii9pDGRieiLgp9FNhlX4YXsPDCFGtMTeIOcxS6he48Jxta
         UoD7Xk0n1DLBIMEwWVhDCReKRvufe5mKHC6fgrhztRl0L98qukAMTrR4z8gD355G9LGS
         C6UxQzsTme0hxl9H/33CCky++2LfurYeDbf6zbDMQlS9LcL5pS5Vw4z8RKEkoSSM6k1b
         OrfwkjHjvk6WA7M/YZ9tdyGb9dnEgd/PkOYHB2i5FwFmlMha/d6M4YxvTqVzB/+r4E88
         WLIW6jJssYk0uueoj7fwlI8A2xxjiMi0T3okHMEBw80GL6bjrRnkjhnOkRrrphxyWcYX
         qz+A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1780293199; x=1780897999; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yQiXUEFsRv68TjkhnS9mTCD/oWCvmJGni3jFZcoXnC0=;
        b=RWAwNi/mDnmRl8ytZKwyYLqxdN7AtA7EHDKi5DGxSMoLhksRkob43FhRtfCt+0K4ro
         aO+SiOHh7yWT5qSW0nDu8YG5ecAu9dXAQufkvRHeyAmFoUOhVUFF/hhDD5RQx/sDh2AZ
         suOCvjz4thzf20c7aJ2SZwSLqaxnhchnDG7wfG6dw64iMdSWh+SG7/AyG4q+UWMusMgh
         8AMayxwV9RnnDMG7JvgyVfzPcEQZzIfqP7OpkAU2EIYUUGX6hNVzgQ1sXPKhgzPacJe4
         pXsiMQ+Vf1nYi+x9wuVxcIproUNUcU33MqVg59Qlp/W20l6TOU8W6NfQDphN6SSXK2Ww
         U3OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780293199; x=1780897999;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yQiXUEFsRv68TjkhnS9mTCD/oWCvmJGni3jFZcoXnC0=;
        b=G+7tNMdUHPnXef8IbmNI+iMJ3XOnwXIsziOsCKzUedS85K3NHGU+UoP26bYTxRNoSJ
         UW/krzLiQ3tkBL/DJ9SYGYGN8yFJgcAEHv3xkSrsaxJNAXJWeEQKd6qxmCtWFW2xPxfQ
         V6dGmSX3yD1KXfs9QjdjeRprv0rSSENPkhNBRwuCHOfFWjEGKkye2GnHp17uUFzbWve6
         g2VquafiNJfdcdndvAzIigOR6WmSm8c3AZh/AVFpYPfo9O9fgDABk5fUq+1rWbQqWGBE
         YO5uZ/eY4dKNpOJkYqcxCunCNV7HYSvBM7g5u4+HSDFzSohxqS322P0DBcVb+stA35iI
         yfxw==
X-Forwarded-Encrypted: i=1; AFNElJ+elnQ5IFSbPAt+LFSXDHBk2xSWjv2RtUtCYBNxgtKM/AgJ4nLkOotvl7Ajag76LPujEPpYpbsg14eU@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe628Vljna2dp8JDMyA79oRGtqDq9dLRgy25HuJqR1SfiWgVrB
	63qPXIQumryQRodsZuhmNlPYwyelUSyzk3qsDmYcwze8sAQP1gKfK5SfHcjhWh5ZrfkgRiTCS4w
	R0DltPM1itP+zDXwz5to0aMLlASSYKOuvuk+mwuVpY1MvuafjZ30VGrQ7fWsltfugm4CM57qSYz
	EEmBYF1SyVOc9s9zxoE+kVHSFs71viuNLOn8fmzg==
X-Gm-Gg: Acq92OE5UbLiCDtuLcqRL8mvTzuEhLrlMC7eG/nFINn90+WUdFyOEYG/LcWhFVVaWNQ
	YPk9UhPPSXmL4JGLOeK0DOl2vRF0LxjIE0hx1wQKjo42gY/97gMvqFl5e2B+9unnvp1BCL0dBqR
	RSkwyCPF/QNrsPuPhZIDVGeteixD/3nf9uu7ZnPw+TIASxhY/Zgfz1vHVkuxhfg23lHYHAUUAz7
	W6LdUGWO5GR4uI+ZJZzM5iihS9F7LN6G3/UB2OnudW3y3mZVFAz3yIi8fqM/etSD0YYz/m+sxAp
	PjPg0yOZ6TXz
X-Received: by 2002:a05:6512:3b98:b0:5aa:6140:393f with SMTP id 2adb3069b0e04-5aa61403a22mr2994636e87.23.1780293198843;
        Sun, 31 May 2026 22:53:18 -0700 (PDT)
X-Received: by 2002:a05:6512:3b98:b0:5aa:6140:393f with SMTP id
 2adb3069b0e04-5aa61403a22mr2994622e87.23.1780293198480; Sun, 31 May 2026
 22:53:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260529054308.2720300-1-hch@lst.de> <20260529054308.2720300-3-hch@lst.de>
In-Reply-To: <20260529054308.2720300-3-hch@lst.de>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 1 Jun 2026 13:53:04 +0800
X-Gm-Features: AVHnY4K_QM3MHL3VHq8y_YmVhgdUGQI-ikICFu_4JfL4IUDpiPn6nmm9oJdCjXg
Message-ID: <CALTww2-Maudy4C+vcvGvWPGqnubpaYh4DDyREPzH=0w=usv5vw@mail.gmail.com>
Subject: Re: [PATCH 2/2] md/raid1: move the exceed_read_errors condition out
 of fix_read_error
To: Christoph Hellwig <hch@lst.de>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, Li Nan <linan122@huawei.com>, 
	Xiao Ni <xiao@kernel.org>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 29, 2026 at 1:45=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> This condition much better fits into the only caller, limiting
> fix_read_error to actually fix up data devices after a read error.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/raid1.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 8fad1692cf66..e510ad7eef32 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2411,11 +2411,6 @@ static void fix_read_error(struct r1conf *conf, st=
ruct r1bio *r1_bio)
>         struct mddev *mddev =3D conf->mddev;
>         struct md_rdev *rdev =3D conf->mirrors[read_disk].rdev;
>
> -       if (exceed_read_errors(mddev, rdev)) {
> -               r1_bio->bios[r1_bio->read_disk] =3D IO_BLOCKED;
> -               return;
> -       }
> -
>         while(sectors) {
>                 int s =3D sectors;
>                 int d =3D read_disk;
> @@ -2652,7 +2647,10 @@ static void handle_read_error(struct r1conf *conf,=
 struct r1bio *r1_bio)
>                 md_error(mddev, rdev);
>         } else {
>                 freeze_array(conf, 1);
> -               fix_read_error(conf, r1_bio);
> +               if (exceed_read_errors(mddev, rdev))
> +                       r1_bio->bios[r1_bio->read_disk] =3D IO_BLOCKED;
> +               else
> +                       fix_read_error(conf, r1_bio);
>                 unfreeze_array(conf);
>         }
>
> --
> 2.53.0
>
>
This patch looks good to me.
Reviewed-by: Xiao Ni <xiao@kernel.org>

