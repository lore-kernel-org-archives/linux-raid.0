Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07893C2D1
	for <linux-raid@vger.kernel.org>; Tue,  4 Mar 2025 09:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741082208; cv=none; b=BeOISNRB6K9NTWSrJ5AjO/Mx8YEDFXa/f/2O6+zVeMdWA6XntCEPojA+6eCitF0b4ZDhE11lRBGmlogHIk1I6SD/46YVOcKlHo1ohIUVP4mswbVmEEkFRgEqwKZ16yf68j4+DiiG1Nr0rwkeFBHNK+qOAhH7W9dDnm5Jg9J8Ad0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741082208; c=relaxed/simple;
	bh=vDhaZxE2eTFhQuIRzFRcDOO6lBB9m14aih+rmJ+jduY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fPV0TxTtYtuv2pIjcYZ8MnRXPR0D9lsTLa9lOPRLYeiLJxWai4MiaupNd2U4GxH5kaBcbVY8XHwU1GhRGoPyut22zOsB8eY8cHhaz4r8Tz0XVoHT/KJ/ZRkbzSGj2OXyDsmBtkVkEq3hE9p4YRPEEdqE3gDEvYJKZofce6r0mRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BSC8yquv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BSC8yquv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741082205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=geZSsmVhY58PkFnIyc+H7q80Fr8l2scSMWEn4NHrcmo=;
	b=BSC8yquv3ZTq1noGVZyXojQ9r+dXXGk3GTAzo167XMGg6eUgE+HwyNfB4yM+n6Ffr77O4Y
	ltj7PU5zq13C9+7X15JinvPIuuI8bWZqfvc1Otn13rZvh2kXFZ5tzl4EkCN87ATgnRMemN
	LkreAWrgujVxIiC0FhhOXJtsqORDsuc=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-mvnNscaUPFWT2mqLG3ZJuw-1; Tue, 04 Mar 2025 04:56:44 -0500
X-MC-Unique: mvnNscaUPFWT2mqLG3ZJuw-1
X-Mimecast-MFC-AGG-ID: mvnNscaUPFWT2mqLG3ZJuw_1741082203
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5495ce84b41so1498570e87.1
        for <linux-raid@vger.kernel.org>; Tue, 04 Mar 2025 01:56:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741082202; x=1741687002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=geZSsmVhY58PkFnIyc+H7q80Fr8l2scSMWEn4NHrcmo=;
        b=ftRhs5uqaCvoTSrC7fgtxPgT3/Ong/iluImlb+nYeQrFb9Gb2NMGDZt4BT0+WIZ195
         JoQ9nzP9G8JXS3BC1b24JY+8o6WBtQw2JY1GviczMk8i/FxZIOLT95K2jFh+jdhARYNC
         MbbiJ9nK5DRC25u8LInYUMuN2/0EcCB0c77LWOJIZdLjwr3bAbe4ZmmxcGRCXtVUkN+e
         nASc4f+onjHDQQ0QQLRgPw2hmerNgaI3aGOhT5rcUYoOCTeA9yFTicdzxRZX3G5R9t8N
         L7v6jsas1cHSXh/ARVYzGpchDMjBShM0otN/cFdeN6fs8aTAAqWbedid4Mt5JuYaeRgA
         KoVQ==
X-Gm-Message-State: AOJu0YxBguVBouzLRMSGTS/OGGKI+ndwiFA0zAqa9CxJ+Gtqpw7uaKDw
	zPAKX3bvMPuodkhY3IkUy/HNnkpSNhG1zeI7PivxYaXYeyXNkg9u4LTeZc6G8yptZOzBYsc/y2X
	yDDZ43qyPbNQTpX+sj+C9y0lgMWG7L4oh18gus3uV8mU2A5ffm3FPnmpZV/W7fG9JsCddUPGUMv
	6CuUyx9zpBcz7GMBbtZgjdf6thQQRc9IrQDGs92MY+UHhs
X-Gm-Gg: ASbGncsQPVQH/ighijt6kX2fSgYEvZD0vFDrKujAavLaglgZXKfJiHko9HF58dOeYLy
	6EpJsMLZTp9CyyFz1LqO7v/gPk/NaFHugJ8DQaXTMN64sJF4fmea2PVpYYSBb9hV99/6gK03z5Q
	==
X-Received: by 2002:a05:6512:281d:b0:545:2eea:9f52 with SMTP id 2adb3069b0e04-5494c107d7bmr5700335e87.1.1741082202522;
        Tue, 04 Mar 2025 01:56:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGNN6JwrwyzVXv6BKLxmxdt995l9bdIF4upUPZtwMRwSryMSJJhZpjs5E/c1f/ApgO1dTxwFvXct4Y+LGQJbp8=
X-Received: by 2002:a05:6512:281d:b0:545:2eea:9f52 with SMTP id
 2adb3069b0e04-5494c107d7bmr5700329e87.1.1741082202123; Tue, 04 Mar 2025
 01:56:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250304090950.18337-1-xni@redhat.com>
In-Reply-To: <20250304090950.18337-1-xni@redhat.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 4 Mar 2025 17:56:30 +0800
X-Gm-Features: AQ5f1JpjTDvlQSCxhPuk35Jrrr8z4pqt62Xfr5WVdcrs_I0xD39r84B21ar8XA0
Message-ID: <CALTww2-kFmb9_WHGhePMAFVb4HpNEzwJ6bp69sSym2kvZF5U9Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] md/raid10: Don't print warn calltrace for discard
 with REQ_NOWAIT
To: linux-raid@vger.kernel.org
Cc: yukuai1@huaweicloud.com, song@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please ignore this patch. It should use wait_barrier first before
returning the discard request with REQ_NOWATI to the upper layer.

Regards
Xiao

On Tue, Mar 4, 2025 at 5:10=E2=80=AFPM Xiao Ni <xni@redhat.com> wrote:
>
> There is no need to print warn call trace. And it also can confuse
> qe and mark test case failure.
>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  drivers/md/raid10.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 15b9ae5bf84d..0441691130c7 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1631,7 +1631,7 @@ static int raid10_handle_discard(struct mddev *mdde=
v, struct bio *bio)
>         if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
>                 return -EAGAIN;
>
> -       if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT)) {
> +       if (bio->bi_opf & REQ_NOWAIT) {
>                 bio_wouldblock_error(bio);
>                 return 0;
>         }
> --
> 2.32.0 (Apple Git-132)
>
>

