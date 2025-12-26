Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2612EA159
	for <linux-raid@vger.kernel.org>; Fri, 26 Dec 2025 07:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766735371; cv=none; b=qscaEhR2Cn8n1b4udWntK0iYKcw2hKZ6OJQ2GYgB605/xw5dFs6I1HOCnlleksXHs9eJQCXPWRZ8d32qqeeMmJnCXN9inISo0cYR/v05qmXDJDgXSmpZkrDV06tDdinn5R+Se7SfQLgHTr1Nm6Zzrw8WSGZg3+DGRaBl1QxeHJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766735371; c=relaxed/simple;
	bh=Zhpyr33fEeYOm7ZVdIxy4HSFPqiWS2gipvmjttj3Cjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MpRqvEu8/x+hG/vFmb4xBdUZvwDaDu8JexKkyLeBEF8boNHH+InKom+Fkhmo6Q11SOL6jarrUspjje90BkzUTsALqL35I7APAwhxIXmrImTkrjCidpzCA9CxVFVItim6Ti7mM3389DRUXE4TerS2f4x+fZb4M+QuCct6burkVco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FAxhT5Dh; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=oE6SnIk+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FAxhT5Dh";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="oE6SnIk+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766735368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GPsdpzjFJq9Fo97Z6igf5R9MxRfzyqd/IbtwCRoWERU=;
	b=FAxhT5DhkYq4ugTM2gJFSx2RAL9bm9c7XyIaeA0e5ZhHpE+eYnw7rj4qiJUnsEke4zJ/ok
	pvSNRwIlcEPiby3deSTjlK3V+pOsilJKVt7cfLbXiWhaDzMj1N9kO3MOihoE8rChrIPD+5
	uJHgScyL+B2hvvpwhpy92Hc5FsPhUfo=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-BDYdLYCfOju6mc2LnhiHng-1; Fri, 26 Dec 2025 02:49:26 -0500
X-MC-Unique: BDYdLYCfOju6mc2LnhiHng-1
X-Mimecast-MFC-AGG-ID: BDYdLYCfOju6mc2LnhiHng_1766735365
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-37fe3e2f619so37523471fa.0
        for <linux-raid@vger.kernel.org>; Thu, 25 Dec 2025 23:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766735365; x=1767340165; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GPsdpzjFJq9Fo97Z6igf5R9MxRfzyqd/IbtwCRoWERU=;
        b=oE6SnIk+/8CA5t+P8Gxh0Fv2hrBrJVYolDAu3CBwmGGQkZG1VL4uY5Bg+KWEIIqaHq
         virCq3rL2ICGuR3M00/ymUGm+nzT64xNv4S5EURUfxWmuuIicJwXboJCxvBMFx0r+kf9
         ofW/+DxyrXoqp6Ig2Pxkge+JJm0bxhktrFwpMhcBQuGbZnjb80BtX0auwknDD8LBDIT1
         +lSslXW2MoAKa7b75qHoRSOvCPwXyLIhzaV4RyDEfqLCJK1yI3zMjZCpim4dD3KKXvEi
         NQvDi7v+qbswAisIKu5+xmUIWJA30wElae+lEDp4wg2y+82JGLfjKF1famNki0LiX4Xn
         HI1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766735365; x=1767340165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GPsdpzjFJq9Fo97Z6igf5R9MxRfzyqd/IbtwCRoWERU=;
        b=Bnsm60PUULa+WI9SBJ5OAffjPhEaMRqEbMEkAdZdHTyloIZTjsf+oJ8tivcuh9P09N
         dXgd+1mhpoVuTgPlOscldmQudJk/E1yCMOpouKU19ztB1T4aPlPc5xezYNkpW64/ass8
         Vt25T65EzTqrJY8CNLucaHfT5bkaMyw0kFSO11I7F32oEonWboAjJkP+D52JxP+RtBnf
         sux9rANxrfxcgFE5S0cuFQvGlj/chPCwt3fSKpWjiwoixm7nyQ2vtKMjFS0KM4vkM0ZC
         8UtogxreYp+F4vJ/pnTLxF9JR6KqZKI22av4qIZRsiBpdI5+hk2mnvJhi2a53OVNaEat
         EJ2A==
