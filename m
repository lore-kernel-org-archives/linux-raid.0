Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B12E1D8DFB
	for <linux-raid@vger.kernel.org>; Fri, 14 Nov 2025 12:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763123498; cv=none; b=dvR/GRuITxXMEgOtstxu65QuK+kfDUboHyOEO2MEUizYNRqyT14JYJc4RTArJKt5NGmCIIY1lMTtwiTaR5pbaNc5lOC1ne66bN1+EFDXEt8StJEdZw27U8UJz/i9/P+yZvlf5OZWPqDpI0fMsJRO6o1Meo5cRtJuGEW3010bMsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763123498; c=relaxed/simple;
	bh=I/5ZwKDnJtZ1QHeVA7vHi5YjQFEo9sYBLzy3T8zEbME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AQpkHULLmLAxyKjH016Ji6Gwmh8SLWyEy3DAIWpVuSPM0t5dPJUG2MZDuksQwJy1N33k4ayEEHemDxAcJt05i5Y9Gl5cBk5ZpcTiOsDo8QzfcL+41QYQVD6wiqtarvH8RRnBL0QQgQuVKpUa/eJvHvlaaUjel8xkczwP4ogY7Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GY71v8Lq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GY71v8Lq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763123495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IFVcxodsfdbO76GQsBhbtk1ePR5txWpCuWnMr3v/vyY=;
	b=GY71v8LqlijDWoZO3apCtMCHKsf/w+JjaACNff65vcAaDchV1QJ6EnqxjYz8fzfhCQ7mxi
	sjeN+bYDPFyfmsRfRCwsnevaJDBQ3H3o+OrgfdLvJd8iRs7P+WwIZSot3yAVj1hTWi2LEQ
	h2aVRCrDSZxwcGIiYv02dvdp9i45CXs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-26-AXg7kpStM3KFnE5mu2sImQ-1; Fri,
 14 Nov 2025 07:31:29 -0500
X-MC-Unique: AXg7kpStM3KFnE5mu2sImQ-1
X-Mimecast-MFC-AGG-ID: AXg7kpStM3KFnE5mu2sImQ_1763123487
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D12B18AB406;
	Fri, 14 Nov 2025 12:31:27 +0000 (UTC)
Received: from redhat.com (unknown [10.44.33.81])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5651D19560B9;
	Fri, 14 Nov 2025 12:31:23 +0000 (UTC)
Date: Fri, 14 Nov 2025 13:31:20 +0100
From: Kevin Wolf <kwolf@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Keith Busch <kbusch@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: fall back from direct to buffered I/O when stable writes are
 required
Message-ID: <aRchGBJA1ExoGi8W@redhat.com>
References: <aQPyVtkvTg4W1nyz@dread.disaster.area>
 <20251031130050.GA15719@lst.de>
 <aQTcb-0VtWLx6ghD@kbusch-mbp>
 <20251031164701.GA27481@lst.de>
 <kpk2od2fuqofdoneqse2l3gvn7wbqx3y4vckmnvl6gc2jcaw4m@hsxqmxshckpj>
 <20251103122111.GA17600@lst.de>
 <aRYXuwtSQUz6buBs@redhat.com>
 <20251114053943.GA26898@lst.de>
 <aRb2g3VLjz1Q_rLa@redhat.com>
 <20251114120152.GA13689@lst.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114120152.GA13689@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Am 14.11.2025 um 13:01 hat Christoph Hellwig geschrieben:
> On Fri, Nov 14, 2025 at 10:29:39AM +0100, Kevin Wolf wrote:
> > Right, but since this is direct I/O and the approach with only declaring
> > I/O from the page cache safe without a bounce buffer means that RAID has
> > to use a bounce buffer here anyway (with or without PI), doesn't this
> > automatically solve it?
> >
> > So if it's only PI, it's the problem of userspace, and if you add RAID
> > on top, then the normal rules for RAID apply. (And that the buffer
> > doesn't get modified and PI doesn't become invalid until RAID does its
> > thing is still a userspace problem.)
> 
> Well, only if we have different levels of I/O stability guarantees:
> 
> Level 0
>   - trusted caller guarantees pages are stable (buffered I/O,
>     in-kernel direct I/O callers that control the buffer)
> 
> Level 1:
>   - untrusted caller declares the pages are stable
>     (direct I/O with PI)
> 
> Level 2:
>   - no one guarantees nothing
>     (other direct I/O directly or indirectly fed from userspace)
> 
> PI formatted devices would only bounce for 1, parity would bounce for
> 1 and 2.  Software checksums could probably get away with only 1,
> although 2 would feel safer.

My main point above was that RAID and (potentially passed through) PI
are independent of each other and I think that's still true with or
without multiple stability levels.

If you don't have these levels, you just have to treat level 1 and 2 the
same, i.e. bounce all the time if the kernel needs the guarantee (which
is not for userspace PI, unless the same request needs the bounce buffer
for another reason in a different place like RAID). That might be less
optimal, but still correct and better than what happens today because at
least you don't bounce for level 0 any more.

If there is something you can optimise by delegating the responsibility
to userspace in some cases - like you can prove that only the
application itself would be harmed by doing things wrong - then having
level 1 separate could certainly be interesting. In this case, I'd
consider adding an RWF_* flag for userspace to make the promise even
outside PI passthrough. But while potentially worthwhile, it feels like
this is a separate optimisation from what you tried to address here.

Kevin

