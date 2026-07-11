Received: from mr3.vodafonemail.de (mr3.vodafonemail.de [145.253.228.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7843191D6
	for <linux-raid@vger.kernel.org>; Sat, 11 Jul 2026 13:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.253.228.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783776636; cv=none; b=SDZiu9dmcj+oVEjIhOQp1uDm9YJSgc3ljr/s4G4TkdDHRfhNllLciNT/cnaQWqQASjaT//SJW5FKgwLD9GlnAFypC3rWrnyZf8227FnCYxDaCrFbb2rUJGofwHtauN6opFmjd2ktdBBwiu590Ge0OjL6gDX5RIEK8rJfftgVo1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783776636; c=relaxed/simple;
	bh=nvIR6UN+8ptAqK58hp6PGFmypjsCYxHb7/kBqe4EwQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hPJJ0zyNwGMk/N3oGGkf9VJJhfyAhEkbA3nQaX5fQ7Qtct3xDIqT5i2rLGkLuh4ZcKJzOOghBvLAGxYtXuktN2xku8Kzu9joio1q2knaVcs6HidNu8AU5oYpbaC0Q5lY3BGa/2eQQoAACNqVZ+NAu1EzzdrRrm1BfGjPFEF2Ln0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nexgo.de; spf=pass smtp.mailfrom=nexgo.de; dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b=RhLnYhzu; arc=none smtp.client-ip=145.253.228.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nexgo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nexgo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b="RhLnYhzu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nexgo.de;
	s=vfde-mb-mr2-23sep; t=1783776160;
	bh=iWo2Lwt6OgEqOWgymds+FWGdCmHdO2lwycntG6DSi/s=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 In-Reply-To:From;
	b=RhLnYhzuQA4cuPbQIzGosGUuujvIKc5EkYxMde8MbZZ7o9hRgP5RxkFwbSsa1XjZU
	 1dH7CFm59ZOMIF1TGcnK/zNxsEjHldrRf+8tF2bGy9ZRUmPGFCuFoLqh3aONdDiwns
	 zLo+QmSpHWKKPePFXYWN5ZL+ENAkcyUpCQlwqk+s=
Received: from smtp.vodafone.de (unknown [10.0.0.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mr3.vodafonemail.de (Postfix) with ESMTPS id 4gy8Wh3wCHz3sVfc;
	Sat, 11 Jul 2026 13:22:40 +0000 (UTC)
Received: from lazy.lzy (p579d7d31.dip0.t-ipconnect.de [87.157.125.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.vodafone.de (Postfix) with ESMTPSA id 4gy8WZ1Zw4z8sbL;
	Sat, 11 Jul 2026 13:22:31 +0000 (UTC)
Received: from lazy.lzy (localhost [127.0.0.1])
	by lazy.lzy (8.18.2/8.14.5) with ESMTP id 66BDMUTf050617;
	Sat, 11 Jul 2026 15:22:30 +0200
Received: (from red@localhost)
	by lazy.lzy (8.18.2/8.18.2/Submit) id 66BDMUPr050614;
	Sat, 11 Jul 2026 15:22:30 +0200
Date: Sat, 11 Jul 2026 15:22:30 +0200
From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
To: Wol <antlists@youngman.org.uk>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>,
        linux-raid@vger.kernel.org
Subject: Re: LBS setup
Message-ID: <alJDltJ9tc6tJCcj@lazy.lzy>
References: <ahLSj1Ua5WJ0GTgY@lazy.lzy>
 <alEb50Nmqt8IW2Nu@lazy.lzy>
 <811c24a5-0c72-4b83-af19-609e42e12613@youngman.org.uk>
 <alExwDILVwd3nVvK@lazy.lzy>
 <a2a4e6f6-5521-44f7-b045-7432e3e8e757@youngman.org.uk>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2a4e6f6-5521-44f7-b045-7432e3e8e757@youngman.org.uk>
X-purgate-server: smtpa05
X-purgate-type: clean
X-purgate: clean
X-purgate-size: 1680
X-purgate-ID: 155817::1783776160-CD592176-DE6D349E/0/0

On Fri, Jul 10, 2026 at 09:43:56PM +0100, Wol wrote:
> On 10/07/2026 18:54, Piergiorgio Sartor wrote:
> > Hi Wol
> > 
> > thanks for the answer.
> > 
> > My question is about "what to do?".
> > Not much what happened.
> > 
> > The log says we should copy some size
> > from somewhere to somewhere else.
> > The docs says this should be done
> > with array at rest.
> > 
> > Is there any documentation about this?
> > Should we just ignore the log?
> > What should be done, if any?
> > 
> > The log:
> > 
> > md1: echo current LBS to md/logical_block_size to prevent data loss issues from LBS changes.
> >                 	Note: After setting, array will not be assembled in old kernels (<= 6.18)
> 
> Ah. Personally I wouldn't do anything, then. Are you using any systems with
> kernel 6.18 or earlier?
> 
> Are you likely to use any kernels 6.18 or earlier in the future?
> 
> If the answer to both questions is no, then you're not going to have any
> trouble ...

Thanks again for the answer.

Nevertheless, sorry if I insist.
What I understand from the log message is
that if I do *not* copy the LBS I can get
data loss. If I do copy the LBS, I will
not be anymore backward compatible.

This backward compatibility does not seem
interesting for me, hence I should copy
this LBS.
Which then begs the question: how?

I mean, this seems the logical conclusion
from what I understood from the log.

Also, why to have this log in the first place?
The kernel is 7.1.3, so if everything would
be fine with it, no need to log anything.

I do not know...

Anyway, sorry again if I bother...

Thanks,

bye,

-- 

piergiorgio
