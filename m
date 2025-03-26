Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E767F9
	for <linux-raid@vger.kernel.org>; Wed, 26 Mar 2025 02:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742956307; cv=none; b=FjWfc5Em7a4yA8KLQ/WYoduPmGAD5IzJyfKHkYFqoKberRyC+m59jzY8RQAIBK6jYxx0uXmINHT+P6R3Ia+qs7IlOuMGmLLtIbYClJ8sGO67qRQbE7w4aq7cebh1nnU2Sn3SWYeYjS6Kvf0bxOhcrcC8lWIZG0C8Xw+zpegmJh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742956307; c=relaxed/simple;
	bh=e2a/um5FH1u+Fk5Bp3pHz5qNemg6ZhG3lu6l4InAR3o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=izEnRx9gvrByYwALJTogFVc2UitNJy0FmkvluM7al0jgSaJQez9e3o3KqRymcL0uVf3x1XMLXNLy+4yoIw2KYwqdeesVAve3OuBRrFQ1KcpJ4Yssj9dkcfvP1Kb8oz7srbzj8VQ1uutYRTnnVXc7X/XobrxNXjqNQ4V6PZKqLLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KfE1MaVD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KfE1MaVD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742956304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hvXio9Of5nIA2nmctJD1GtKk5xVsWSahcOV6i+3aq8g=;
	b=KfE1MaVDDvoR6gk7iYACUNId8G/pvceVx76HTiVhMl0QEAdm2BlykRtH/khSJqfrIl9StV
	WvGZy5lP6N+RiNu0LwHaxqaWnox9O8jbhzJMl+APgGPQb+OcjGzvgk8hn+6GVSFxnRXooX
	STBm4VtLF6FSW3T28FnfDs2XikqF/K0=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-9K8SmWvvM-ypv3KuaEEydQ-1; Tue, 25 Mar 2025 22:31:42 -0400
X-MC-Unique: 9K8SmWvvM-ypv3KuaEEydQ-1
X-Mimecast-MFC-AGG-ID: 9K8SmWvvM-ypv3KuaEEydQ_1742956301
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-549927ec579so3276511e87.3
        for <linux-raid@vger.kernel.org>; Tue, 25 Mar 2025 19:31:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742956299; x=1743561099;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hvXio9Of5nIA2nmctJD1GtKk5xVsWSahcOV6i+3aq8g=;
        b=dtY5wpB1eXl3hb8yExis682VRDLky5WNjuhDmDhWocwx1M7sbfqL53BG3eO8VZQdJR
         AhhGx3NYhCRHZQqASapmR97YwBci8Vvjg9d30OiaEAtuDrxIXXx3EEPI2+KlQu43BFEH
         S7WVR4B+VDFrGDdk+q9LJwKsQcwpfmGADxcJeo8t2NgiteQrBpiUbDc4ispYZOLdIUjb
         HVrnqqMrwcAh04Mr+eOb0qlov15/aUiE6Rb+SpuhF4NMIxYlgt6ruMOCo3N0fyoRVfM4
         rK6XjwUqV5+E4XC9vPKE81qNkiHPPkNFfbo2Bq2hYbgKtcUojb7RdESReIa1bsY/Qihb
         35kQ==
X-Gm-Message-State: AOJu0YwJR+8xY46FauZQhrtphHHluXQ5ECE7kjvpXAeXi9bx/PQFUFAt
	iE6DT659JJmiF0cyzTMPvJgC5e/dStkUEcoG7PkWd/8YBh6S7ZHfJxgmQ5JhJUotaJnTVN7tEz6
	XLCQsInWlrbh55bNtOl8LqkDlG+3KYpB5qnYug79FTwMtrZMm7EBW3j4Fz5VRGjUeC9wWVf7jIX
	UhZ8lglylvezIlpMhMBjqyRLCOx4svXrKik/jQdCSNCCGv+wA=
