Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4707E290DBA
	for <linux-raid@vger.kernel.org>; Fri,  9 May 2025 11:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746789666; cv=none; b=IX8CnBf4iQ+7wB5I3DQcZbPOyQC/YBYGkg+j81Izndbka/oVoZvUGC5H/zqCXWV6xvI6GD6z7gBxim2JtSjQSxTkcR2tUot1wKextKzluC0FbWs3xuZkvEA18qtOJMSKMFcF0hnZukuoWYgsZ0gOoEgOkdJnNU4Qz3sFYvvTpF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746789666; c=relaxed/simple;
	bh=UwWTr+hg0GWvyJ3ArekwmVyoHnInQ257wAgvXRNBDZw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eyVDCG4j4EhX9o1axsxFMv0NCXSN7r/7DSKPZRjHz9fbYRYJZESFwpVLixiDfI3Yq1GAwfi7lzmP/zSbIk3yfCq25avfvTdpjC/hujSeZPK0uctZCWSuxwYjZ4wLi4ysFcZDjVSvuLxyjFJ3s9IHs3yKZvmteOm8C6jwcsX3/Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hdXySYxG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hdXySYxG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746789660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UwWTr+hg0GWvyJ3ArekwmVyoHnInQ257wAgvXRNBDZw=;
	b=hdXySYxGX067zamLeIzIPQX/Awp2pSCiNx+cMkR0HAr0+ilNPta0F+ebEX8OXYfoleiYwE
	NQ3tESjE5eaGNniV3nC9euqtxSaiRPjJH97V952iryx/8CKUMuSECstVgdPVCMCi1QwArC
	wxVXbyeaKSLYzNWhpXjxiqoF6cbs9Yw=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-yDobZwQ3NF6bXQXHj7o9BA-1; Fri, 09 May 2025 07:20:58 -0400
X-MC-Unique: yDobZwQ3NF6bXQXHj7o9BA-1
X-Mimecast-MFC-AGG-ID: yDobZwQ3NF6bXQXHj7o9BA_1746789657
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-326b56661dcso8885071fa.0
        for <linux-raid@vger.kernel.org>; Fri, 09 May 2025 04:20:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746789657; x=1747394457;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UwWTr+hg0GWvyJ3ArekwmVyoHnInQ257wAgvXRNBDZw=;
        b=VqclKh956tBrQiMMUyfLafaIBTSjk15SU4vv8pj6eiAu7g3l2jbMEZ5trHDFelkVzp
         ij1DxIhXl9vcQPRhmv5krfRM5pe1pX7hbuToSBa9y/mi++R5OurceGfHkN/hBFa3qhbQ
         YGHD+wfs/ozwrDcfRP7bB2DX/zvUxUTLKWbKIseWUA+e5lvlczVap2X1UnJMkKlkUUXt
         AKSB6D8Jgvf2qH6+jO9iLDPrq3vhSyKkO3eTC0yIEvGciwlAHL7nl+RQeUQRlwvqkYPH
         JXxWAuhAkltUHixDppZ8DuLJA+MNnusE9AYTKastg/afUqn9lA8vNhG3uTvFUlBJFjJV
         jRig==
X-Gm-Message-State: AOJu0Yy422qKFCo9mPtEumKP/bG1TNMDjE3iwm7YZ2CHBxsJo0zGP1wk
	gp44MeKUCJBHRmNS7ETDA1W4ZL1yWkEvqyf8QXhJhDL2QkxFzCQumiWNqc+niigwqrbEqNB5kD3
	N5QKIUJ5mKDRyhp1iFeIeujekwccXdsERZlRgkgirkEXK9tihb9E1VRLLEh2JRMKxwZM98kIi9i
	Dm2dNkZqSwVsIjuOi3qQ0RrUSEvtN8+yhdVA==
X-Gm-Gg: ASbGncshZAQwJB2XbNMG5uBFmiL40gy43GmLd9qfVvvZlWCNRSULJgq9glIMKmtToRn
	R3sz5dt1wVr1LJwru1OU3BMhZp0BqGb18QiNWl6Xm/+w5Xc9b7LKHo8w2sijBj7npiEKcQA==
X-Received: by 2002:a05:651c:19a8:b0:30b:9813:b00c with SMTP id 38308e7fff4ca-326c46a10f7mr11745231fa.27.1746789657099;
        Fri, 09 May 2025 04:20:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEEJAfUNn8LVKmRBf2u6sVPE+fKb18q1FzY7890BlD0ikc9+OluBWe4ocD14nVWOu09arfCoKJJoZ1tJvGezSM=
X-Received: by 2002:a05:651c:19a8:b0:30b:9813:b00c with SMTP id
 38308e7fff4ca-326c46a10f7mr11745111fa.27.1746789656685; Fri, 09 May 2025
 04:20:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250507021415.14874-1-xni@redhat.com> <20250507021415.14874-3-xni@redhat.com>
 <09d3eb78-d2c9-5c04-bec5-5aae4a19cf83@huaweicloud.com> <CALTww29siTuVSpCOJB7j47DxWFMcZV9RHkX=VfdxU0OyA4TsFg@mail.gmail.com>
 <c994b86c-cd40-1778-81d4-fdb3066053ef@huaweicloud.com> <CALTww28OBZZYdD_fJdFjmsjo51cn7CvVrKe=yserF+xvMd5f0A@mail.gmail.com>
 <04bc114d-08f8-b703-de7e-2f828f41321b@huaweicloud.com>
In-Reply-To: <04bc114d-08f8-b703-de7e-2f828f41321b@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 9 May 2025 19:20:44 +0800
X-Gm-Features: AX0GCFty5Ac03rlYeCb-7bwgWFHQCP0YVQhG096UAT_VRfHKIcfArXA71ExpZDM
Message-ID: <CALTww294G-r4BtFAnoQayLQgJO4Lm2+WSRac403_ERsLJbesKg@mail.gmail.com>
Subject: Re: [PATCH 2/3] md: replace MD_DELETED with MD_CLOSING
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org, ncroxon@redhat.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 9, 2025 at 6:26=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2025/05/09 18:20, Xiao Ni =E5=86=99=E9=81=93:
> > On Fri, May 9, 2025 at 6:08=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com=
> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2025/05/09 17:33, Xiao Ni =E5=86=99=E9=81=93:
> >>> The two places clear MD_CLOSING rather than setting MD_CLOSING.
> >>> MD_CLOSING is set when we really want to stop the array (STOP_ARRAY
> >>> cmd and clear>array_state_store). So the two places clear MD_CLOSING
> >>> for other situations which look good to me.
> >>
> >> No, MD_CLOSING can be set first in the two cases, do something and the=
n
> >> be cleared, that's why I said temporarily.
> >
> > So you mean mddev_get should pass in this case (between setting
> > MD_CLOSING and clearing MD_CLOSING)? It doesn't allow get mddev now
> > without this patch. This should be right.
>
> I don't understand what you mean "It doesn't allow get mddev now without
> this patch", for example, the ioctl STOP_ARRAY_RO will set MD_CLOSING
> temporarily, but never set MD_DELETED, mddev_get() can always pass.

You're right. I thought of the md_open path and it checks MD_CLOSING.
There is a short window that will fail to open sysfs files. I want to
make things easier and clearer here: it can't get mddev when
MD_CLOSING is set. Is there any problem if we use this rule?

Regards
Xiao
>
> Thanks,
> Kuai
>
> >
> > Regardes
> > Xiao
> >
> >>
> >> Thanks,
> >> Kuai
> >>
> >
> >
> > .
> >
>

