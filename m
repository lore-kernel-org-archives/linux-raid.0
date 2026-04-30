Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FE41A9FA0
	for <linux-raid@vger.kernel.org>; Thu, 30 Apr 2026 02:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777515830; cv=pass; b=SagfncnuaV0Kd3hXNsFIsgBdcwrgGajmqWc5EkPGPyAMkudRawR+5l4Vq7aVN1XC1MQ13u5h7ey9l3V1WKR8L+1oZvlUsIXJ3GOQDInkkdeQmjqzRaqS7fuezfRUB8s2pQKslKiQHkvY863E68Lg/vxzF6zskzVboBMHlZmb/YQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777515830; c=relaxed/simple;
	bh=7vkOdTtCtVJYojZ5HX7HyCwQ0EwkKS3bmipDXPHEFSs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SKC/JjpJlf14hfUgLMkVEeCs154aV4/jVCdrvTogSX3pocsD6QlwX1hhtmqoyFldWPL0qC4uIrhwEuYTXl1fxsSLkjjD6DpWCp0oUB088cOvh3VqipUq4YXXlS/hDKW2dOgom+i55H0TeglOFsDFiBV064nX0du2Lbfqg5ecj9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XQZZ/SXk; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=P6jzpH5p; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XQZZ/SXk";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="P6jzpH5p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777515827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VJcTKEYq74ChheTIldNeXTTCr4nynWaYPf9BezwHQ0M=;
	b=XQZZ/SXk00G9LllXY/Pk/mIalw6KW82KeT6JO8XyvMOE02TgAIVetbOijQtU9knJOlb4VG
	umjggPg6E6+mGFWXR+9D0qxQMoYsGatLXCJ28YSX3XWl1SKnbznBMiWeTej775seRIzJWn
	CNzXVIabNx3f7Dj/fxvnC3EQ+qGuZVY=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-lOCKUccBNc-xpDuxKS8vYQ-1; Wed, 29 Apr 2026 22:23:46 -0400
