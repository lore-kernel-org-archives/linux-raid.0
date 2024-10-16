Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475D712E75
	for <linux-raid@vger.kernel.org>; Wed, 16 Oct 2024 13:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729084254; cv=none; b=Gkd67J1uX1H+YVlMARvYAa2d5vR27YYtSuJ6avlJmqg20mK92ynm71JNTySXwtwsMRLka7We+fVRBCqkBcurH+X80Dsu8PJ2Q5szCDiu7L3peRu7rz6PUhekd65bX52hFK83Y4xVubpxruFIsAGwpF4USTnGvaT3k3mmkV8jyA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729084254; c=relaxed/simple;
	bh=n6AbBCe3WPZGaO/OjHXYcKdxAlxMkS+BPqjlYGd2sRw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GKc3wEb60rGLpu2vXOUffgwjFG6pjJxCvIBH/GTTCdBNq3KrgNPjaHNIP9b2MgSdgrV60tGT/9korK37j57jVRG/UY9dZaEWuPUJZ0m5YiPsHD0T1M+uuUUNvoK2pHtlwCIq+6Hh2UMsP5U+GqwAueCIef57Q+LJmeBU5qYa+eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VkZTs/7E; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VkZTs/7E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729084252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n6AbBCe3WPZGaO/OjHXYcKdxAlxMkS+BPqjlYGd2sRw=;
	b=VkZTs/7EQ5U0etCIC8g7Ay5IoWRm4RdVNWyGHOODyTNhF7T8rk35gF0XK69eQO1GO3Ttvi
	l2cJ+ZZ31IQPVnTnsL6J/fGZbEkv6JvPJoj2A/TprMW3bx7UYTH7dgHr/Y15vP38iF/Ivw
	fDpTi+Kfj00t9Us3C6YVJDoOf4J3D5Y=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-so6kwBz1Mxq6C6t1CcgyPQ-1; Wed, 16 Oct 2024 09:10:50 -0400
X-MC-Unique: so6kwBz1Mxq6C6t1CcgyPQ-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-5e80448f56fso4476289eaf.1
        for <linux-raid@vger.kernel.org>; Wed, 16 Oct 2024 06:10:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729084249; x=1729689049;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n6AbBCe3WPZGaO/OjHXYcKdxAlxMkS+BPqjlYGd2sRw=;
        b=hffI2LyTQNXdA9u1GtZzEdXihjN8YKb7gdOHr9Y1ka05DlKVo3rI0hL1xgcNBN6HTE
         V6Sh1H/epOx5rVuRqfgkfim2UK43c9aNH3XocFRAEUXviXNxDrLm1k+CrP/3QzNd8gnU
         kz3jI2OTGL16NGPYX2WR8s+WKvwZGT3/69WBem0jl161UcZ4Oorj1p8nW3AbmPpLtwLW
         qTKVp+exb+JDOnTe/CWIbkZix/MnfGQqfV9Ucg4LyGy1Tjfb2dD5cd66Vff2K8W1prWT
         yJNPoUHI9B6PNpEhS5Ip4eHrIXU+qRISOWlaLq8xbmjR7/pF8txI5W5nfM0Rw8xygTqK
         aaaA==
X-Gm-Message-State: AOJu0YwD798Jp000vAbZr2P9R67HItAdrGwWEi43IRDabmYpSbdkMwO9
	twGkjOTbNNh8IpNS6lFr+wSIX+UXrM3/R6keG7YzUGzULhUq+6NfhlwoHsIMiZibJDpQL8rZXGs
	L33K+gTJDJBvdOBrhGGPPCtx3HirSV9YP9DgERFzw7tWOR5P2OcnPzfxiBwAniHVC/2w=
X-Received: by 2002:a05:6820:1989:b0:5e5:c291:9f86 with SMTP id 006d021491bc7-5eb58b8826emr3035734eaf.2.1729084248904;
        Wed, 16 Oct 2024 06:10:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGhb/NM0kRjfBQ9zIVpuzL1zgiWPED8rh6bwC/51Cha2mQNjR8cxX6iQ1EUqeBARG02Ytl70g==
X-Received: by 2002:a05:6820:1989:b0:5e5:c291:9f86 with SMTP id 006d021491bc7-5eb58b8826emr3035714eaf.2.1729084248579;
        Wed, 16 Oct 2024 06:10:48 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a? ([2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5eb4ede22a4sm695486eaf.19.2024.10.16.06.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 06:10:46 -0700 (PDT)
Message-ID: <5321cf0e579ee5e025396e9f9b62432dd2ed3458.camel@redhat.com>
Subject: Re: [PATCH] Add the ":" to the allowed_symbols list to work with
 the latest POSIX changes
From: Laurence Oberman <loberman@redhat.com>
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, "Hellwig, Christoph"
	 <hch@infradead.org>
Cc: linux-raid@vger.kernel.org
Date: Wed, 16 Oct 2024 09:10:44 -0400
In-Reply-To: <20241016101433.00005bb9@linux.intel.com>
References: <20241015173553.276546-1-loberman@redhat.com>
	 <20241016101433.00005bb9@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-10-16 at 10:14 +0200, Mariusz Tkaczyk wrote:
> On Tue, 15 Oct 2024 13:35:24 -0400
> Laurence Oberman <loberman@redhat.com> wrote:
>=20
> Hello Laurence,
> Thanks for the patch.
>=20
> ":" is used internally by native metadata name, we have
> "hostname:name". We are
> searching for it specifically, for that reason I think that I cannot
> accept it.
> Name must stay simple.
>=20
> If you want this again, I need to full set of mdadm tests that is
> covering every
> scenario and is confirming that we are able to determine hostname (if
> exists)
> and name in every case correctly.
>=20
> There are some workaround in code for that, I can see that we are not
> appending
> homehost if ":" is in the name. It is not user friendly. I prefer to
> not
> allow ":" to keep in simpler unless you have really good reason to
> have it back
> - there is no reason in commit message.
>=20
>=20
> > Signed-off-by: Laurence Oberman <loberman@redhat.com>
> > ---
> > =C2=A0lib.c | 2 +-
> > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/lib.c b/lib.c
> > index f36ae03a..cb4b6a0f 100644
> > --- a/lib.c
> > +++ b/lib.c
> > @@ -485,7 +485,7 @@ bool is_name_posix_compatible(const char *
> > const name)
> > =C2=A0{
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0assert(name);
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0char allowed_symbols[] =3D "=
-_.";
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0char allowed_symbols[] =3D "=
-_.:";
>=20
> Because the function has been made to follow POSIX, this cannot be
> simply added
> here. Please at least explain that in description.
>=20
> It is not POSIX compatible with this change.
>=20
>=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const char *n =3D name;
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!is_string_lq(name,=
 NAME_MAX))
>=20
> Thanks,
> Mariusz
>=20

Hello
Apologies Christoph and Mariusz, this could have definitely done with
more of an explanation.

We have customers complaining about a regression in mdadm since these
changes happened. They have 1000's of raid devices that can no longer
be started because they have ":" in the name. Example=20
mdadm: Value "tbz:pv1" cannot be set as devname. Reason: Not POSIX
compatible.

Should we add a --legacy flag where the original behavior is still an
option, what are your thoughts ?

Regards
Laurence=20

