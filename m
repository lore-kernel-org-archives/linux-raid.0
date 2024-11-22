Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56000230999
	for <linux-raid@vger.kernel.org>; Fri, 22 Nov 2024 02:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732241848; cv=none; b=FVVnOKYPr+MZuK9dFrNxaNQcVcvgm5khPWnO/dfVfDpuwfakDTouTdpHyfGqF6oRTCkqfmBUltHnDUwJsOWsBOfUP16Y3z7YCIPgzOKdI3AS3lrB/nRu7XWI9DnB65XxaJJKIy3TtFfltJXviybxQ6zxeTm+hOkhL0mXqncZ2T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732241848; c=relaxed/simple;
	bh=ddC3zSEmscyO0nqLLSx+KJlKaxs1qJUrPHKpcJZ65AU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XIa4OoGcSLhr8vtmR+4sE5OMpqn44Ne4L0wAoJAU808+2FD+tjrBN/JMd+YnibgqqNoEIVQ+/1GHIKbz/ALs5RPxwrQycDlxlJiOKYNlgLU94sYxXbf8aiYOlIhTUQnnM4NsLdqU5egYBWcH9CS2NuCRf4YTftolDbluCc5CJZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ePWiMv1s; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ePWiMv1s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732241845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w0rwZntxeuzz614rWcmK6DkyUn4Us9C9cxRvDMcMi3g=;
	b=ePWiMv1s4vFU57DeqKRxUO56gIjsO+h9er5oZJuy2E3qfKUNtpCVa9nu2+X82M8iSEnB0b
	Lo9IrTb+A4WVsh8T+PR+KuZg0AsvbOwKNuxNy+XkBUKUPAXmTZBRlu/R2V8lzNVBhi5hfW
	fCI++U0m7sj+41oBpNl9nCKxjJ1KIiw=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-3vuiDko9OuiJBfe2PSwBZg-1; Thu, 21 Nov 2024 21:17:23 -0500
X-MC-Unique: 3vuiDko9OuiJBfe2PSwBZg-1
X-Mimecast-MFC-AGG-ID: 3vuiDko9OuiJBfe2PSwBZg
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-53dd21c67c2so361753e87.1
        for <linux-raid@vger.kernel.org>; Thu, 21 Nov 2024 18:17:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732241842; x=1732846642;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w0rwZntxeuzz614rWcmK6DkyUn4Us9C9cxRvDMcMi3g=;
        b=YeP/bm4zn0XZXFFJ1mk5EUfB1l5nMPL7yNJnFzTBORB10tpPbFwYhGeIiVGIy6kEH+
         Bf6oe2OJCA1/pySzIeV1JV2KML56kkOV0ipXHz8Hu6eN9UHJyZuac6m/XC6LBScDYpL6
         BBnU9TgovnCU2VSj4+75DjZJGBoKm0pzNGXenlu7HfSRUIgN7EgDkEU6VDN2BgrFQSXO
         cD3WJMytoCmjXOoe4xIk9R+aIgTNXVAl1xTPZ+I+1NRtI47bfxHCo6uF77dtf9nmW5RW
         V4PVIFjg1wag2qKPyNlLBEjxMzRmPptox+j2ki6V96jvPCCC8agbZlcCEQ7yERH92lHi
         Vq+g==
X-Forwarded-Encrypted: i=1; AJvYcCXCNmqP/LS/jQhDWj+Wmc3Vu8ZyaxyLr8nF2mD8gx5waoTMCjgvjMRWcyztP78jUpZjvxZ721gJkzV6@vger.kernel.org
X-Gm-Message-State: AOJu0Yy52NvH746eTOSGmWWdRgaIB2GNj/N1v69xt4igLoKg0pHikK1w
	wl/NG/7b7tQuzFwcP05ELKfbA3txs1YFYp1mWKqWeBGXisTBnWpUpsltyoL/mdKzSUYRGO9pKGD
	gpeLq85VkLaQborTUroT0Olh2T6bwDTXBxxE71+QNaorrvB4Yduxq3odLXGnSkJCIQzVnUYLlvc
	WnjGyc36StVqgzlZKoE1Dzh7XQ4QPITxfWnQ==
X-Gm-Gg: ASbGncsMkfSwdvKGn/5nwWo7jeNfImjp9wO4jYEbpi1mrJdMP9IW+kb6lW3TAumts6z
	pgdG+jeFHZgiK6U/IsehdnfHWH+NYUpx1
X-Received: by 2002:a19:9113:0:b0:53d:d3bc:cc51 with SMTP id 2adb3069b0e04-53dd3bcccacmr311779e87.22.1732241842107;
        Thu, 21 Nov 2024 18:17:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE3Q50NDgLKcxJmMeMeWWAsHe42EEfyEry/LoPGuklqIv6QJ8+gzd3lEsiWkeRlj17YVWtfXgTGCmTebqQ7cp8=
X-Received: by 2002:a19:9113:0:b0:53d:d3bc:cc51 with SMTP id
 2adb3069b0e04-53dd3bcccacmr311770e87.22.1732241841784; Thu, 21 Nov 2024
 18:17:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118114157.355749-1-yukuai1@huaweicloud.com> <20241118114157.355749-4-yukuai1@huaweicloud.com>
In-Reply-To: <20241118114157.355749-4-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 22 Nov 2024 10:17:09 +0800
Message-ID: <CALTww2_VzpF79ZEvKvAKf7itpuveNM2caqtGzeO+7_YivMe0Gg@mail.gmail.com>
Subject: Re: [PATCH md-6.13 3/5] md: add a new callback pers->bitmap_sector()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 18, 2024 at 7:44=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> This callback will be used in raid5 to convert io ranges from array to
> bitmap.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.h | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 4ba93af36126..de6dadb9a40b 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -746,6 +746,9 @@ struct md_personality
>         void *(*takeover) (struct mddev *mddev);
>         /* Changes the consistency policy of an active array. */
>         int (*change_consistency_policy)(struct mddev *mddev, const char =
*buf);
> +       /* convert io ranges from array to bitmap */
> +       void (*bitmap_sector)(struct mddev *mddev, sector_t *offset,
> +                             unsigned long *sectors);
>  };
>
>  struct md_sysfs_entry {
> --
> 2.39.2
>

Reviewed-by: Xiao Ni <xni@redhat.com>

