Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A61199937
	for <linux-raid@vger.kernel.org>; Wed, 21 Aug 2024 13:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724246019; cv=none; b=Ys5xleD3MO06Zgw6MHNG0DI5yGTsiXNwY8upoe0gyaEsWBc1GbszAxtQwfoWMVEYVk7BGEu/hVAeeuHMFLwXFR1+FyH/lljpag697p59d7WZOqwg+HupfOf2N+6ncYRufJKXxGsply4T7n7UkgYMiE4d/yntwAe7hk8IPaaQ1EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724246019; c=relaxed/simple;
	bh=VxdnQRQ9RoJiHroH7aL12ZENbeWU8OgMK4PjHewMYIM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cY7LsiaE+DpUDCyBPhhCXJnKy9mplf+lWpRLJUZ8MYmSPXwP2JjIQhxmd7YIqw8OuGesrUo4mqTOipqEPsjpFSrOSaaluIcK6REmBgGEGhBXg1MH013V5J8ur3gc3ef1s0ZoVYsukPNMnmnFHHf1oVOqFIn+pKAcrPkFAprz0S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DY9JGeAz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DY9JGeAz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724246016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VxdnQRQ9RoJiHroH7aL12ZENbeWU8OgMK4PjHewMYIM=;
	b=DY9JGeAz9K87/d9DgzpkrWDycbq5Tn3K1G+LlQTmYiW0/xgOmirOYkM2lyq1fFRjLvo0Qt
	ZpDIDiDlznwaeuS0FkbalVBVu9edYXl0uL+cD9GCcdDzsIf2bJyrBaLQ5f3UUNqfVyqFVZ
	GsBzvMO/3zzRCLkjgzYQnAZXdYtlmx8=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-Cn7oif9fMWK5PbuhYJNumQ-1; Wed, 21 Aug 2024 09:13:34 -0400
X-MC-Unique: Cn7oif9fMWK5PbuhYJNumQ-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2ef3133ca88so56509631fa.3
        for <linux-raid@vger.kernel.org>; Wed, 21 Aug 2024 06:13:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724246013; x=1724850813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VxdnQRQ9RoJiHroH7aL12ZENbeWU8OgMK4PjHewMYIM=;
        b=dRGXPhgtKPCY7BB0hrEbtNyAU7WBYcrdKpH1bX/rKeXb+0zEWWLWJXOunqkxJBUS4v
         qWPScY5zhO4s8VkwyJS56iJ3/SbcSnPxqVBTJVPzJ5jCR9ob1W3gaLLjPZm+QN9fCOoH
         eYOacR/NTyJJCjmToaheje2KJD66m3NeKZ9R+Yg2WoX9OKbklPUSikUVL2zFG0LDDecW
         JeXVLgRiSfVj/A23SuKhR3FJmk3PJprRN8VMVucKfs4S6gMJ2higLfn2fJjg4+qa+2jS
         tKtlAxmBInHebLe3xlq68bqruICUczfNHYLIGUboUkywwgNk50scPjljxxd9CMZJFRvE
         aWwg==
X-Forwarded-Encrypted: i=1; AJvYcCV5eFeoaU1UGBQLb9K5ZGZGGtJX8a8qzo/axCPIzXUZ+Wx9hIVQXxs51F0sbGF9wfugBFkAYUP4aSLr@vger.kernel.org
X-Gm-Message-State: AOJu0YxXtVQurWcr/cvOugBfnUDdrjZ6Bf6GIj/7oD3YmDslqo6HjWjD
	Bjgk6ewsGTtlpSF8J9EOBIu5fjew5pEB7aBu0DgGk9MSLA3ehmiQUKLydDNqsagawHmNdqZzje5
	PmdPX37l8/ftR01xIHOgDs04NaJ/asZkHT+reb+4XcbREDR1k91XTHgN4OYnSqd2371wyrGyeCE
	FwGUx9cs4dXzsQjfFIjWYgW7VZBFgYZJqBhw==
X-Received: by 2002:a2e:e09:0:b0:2ee:88d8:e807 with SMTP id 38308e7fff4ca-2f3f88a6e99mr13197191fa.16.1724246012976;
        Wed, 21 Aug 2024 06:13:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbXz/zZNLpgYy914DPQE0G3jUIMMtBg2FW5l+r7EiJf3/VyOVgUXkDaaMO4gGanew6Bd0Rh41sjKlfIR/KxZc=
X-Received: by 2002:a2e:e09:0:b0:2ee:88d8:e807 with SMTP id
 38308e7fff4ca-2f3f88a6e99mr13196981fa.16.1724246012310; Wed, 21 Aug 2024
 06:13:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240819183742.2263895-1-aahringo@redhat.com> <20240819183742.2263895-12-aahringo@redhat.com>
 <20240819151227.4d7f9e99@kernel.org>
In-Reply-To: <20240819151227.4d7f9e99@kernel.org>
From: Alexander Aring <aahringo@redhat.com>
Date: Wed, 21 Aug 2024 09:13:21 -0400
Message-ID: <CAK-6q+hx8MNeZCc0T-sTPdMgXH=ZcpLVqc2-5+psMCoQ_W0FxA@mail.gmail.com>
Subject: Re: [PATCH dlm/next 11/12] dlm: add nldlm net-namespace aware UAPI
To: Jakub Kicinski <kuba@kernel.org>
Cc: teigland@redhat.com, gfs2@lists.linux.dev, song@kernel.org, 
	yukuai3@huawei.com, agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, gregkh@linuxfoundation.org, rafael@kernel.org, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	netdev@vger.kernel.org, vvidic@valentin-vidic.from.hr, heming.zhao@suse.com, 
	lucien.xin@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jakob,

On Mon, Aug 19, 2024 at 6:12=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Mon, 19 Aug 2024 14:37:41 -0400 Alexander Aring wrote:
> > Recent patches introduced support to separate DLM lockspaces on a per
> > net-namespace basis. Currently the file based configfs mechanism is use=
d
> > to configure parts of DLM. Due the lack of namespace awareness (and it'=
s
> > probably complicated to add support for this) in configfs we introduce =
a
> > socket based UAPI using "netlink". As the DLM subsystem offers now a
> > config layer it can simultaneously being used with configfs, just that
> > nldlm is net-namespace aware.
> >
> > Most of the current configfs functionality that is necessary to
> > configure DLM is being adapted for now. The nldlm netlink interface
> > offers also a multicast group for lockspace events NLDLM_MCGRP_EVENT.
> > This event group can be used as alternative to the already existing ude=
v
> > event behaviour just it only contains DLM related subsystem events.
> >
> > Attributes e.g. nodeid, port, IP addresses are expected from the user
> > space to fill those numbers as they appear on the wire. In case of DLM
> > fields it is using little endian byte order.
> >
> > The dumps are being designed to scale in future with high numbers of
> > members in a lockspace. E.g. dump members require an unique lockspace
> > identifier (currently only the name) and nldlm is using a netlink dump
> > behaviour to be prepared if all entries may not fit into one netlink
> > message.
>
> Did you consider using the YAML spec stuff to code gen the policies
> and make user space easier?
>

I will try to take a look into that and prepare a spec for PATCHv2. I
saw that there is a documentation about it at [0].

I did a kind of "prototype" libnldlm [1] to have easy access to the
netlink api but if there are more common ways to generate code to
easily access it, I am happy to give it a try.

Thanks.

- Alex

[0] https://docs.kernel.org/userspace-api/netlink/specs.html
[1] https://gitlab.com/netcoder/nldlm/

