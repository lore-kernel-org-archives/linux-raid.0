Received: from smtp161.vfemail.net (smtp161.vfemail.net [146.59.185.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5B73A1CD
	for <linux-raid@vger.kernel.org>; Sat, 27 Apr 2024 03:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.59.185.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714188763; cv=none; b=T2z5kkqDin3qjnxZ3jO0fglZygUMliUpVcTI2w3LKaM39tj/swqFuofjV5ekeMASaIIV6W4GAUl+UV+B5xCQ9hRM1IsrxjqcKqC9ZdciwhckOdVLZ8VOzSGHKAFwIBaUJu+2B8yATsv7sqEtp814y7lGDfsbJ4G99GfZvz14WEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714188763; c=relaxed/simple;
	bh=MDKwZsWWeD9kOyBRQk4Pr2wiSxm2Yl2miPrev/ncc1E=;
	h=Date:From:To:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pdddPOMgP2dFEmQ3392IjcTja+8fcjBwd7AtmDUEreIIC8RfkP5NhgIkmMuOHJg50z/1eVT9WE3kIzdT/WQxRcHPY8qXEzwZMNjHCXOvYIIgDsGuGP7Ua6Ta2v5bnS1ev+J/qGfo6oalJXlcBAaq9Jg67UItYqnHTz3wJRMNUZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net; spf=pass smtp.mailfrom=vfemail.net; dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b=IHcgfq5b; arc=none smtp.client-ip=146.59.185.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vfemail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b="IHcgfq5b"
Received: (qmail 29264 invoked from network); 27 Apr 2024 03:25:57 +0000
Received: from localhost (HELO nl101-3.vfemail.net) ()
  by smtpout.vfemail.net with ESMTPS (ECDHE-RSA-AES256-GCM-SHA384 encrypted); 27 Apr 2024 03:25:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=vfemail.net; h=date:from
	:to:subject:message-id:in-reply-to:references:mime-version
	:content-type:content-transfer-encoding; s=2018; bh=MDKwZsWWeD9k
	OyBRQk4Pr2wiSxm2Yl2miPrev/ncc1E=; b=IHcgfq5b9DL1FFZYbp1DfbXi/J6e
	T86CPXyaDl+o/+Xtwi0GtoDIQlcxjLnl7F/EBbdH805e6+8RcWIlIAJvPEWKCVV+
	y0kIUB1YKv+Y3OFOjKf3ZAbwBK9sFmjII6Qk0MLXd8avXRtoKLw3kuQ1P8ZGtwxP
	rhirnWAbFjhhT0M=
Received: (qmail 34535 invoked from network); 27 Apr 2024 03:25:57 -0000
Received: by simscan 1.4.0 ppid: 34519, pid: 34527, t: 0.3939s
         scanners:none
Received: from unknown (HELO bmwxMDEudmZlbWFpbC5uZXQ=) (aGdudGt3aXNAdmZlbWFpbC5uZXQ=@MTkyLjE2OC4xLjE5Mg==)
  by nl101.vfemail.net with ESMTPA; 27 Apr 2024 03:25:57 -0000
Date: Sat, 27 Apr 2024 03:25:54 +0000
From: David Niklas <simd@vfemail.net>
To: linux-raid@vger.kernel.org
Subject: Re: Move mdadm development to Github
Message-ID: <20240427032554.5dd83266@Zen-II-x12.niklas.com>
In-Reply-To: <ZiuDtQTn39HVgIH-@infradead.org>
References: <20240424084116.000030f3@linux.intel.com>
	<26154.50516.791849.109848@quad.stoffel.home>
	<20240424052711.2ee0efd3@peluse-desk5>
	<3ba48a44-07fd-40dc-b091-720b59b7c734@youngman.org.uk>
	<20240426102239.00006eba@linux.intel.com>
	<ZiuDtQTn39HVgIH-@infradead.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 Apr 2024 03:36:37 -0700
Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Apr 26, 2024 at 10:22:39AM +0200, Mariusz Tkaczyk wrote:
> > There are thousands repositories on Github you have to register to
> > participate and I don't believe that Linux developers may don't have
> > Github account. It is almost impossible to not have a need to sent
> > something to Github.  
> 
> There's plenty of us that refuse to create an account with an evil
> megacorp just to re-centralize development for no reason at all.
> 
> But hey, I'm not a major mdadmin contributor anyway.
> 

It's true that you "need" to have a github account. That being said, MS
has never been friendly to FLOSS/FOSS/OSS, only to mixed source SW. Even
through to this day. For example, WSL.

So you can certainly move main dev over there, but please keep other
places alive and well because there's literally no reason to think that
this "marriage" of MS and OSS will not be an abusive relationship. E.G.
some OSS devs have noticed AIs copying their code verbatim which then can
wind up in closed source projects.

David
