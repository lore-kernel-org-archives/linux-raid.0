Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F6B3FF889
	for <linux-raid@vger.kernel.org>; Mon, 17 Aug 2026 11:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786965467; cv=none; b=NNCGv8WkALTtxsHlvZZXxQQrecuDKXKEiDKFEtKygKznAe+h1GDgZY8DyQIp4EXxd7FqF85VxrajcCGGlHsa/2yWqPChZR2cCJmG+xGkrovNTrLhgJX0WAQlqCITt7xl/ZWaNc8OcW/wG2pN7R+vjk7Xb5PrtGERBhhV4SjgnQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786965467; c=relaxed/simple;
	bh=nmIJqKYUorjBeUTJ55+kjKbsShLkxxa8SVIxElN7dTc=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Date; b=u4Xb5RsPIjU0Ge1GmHtFcCcWo8XjNxXBUSTeY/nndYpvamw6eqV+SnoqBR0NSqhQC2o3ZAcox4ufnPUVR6zxRVdzwZaQ8fF7ogXY4ykYWLpFClRKdawwNe5DjS+5mcX5zvYf0Ahxp5S5ll2yH2LZll7/2jPVtJN1xir071ZNv80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UheXgto0; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=N4JVShq7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UheXgto0";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="N4JVShq7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786965464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jlLmM3V4bNqNAIwd0E7E4syK/sSR82TVvTikdxpHb34=;
	b=UheXgto0hpL3yCYPxDDFfae9wzMhNL1u6df7yW9lpS9GfIf2uS6VN844CE33SjbmXzXuZf
	CtawJT76cXlMFWYp2MSHBGqHf9w8dbWB3A5LFhXVuCG/j1WuNQezVdinBmMcFGWG3u/b8u
	VZjM6EiOt143Ols3/4AdUFVpCPAj7AY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-7dBnwAsHOIGUSV19Wy56UQ-1; Mon, 17 Aug 2026 07:17:42 -0400
X-MC-Unique: 7dBnwAsHOIGUSV19Wy56UQ-1
X-Mimecast-MFC-AGG-ID: 7dBnwAsHOIGUSV19Wy56UQ_1786965462
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-47fd4ee0ac0so2663769f8f.2
        for <linux-raid@vger.kernel.org>; Mon, 17 Aug 2026 04:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786965461; x=1787570261; darn=vger.kernel.org;
        h=date:content-transfer-encoding:content-type:mime-version
         :organization:references:in-reply-to:message-id:subject:cc:to:from
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jlLmM3V4bNqNAIwd0E7E4syK/sSR82TVvTikdxpHb34=;
        b=N4JVShq7MhCNlo68qwtt2kPCCgiQhhJY09ARkrDZ8MHxpQKR8Xm6dL5hgkCx+a6kte
         S+1rsqpNHsUEhXz/h8y/nqKv/Ga9p5SDgRNwQ2oyQahq30G66+ylQ3dW4V/nqRzjiA7B
         WdnmCNwEh9EBkoERhPifTYHXKBvYMgUNOpRCRlld3Sh8C8rMaqqqnPLfJvjdYTJvjcSZ
         bMPc3Jp1lqRtM2je1Zu3IElqeRcAL+wsQJdjUnzt45znkDaMZwYTfrMxOlyLy0MSIsLH
         PR4B1nNkShuRqDjwQUG1pcF7xUttkex8z5tUNjWKaqPQxbZEd96SpLdXsGZAaOLKO9Sb
         Qvlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786965461; x=1787570261;
        h=date:content-transfer-encoding:content-type:mime-version
         :organization:references:in-reply-to:message-id:subject:cc:to:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jlLmM3V4bNqNAIwd0E7E4syK/sSR82TVvTikdxpHb34=;
        b=eL03VFlG/0n2SftSdnL/v4wrT4Ziz9Yajcjc+xz5oO0faUQGVJuyjCF2+fo4v5LRjF
         PBRwjaRXU9MwMuh5EnJ3dN6emm4aBqhvjeOojp/rWgHV34JjxJ7YbGjljIH4LvGd5WFt
         pyAT2xhQNn68kKLO4Gg7fGLOwAWR/STJUb5vPz2JIyZbrpfiezE2KO5CwlRYwlRGjTK8
         6FY21/btCeRh9NIhDdsNYpWjglM6Umo8vxYAX9uvIGwRT8rzwQOeW7fcaFliZfXR94ID
         nAHOb3kDlaq9yeemhmcEkDZiZvGQEsR+obgcB7wQcL2CNWCkzcApZiFNIh7/GCvSX1Ad
         6pwA==
X-Forwarded-Encrypted: i=1; AHgh+RobammKTAz5FyvJVWn0VGemwbtWtL78fhD0jZ1APIHUKFUSgp3AqWbm+kAlX4c0zIt9MUIZc2dp0ANU@vger.kernel.org
X-Gm-Message-State: AOJu0YwxkDTYGKVCvKbGDtlS7UBCPxWmWuMV9/I5gXKEcN4JS8XgZSwB
	2HOHVw/aIm3ttC3XxJV5JPNBlT2tlJ1ZO6d8RaPuA+O0ohMJwQBXYdfoYHMmnwt1xEuPlIGgw+d
	sgSKDZAUlqha69RoJYDJmdszuf9GGhPjTv0iSIRQ8SHp+tx5FzbzK14arcjbpm+Q=
