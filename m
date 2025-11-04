Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF4F235358
	for <linux-raid@vger.kernel.org>; Tue,  4 Nov 2025 01:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762220884; cv=none; b=KE187OYDXcbbA47uY1IKdtux5ew+n9tpp109j7FCwUfgnUiMRwxZS95n9HZ8RmAOXud+yr/Ahoqve+R+PjDFsdoYQoebPxpu1zYBMUA/uBxaTElHXFGTpAEIiEUkIsF+Bc2+6jNGiSpsW/7tkzw/V64nqgZWsRggXrYBf1hlYbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762220884; c=relaxed/simple;
	bh=fSdA0L8Nm0YCwS16VUPzW3Aq3gD381+XRBN41NLXEX8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lDfKsgvpZhKb5n41UPtSubSW4Vrb0bUOpUa82sMX/rdkr+7/o5cGCar6tvC2TU9ni3BmPz9YeNWQtmxb/TYRIEZjMG3Z2xr4gkNxvSOoduwsAPTV4RWTy657O5e/HFZ0q+INRGyuULiN6aTTVrYkvOjGepA4HmuNkaFg+QiSYUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D5aonBUf; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=trspT5Zl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D5aonBUf";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="trspT5Zl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762220880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bsXwYGK1x1byPj06v8OW9bm66Zb85lZTaaKe7v0rKBA=;
	b=D5aonBUfqMZU8YSXnnYNP5YqzwF5bN8ZavWWEHfk9bOD77JXWPz2A/H9tNoiNkWiHAcoW+
	2H7AuFq7DN7FXSLdVNjihz7eC1W+M+r/giixRNOg1cNKR0uojzGKEg/4ZXoexbeBQ8zvRd
	usyp8ZW8ymbBNyRyHFmxQ0tvpMOapCU=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-SSdUgzGGNWC3J4SUnc8s1Q-1; Mon, 03 Nov 2025 20:47:59 -0500
X-MC-Unique: SSdUgzGGNWC3J4SUnc8s1Q-1
X-Mimecast-MFC-AGG-ID: SSdUgzGGNWC3J4SUnc8s1Q_1762220877
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-591ec0a2a11so4531820e87.1
        for <linux-raid@vger.kernel.org>; Mon, 03 Nov 2025 17:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762220877; x=1762825677; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bsXwYGK1x1byPj06v8OW9bm66Zb85lZTaaKe7v0rKBA=;
        b=trspT5ZlNBdAIQC/2orO/aYr8asqK8FPRoQ1G5hJ8lu8hy94oy9bbBdJXfuAe1FLzO
         uEMr4WB9btdusS+3L8OG1NzauT6vJrJ1vcPKV9tNUePNp4ZmT1lp/RuqFv3K2qTfn/6O
         rilcB4j7vlWXiBcMxIPRzAE4l1khfnT3go3nmktoVGh9rl7g94D6gToAci4OrDz9/EcE
         HSIclXG84Z6p+dYcjGJKu588YVPloRD7fd4O/noPfdPScLw97NhGkgft1hsmj7JDS6tj
         Dl2vBK/SUy2KA4Hn9Lirvgqbe8vQV6KXO0Qrkbg79o/JFEdCseQPLdno7HEa4qaUOcU9
         3tzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762220877; x=1762825677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bsXwYGK1x1byPj06v8OW9bm66Zb85lZTaaKe7v0rKBA=;
        b=MEm0sip0Ix7DNVqfwjFPilPIRW8BS9Hwi+V/KMy2NbEO/1GyEG8Jlkrq15DnBOH+Oa
         TAByFft/Wx0n9An6YDE9FXyzYOWStIVLtSmwpwbjgGFBq/3vtcrm6gjEMr/zsysGRqds
         vsqu5gS4gTFvtyfH6acMr8RwOWRI2E67Gwc6dU96++mz6QAIoyuU97BRClNK0S6fYoJ3
         6npa9KH7m88sSW3cKj2/gd9z4xsiRhJC7koSUl5cRa3aA5Ly6xIEH6LW6reRkVP+eu1Q
         nbiMKWmaV4ATur8EJ7a/Y/w/p1Uev/1yWTZXcgcaZ2HnWiFuSkZiB9IfpukPLj3fkLhf
         /BTQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5MFUq/9Abs4Rrd+N0Kv6oSGRaan4Rs1ZheqNMfHKBl1tYZXxcgXXunX7E14A/JGkPkyjRMRLX3FXN@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0P0wvpmxL1imlU+8JUdLLKPOnffdJL/x6z5xu6h4PczLUwdnw
	XcGyWq3EFYhEDvjYr+3WyIWIslK3qmLq2nd7oPSFl/0hq6/W7mWXqxJTkcsJ9vZNjoykH03IfGg
	xPxL7yHAfMjQ0adk0VshxhfTwIS4V+ToNXLv/J/RXv8oHPX3Tamjs3Z8xDHkRx2WqWKwUea7/QO
	mH+w0xoGqIO5AwfWZyYk6F930PJSwB0YAifQoxPw==
