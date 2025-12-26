Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EDF27602C
	for <linux-raid@vger.kernel.org>; Fri, 26 Dec 2025 02:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766715615; cv=none; b=SVbMFpExMWtI3J3zbf1/La0drGen8tXXOrfM3eLKHfr7Fifvxn5cRHbl8dnv7h/SHYCKcFhiH7BHH3zfebJjOkoo5sCOkZg2irNdz1NjTwmw0rCnZqeHJTOj8xmb1EkVxrLrRMQYZnX3Od5XXSbRIAkp2An5EiHZHn4SbZafJgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766715615; c=relaxed/simple;
	bh=GLvvxXJ61QOTyjRA9511e7R20yHeJ8g5H9+zEE2rPkc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MLfTfDrEk+QCL74NGiOL9f1eaa6eWCijREGo7knSSe2CPHseAJq4NyF+t5veTzqwKtCTllPfTC9RDay3daTHQRT8Vw61d0S0mAHC9jaqIkE+8VOqDHl4i4Eauq33SiS3DmJJO3utzzQNhngKHbY+tIXFBOCnkDzd7yyVFiNxmps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YzungpI7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=n/HQXNRx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YzungpI7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="n/HQXNRx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766715601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4X/cYh6G1zJeIwjgMYUOeZsSxw3NZGuaz60Q+GWYNZc=;
	b=YzungpI7Q7gNx7SsRfl9ItOh43ZYDOZ6iVHvh/Kms5tAIprxBaNxJwMQnes35lyiRekpAk
	nEdFaZt5SVR7HmhTEt+fJXK+gMqV84uqqs0LWFsW9SfTpUoITTyQFNcxZzLqng1QnZmc6o
	EZY4UC7UTOngejXhvrwjsxkPOzvO738=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-d8NeBRYtOjSOoE9CCwpdew-1; Thu, 25 Dec 2025 21:19:57 -0500
X-MC-Unique: d8NeBRYtOjSOoE9CCwpdew-1
X-Mimecast-MFC-AGG-ID: d8NeBRYtOjSOoE9CCwpdew_1766715596
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-37e68848509so33854691fa.1
        for <linux-raid@vger.kernel.org>; Thu, 25 Dec 2025 18:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766715595; x=1767320395; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4X/cYh6G1zJeIwjgMYUOeZsSxw3NZGuaz60Q+GWYNZc=;
        b=n/HQXNRx60Jxz8IfvXLqB9Rkpd16x46G7Qm9dPRW5BZT0Q5+ZZRac8IlR3htfLNJfM
         Qfg5r5XEg3z5k9kHhUzF2Um30a4bJw4daiHX6Drj4E/MsnV3B1o6tRDBB0Sui2gasAuV
         UgPaZoGD6/53BN1xeRS8zoGCt5iKHSsbIwrrk4iHZEaFmQzhiNUp8LrpM5Pb0Y5KKu+m
         dASo4bZ3Nz4iE8S28BzlgC13hW5fY+HO0T8SirQGI9E6UbyoGZp6SGCvfE8wqO3iZGKf
         8QEMQE4BMOCGPXDVEVMvAYP3vSdQ46JL9uBsk3+bTlUWTfT+Iu137Yp4QptI5vDjbyuX
         2CqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766715595; x=1767320395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4X/cYh6G1zJeIwjgMYUOeZsSxw3NZGuaz60Q+GWYNZc=;
        b=KC4mEa58BzIdX1uDSZ51MsqOeUDlqsHbgng0IJCOyC8ZKUL3HR9r1mk2E5KHSsB0sB
         9OP8TU5EeyJpDCLHVcGzKuXeTI7NkNDobu/cOMP3l4ohJCUtnLi2efkwTVZ1HUCs/oJz
         1DBInc8XJSsmYXkucvbOFKdFHNLQejAOLitT4L3JPvcYRaslMXLlsygAk/eIa30xpKkC
         0pn4O32dHgQMSHDWOOPu8yv4SHIAgQbIyIfkcrQe5QqAyc/0J2d2drS5JjFPIpIVLOgH
         AwoIkKLJJ+kZwACdz6xisu/mNXryqtpCL1XjaqXDXGJcLGiiCw5P0iOpzFnNqBu/r/VR
         dTmA==
X-Forwarded-Encrypted: i=1; AJvYcCWDgGe9fWjpWgnbhpeJ/nXyTTZBnkDOBX0tzupmYFJ1Hmu36hDFEN0A5CStgoyTGcqqACMvmZKm6s/V@vger.kernel.org
X-Gm-Message-State: AOJu0YxJqCJvbhPPwj38+92DjFpjmb1VR+pwg5zHcCT9+xT0UEg/4W18
	WmflXK1Co9tASmcIwAP86aoIcoxLwEr8PU4avsrnL/ZGzei+K2xIy1S0dSXIpRvA1oLfpNz0Y0T
	3Vg5zGZ/EFaUf55yW2jrP6PZ5ScCpXH8A+v9EY5TkQ6JtmMKVXPX8E/AmUo3QOamJt0r9iuKOFf
	vav4rOIHHJqZ+0xWmzwHtwpLzpUbDqHOBSdKOqblj0bt+Adw==
