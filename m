Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937AC32C33E
	for <linux-raid@vger.kernel.org>; Tue,  4 Nov 2025 14:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762265450; cv=none; b=jWU02ilyOZ+aGtOqACpXRb7iYoVoOZ87BjEoji2sDGxbT7kFWFL+uKW9Fm2ZkVn4r2fapXE0OF7NpVpZuunJSZQnlM/Pwo5RFiLsvxKoxIEMnXtE6aoyUnKfa4XN85w/Yb8VKh27GtedsdC/ILwm7ADZ1ZLsd9MkAMlnhVUS5+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762265450; c=relaxed/simple;
	bh=kOQJzZDZyFM5wXYEgd/w8vVqM/Mg2pMo5lBxbRB6cEQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=llGuRtDqzb8kZRqmpZzCWqHEh70EExKnq8Rv9tgNs5O8yV1+1wNQwVLhMhCcbLJsI5JDsWH6GVaNwG+TOD1KG+75biiChYkDrKQY0lgCVnfYXYuyZj9YVbEiBxU670gmBFElYj0KfvhxBimhqo/uyYGvATdK2DWTz5Dw/BHilcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I25g7Exs; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=CHhaG2wB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I25g7Exs";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="CHhaG2wB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762265447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kOQJzZDZyFM5wXYEgd/w8vVqM/Mg2pMo5lBxbRB6cEQ=;
	b=I25g7Exs711MVNroBMFm4Lqh68EASfnC/V28ya7jfqEtMT15z09+fU1rzsPHsg7aQADuWa
	x1WCcuC7wt4+BH00Un7onYyLruYuSFGO2E4VJFkd+1Hfb+6xzfpn78ne9IHYjL2FeudsM3
	IrR9abuVzl1DIpRxrlENqhB+ATGLb/U=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-wDsEGKLLM_K7HVyTrFL3Fw-1; Tue, 04 Nov 2025 09:10:43 -0500
X-MC-Unique: wDsEGKLLM_K7HVyTrFL3Fw-1
X-Mimecast-MFC-AGG-ID: wDsEGKLLM_K7HVyTrFL3Fw_1762265442
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-592f6f0a15eso3431372e87.2
        for <linux-raid@vger.kernel.org>; Tue, 04 Nov 2025 06:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762265442; x=1762870242; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kOQJzZDZyFM5wXYEgd/w8vVqM/Mg2pMo5lBxbRB6cEQ=;
        b=CHhaG2wBxdHf4kIVaSTXnyEy8ecuajD9N/vcTH0vzw5/19OioXZsq8/G0eCNungxfQ
         J8mDcl7e8hU8b5QAFOi1GaXOb2ufI7JNavGbmOMy/D/ZPOoog5m5E0p3qhoTVnjKIvGs
         xbs0U1WUXt60yPVzav9slTlJNCoQxI6I1dz7DrFQUgsE1uUjfReO4vTQE+EBNBeutB11
         bI4mkg2fxVcs6ktzJUKiGwCjA/ouRWfCuTm4GGcn8+LazjvaIZt1buz3rqtwu2PjPqla
         andPG3oULxxXcqZ6RsRaYjqhHusctJyoQ3WCLcendbD4fyKqrehdyl8CXvbG+d/vtXEZ
         VumQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762265442; x=1762870242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kOQJzZDZyFM5wXYEgd/w8vVqM/Mg2pMo5lBxbRB6cEQ=;
        b=bF2hJ467ohBJIvY/6zqXdJCFgSiSYOnWpMcjntrumsg4SepWyiLOk/spoDxAGxP2lh
         wWBO9nOl2g5pF5vK1PCxirBySaL2k2R/Ft/pzWkUPVYD0B79+larGSuX+nJf/jE8PlII
         T5bq3iNy3lwcG+d9W6z/eA1GLA8txONc4wBzvigRb+ceWRvu7s1VWf0qDS8YebnnIMCp
         ziY3+v/zoRCXSEWYQJWkmHFSvAEAK087QJq8RZohbGKmk4zXVVcwWdubfJGD6x+dw8ov
         jYpHM6E+iK4bV9NVuoXawhaDDmFJytDVQr436sKyk0HRHO2sLaAs9bvZo9TN3J6YxNYP
         ofLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtAZpQk/oJporJy/CQddomBPjk4aNQvgDeYw9g9oRm9jFsJavlRBQtrmZHz7SaIM4mPEtYQzER+Okz@vger.kernel.org
X-Gm-Message-State: AOJu0YzA05K8Wsv8ldfwf574g73j/5bbxkjNfpHamUj3zUdogT4ImvP7
	LvJyVvgxMtc9nekls3fvy8maMzLgxU1BAvdOh8d+HWpPMhxssFW0bm7q0NKdV6Vc1GGjGkMoBDE
	xzqmfY9IHqQca1Io8lwgiqWko2VYwJ3C40L8ysaRDjJwfYTPOBY1i1uouVVDX8aUHgPjsUF7S2m
	eDwFupmHkV0E43lENENZVqssve8FPsGixRnO1PDA==
X-Gm-Gg: ASbGnctm4p9lCHjnBbeEfUyZcBahXT00/xNIUizj841OwMta4I8jvJ+Iy/MYDJS33Og
	mlmLko0XBmOsRax3hacYcJLtA0a5ipTzubTJS6P8wzcD43wMHw05TqO/qlbGJZ6dhw3EO5JCpU5
	Xdh2SjZztlOw+70V3yH++hzuoAyOhLVod31Cbm3Xjlf8fYZTWFXwE0rHNy
X-Received: by 2002:a05:6512:3c92:b0:592:f521:2334 with SMTP id 2adb3069b0e04-5941d4eedeemr5207470e87.8.1762265442045;
        Tue, 04 Nov 2025 06:10:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEzd+AgX+SxHX8XNy+La2tKTXleZsFzvFKS92bHfkJwYH86llClCOpV77Ngrt3fnpXownJ+KIcUGAdGx6MLF6Y=
X-Received: by 2002:a05:6512:3c92:b0:592:f521:2334 with SMTP id
 2adb3069b0e04-5941d4eedeemr5207456e87.8.1762265441570; Tue, 04 Nov 2025
 06:10:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALTww29GVOw3sk2=A_9dj5QMGtfogRjxRsunc1D74AqLFj_MyA@mail.gmail.com>
 <20251104093449.1795371-1-hehuiwen@kylinos.cn>
In-Reply-To: <20251104093449.1795371-1-hehuiwen@kylinos.cn>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 4 Nov 2025 22:10:28 +0800
X-Gm-Features: AWmQ_blglH4aG1yLsUXdEGUiksyid_PC2Ymu6c71UlD9PofH0MnqLRl0YVyins0
Message-ID: <CALTww2-f=tUM=3PD564gNNfTs=4dPGH5mhmY1c90DZ0kT0PnwQ@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: remove redundant __GFP_NOWARN
To: Huiwen He <hehuiwen@kylinos.cn>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org, 
	yukuai3@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 4, 2025 at 5:35=E2=80=AFPM Huiwen He <hehuiwen@kylinos.cn> wrot=
e:
>
> Hi Xiao Ni,
>
> Thank you for your review and feedback.
>
> The reason for removing `__GFP_NOWARN` in `r5l_init_log()` is that
> it is already implied by `GFP_NOWAIT`. However, I noticed that
> `__GFP_NOWARN` is used independently in `raid5.c`, so removing it
> there maybe incorrect.
>
> Best regards,
> Huiwen He
>

I c, thanks for pointing that out.

Regards
Xiao

