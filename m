Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73703274B48
	for <linux-raid@vger.kernel.org>; Thu, 15 Jan 2026 02:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768444182; cv=none; b=a0FkaFGDQ6M65+QWm0IFs7njiPLPIOCPnNRFsXZEeJWj55GKtr7kPik2Q96IWAvP2sXf6zlICPgF1HBgmLtG14YUdGQaLsCMsv5DgoWHHqOq7fV9s8VST4x7xMoKBFi/HjaD/uww3n+gzEMSFaA4I1+W1gc8bo1gNvhu9XPbDVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768444182; c=relaxed/simple;
	bh=8NhV18A96zePzWXPb/KjkMKUCyIsztVCndu8HxJJcrA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lQh658kjcu5D3h9079f5mjQHHcNPy0f2jeQpUrVDN5U2jNlymrkLh73hm2oxSzJ842OIBA8FjW1UuSx317ajQR4OSBqQFoBJNZE+cw9snkSsvlr4JUYKctrl11IfUn5zj8VSBVhiTCW3/QKEErdWBvNQ4HrEmuRQDQInanjisQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LG2u/eah; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aAyIruHO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LG2u/eah";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aAyIruHO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768444180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ar1wdXSEijPAm0jelWZ9LsayhIeRp1UgsityRqB8QgI=;
	b=LG2u/eah+CuZZY31qjJwsiwHu3ZJAkBf4W7I6/7cyzdFkcY15axydWHslCorFNmmpPETz7
	ZlQWNYLrigU8urHRWtTnPa/4WdFXchWGb0F7rLoOXw22nYiDdAbgHjx0ZDgmB4hMT4A8wG
	z7RiQ1G33pxxKkwuUUi4K2R9bA5ahO0=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-72wGVp1jMnypRbetTnDCJw-1; Wed, 14 Jan 2026 21:29:38 -0500
X-MC-Unique: 72wGVp1jMnypRbetTnDCJw-1
X-Mimecast-MFC-AGG-ID: 72wGVp1jMnypRbetTnDCJw_1768444177
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-59b7e9f0af5so307523e87.2
        for <linux-raid@vger.kernel.org>; Wed, 14 Jan 2026 18:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768444177; x=1769048977; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ar1wdXSEijPAm0jelWZ9LsayhIeRp1UgsityRqB8QgI=;
        b=aAyIruHOLCT4VI9BPOVKke1lE9z8pf5m44r5I5zVcSPn3g1tJa+gO7aqKKHyILK36h
         McS+fjeOmDAdCqbHR7F5B/pA4uyaQcGymO6Y6J4Ppx0xQJyPbsvLnKbBOQuF+q+BBCwP
         SGyDIYYurSKBF1mEKGk+Few9ywOlbgC7Bfd65lrWcSdXmV1gUE+iR/VkSr+PNbt1mSBr
         fX0Yz+4S1W5KXSbBbVGAtaDobrexkd6v9/t1b8W1dcyLtka2NGHwWq2wylF0MeKYkIXm
         UOlmI/Fu3y2Dlk7wYK2Xwc8YsYjNU6hVV6RoticH0w53vUJms4H5WuFEqa8vbGTdf2eF
         CsDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768444177; x=1769048977;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ar1wdXSEijPAm0jelWZ9LsayhIeRp1UgsityRqB8QgI=;
        b=CvcLNJ3LftIrqdRQjnslhFIwHjRH2Ivvanxvv/AZB/yWMdjFLgGOKfwn7UNsSWFh2Y
         eNStrXdxtXe1nAi9CpWPIBtf5VADh/5UDuhMm/vDnysbjZXGEZmdnpW7P5MdJ53CUiCv
         PxdcZIceQvnLJ2UNJrWbkUCrbno6dCKsSwBL9PIN9P0LlRXCayp6nePoVUdjqExZdCJy
         0jpVWORfsLAW3fr1O+6tI0PDz4s/FQIt0Ecl47ikpL58ug0aTiWvW5zKlcu6SeHEbIx9
         Y1F9eklDmSXo8I+vf36CqrXC1rVPSWG0fc0BPczSPe6dqZ1+Ai2Xpn8kvi9XexsTXgZR
         XOuQ==