X-MC-Unique: lOCKUccBNc-xpDuxKS8vYQ-1
X-Mimecast-MFC-AGG-ID: lOCKUccBNc-xpDuxKS8vYQ_1777515824
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5a3ffc66760so158815e87.3
        for <linux-raid@vger.kernel.org>; Wed, 29 Apr 2026 19:23:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777515824; cv=none;
        d=google.com; s=arc-20240605;
        b=eQnJX7H0tRmTnW5eR/nxtsypFJETfi3CpqbPXAP1H8UC8MmTaj9a0DCUHzzg0g1eFx
         VTg0LqydO8jCntdsC5iNx/0P6rZ77GGRYId5qHdEMbY7F/JJ9dy2wMbORszQ8D90Y4Q1
         WCmJ1iGWQf4sHZQUbW8B+M1PRTjYt4a6QUD3uyWZxdB5CKGT0lPJcpSsWFL5/gy9Bfbq
         QNiKs6lyi0p27KgLCMdPidjtc8comQU5Bfxl2jcUbc+p2GbryZE0PYQ75O5zcEYx/vHn
         xXi8kC51YTfQRWlG25XmvG8QyZbkEyt5Qd7QSh0Hakm4/7GaCbj6JHgoT7LbQWm64thK
         4Sag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VJcTKEYq74ChheTIldNeXTTCr4nynWaYPf9BezwHQ0M=;
        fh=snDaGRS4HwoE1Fy3kxz5oSZYshZkjEXdJCa+B3ZYORI=;
        b=ckzrfM+g4E0eqXx4IryUmr4F2wZQ1c/ArORU1uXy7l43ONs0ybPc7u2017FkahGLzv
         lzJvvvPQpnBi0wIu5+wWS3PW2lNXarRBk6ER030PMJU+6l5ODhIUqFabldFCmff0UIeB
         JyLojt2quA+Cw1gh+axopEFVnUPA/CHqAw7UTGbue6Hns5nZw2SpMWiFniKR529q7jYx
         gAd42GNRcQygptDugJWzgOisvwBUJ5ZLpV456fOdIS9eVvH6SWI5oxaxcOmIrBl+to7F
         N2o2qo3BeGyiq3o2JobfrhymM0M9CPDjizmfSuBnjg05S1IItUkR1944R51Fkhbzfjnc
         416w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777515824; x=1778120624; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VJcTKEYq74ChheTIldNeXTTCr4nynWaYPf9BezwHQ0M=;
        b=P6jzpH5poexma0G6RtdcJcBP+GUkTxx3o9CiqWYpwZpJPrx8xIDysrjNHe+veWcR4y
         s8bsTeoD2UOIC5XX5fV+zL1yiStvU3eA2+MWqjMLtx2vPmz7ZKAd5auqjBwE1PO1OY1l
         XzNSOsd0aVqZoeSVOVwVqWNhY9hU853P7JpIJgfuIwfNhuurfh88BcgL/p/OkfAwT9kJ
         6Is3vsWGu8eZ069tkyJMJoYNY2EBq5MbNC/s9lWiiZlCwl5SKP9UFo8mUfw6eAeg6a/4
         53TborZsyrDOXTNIYhwjMa6seihPMncP/TBarotzelc2YvXPz2XNjb1xrf4jOX4aWKA3
         1P2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777515824; x=1778120624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VJcTKEYq74ChheTIldNeXTTCr4nynWaYPf9BezwHQ0M=;
        b=eEIUG2cFF7xFFe+0iy2+sX6ZF8OgK/sE4XfW4tbeLKu+d70D2cXuaSxIpIs96KmB28
         a2maZGN1HIxw2NgXqDPjOlxqVfMf0oqaJZtrhSnAjMsNLtugR8tnWW0Lv1CglOWr+KIn
         +y3zph7YZMnkBtSiOi+Sg2vJ6WZOYxYkScuvEnbHF+d4m0tYPtFGiDXdB3jxlUyuX817
         DFsBwJJK/WblHApa8GAo+fr+UQCc2eHLd0ZsiPz0rZ+yq5Hz0eUFa4P3kK7UnnwZA9WS
         sVwG2qkqS3H1XZ0GHl6q5AKn9NumFltjNhvZ3q0hDRUeiQ7F7EMVIavrz0szHFiwX+hS
         Vj5w==
X-Forwarded-Encrypted: i=1; AFNElJ8MLhj+XNZSrCnSA4cx1WOAAW/fnCt1wAJKAE1d3JiSPCxddAda1tVmryeEOp1SIrogEX4KPW59McEz@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2KRoDSaxouJL25jZ2PwdWLZmsXXkt/vWXAVSeqFBH+VSLj/3I
	iR2+o/oV5JIM0ffA4wqehr3BBxSItrMNcd33T+wDnJO03HNjix8g1ZhaPfoQounkTt1+1EU2cq0
	/ZwYrMT8eOI9q+kpBd4yAn8gESMhel04xTuDDepU3GNAfX9zJntLCBC0bAxM50hfxYivE4gvm0A
	0wcZbDlxkZaVLF/5mhd8uT3hAkLGnko1wid5Ua6A==
X-Gm-Gg: AeBDieuRz+dFFlqbNu7bRMVB6E+IVH1GuqnyqM+TDQMdEjt6DbaVg+pvJPk758Dg38v
	lDn8T/dDerhy0RiDWt/NqvsyqAuyTTeIs+6rlmDCmsvPtv6Hmpk970Z406DzrVVa6lrbiiIU4ZJ
	MKmgFPwqEIKz2SUBT90jSipsRHQ9jAfe/KczNBuu4p1WZ1YoI7SCoT/QCq40N2kFf+pJqoPbQ3l
	eJ1tTrEFoe3V5JISjK63eND+X1xwY3F9j7S+PTCBaOIcPWjUBK4eeRzGXzxU7ljoSuIWWd00ilu
	IegRdZOHTjOY
X-Received: by 2002:a05:6512:308f:b0:5a7:42d6:529b with SMTP id 2adb3069b0e04-5a8522dc224mr255127e87.34.1777515824466;
        Wed, 29 Apr 2026 19:23:44 -0700 (PDT)