X-Gm-Gg: ASbGncuecmZzcWm26pLVain5EF0HczRPLjeamaalp4VUB/KRWZndaxvXoCbopdqJXV0
	3Ep4yb/rMo8q4WjTO40sQhJ/0Z4VrDwLNzFzx8zEYY5fl2MMrKVg79fPOtTx+u19hSF+6sypwkV
	/ceqRaM34dUIWK6+QZqLJYLgNvAgz/2HDHKOJiyZkTuAYoO2UVnOi2xqer
X-Received: by 2002:ac2:4e06:0:b0:594:2f72:2f8e with SMTP id 2adb3069b0e04-5942f723446mr1343710e87.10.1762220877393;
        Mon, 03 Nov 2025 17:47:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGa2QAcOx2jbiaR7JKF3K5bdYSVRtB/YvBQpCC8cf4XQDFWQEH7U+c+L3BD/FhyG3c+WA30SnGgfwMNQxzZnKY=
X-Received: by 2002:ac2:4e06:0:b0:594:2f72:2f8e with SMTP id
 2adb3069b0e04-5942f723446mr1343693e87.10.1762220876921; Mon, 03 Nov 2025
 17:47:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251103125757.1405796-1-linan666@huaweicloud.com> <20251103125757.1405796-5-linan666@huaweicloud.com>
In-Reply-To: <20251103125757.1405796-5-linan666@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 4 Nov 2025 09:47:45 +0800
X-Gm-Features: AWmQ_bnPKBTjG4KT60HiXK62t6RM-uEzUUaIJ9bAKjC9tyeQ8C-26fjcFNkMFHU
Message-ID: <CALTww29-7U=o=RzS=pfo-zqLYY_O2o+PXw-8PLXqFRf=wdthvQ@mail.gmail.com>
Subject: Re: [PATCH v9 4/5] md: add check_new_feature module parameter
To: linan666@huaweicloud.com
Cc: corbet@lwn.net, song@kernel.org, yukuai@fnnas.com, linan122@huawei.com, 
	hare@suse.de, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 3, 2025 at 9:06=E2=80=AFPM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> Raid checks if pad3 is zero when loading superblock from disk. Arrays
> created with new features may fail to assemble on old kernels as pad3
> is used.
>
> Add module parameter check_new_feature to bypass this check.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>  drivers/md/md.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index dffc6a482181..5921fb245bfa 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -339,6 +339,7 @@ static int start_readonly;
>   */
>  static bool create_on_open =3D true;
>  static bool legacy_async_del_gendisk =3D true;
> +static bool check_new_feature =3D true;
>
>  /*
>   * We have a system wide 'event count' that is incremented
> @@ -1850,9 +1851,13 @@ static int super_1_load(struct md_rdev *rdev, stru=
ct md_rdev *refdev, int minor_
>         }
>         if (sb->pad0 ||
>             sb->pad3[0] ||
> -           memcmp(sb->pad3, sb->pad3+1, sizeof(sb->pad3) - sizeof(sb->pa=
d3[1])))
> -               /* Some padding is non-zero, might be a new feature */
> -               return -EINVAL;
> +           memcmp(sb->pad3, sb->pad3+1, sizeof(sb->pad3) - sizeof(sb->pa=
d3[1]))) {
> +               pr_warn("Some padding is non-zero on %pg, might be a new =
feature\n",
> +                       rdev->bdev);
> +               if (check_new_feature)
> +                       return -EINVAL;
> +               pr_warn("check_new_feature is disabled, data corruption p=
ossible\n");
> +       }
>
>         rdev->preferred_minor =3D 0xffff;
>         rdev->data_offset =3D le64_to_cpu(sb->data_offset);
> @@ -10704,6 +10709,7 @@ module_param(start_dirty_degraded, int, S_IRUGO|S=
_IWUSR);
>  module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
>  module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
>  module_param(legacy_async_del_gendisk, bool, 0600);
> +module_param(check_new_feature, bool, 0600);
>
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("MD RAID framework");
> --
> 2.39.2
>

Hi

Thanks for finding this problem in time. The default of this kernel
module is true. I don't think people can check new kernel modules
after updating to a new kernel. They will find the array can't
assemble and report bugs. You already use pad3, is it good to remove
the check about pad3 directly here?

By the way, have you run the regression tests?

Regards
Xiao

