Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009DF1A256A
	for <linux-raid@vger.kernel.org>; Mon, 30 Sep 2024 20:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727727772; cv=none; b=TcXfVo+tjj6VUAW69POLmErluQfFO7y7naX1LDWLieGKHv50jrZAsDV8meWfUb/Vs0yqDoZVlny/Qv6zXf1yjB97kPpz4N86FB/WlG5LSxEXEgMzMTEtrtThnyRLHxLzKxzh29xkVWKmQ6Mpv+w9Cwm1TMDS2YZVOTOIxQH7Pvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727727772; c=relaxed/simple;
	bh=kMZH+xLU9w/w+jErL7nAUzTIjTaixU+hbZdI5UMjEAs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LlAC2AAabhcN2w6TFTBSmdd97BE/znVDo6phi5RNT8hDCXKeTw7QStkijko4+hoGktZXF6QuLf3aWsP35QEYDqmJKfOTEwwHigddixR2E5PB1dC6xyoxYrscgM0Ra0jnn5wLK6w2NGljcjHUY8zypudBJgN+AAqJxWjt8xLuLc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MGpW3wqZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MGpW3wqZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727727769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SVaqJm7tLoF1HWWT2ray8rPf/j7gC0aKBR8MDdz/TH4=;
	b=MGpW3wqZraBFuul1MtMDJThpJNLdF0TQbnX4rZPU5zmFMKKuhrXqXYz+mQ3atnFypJamnv
	GP5R2l/GIVnNto8MVZzDC7Pt8dq/a8ujYXe4dKD0r1SKQO8obHcfzX8oxm6DtE9CB7US9g
	mOxJWvhTcYwASEvsbtX8Yjg1atOUR14=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-D8wrNIxQPE6e3Brafw8xiQ-1; Mon, 30 Sep 2024 16:22:48 -0400
X-MC-Unique: D8wrNIxQPE6e3Brafw8xiQ-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2fac931e7c6so12219811fa.3
        for <linux-raid@vger.kernel.org>; Mon, 30 Sep 2024 13:22:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727727767; x=1728332567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SVaqJm7tLoF1HWWT2ray8rPf/j7gC0aKBR8MDdz/TH4=;
        b=m+YvdWVqdGIj20qVKPSybdEaS+9LMwsJDbj3j3z4USRPAuys9Y66r/YMLhCOZpLNYb
         VfsiHAyDLHHWgLWnAm15lfDU7kXcu4nR59tvefRM3/zfGkPaYqd7Yws8dTaCHlpIKEu4
         fHHIdV7dzTKlkf9GgyjdEBYfowtBcoI45oMQqjG6KmnFSPXpax0PedBok0kDd2WaNOcG
         jUIFfJiKJ00LRr6WD+0UYsNWQckfl4CaeFNfMpE4IPcxnH4/cZDVoJzMQc31qaC1r8la
         gdQBKJodtmyPde21/g7X0BNKgss3u/cK5eLwPKGsxiCXlOpqRBhOjGwLiaI31Q2jcRZg
         pSEw==
X-Forwarded-Encrypted: i=1; AJvYcCUMBrwxk40XYZi1ritNAGS+697D83W8UcH41nI4xVVN9rr1lRZs8cxZtsB8yyE8s9yTy/OoqfZ3p29C@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+mLN646BoKt6+Jt1oFybJRFWRTZSdx9ijCDhVxU4HITL0cyF3
	jiOlwtqGls/m0OOFfgq6FfhMXcGEWnaN05cFfOO3Uu6XegUuXOvp/CfbVGAkeNBclppGNaO11gb
	ezKPv+Dp1V0sG3CsZmzpXoFR0Rav0ZbCHhp5g6O4HxKEFMVSRPIO9xXK7SpDjP1rKXWDH/y/ZqJ
	HLuVWJuagwvYXkLUaHBc49SCmrW7eRn2a5sw==
X-Received: by 2002:a2e:a58d:0:b0:2ef:2cdb:5055 with SMTP id 38308e7fff4ca-2f9d3e56140mr78848841fa.20.1727727766773;
        Mon, 30 Sep 2024 13:22:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOED+J7NIK671EAM5WNjgF/ITexh9huIebyGUKOqbFC6PtuFqTW3MFJhR+aLaTHS/W0tzN6SptNXddUS+y8JA=
X-Received: by 2002:a2e:a58d:0:b0:2ef:2cdb:5055 with SMTP id
 38308e7fff4ca-2f9d3e56140mr78848661fa.20.1727727766316; Mon, 30 Sep 2024
 13:22:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240930201358.2638665-1-aahringo@redhat.com> <20240930201358.2638665-12-aahringo@redhat.com>
In-Reply-To: <20240930201358.2638665-12-aahringo@redhat.com>
From: Alexander Aring <aahringo@redhat.com>
Date: Mon, 30 Sep 2024 16:22:34 -0400
Message-ID: <CAK-6q+h2-APvPUUDYgjGx2FzeJVkeAzH5Br+27A6bZyztfD5mA@mail.gmail.com>
Subject: Re: [PATCHv2 dlm/next 11/12] dlm: add nldlm net-namespace aware UAPI
To: teigland@redhat.com
Cc: gfs2@lists.linux.dev, song@kernel.org, yukuai3@huawei.com, 
	agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, gregkh@linuxfoundation.org, rafael@kernel.org, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	netdev@vger.kernel.org, vvidic@valentin-vidic.from.hr, heming.zhao@suse.com, 
	lucien.xin@gmail.com, donald.hunter@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 30, 2024 at 4:14=E2=80=AFPM Alexander Aring <aahringo@redhat.co=
m> wrote:
>
> Recent patches introduced support to separate DLM lockspaces on a per
> net-namespace basis. Currently the file based configfs mechanism is used
> to configure parts of DLM. Due the lack of namespace awareness (and it's
> probably complicated to add support for this) in configfs we introduce a
> socket based UAPI using "netlink". As the DLM subsystem offers now a
> config layer it can simultaneously being used with configfs, just that
> nldlm is net-namespace aware.
>
> Most of the current configfs functionality that is necessary to
> configure DLM is being adapted for now. The nldlm netlink interface
> offers also a multicast group for lockspace events NLDLM_MCGRP_EVENT.
> This event group can be used as alternative to the already existing udev
> event behaviour just it only contains DLM related subsystem events.
>
> Attributes e.g. nodeid, port, IP addresses are expected from the user
> space to fill those numbers as they appear on the wire. In case of DLM
> fields it is using little endian byte order.
>
> The dumps are being designed to scale in future with high numbers of
> members in a lockspace. E.g. dump members require an unique lockspace
> identifier (currently only the name) and nldlm is using a netlink dump
> behaviour to be prepared if all entries may not fit into one netlink
> message.
>
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
>  Documentation/netlink/specs/nldlm.yaml |  438 ++++++++
>  fs/dlm/Makefile                        |    2 +
>  fs/dlm/config.c                        |   20 +-
>  fs/dlm/dlm_internal.h                  |    4 +
>  fs/dlm/lockspace.c                     |   13 +-
>  fs/dlm/netlink2.c                      | 1330 ++++++++++++++++++++++++

and this file shouldn't be there anymore. Will be dropped in v3.

- Alex

