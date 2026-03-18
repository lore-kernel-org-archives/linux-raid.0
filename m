Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D5A375F65
	for <linux-raid@vger.kernel.org>; Wed, 18 Mar 2026 10:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773829818; cv=pass; b=atn2T8VysrfcZn9X4DpKQPkf0Ue5zf6fZpummRM/gZOnw9FxiPTYOTG6uVvRtFlS0W6Q1Vr4LpykTrERrAKsMmZsEyXNT5i7/5A7IHcb6UdhZWz4PQCvHZs8775r4eOuggCwTxHjA2ET9sWED5HNe0U6MI9xL+HNguHig+j+SRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773829818; c=relaxed/simple;
	bh=bjxrCYpAiEKVlgGB+nNbhqWNJVL8DZ5RxVqPlBiy+9g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RzHNQqqfFT42dPMsvfDnuevefKf7XD5u2Q1axB9Qev2tKKCV06DjJU2rdqnxzv8Ptkw2bbXmm792uDSHcfxpcsUMPM5Zc/oCEWlD+Ji26YFTw/SOZ9c5/g0HF4Dei5Fvx3uY/bp5bOIXSWE51DCi/OGgrNDEYNsgZlT3GFCJ+iY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GRtWcGOq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=txx9pzGy; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GRtWcGOq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="txx9pzGy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773829815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zbdxVNqvxy7NOb+OV1imE4sW3zOo7J/8dbicjSfS/YQ=;
	b=GRtWcGOq5KqPmPprdf64269r7K0PU8FS9HD4n32s3qY1WddDKUQR1u8ZflPiB1GhIfIeYU
	F+Hg8QwpWs9hNECWFJr7AkceOdCoC70vNr208ZuPMfVC7oL9czHFaIHpz9cJi+vcjfsxve
	ybm+f0qjtGul8BU4LzSP8FL7vCNLaEI=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-_o_D3by5Mg2tpdUWTfNtFQ-1; Wed, 18 Mar 2026 06:30:14 -0400
X-MC-Unique: _o_D3by5Mg2tpdUWTfNtFQ-1
X-Mimecast-MFC-AGG-ID: _o_D3by5Mg2tpdUWTfNtFQ_1773829813
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5a155efb888so3613658e87.1
        for <linux-raid@vger.kernel.org>; Wed, 18 Mar 2026 03:30:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773829813; cv=none;
        d=google.com; s=arc-20240605;
        b=Qmn/kaKZlFwZNZ0myH7zOV1lCx9QkRWSiHZkAkfVr0HQCwzM0BpqjFyPJoo6MzeGes
         tAy2IT9xCAbnwAOUyPd2gZMVIIOYOkZpZJOGPeX9cH6CO7f9pCfP71jPlG9vhAnvAVtm
         eFnw2lEfZQP2u5PtN5TIHixZz7YI7dphCVJXgJsmQNXUreLwnODIjhkiq8EHGRXjYxle
         Wcgblkkvul/MM+44baH0QFGr3VnRCjKR7GX4VwFQppwNdkHRQr0XhuGRGyMI3eSGVmM4
         wSw5br41TDaxPiYUyDC4dAMxXqPsYU4Ah4rigx4iDgRAhktXtOENg0PnT14+iUW8c/gW
         qlhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zbdxVNqvxy7NOb+OV1imE4sW3zOo7J/8dbicjSfS/YQ=;
        fh=ZjLmttaMNLGYsRNMnSP3dXkyHjXCP/T0dEi7Rlcj6O8=;
        b=ECljQxThy48UwgAMzIt1IKmJAFkdab9Yt/ZIJdO0Jx8s8CyhA/E7EvTawFltLoTmt9
         +osDpBQyJM3qmRzw61op7WJYVPY234hN1HrjsbzjW/OKB0Z+A/v5GPxMXqudJ01Lsm9B
         BDHT9Mx9Ua8GCNxj8+Ru4uXb/58b8cPjLYdsPrIp2Q32DWymRG1AIHB4tPtZqlMh1gdJ
         7SYsrjFRJ0bV+F8FfW7/wZYhUcQpdsAMu36I3n4OTbQIvDbUfZMhwmhlNw3leWYJaRL9
         8sWPe3VCE59mlBQtKFOZVwGnxBxk2qIPEPuBRiFyB3uLEosnmcrmknB5hpZxHG85t5Vc
         42SA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773829813; x=1774434613; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zbdxVNqvxy7NOb+OV1imE4sW3zOo7J/8dbicjSfS/YQ=;
        b=txx9pzGyvPAcmB4Qaw3qHUN1dfjJXlb9dOQXel4Exm+jRH0wfIczWzQuWm6SRgJxT5
         sZ/RZcxUHDo5iPAzho1er2ngAI1Hx1mxezWQP6MkXgGxsXUguPDtjJS4qvSuyKX0Ok1v
         pL54s/wpaMK6Kx7oopBSFgpKrtCB1RYy8QU37W1usgzDG5ivCNJ3qcRRhkeZkmcMBkHQ
         VsLUqksZUKUH7BafLtaxQ7jhqUxTNakfh406xpcHXeLuz6hYjgpNhVdLaUeHcHqHCZ3a
         XKXCu91I0aRwkvZGjHRrEyz6ElyL/fFrSyCLzicrclCxhM5Omj1d4AzZH11bROwnbgUh
         PHwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773829813; x=1774434613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zbdxVNqvxy7NOb+OV1imE4sW3zOo7J/8dbicjSfS/YQ=;
        b=XJ1bqYsVuqoEVyaz6ZG6sHabQPFkj0S/2fwWp0fNllxcqt1f7Xe6Y+Lg6ccEQz4P2D
         8yfrixi1hWhUCEJp1aUpNWbBvvJ4oJMybUedetJnBwE6g9CqYSKvC2Hmt8Qs9AiU291c
         PkhUJ2wzEQVMaZPr85yxrJlYxLvUZyjVg/+0ZGLe7zBBPf8ujOQrpjlPV0cWaFogwOdB
         ThE/cvGN56g8MXbZw9XIMy+j9TQkmvgoNOOWkE0+5X5YPphdSX1myOa1QGtMh/Amw1C3
         eJ1DMhiL3/kxhyJI6v6R9Bkus+o7tjAip/vFJB1aTSrazLcGlOogQudFNo2hZ9uFnrWN
         859A==