X-Forwarded-Encrypted: i=1; AJvYcCUyOiaJQedHb+5FA3q0BqU2I6JfCjmKEIShdoDGis1h9Vai3N30JosG6XyAqKQ7lK/2/oTc8nsrDQaM@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3oIEn2GCA0MGJKMDl3wwDrud6LC1D+JQk87UzBYc3ArgEHGnx
	kOzDU2stqwHBMgDhQTjPSU9VCyphcQrr0m26TaAkblNw1+bDbxjRkbLQnzmYhp0jQ2HqtNq2wKL
	wDLAO4ZqABux5wdp03twRcedeqvjywdYNIiKVEnTEts4ij/kcCWntiMvqBGFPJmZ8qYm7ChAunl
	23oFtFmqQleFNmTC7e+hfYCash4+W+E7OHNBMxkQ==
X-Gm-Gg: AY/fxX7JZU6sMTpkZY8J1b24v2yyRt+n6lfztMTIvlhi9cq8vlYQ3mAjdCQFUUusM+7
	ToTvDuEwmmtL7gOEzonfgvrxwcSipF5Ba6F30gjLZmQCFfSCHTUEs9W4JgneH4Dv7jpJrdB1Fz5
	quDwxjG7/wsMQBYUWFBOfL/O8ZX9nunh8leWz+BMmSJdPJ291603/F1J64JwBsuP2Z9fRHZNw/n
	mDKV3CBlbQrvvgvI2f4Lo6esaMu5sGiJ4KF6xdbVw/iZUAnhLee+Thmt+JiXL4VDefamA==
X-Received: by 2002:a05:651c:544:b0:37b:95ee:f605 with SMTP id 38308e7fff4ca-381215af948mr80856171fa.10.1766735365249;
        Thu, 25 Dec 2025 23:49:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHWMj+LQme/zHgFltgvWQyUvmdaknRhLFI5Z102YsUlCnyJLBwCfjroQQB4rnHpV3HMmdcAXoZ5ElkqSahw81c=
X-Received: by 2002:a05:651c:544:b0:37b:95ee:f605 with SMTP id
 38308e7fff4ca-381215af948mr80856051fa.10.1766735364843; Thu, 25 Dec 2025
 23:49:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251226024221.724201-1-linan666@huaweicloud.com>
In-Reply-To: <20251226024221.724201-1-linan666@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 26 Dec 2025 15:49:13 +0800
X-Gm-Features: AQt7F2rdyv6C8KwjBJaOQHuCGWe_LrtTutn6D4U5x_bMVjG2LlNlxmPTL40b4zQ
Message-ID: <CALTww2_vNNd1kj0-wQjwZDC74WMQnN5jFYnKWw=RV_MALQ_9AQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] md: Fix logical_block_size configuration being overwritten
To: linan666@huaweicloud.com
Cc: song@kernel.org, yukuai@fnnas.com, linan122@huawei.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	bugreports61@gmail.com, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 26, 2025 at 10:54=E2=80=AFAM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> In super_1_validate(), mddev->logical_block_size is directly overwritten
> with the value from metadata. This causes the previously configured lbs
> to be lost, making the configuration ineffective. Fix it.
>
> Fixes: 62ed1b582246 ("md: allow configuring logical block size")
> Signed-off-by: Li Nan <linan122@huawei.com>
> Reviewed-by: Yu Kuai <yukuai@fnnas.com>
> ---
>  drivers/md/md.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e5922a682953..7c0dd94a4d25 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1999,7 +1999,6 @@ static int super_1_validate(struct mddev *mddev, st=
ruct md_rdev *freshest, struc
>                 mddev->layout =3D le32_to_cpu(sb->layout);
>                 mddev->raid_disks =3D le32_to_cpu(sb->raid_disks);
>                 mddev->dev_sectors =3D le64_to_cpu(sb->size);
> -               mddev->logical_block_size =3D le32_to_cpu(sb->logical_blo=
ck_size);
>                 mddev->events =3D ev1;
>                 mddev->bitmap_info.offset =3D 0;
>                 mddev->bitmap_info.space =3D 0;
> @@ -2015,6 +2014,9 @@ static int super_1_validate(struct mddev *mddev, st=
ruct md_rdev *freshest, struc
>
>                 mddev->max_disks =3D  (4096-256)/2;
>
> +               if (!mddev->logical_block_size)
> +                       mddev->logical_block_size =3D le32_to_cpu(sb->log=
ical_block_size);
> +
>                 if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFF=
SET) &&
>                     mddev->bitmap_info.file =3D=3D NULL) {
>                         mddev->bitmap_info.offset =3D
> --
> 2.39.2
>

Reviewed-by: Xiao Ni <xni@redhat.com>