X-Received: by 2002:a05:6512:308f:b0:5a7:42d6:529b with SMTP id
 2adb3069b0e04-5a8522dc224mr255112e87.34.1777515824046; Wed, 29 Apr 2026
 19:23:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416033801.786415-1-linan666@huaweicloud.com> <20260416033801.786415-9-linan666@huaweicloud.com>
In-Reply-To: <20260416033801.786415-9-linan666@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 30 Apr 2026 10:23:30 +0800
X-Gm-Features: AVHnY4I7LMDyr3yVgB5ZssH0sGdMyGv9UdedMu-cy3eolQBpJlJjyBuDTZXCvak
Message-ID: <CALTww2_cU_kMCROQFOri6LvaTGipe_tMgsBmkaJdahCFizDoTw@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] md/raid10: fix IO error at logical block size granularity
To: linan666@huaweicloud.com
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 16, 2026 at 11:51=E2=80=AFAM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> RAID10 currently fixes IO error at PAGE_SIZE granularity. Fix at smaller
> granularity can handle more errors, and RAID will support logical block
> sizes larger than PAGE_SIZE in the future, where PAGE_SIZE IO will fail.
>
> Switch IO error fix granularity to logical block size.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> Reviewed-by: Yu Kuai <yukuai@fnnas.com>
> ---
>  drivers/md/raid10.c | 17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 3638e00fe420..5b4ffd23211a 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2454,7 +2454,7 @@ static void sync_request_write(struct mddev *mddev,=
 struct r10bio *r10_bio)
>  static void fix_recovery_read_error(struct r10bio *r10_bio)
>  {
>         /* We got a read error during recovery.
> -        * We repeat the read in smaller page-sized sections.
> +        * We repeat the read in smaller logical_block_sized sections.
>          * If a read succeeds, write it to the new device or record
>          * a bad block if we cannot.
>          * If a read fails, record a bad block on both old and
> @@ -2470,14 +2470,11 @@ static void fix_recovery_read_error(struct r10bio=
 *r10_bio)
>         struct folio *folio =3D get_resync_folio(bio)->folio;
>
>         while (sectors) {
> -               int s =3D sectors;
> +               int s =3D min_t(int, sectors, mddev->logical_block_size >=
> 9);
>                 struct md_rdev *rdev;
>                 sector_t addr;
>                 int ok;
>
> -               if (s > (PAGE_SIZE>>9))
> -                       s =3D PAGE_SIZE >> 9;
> -
>                 rdev =3D conf->mirrors[dr].rdev;
>                 addr =3D r10_bio->devs[0].addr + sect;
>                 ok =3D sync_folio_io(rdev,
> @@ -2621,14 +2618,11 @@ static void fix_read_error(struct r10conf *conf, =
struct mddev *mddev, struct r10
>         }
>
>         while(sectors) {
> -               int s =3D sectors;
> +               int s =3D min_t(int, sectors, mddev->logical_block_size >=
> 9);
>                 int sl =3D slot;
>                 int success =3D 0;
>                 int start;
>
> -               if (s > (PAGE_SIZE>>9))
> -                       s =3D PAGE_SIZE >> 9;
> -
>                 do {
>                         d =3D r10_bio->devs[sl].devnum;
>                         rdev =3D conf->mirrors[d].rdev;
> @@ -4926,13 +4920,10 @@ static int handle_reshape_read_error(struct mddev=
 *mddev,
>         __raid10_find_phys(&conf->prev, r10b);
>
>         while (sectors) {
> -               int s =3D sectors;
> +               int s =3D min_t(int, sectors, mddev->logical_block_size >=
> 9);
>                 int success =3D 0;
>                 int first_slot =3D slot;
>
> -               if (s > (PAGE_SIZE >> 9))
> -                       s =3D PAGE_SIZE >> 9;
> -
>                 while (!success) {
>                         int d =3D r10b->devs[slot].devnum;
>                         struct md_rdev *rdev =3D conf->mirrors[d].rdev;
> --
> 2.39.2
>
>

This patch looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