X-Gm-Message-State: AOJu0YxYi3OurU0zj6SrYGmesocHpsRKdTRWiSB5IXucHY7yn1YBuOEf
	5QiO9Hn9ik8LQNE0P76RLQRjW3DXLTMZO30IiqAB/cSYXaMNLN26Z/sbryo3Q6+6SQBllqomrhT
	MGbr58AU9aB8BQtMKKgfRCxvHEP/x4BSwdvG7UK5st2Fn7BNhzwSqZmz7173qDSs3D2KwAZJrrw
	9SLYYh76dH3V9MtGT5dQgppspUsZq5nQUVm8pgyQ==
X-Gm-Gg: ATEYQzw+fVjQKgiaGf7GJuzyO+3hsKEgC4gl4A5FLw1+EElY0uvQ3KwqYxYpWtGqXbx
	Q+XNAfvb8sJlPUde++JDlqWw5Ok1HxXdktajb62AfdWXgCw9AtCrCd+bmTb3IEHvjAXfaHdxtz+
	ai5IEKD/Xy/bP7uqH0eksUYg0UO6MS94nvwqSvtWiF6VluxEg2PCjhyoVWiebYxEFJxICisAUzU
	m1AFS9R/Tc+karuaLmYCotb48tUzsFasq3go3W2ozqdT8mYRUWCUsAJlC83I6i3JcsGfJlvQbJk
	VnOelw==
X-Received: by 2002:a05:6512:138b:b0:5a2:7a31:9193 with SMTP id 2adb3069b0e04-5a27a319441mr1102478e87.18.1773829813051;
        Wed, 18 Mar 2026 03:30:13 -0700 (PDT)
X-Received: by 2002:a05:6512:138b:b0:5a2:7a31:9193 with SMTP id
 2adb3069b0e04-5a27a319441mr1102465e87.18.1773829812608; Wed, 18 Mar 2026
 03:30:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALTww2_2pjjOSsVj-WT++m35555CjnPWokU7fut+HwUJVV-=ZQ@mail.gmail.com>
 <ebafe7e7-4166-4c1b-92b0-378db8f79ebf@gmail.com>
In-Reply-To: <ebafe7e7-4166-4c1b-92b0-378db8f79ebf@gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 18 Mar 2026 18:30:00 +0800
X-Gm-Features: AaiRm525oUHDeZFukFGdjyqKvbDVk-gi8POCE3egyIgYA31oguCrJxjA8R3unuQ
Message-ID: <CALTww28+ZdE4VzP1DqU=nFRibSPtu8L1qSOXKabv0ShdsAOO7A@mail.gmail.com>
Subject: Re: Release mdadm-4.6
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai@fnnas.com>, Nigel Croxon <ncroxon@redhat.com>, 
	Mariusz Tkaczyk <mtkaczyk@kernel.org>, Martin Wilck <martin.wilck@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 18, 2026 at 5:35=E2=80=AFPM Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
>
> On 3/16/26 4:45 PM, Xiao Ni wrote:
>
> > I'm glad to announce mdadm-4.5. It is published to both remotes
> > (github and kernel.org). Here are some highlights from CHANGELOG.md.
> >
> > # Release [mdadm-4.6](https://git.kernel.org/pub/scm/utils/mdadm/mdadm.=
git/log/?h=3Dmdadm-4.6)
> Could you please upload the corresponding tarball to the official
> kernel.org dir ( https://kernel.org/pub/linux/utils/raid/mdadm/ ) ?

Hi, I'll try to do this. I took the maintainer job, but the job
doesn't contain this part. I'll figure it out. But it needs some time.

If you want to download the package in spec file, you can do like this:

   1 Name:        mdadm
   2 Version:     4.4
   3 # extraversion is used to define rhel internal version
   4 %define extraversion 3
   5 Release:     %{extraversion}%{?dist}
   6 Summary:     The mdadm program controls Linux md devices
(software RAID arrays)
   7 URL:         https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
   8 License:     GPLv2+
   9
  10 Source:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/snapshot/%{name}-%{ver=
sion}%{?subversion:-%{subversion}}.tar.gz

This is my way. Hope this helps you.

Best Regards
Xiao

>
> Thanks.
>