X-Gm-Gg: AR+sD11Kila4h7VTRN9a2e7Ag5kWygDMakyqqYXJUEqYSquAFKVuvGFI8GGn8KCVLL5
	4Q7eZUKTzG/SZM24gunoA7p0gd3G30G5jMEYwNPKeubgTKjj8VnhNsaxBltd/73pwABNqjT8z1N
	dKcKaG4Szxii5DEc7TrGSwCz1webytJL4ZriXrCs1Q9G6WZC946C+izG9ynWsukRRNcQdujWQUk
	w988N1vTriAKAP3Avj3isDEnhr/kAUwV4RhlYOK9b67ijVJSIXSHqoZcuSmIFlurzslGQf1FA+f
	14vsvnguxDgzyXj+XYifP0JdVXkrQGsGtF43gta3JgonQl/Yer6UwXSUpYZHxTx0OBAu2xIP4Cr
	Q1g9hdcHCCQizeZx/rm4OTkbLeoFj
X-Received: by 2002:a05:6000:18a6:b0:47f:5ec2:d54 with SMTP id ffacd0b85a97d-481607351d6mr41088964f8f.5.1786965461448;
        Mon, 17 Aug 2026 04:17:41 -0700 (PDT)
X-Received: by 2002:a05:6000:18a6:b0:47f:5ec2:d54 with SMTP id ffacd0b85a97d-481607351d6mr41088827f8f.5.1786965460933;
        Mon, 17 Aug 2026 04:17:40 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5a31572sm3207747f8f.5.2026.08.17.04.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 04:17:40 -0700 (PDT)
From: Stefano Brivio <sbrivio@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Taehee Yoo <ap420073@gmail.com>, netfilter-devel@vger.kernel.org, Pablo
 Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil
 Sutter <phil@nwl.cc>, stable@vger.kernel.org
Subject: Re: [PATCH 6/6] netfilter: nft_set_pipapo_avx2: add missing
 vzeroupper
Message-ID: <20260817131738.51554efe@elisabeth>
In-Reply-To: <20260816171518.GA2013@sol>
References: <20260815205750.169336-1-ebiggers@kernel.org>
	<20260815205750.169336-7-ebiggers@kernel.org>
	<20260816123839.3670e5c3@elisabeth>
	<20260816171518.GA2013@sol>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Mon, 17 Aug 2026 13:17:39 +0200 (CEST)

On Sun, 16 Aug 2026 10:15:18 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> On Sun, Aug 16, 2026 at 12:38:41PM +0200, Stefano Brivio wrote:
> > Eric, thanks for taking care of this.
> > 
> > The patch looks good to me, I just have two questions:
> > 
> > On Sat, 15 Aug 2026 13:57:50 -0700
> > Eric Biggers <ebiggers@kernel.org> wrote:
> >   
> > > Since pipapo_get_avx2() uses YMM registers, execute vzeroupper before
> > > returning from it.  This is needed to avoid degrading the performance of
> > > any later SSE code that may happen to be executed.  
> > 
> > Out of curiosity: was this prompted by some observed latency spike in
> > execution of SSE code, or it's just meant to satisfy the recommendation
> > from AMD and Intel to use it while transitioning from AVX to SSE modes?  
> 
> This one was found by code review.  But the latency spike has been
> observed in other cases with missing vzeroupper, so it's definitely a
> real effect at least on some CPUs.

Ah, interesting, I've been wondering about that.

> > > Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
> > > Cc: stable@vger.kernel.org  
> > 
> > Is this really stable material? Skipping vzeroupper might have a
> > performance impact, but it's not an issue for correctness.
> > 
> > The main reason why I'm asking is that, while vzeroupper might look
> > harmless and obviously safe, it actually caused CVE-2023-20593
> > ("ZenBleed") on AMD Zen 2.
> > 
> > I expect systems receiving stable kernel updates to also run the
> > patched microcode by now, so I'm not overly concerned in any case.  
> 
> It's awkward to mark something as a fix, then not actually want it to be
> fixed everywhere.  The stable maintainers know this, and they often
> apply fixes anyway regardless of 'Cc stable'.

Right, I guess you have point there.

> And if vzeroupper is really not safe due to ZenBleed, then why is it
> used everywhere else in the kernel?  This is just one of the few
> exceptions that doesn't have it.  If it's not safe then they should all
> be alternatives that patch them out to no-ops on affected CPUs.
> 
> But since that was never implemented, and userspace almost always uses
> vzeroupper too, it seems the only real solution is the microcode.  I
> don't think it makes sense to have a middle ground where almost all of
> userspace uses vzeroupper, ~97% of the kernel uses vzeroupper, and a
> random 3% of the kernel doesn't use it.

Don't get me wrong, I wasn't advocating against "fixing" this for
specific paths, rather just pointing out that something seemingly
harmless such as vzeroupper can have nasty side effects.

I used ZenBleed as a mere example, not as a current reason to do or not
do anything specific.

-- 
Stefano