X-Gm-Message-State: AOJu0YxhPGn1C6Mi91MFvaUPNYLZLkYP8dlaOKDgMuEXjOsreHPhsPss
	1ybLyw9idyTOaPSztW777dmF68sl8dtF2sckvesQk4L18nBcte52mKtXujoBiPkDIzVknvRfVue
	DkEbI4S+EnGwImQK7M2cbU6P9IFt7yl74hoby05FiuAlxsUKfq5czXs3R9cKmVzt00yAfTs+M5G
	jIOZicesrnQRRebQydxVrJvKvhWWMVlaXA/7UPmA==
X-Gm-Gg: AY/fxX4HdrQCJ0H5NQVi8Sdfb7GikzKGjfdrx3u4XI2bXmfUjLy7fQ1GuhnZk5OsjAl
	7BPbIQ4gHj+FyscKKMz+bVdpPWefiimjUAUEAkOgQ8i5ffF4bvxuF22q09D2Otw+X6LQBMPH2c7
	zUCpgRf6qpERBk7Y/zsoU7W6GrBjts6McTdTHek8acMesmgnwWiLvoVbWd5Dlddh4CfdmeCZF1m
	/1cW1jzxQZUgqpHXeoqDfSEz1lwiNyQsvt0SPXdSuWik+F6iJifMf8lwZ8Nrs1zT1CV6g==
X-Received: by 2002:a05:6512:3f12:b0:598:eed5:a218 with SMTP id 2adb3069b0e04-59ba0f5e981mr1462730e87.10.1768444177257;
        Wed, 14 Jan 2026 18:29:37 -0800 (PST)
X-Received: by 2002:a05:6512:3f12:b0:598:eed5:a218 with SMTP id
 2adb3069b0e04-59ba0f5e981mr1462724e87.10.1768444176832; Wed, 14 Jan 2026
 18:29:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260114171241.3043364-1-yukuai@fnnas.com> <20260114171241.3043364-2-yukuai@fnnas.com>
In-Reply-To: <20260114171241.3043364-2-yukuai@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 15 Jan 2026 10:29:24 +0800
X-Gm-Features: AZwV_Qhj1Hb2XQsZnsR02fyO1iQpI3UC8YpA0bbWuoJ32nonL9S4ZJTNBp-LIXU
Message-ID: <CALTww28xvhEFyHUnNVLS9YVHLQRAfmDcU2zEpb94JWoS_buPkA@mail.gmail.com>
Subject: Re: [PATCH v5 01/12] md/raid5: fix raid5_run() to return error when
 log_init() fails
To: Yu Kuai <yukuai@fnnas.com>
Cc: linux-raid@vger.kernel.org, linan122@huawei.com, dan.carpenter@linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 1:17=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Since commit f63f17350e53 ("md/raid5: use the atomic queue limit
> update APIs"), the abort path in raid5_run() returns 'ret' instead of
> -EIO. However, if log_init() fails, 'ret' is still 0 from the previous
> successful call, causing raid5_run() to return success despite the
> failure.
>
> Fix this by capturing the return value from log_init().
>
> Fixes: f63f17350e53 ("md/raid5: use the atomic queue limit update APIs")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/r/202601130531.LGfcZsa4-lkp@intel.com/
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/raid5.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index e57ce3295292..39bec4d199a1 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8055,7 +8055,8 @@ static int raid5_run(struct mddev *mddev)
>                         goto abort;
>         }
>
> -       if (log_init(conf, journal_dev, raid5_has_ppl(conf)))
> +       ret =3D log_init(conf, journal_dev, raid5_has_ppl(conf));
> +       if (ret)
>                 goto abort;
>
>         return 0;
> --
> 2.51.0
>
>

Reviewed-by: Xiao Ni <xni@redhat.com>

