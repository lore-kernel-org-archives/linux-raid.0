Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BEC28DF5C
	for <linux-raid@vger.kernel.org>; Fri,  9 May 2025 10:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746786042; cv=none; b=H9SVzxZ0aaH7oX5bQKMc7/nmRq0umLwVE2k4CngAxvZv85mzv0bUVp3Q/uoUrftaGLgJozAEm4PB05TrhKqcGH9qSjzl5pkC5QDSIFDLogQvylbCaDutIm9JTDXN962aXpKpK/g0lz7xalESptsa4ZFQkPiGv5k8r+Uik8cHm8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746786042; c=relaxed/simple;
	bh=Q92m6DUFEnjYNO4SOAUH9lRF/jQmaJFqkclilbiOBFA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s8Gh90JutUXrDhW6gpht417ZIk1BXhPcg6+uHvk2dULB2MC/bpiLEAkU86l29xqBUQlr5+ZkX8nwkATWhHVYeX/SLmgY04mpXDWcgdUYMKGhHcbavyUkr/CbrvM0Fu2lKXi8fTpKBUZesQRwv3VdxlWWzCGTmoKrzlFkHqkN0Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PFxCwhE+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PFxCwhE+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746786040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q92m6DUFEnjYNO4SOAUH9lRF/jQmaJFqkclilbiOBFA=;
	b=PFxCwhE+eJBSAkMIutQ6qJk9WNnsL+FEEUAl/CR6E0OmcaMbP4GI+rv9iWQnCUFSD+zQxf
	z11gSbLffm6RzGIU94r05tyXQwZT2i48/ZoUtB1iXKdSPmk9KU9cFYOQrI042hvAfQE+WS
	OoNODe8HadP4BvjDafnRfenq1l9ZYxI=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-qSIvZfTKNzCelviXhi3uAQ-1; Fri, 09 May 2025 06:20:39 -0400
X-MC-Unique: qSIvZfTKNzCelviXhi3uAQ-1
X-Mimecast-MFC-AGG-ID: qSIvZfTKNzCelviXhi3uAQ_1746786038
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-3120e91a251so9882411fa.1
        for <linux-raid@vger.kernel.org>; Fri, 09 May 2025 03:20:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746786037; x=1747390837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q92m6DUFEnjYNO4SOAUH9lRF/jQmaJFqkclilbiOBFA=;
        b=O9SHRYEb42kPxzVI+M2MyNL2kvH6mO5lt/8rAKqVA2Q/2uxE/ENPOmLYJLpfvm+BW2
         fDBybBaG4z70trN5U9uDzKCqVwKn/thQIdECRNVlbmToCoeI+Ps7IA+fxhssQUUZV8g5
         8nwi6VSdQuQNmXtPOvJLqth2UOecv9VnblVn/uNvOZ1sA5a99Pkdu0g7zGNu7Pce1U47
         kXVJiIFN7hTM0OM9MBtHX2btUI7kMbcGUkQs7CuGRfbIRnPEhqbW5VQGSAAfP/Cn2vcW
         38Uv0B7v5eACt8LObgSasc6gYoOXSSBuoBimRgDI6U2X5HXyuw6co277+UtSAU5A7Iad
         QT0w==
X-Gm-Message-State: AOJu0Yw8ahv3cmmIyvMoFZVd0jY1Qm7xNgreMZpGJY8Gx/Uyb2PuRkpF
	/6Gm/+6a395BZSYvRnU6hGluVJJ5PWtF0/cFHIGd5HxoZxG5wIKqzp4xSSAlHhhVSM7uyoMyf+O
	JBZLL9p/A+UrTMBg0J9gl0XO7++kOxKDVWgiq0GwiiH/Cr2NDKbnchKnTunwC9UDkX6nTUDXh5U
	ll1FEhn3J3YYBVSVJuY4UEzzvjGBn2I8MgAA==
X-Gm-Gg: ASbGncspnJ+6HM1NItkQPPh/P/JxOxLx8V8W69qZ9HdiMupy28BKUAXzcHvhrT+U0/r
	RTQX6PlIkqClCrbi6Lk9rMY0EceJa4hinGqPyYYonYqUoX3QbVf1RzQ3WKVkYGuxbkoZ9Ow==
X-Received: by 2002:a05:651c:3226:b0:300:3307:389d with SMTP id 38308e7fff4ca-326c45a984amr11544891fa.19.1746786037462;
        Fri, 09 May 2025 03:20:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9mmUB0UxqYZKNsawxdJdlr9scIxU4+q4w9Z2m/13Qj6hIZJu01hIIte1SOjuNdpWZV9mq/7XTLQ/BCIqy36Y=
X-Received: by 2002:a05:651c:3226:b0:300:3307:389d with SMTP id
 38308e7fff4ca-326c45a984amr11544721fa.19.1746786037047; Fri, 09 May 2025
 03:20:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250507021415.14874-1-xni@redhat.com> <20250507021415.14874-3-xni@redhat.com>
 <09d3eb78-d2c9-5c04-bec5-5aae4a19cf83@huaweicloud.com> <CALTww29siTuVSpCOJB7j47DxWFMcZV9RHkX=VfdxU0OyA4TsFg@mail.gmail.com>
 <c994b86c-cd40-1778-81d4-fdb3066053ef@huaweicloud.com>
In-Reply-To: <c994b86c-cd40-1778-81d4-fdb3066053ef@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 9 May 2025 18:20:24 +0800
X-Gm-Features: AX0GCFuZWupPIalCCq3ETTS1DB12thFEne2C9OnUOXNs2V18u1RWpw1HxaDneYk
Message-ID: <CALTww28OBZZYdD_fJdFjmsjo51cn7CvVrKe=yserF+xvMd5f0A@mail.gmail.com>
Subject: Re: [PATCH 2/3] md: replace MD_DELETED with MD_CLOSING
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org, ncroxon@redhat.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 9, 2025 at 6:08=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2025/05/09 17:33, Xiao Ni =E5=86=99=E9=81=93:
> > The two places clear MD_CLOSING rather than setting MD_CLOSING.
> > MD_CLOSING is set when we really want to stop the array (STOP_ARRAY
> > cmd and clear>array_state_store). So the two places clear MD_CLOSING
> > for other situations which look good to me.
>
> No, MD_CLOSING can be set first in the two cases, do something and then
> be cleared, that's why I said temporarily.

So you mean mddev_get should pass in this case (between setting
MD_CLOSING and clearing MD_CLOSING)? It doesn't allow get mddev now
without this patch. This should be right.

Regardes
Xiao

>
> Thanks,
> Kuai
>