X-Gm-Gg: AY/fxX7cSw43jS9pJQsTT2DCdHrR2vcfTmCav4vuSuerd172ch3l8hcy2rllgzYXkZ7
	MwyBYElKfU08Q+gQy26Ndru3KgnVqzCOlIqDAx5qEFgNRiEYewJhkNTcYxTsXtsppWmGB+f+zL7
	l824o7+DeNZyd6BMkWttrlLvWdjZzJGBbZr5OEMCDkelqyrtfrgIwxQ6HUhNagVto9xwVV6V3hE
	51U86XPK5CxwY2ZCppBwsOof298Zx2S8z4fob219Roc17gxVr5mpGHW7TenIw7ONmsVwQ==
X-Received: by 2002:a05:651c:542:b0:37b:99ec:9bf2 with SMTP id 38308e7fff4ca-3812169d8f2mr75647071fa.35.1766715595426;
        Thu, 25 Dec 2025 18:19:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGey0cORZNoiOnqJwBQbDaIsGyUD2AhJs3+kC1np8d3xBqLhn84zNQysRZf7EfFBDgIzr6mSZwhkjiWwOv9GGw=
X-Received: by 2002:a05:651c:542:b0:37b:99ec:9bf2 with SMTP id
 38308e7fff4ca-3812169d8f2mr75647011fa.35.1766715595013; Thu, 25 Dec 2025
 18:19:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251225130326.67780-1-islituo@gmail.com>
In-Reply-To: <20251225130326.67780-1-islituo@gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 26 Dec 2025 10:19:41 +0800
X-Gm-Features: AQt7F2r-WhjUGUrk59JOhPn2HZV2a1DW9lF6l2nqxVATtlBGZb8bbh_lYP7qW60
Message-ID: <CALTww28jT+FFcQda+08LNo1X5vo8F9jrsxSkK16gWcTwJR392w@mail.gmail.com>
Subject: Re: [PATCH v2] md/raid5: fix possible null-pointer dereferences in raid5_store_group_thread_cnt()
To: Tuo Li <islituo@gmail.com>
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 25, 2025 at 9:04=E2=80=AFPM Tuo Li <islituo@gmail.com> wrote:
>
> The variable mddev->private is first assigned to conf and then checked:
>
>    conf =3D mddev->private;
>     if (!conf) ...
>
> If conf is NULL, then mddev->private is also NULL. In this case,
> null-pointer dereferences can occur when calling raid5_quiesce():
>
>   raid5_quiesce(mddev, true);
>   raid5_quiesce(mddev, false);
>
> since mddev->private is assigned to conf again in raid5_quiesce(), and co=
nf
> is dereferenced in several places, for example:
>
>   conf->quiesce =3D 0;
>   wake_up(&conf->wait_for_quiescent);
>
> To fix this issue, the function should unlock mddev and return before
> invoking raid5_quiesce() when conf is NULL, following the existing patter=
n
> in raid5_change_consistency_policy().
>
> Fixes: fa1944bbe622 ("md/raid5: Wait sync io to finish before changing gr=
oup cnt")
> Signed-off-by: Tuo Li <islituo@gmail.com>
> ---
> v2:
> * Move the NULL check and early return ahead of the first call to
>   raid5_quiesce().
>   Thanks to Yu Kuai for helpful advice.
> ---
>  drivers/md/raid5.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index e57ce3295292..8dc98f545969 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7187,12 +7187,14 @@ raid5_store_group_thread_cnt(struct mddev *mddev,=
 const char *page, size_t len)
>         err =3D mddev_suspend_and_lock(mddev);
>         if (err)
>                 return err;
> +       conf =3D mddev->private;
> +       if (!conf) {
> +               mddev_unlock_and_resume(mddev);
> +               return -ENODEV;
> +       }
>         raid5_quiesce(mddev, true);
>
> -       conf =3D mddev->private;
> -       if (!conf)
> -               err =3D -ENODEV;
> -       else if (new !=3D conf->worker_cnt_per_group) {
> +       if (new !=3D conf->worker_cnt_per_group) {
>                 old_groups =3D conf->worker_groups;
>                 if (old_groups)
>                         flush_workqueue(raid5_wq);
> --
> 2.43.0
>
>

Thanks for the patch. It looks good to me.

Reviewed-by: Xiao Ni <xni@redhat.com>

