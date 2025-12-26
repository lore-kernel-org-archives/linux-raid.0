Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AC21AB6F1
	for <linux-raid@vger.kernel.org>; Fri, 26 Dec 2025 07:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766735297; cv=none; b=AIvuPBh5iMPAWhTINkc8TpElUs1PZZoKx5oYaRSS08gCvCdn6Qx9dpf02n+CURcvkzoY3UXDapPWwoE9L2wUFlbuzJQvWP5UKa5xXFlGdrkHSprHaYXfXYBGTeB7+3jZHfftc0zpRMg/JwYsLVOi0a+DLYhL2Ds5SKrV+Fuxl9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766735297; c=relaxed/simple;
	bh=IayDniNA5eW8F1GDFeENaeaPe2xOwKXSfEP+67O56NU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z8EeUEGIiw3N/0qLpOM3r9hKkwASSvNGfNDoMYtIDQdVB2RKmo807e8HPUotjA7H+ioeSTFhTn52feHIdn4Niv+6AtlWcXftsz/ia4C7FZCHIUgLDbKO6nUxr7mmHT5EqT8IFj/hg4VEMxYd5krAfOFxJxgJUN8vSHHCWLUeC+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=an1ce34j; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=R7YSLJz+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="an1ce34j";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="R7YSLJz+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766735294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hGYoQeCmfq9V/E9OZuq8ZkRY0/7jhOmiq3nUYAMEx0E=;
	b=an1ce34jnvqFZnNIyupFn2fA3/jq6vyLYK8hEXh+35S979GWBc5CJLD2fseUjo59WLzydj
	tvNAIGE1SEbdp0jgXEJh6fZAKlIcalqaEmhpzwChOUne653cT4zxET0MuiC+Q562NuT8sh
	d37+kjQ03xTR0s3N+NVqa5DlfIWZB2s=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-37rA6iHHMZitY-94NOqzfA-1; Fri, 26 Dec 2025 02:48:12 -0500
X-MC-Unique: 37rA6iHHMZitY-94NOqzfA-1
X-Mimecast-MFC-AGG-ID: 37rA6iHHMZitY-94NOqzfA_1766735291
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5944d65a8f5so4686989e87.1
        for <linux-raid@vger.kernel.org>; Thu, 25 Dec 2025 23:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766735290; x=1767340090; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hGYoQeCmfq9V/E9OZuq8ZkRY0/7jhOmiq3nUYAMEx0E=;
        b=R7YSLJz+YIppa0mriR9oV0Evi8yy2fJaf/aohk9uvJzkLxfHprdKucy27Kp3yPcIFm
         FXcf2xNrqiuZM98kEr7r4HubCYtvgmlssookvIcP52UomfHZC/ZlbLTBejqE/6D7ZX1M
         r8nwzGu5gpAKHf1eNuq3aBpsM8bNga9BNaQgBXC2k3wjYfD+sopXzowFRMMwIOQ/JECN
         qpx1tpkcD5fSDOLvivFy7xiR3ZYpEqpCeGPxmX0C7CYrZFQj3uSPN6U0EcN4fJIxVpmO
         BTWfE29iZDyEVH4YzYz03O9HL6zF5ZDhSVAoKPcPD6IDqWW2pLFhlNTPdvxLZIQOT16K
         NFQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766735290; x=1767340090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hGYoQeCmfq9V/E9OZuq8ZkRY0/7jhOmiq3nUYAMEx0E=;
        b=jmCSGX610PFp8mq4WFfCPxExfpGSpuU1fI+6/bg//ENPyJugIvKhfSVOBKGQibpKb2
         WL0l48fcM+LnKjrNExjB3Tek14AalzAJQDWtSVvphoz/xqMo5054wNhlFVoGlosYhNrM
         8rewXOHRngsVWSjjllXlynmURfvVnNJ46DKXrIIRZRLQBb84PslAWRePeri0vQc1jzGn
         neMEsshJkDb36K46sEnymND/cW/iYo4YCILonO/K5oPdaewUr0MNZW1g+Rw5riJ00BoL
         M4Y64RvMIuk41UREVPbCYnComXvmJbfuqQfSVwwHuHu2TmdsUTOf49LC+YDIfJSBnsKU
         l85w==
X-Forwarded-Encrypted: i=1; AJvYcCVsrPeHu/+0O2gRArjpi3tBzIMujDsIz76i7ajS9g0BchHPc89zL9bOyq9nchR7tBpJgp3FiRCptYmn@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg6P8LxDLUFzmsFFQ1iNdvJUQjdDrdFlT51997rjP6EKeP/77y
	AujtK/AWtGmq+mUJi/3XedlHcVFyTkGXSOME5YMEbp6JH4U0HM5iOznYHrj6U9HvssYOyIEj8mz
	iZRqzcZwxOJU/Z1JsDu7C6R01ONkVbTqFmeNj2SfzGa6+qx2WDUlBB7OJ7vWJYYdKQ4Vv4ICnJa
	fVUcpgz8cflPQNCmcAJuU9XzdSoa3AXQvy9CcPuw==
X-Gm-Gg: AY/fxX60qrU4tg4cKRwvmx9aaSogveK5+Q1G537asw6GC2aUUHQDjxh6Mfov57UCvTo
	O/0wFt8DIk4KXWNV3jsA6M2vQ7Mc9yNoCsHGbz8NemuAAt9hnE0EVD9ABpMalWe5skmD5d8UzL8
	w4Bm8LzcfnFJB/9On3jbcYaDWIPAHw+rkKl3kb2NOrKGyNwSOyXULmaa4vi4Gs7v4md7wa3TKwi
	cfCKNgQbC7aXGAVQWG/XDprvPJ72JqlKrthkLXMv42jfP4wagoytDF53oqZt1758byxfw==
X-Received: by 2002:a05:6512:3b9f:b0:595:7cb9:8e51 with SMTP id 2adb3069b0e04-59a17d1fa1dmr7838669e87.12.1766735290462;
        Thu, 25 Dec 2025 23:48:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH8F3MrJ1ct/xM1EWRfao2sIrMemeKzXbQ57OgHJpKO21nZgjk5QZGJrJAMrFKyDF4im0DfliLkvBXllhx+LNg=
X-Received: by 2002:a05:6512:3b9f:b0:595:7cb9:8e51 with SMTP id
 2adb3069b0e04-59a17d1fa1dmr7838662e87.12.1766735290055; Thu, 25 Dec 2025
 23:48:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251225121311.1992029-1-linan666@huaweicloud.com>
In-Reply-To: <20251225121311.1992029-1-linan666@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 26 Dec 2025 15:47:57 +0800
X-Gm-Features: AQt7F2rDF7MrbzWowsBIUDNRTQ-tWUABELb2rwgh5VXox4V8iuqhpaJg8a9QdxE
Message-ID: <CALTww29hq7t5SZ4gtprJN_9msW58qs6DaSsdLQ2CQWTZ=k7Lng@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] md: Fix logical_block_size configuration being overwritten
To: linan666@huaweicloud.com
Cc: song@kernel.org, yukuai@fnnas.com, linan122@huawei.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	bugreports61@gmail.com, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 25, 2025 at 8:24=E2=80=AFPM <linan666@huaweicloud.com> wrote:
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

This patch looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

