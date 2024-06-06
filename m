Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3DF160883
	for <linux-raid@vger.kernel.org>; Thu,  6 Jun 2024 14:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717684453; cv=none; b=NEnYE5KgVEu11lJpzIIGcSCBv/12ZTq5vOst7zYo1JgtKevy4wS9UD5Bh31NsXuRjjbmso6b83i88Sl45RiFRidiKfpY6vVkhAgfrAbUSC4Wa9209OZw55pOJQV//r4op1c3iakE5/p8MWBM6rpXkxk4WseKZcqT+8NK7FYs+1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717684453; c=relaxed/simple;
	bh=w1/NkoTv8okh3b4ZpKGtzQX3QsBOwjLqB8iAJ61xN4k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X5xkASavvyNacQyJiznxz9Q6S4ldMMqE15WsJxQZnoQs/g4lhCAffThNpoBCGlLhm1j08GNbMQjo7MFGmoXAQq7w0udZLP9HPUX5oZOoGDsiWOGzLtDcCZG2cxIxs1yBo6f/C0v/P3i9ZvVNs8DcSwhuEYL+FY6fFhJcsVfpJCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H/lHyqjW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H/lHyqjW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717684451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w1/NkoTv8okh3b4ZpKGtzQX3QsBOwjLqB8iAJ61xN4k=;
	b=H/lHyqjWdYZhlietGvYqvGWBLB0MefuKtuqmgm41oY4SvIOEwMnzqtZtzmfpJFysF4/NWb
	S/SbHeUGo1PwnZHCkrJXTQ7/6Z1MAZsWbdUUiqVLmuUssZbzUzxbZF6gQxYqpUq50rp+Tz
	KC2SwMY7hnNPoqC/xYLfirFB2VtXmm4=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-6k4sNqufMByyloqmzb0cfg-1; Thu, 06 Jun 2024 10:34:09 -0400
X-MC-Unique: 6k4sNqufMByyloqmzb0cfg-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2ea93c06e3cso9009021fa.2
        for <linux-raid@vger.kernel.org>; Thu, 06 Jun 2024 07:34:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717684448; x=1718289248;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w1/NkoTv8okh3b4ZpKGtzQX3QsBOwjLqB8iAJ61xN4k=;
        b=oQXWYoA3yRGLXfxqgYQe3CSO6AgvDwUr50TYoqUrpYuHyOY69UX5NoKHxe4o4XdITA
         NcIPzmzgLjY/bjHVHtSyGxDQlv/DPXrjoeoo8Wt4jq4M9m37FX8ejeJpjxfa3D176eT3
         gqw84QRlcqupq/5PTwxMnq9Dcnns5hXAaNmyIj5SuM1jb3AgsnFlqxqlsdqGUfOTW9qJ
         jB6EW2lX/WcXKvMdN7PFM/9DLIkJQqswbugRDF844JBNRqnK3+kSbiey/GUPrizqbF5p
         cSgnIEUTirVe1a8sxkmzaa2YymmGZuRKfqMRONlTqDSs5WeYFSYxEMnd6kPqlFXDirvs
         slkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVObURjQ3c0li/psLmQ2nBl+5FKe+ynjxdMLaUwq3/8KjXn0YSPwRV5KmTOedvHGW6zVaXynNJwUhpK+5cZp9rrqC+I+/Sf5Kfr5g==
X-Gm-Message-State: AOJu0YzFhE9qapO1zEn68tAJXEi/QW3qWHY8jvtrUnIJk/HVSw8AtTzW
	P/oH+9ZVMi9/mV17wWVwD6VioRxLsRIVz54un40wMgf/G2RFt2RZpv96eDduEdjrY6h3CWg5IG6
	Kr9xUAzVnQXzboKyYCZZCM7zzgyP1geyjA15fRqtqPXZ3uNQmVkBrXdvYE3b3zyiA1yPQtYDAXh
	RO1QWlTkwlcp+lhg9V5nldLYVNCpUveCOcLw==
X-Received: by 2002:a05:651c:2320:b0:2ea:79ab:6709 with SMTP id 38308e7fff4ca-2eac79ed93emr31221431fa.31.1717684448267;
        Thu, 06 Jun 2024 07:34:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFT3EWEpFlehIA5VQcmw82susmEa5mxX+JAN45jlMuv4WHB/jNJQcpr0eAhspVHZW4mCX0boPUjP5PU5/VPpdM=
