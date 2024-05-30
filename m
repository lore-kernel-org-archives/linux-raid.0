Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999B81B947
	for <linux-raid@vger.kernel.org>; Thu, 30 May 2024 03:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717040837; cv=none; b=frjbqi5rDnDoQzX/iMOJs2aYC0aW+UrKz2osG/yrxuW5OMU8W6igxSKSSmKKd98eWVsVeg7nu84N+4un8tIvb3rb7g9vzqVfZNiCbgoSbS8YI/X5drmQrhx8NtZ1fCDy/DJ2HqLr2s1iKDYX+KKPySQQcDa3VyQaSqs8lyhe7Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717040837; c=relaxed/simple;
	bh=wZIsSRd0ls6pYqONOBOO1TauX4Ow/TSfhidTY/Lptow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=swjRCWmNk4OZdSzYwUb5ov2q2bqSK9MD66r8EYJRB/s6QJXiJuqTr4XBRbsROIzCtynzPf1aZ4eDkwBRqCGl+XA1uHI8Sw5mI5QiDHv6W+Xg4Lf+ksMnlOdyywyxVarRSdmA4N7iINXj626fprtcWpfez/uKHa41g79/YydaEf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ERriaKRh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ERriaKRh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717040834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZIsSRd0ls6pYqONOBOO1TauX4Ow/TSfhidTY/Lptow=;
	b=ERriaKRhiGhIDZ3TA/4AhyBggGAQvBgpOC2PG+o1BqDTinB89ZqF/JQIrxobDw2pIvSROe
	04dpMQ7aiSPngkUuiq9ZttWboGT4GR8NK+LuHqFc/vTX02PswucVv7xBBYmIcNSbZn31iA
	RggSMsS6b9vWx5SAi64TVyLIDoJ66t8=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202-03NGdAUnOkuDbXYZsUa8Rw-1; Wed, 29 May 2024 23:46:31 -0400
X-MC-Unique: 03NGdAUnOkuDbXYZsUa8Rw-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-70234548ae7so100304b3a.3
        for <linux-raid@vger.kernel.org>; Wed, 29 May 2024 20:46:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717040789; x=1717645589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wZIsSRd0ls6pYqONOBOO1TauX4Ow/TSfhidTY/Lptow=;
        b=fobT1KQKLFl+msQuBSusO55J/+sBgiUNv2zk0YNNLrBZwvjXVJ3G0uhGR3ci8Wl+8D
         LeKsuPJ5PNr/vrQ4MZXyvc7+3Uiq11dspjzpBC7AxWip8kQNsq8VKA+vnldJSc5gIFSN
         OXNcYr7YpI5Ex3zrQaI1+4gsLSvs5JEzHk9OcfSfPhDIw6Y81dJOAn6LWWTl0Hoc35qr
         Hnv+9vV4Rf+ssi1BJV3OI6FN/f7impB0drZWV5lpmjORA1rvj7u0VogbkrME+GAJRRHf
         ogzCKF/n2O5A3vDdBOTCfWYK3E8XmM3IhVzOy92ss+iw/uBtqr1L+IVx1F61ZI8P1LSQ
         wFMQ==
X-Gm-Message-State: AOJu0Yz6fHpDGutgP9GQ5vXCdFfp/BzQWYT2yTcuh0h8VwvhRvW128eS
	zMtRNv5qaE2IwXRvhY6S6qvdvHb3BuDASydCt/jyqdQQYzO0+XNq6wPs1Qdl2mloCGr4hcNLL35
	4M7JIy2TSTEdtK9DSXl8m3NYd7jZnrfQRkB4HHTkkpyTxCuQmDaTOmggMWojAj59gMUII40BDuX
	EUI0BUS1dM7rQrYm59gM2pTRQPcqkQiZSLvPNXpWUmkNdiuhw=
X-Received: by 2002:a05:6a21:7892:b0:1af:cbd3:ab48 with SMTP id adf61e73a8af0-1b26452bcb9mr1071328637.3.1717040789657;
        Wed, 29 May 2024 20:46:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCq8a0lJESL97+oP27+TBsyHfUlhsjMCrBVxVVvu74Wz55aZ033LEVDKF3ydxQN3fTVR0LMsJkpvVYof53zY0=
X-Received: by 2002:a05:6a21:7892:b0:1af:cbd3:ab48 with SMTP id
 adf61e73a8af0-1b26452bcb9mr1071309637.3.1717040789177; Wed, 29 May 2024
 20:46:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALTww28qp4d=mvdXvLqHPTrt0FAJihdMOQMrAyL44urstSdznQ@mail.gmail.com>
 <25ea3a8d-6331-476c-8fb4-8932185b3113@deltatee.com> <CALTww2-Rm=ORd0QtuWru6qz8VaTY3D-EnjJVQ48uf8gPTSG6Uw@mail.gmail.com>
 <5c0a5fdc-a86c-424d-9f8e-ee881baf82be@deltatee.com> <CALTww2_WnuQkMH4KeSvJNMJiiQtbP6NNA4SNt2BJPNriHcHZfQ@mail.gmail.com>
 <4213b8bf-2907-48ac-b65a-6cb7b12f7a8b@deltatee.com>
In-Reply-To: <4213b8bf-2907-48ac-b65a-6cb7b12f7a8b@deltatee.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 30 May 2024 11:46:17 +0800
Message-ID: <CALTww28sTLSiGinQEmv2POYcxa9KAHA=7+72Ktv_-HuTUir7Dg@mail.gmail.com>
Subject: Re: mdadm/Create wait_for_zero_forks is stuck
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 4:54=E2=80=AFAM Logan Gunthorpe <logang@deltatee.co=
m> wrote:
>
> Hi Xaio,
>
> Sorry it took so long but I had a chance to dig into the bug today. It's
> not what I had originally thought, but I do have a solution.
>
> Turns out the problem is that multiple SIGCHLD signals can be coalesced
> into one signal if they happen at the same time between reads to the
> signalfd. This is just the way Linux works and I didn't account for it
> in the code.
>
> To fix this we, need to wait for multiple potential children being
> completed after every SIGCHLD is received.
>
> I've made two patches which you can get from:
>
> https://github.com/lsgunth/mdadm/commits/write_zeros_sigbug/
>
> I tested it with several hundred runs of your test script and it seems
> to fix the problem. Please review and test for yourself.

Hi Logan

Thanks very much. I've tested more than 1000 times and it doesn't stuck any=
more.

>
> On 2024-05-22 20:05, Xiao Ni wrote:
> > I did a test in a simple c program.
>
> I made a similar test program to try it out and I think the reason it
> wasn't working for you was due to the coalescing and simply blocking
> solves the (now only theoretical) race at startup. Once the coalescing
> problem is fixed we still need to move the block earlier to fix the
> race. I've attached the code for that program if you want to try it out.

It's the same resolution in the patches :)
I tried in my c program and it worked well too. It's the coalescing
problem. And yes, we need to block signal earlier (patch2). But for
patch01, I still like the wstatus name rather than wst.
>
> Thanks for finding and triaging the bug!
>
> Logan

Best Regards
Xiao

