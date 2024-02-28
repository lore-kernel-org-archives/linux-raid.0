Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E07673515
	for <linux-raid@vger.kernel.org>; Wed, 28 Feb 2024 12:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709125053; cv=none; b=H2rzkDoZlpOqDMAHKIBI6NLZZHEcnvp0lCgafxOfAy/IGqzzV4EZRAht78TBvMgQBLjDQBPjeeQ/G5im2jysKkTM8pG8qt4LuDUf4wbZ8Tzjt/p9qGuNDnuZKKgZ8eZcJvx1DwQ64G6x6eS6vEzVivz+K5b+Yhg2yvVEoE6VhFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709125053; c=relaxed/simple;
	bh=aRQu0O94B8WlLNlFmFrl3z9Zt2G7Kv2dqaDlpP4+6Bo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ndMbdCGVpDm5q81Dwq8tQT8rF+sDIap0HnOm+Zs/BNsTyKnBdKA7zDlcjcw5veAIXJCVkp4Joa4E96bjnP2HfothNHHcEfpW4K/jFI1hDgpa/ZG81vZBhZDbyX9SR49zFOGiSeGJUx5COg4aZ9iCxW/z7HKI275Pf7+ri5btKkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bKZgXW5V; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bKZgXW5V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709125051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+KvWJOwrGwY/l3wFHjX1h2nSrO3dCw0bb3kRO4rQX5E=;
	b=bKZgXW5V2GOyGpqjtoIRpw/yD1MqvFHTDOyH76awmmkmY9pMm03o4+xj+StV6iiQFkTUsd
	YQolCGLh5YURJu/EWkoJB65yH9CeeynWwN1C2d1ogiTkqqNOTUtUrXcg2EQ0b1X5V3XZHW
	KWAV9DmbVaYwClPSjQYTyqttzec4DH4=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-QTjtPrcpPpKD0UdhwNztiw-1; Wed, 28 Feb 2024 07:57:29 -0500
X-MC-Unique: QTjtPrcpPpKD0UdhwNztiw-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3c18df0db21so9042571b6e.3
        for <linux-raid@vger.kernel.org>; Wed, 28 Feb 2024 04:57:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709125049; x=1709729849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+KvWJOwrGwY/l3wFHjX1h2nSrO3dCw0bb3kRO4rQX5E=;
        b=axzRkZbIm4OvXRcMzef2jtJuOlxJfZ6gD4NghXhasTHEbXA1Xq2rF2J3hV1I3LCzm/
         TQCJySAMCwdVnEFmAUiExQIbJBOQRBBiWmR2ZJXeHgmW/+0ZPQnGdv9mpap7lcq3APgX
         HR5rVDWZwNLhwIUr2WbZBNsxxop5BiH9RH3X6SaKpDfdcBbxxruismr8sXFTXyV755yq
         UxR3Q9QYkU9K0d23pdRugOJakP+49WQwbWYMrYr98Fi4WdmH5Tta2JaxYZ2++HnRBr95
         rmI7z1eEE1RyojoOCumoJ1ap0QQlws20dLH1MnLcE2nqhOhHml857LDGqxAXtSnpO5ql
         /CIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbZ077p4oWY9RDGmQPaVDbXYsWIfKFmCEk43Eeln88LqMcpjaNeSz1i9o2mDp/je+7FhEyGm38yZq/zBqyuHTu2RcsWKwJN5mBQQ==
X-Gm-Message-State: AOJu0Yy509qpW/vPoNz3qvJuqKuiWoBkXYMYNYtVVMp+A3JaM40aY+qu
	p4/qJC3ejtPRzy0r9KM10N6pZakNVI3iaj+djq0dDAWTAAPKJqPzMTElAwtwG8F9VoBpfZ46avb
	cR+5z+gGODtLgw6r4v9JpWzU70m63YsJfrvB6A8LllZjLKJqknPncM3qK0sUz2PShPpQPjctAvO
	eBheVjqsAtK9F+RR0IIVWJNC8BwN/lEqO0Kg==
X-Received: by 2002:a05:6358:9226:b0:179:ff:2486 with SMTP id d38-20020a056358922600b0017900ff2486mr16401029rwb.29.1709125048895;
        Wed, 28 Feb 2024 04:57:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHeeS0ikgf4yqHsAJ/HQO06vAA7zJpcNmKqX0+hjaYOSr4+cDMEL+uZzsSUC4oElIAfogBFzrTOJJbscktJ8dA=
X-Received: by 2002:a05:6358:9226:b0:179:ff:2486 with SMTP id
 d38-20020a056358922600b0017900ff2486mr16401001rwb.29.1709125048659; Wed, 28
 Feb 2024 04:57:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240201092559.910982-1-yukuai1@huaweicloud.com>
 <20240201092559.910982-5-yukuai1@huaweicloud.com> <d233fc29-e3ab-4761-9368-c203efc0466e@redhat.com>
 <40ac6914-7c1f-00b7-f480-25c9786482fc@huaweicloud.com>
In-Reply-To: <40ac6914-7c1f-00b7-f480-25c9786482fc@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 28 Feb 2024 20:57:16 +0800
Message-ID: <CALTww29JwP+_1vfiodjy3YCze9pQ92JRGhCNVygLpm3k0gVJAA@mail.gmail.com>
Subject: Re: [PATCH v5 04/14] md: don't register sync_thread for reshape directly
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mpatocka@redhat.com, heinzm@redhat.com, blazej.kucman@linux.intel.com, 
	agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, song@kernel.org, 
	neilb@suse.de, shli@fb.com, akpm@osdl.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 28, 2024 at 8:44=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/02/28 20:07, Xiao Ni =E5=86=99=E9=81=93:
> > I have a question here. Is it the reason sync_thread can't run
> > md_do_sync because kthread_should_stop, so it doesn't have the chance t=
o
> > set MD_RECOVERY_DONE? Why creating sync thread in md_check_recovery
> > doesn't have this problem? Could you explain more about this?
>
> raid10_run() only register sync_thread, without calling
> md_wakeup_thread() to set the bit 'THREAD_WAKEUP', md_do_sync() will not
> be executed.

I c. The user is responsible to wake up the thread. If raid10 wakes up
the thread in the right way, we don't need to move register reshape
thread to md_check_recovery, right?

>
> raid5 defines 'pers->start' hence md_start() will call
> md_wakeup_thread().
>
> md_start_sync() will always call md_wakeup_thread() hence there is no
> such problem.
>
> BTW, this patch fix the same problem as you mentioned in your other
> thread:
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 2266358d8074..54790261254d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4904,6 +4904,7 @@ static void stop_sync_thread(struct mddev *mddev,
> bool locked, bool check_seq)
>          * never happen
>          */
>         md_wakeup_thread_directly(mddev->sync_thread);
> +       md_wakeup_thread(mddev->sync_thread);
>         if (work_pending(&mddev->sync_work))
>                 flush_work(&mddev->sync_work);

The first patch of my patch set has this already. Maybe it's the
reason that my patch01 can fix this similar problem.

>
> However, I think the one to register sync_thread is responsible to wake
> it up.

Agree, the user that registers thread should wake it up. So start/stop
sync thread apis are common. And they can be called by many users.

Best Regards
Xiao
>
> Thanks,
> Kuai
>