X-Received: by 2002:a05:651c:2320:b0:2ea:79ab:6709 with SMTP id
 38308e7fff4ca-2eac79ed93emr31221281fa.31.1717684447910; Thu, 06 Jun 2024
 07:34:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240603215558.2722969-1-aahringo@redhat.com> <20240603215558.2722969-9-aahringo@redhat.com>
 <CAK-6q+i18_oHfdh6Odfidi0y4hWiR9bn_svWf2BwPqnLwdEFGQ@mail.gmail.com> <41da824f-f3e5-429f-a701-5feddf8b2ed1@suse.com>
In-Reply-To: <41da824f-f3e5-429f-a701-5feddf8b2ed1@suse.com>
From: Alexander Aring <aahringo@redhat.com>
Date: Thu, 6 Jun 2024 10:33:56 -0400
Message-ID: <CAK-6q+j0rbQ2CZ9y9wxZBUxsgGV03nF+ahVZPJEQPoUW-Mc8nQ@mail.gmail.com>
Subject: Re: [PATCH dlm/next 8/8] md-cluster: use DLM_LSFL_SOFTIRQ for dlm_new_lockspace()
To: Heming Zhao <heming.zhao@suse.com>, yukuai3@huawei.com, song@kernel.org
Cc: teigland@redhat.com, gfs2@lists.linux.dev, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Heming,

On Wed, Jun 5, 2024 at 10:48=E2=80=AFPM Heming Zhao <heming.zhao@suse.com> =
wrote:
>
> On 6/6/24 02:54, Alexander Aring wrote:
> > Hi,
> >
> > On Mon, Jun 3, 2024 at 5:56=E2=80=AFPM Alexander Aring <aahringo@redhat=
.com> wrote:
> >>
> >> Recently the DLM subsystem introduced the flag DLM_LSFL_SOFTIRQ for
> >> dlm_new_lockspace() to signal the capability to handle DLM ast/bast
> >> callbacks in softirq context to avoid an additional context switch due
> >> the DLM callback workqueue.
> >>
> >> The md-cluster implementation only does synchronized calls above the
> >> async DLM API. That synchronized API should may be also offered by DLM=
,
> >> however it is very simple as md-cluster callbacks only does a complete=
()
> >> call for their wait_for_completion() wait that is occurred after the
> >> async DLM API call. This patch activates the recently introduced
> >> DLM_LSFL_SOFTIRQ flag that allows that the DLM callbacks are executed =
in
> >> a softirq context that md-cluster can handle. It is reducing a
> >> unnecessary context workqueue switch and should speed up DLM in some
> >> circumstance.
> >>
> >
> > Can somebody with a md-cluster environment test it as well? All I was
> > doing was (with a working dlm_controld cluster env):
> >
> > mdadm --create /dev/md0 --bitmap=3Dclustered --metadata=3D1.2
> > --raid-devices=3D2 --level=3Dmirror /dev/sda /dev/sdb
> >
> > sda and sdb are shared block devices on each node.
> >
> > Create a /etc/mdadm.conf with the content mostly out of:
> >
> > mdadm --detail --scan
> >
> > on each node.
> >
> > Then call mdadm --assemble on all nodes where not "mdadm --create ..." =
happened.
> > I hope that is the right thing to do and I had with "dlm_tool ls" a
> > UUID as a lockspace name with some md-cluster locks being around.
>
> The above setup method is correct.
> SUSE doc [1] provides more details on assembling the clustered array.
>

yea, I saw that and mostly cut it down into the necessary steps in my
development setup.

Thanks for confirming I did something right here.

> [1]: https://documentation.suse.com/fr-fr/sle-ha/15-SP5/html/SLE-HA-all/c=
ha-ha-cluster-md.html#sec-ha-cluster-md-create
>
> >
> > To bring this new flag upstream, would it be okay to get this through
> > dlm-tree? I am requesting here for an "Acked-by" tag from the md
> > maintainers.
> >
>
> I compiled & tested the dlm-tree [2] with SUSE CI env, and didn't see the=
se
> patches introduce new issue.
>

Thanks for doing that. So that means you tried the dlm-tree with this
patch series applied?

Song or Yu, can I get an "Acked-by" from you and an answer if it is
okay that this md-cluster.c patch goes upstream via dlm-tree?

Thanks.

- Alex