X-Gm-Gg: ASbGncsSsiCI3g0nLsXIt/Mwby/ql7j5pMTfK3u9sFsZuXewVzcuQA8H1/wQA8HVrQ2
	j3sjCCC6vpcnpmYr8UlBndbNWCGyu6Z1vEMwvWDQoqNtrBlu41jOt8BMCcbkGqFNT7kZNrzvTlQ
	==
X-Received: by 2002:a05:6512:110b:b0:54a:cc25:d55d with SMTP id 2adb3069b0e04-54ad64f823cmr7848462e87.43.1742956299168;
        Tue, 25 Mar 2025 19:31:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgjeCBkYCVdInqZ4di4n3a6EhnPpKtA7O0irt6p8CUirivnrkZzA4apW4beB9m4m5dORT9RvIJ+9pnrxbfnm8=
X-Received: by 2002:a05:6512:110b:b0:54a:cc25:d55d with SMTP id
 2adb3069b0e04-54ad64f823cmr7848452e87.43.1742956298684; Tue, 25 Mar 2025
 19:31:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ded3b88e-c0e8-4a66-89f3-43bc6bb9664a@redhat.com>
In-Reply-To: <ded3b88e-c0e8-4a66-89f3-43bc6bb9664a@redhat.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 26 Mar 2025 10:31:24 +0800
X-Gm-Features: AQ5f1Jp2DJkD4iIRGXkeo9wJgVGGWFwMYHcx0vZwDGEDVnqkbtYrsBBE-vdWMqk
Message-ID: <CALTww2-=c0onxFw6hMgZ3KGKVRQw1hu_7cQ8f-X_KjjFjt6eNA@mail.gmail.com>
Subject: Re: [PATCH] mdadm: Incremental mode creates file for udev rules
To: Nigel Croxon <ncroxon@redhat.com>
Cc: linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 26, 2025 at 3:18=E2=80=AFAM Nigel Croxon <ncroxon@redhat.com> w=
rote:
>
>
> Mounting an md device may fail during boot from mdadm's claim
> on the device not being released before systemd attempts to mount.
>
> While mdadm is still constructing the array (mdadm --incremental
> that is called from within /usr/lib/udev/rules.d/64-md-raid-assembly.rule=
s),
> there is an attempt to mount the md device, but there is not a creation
> of "/run/mdadm/creating-xxx" file when in incremental mode that
> the rule is looking for.  Therefore the device is not marked
> as SYSTEMD_READY=3D0  in
> "/usr/lib/udev/rules.d/01-md-raid-creating.rules" and missing
> synchronization using the "/run/mdadm/creating-xxx" file.
>
> Enable creating the "/run/mdadm/creating-xxx" file during
> incremental mode.
>
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>   Incremental.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/Incremental.c b/Incremental.c
> index 228d2bdd..e0d3fce7 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -30,6 +30,7 @@
>
>   #include      "mdadm.h"
>   #include      "xmalloc.h"
> +#include       "udev.h"
>
>   #include      <sys/wait.h>
>   #include      <dirent.h>
> @@ -286,7 +287,7 @@ int Incremental(struct mddev_dev *devlist, struct
> context *c,
>
>                 /* Couldn't find an existing array, maybe make a new one =
*/
>                 mdfd =3D create_mddev(match ? match->devname : NULL, name=
_to_use,
> trustworthy,
> -                                   chosen_name, 0);
> +                                   chosen_name, 1);
>
>                 if (mdfd < 0)
>                         goto out_unlock;
> @@ -599,6 +600,7 @@ int Incremental(struct mddev_dev *devlist, struct
> context *c,
>                 rv =3D 0;
>         }
>   out:
> +       udev_unblock();
>         free(avail);
>         if (dfd >=3D 0)
>                 close(dfd);
> --
> 2.31.1
>

Hi Nigel

The incremental-assemble tries to assemble the array. One array has
more than one device. This patch calls udev_unblock and
/run/mdadm/creating-xxx is removed when the array is not ready. So it
needs to choose the right time when all devices are added to the array
and then calls udev_unblock.

Regards
Xiao

