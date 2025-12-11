Received: from mail.bitfolk.com (use.bitfolk.com [85.119.80.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0544B21C16A
	for <linux-raid@vger.kernel.org>; Thu, 11 Dec 2025 00:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.119.80.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765413732; cv=none; b=GkXCgr/FHK5PbeDGIzAfaFZ/yySXppQxpm2BQWr8DU5xGUiewWlIn6hz4q4/1msIX/IbvaXNYj/POklvaXynQNRLnl9nNRXJCrNdEt8CxfzFCU6IE6lqzlUbGQgw8ZHvYN2aaijSlR8k7JeJErEoTPW+OO7EKLjHre577Vc5xbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765413732; c=relaxed/simple;
	bh=qhIaQPtd0SescODI788eomBjcpXjhPGL1nDQ9gpaZ2E=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PsyjZQGcBllhAs6x992TOV5A1MPtcgJlN8NMg6wZDfat9m3iQsTy1yDd9fBhhu8LXgN/x9WrGP1Ct0hxTKERnKN4bbeJMmqCnMT1xfax4N5ilaNGLj3LEVxDhd1FGL0CGwYD73+Q6FSNPDMyLKOC1LAnFc4j4Q2jgTYD4eKbHDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=strugglers.net; spf=pass smtp.mailfrom=strugglers.net; dkim=pass (2048-bit key) header.d=strugglers.net header.i=@strugglers.net header.b=op0AUpbe; arc=none smtp.client-ip=85.119.80.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=strugglers.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strugglers.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=strugglers.net header.i=@strugglers.net header.b="op0AUpbe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=strugglers.net; s=alpha; h=In-Reply-To:Content-Type:MIME-Version:References
	:Message-ID:Subject:To:From:Date:Content-Transfer-Encoding:Sender:Reply-To:Cc
	:Content-ID:Content-Description:Resent-To;
	bh=NKrZFz+4Dl2O9buccJbaUlKbE0pgbGHJ/3Qet4d4wbo=; b=op0AUpbevMCdT6Pi8VDNUmXQZM
	Xq9kLsTJMlaZ4MJ9QPG4FJ97dKdARQidP/y8C06dnrU774+zLfJQF0WYzqiinKalIAcrd65iWj9NI
	J5xppciSvB604ffuoYY9Qh7Cjdbm+RlZtgOhqAjLnZgN5onY+g1d3Jfg8fbP1VnCD2RPFoZbNqlSh
	dCSr4TMQ/xWsezuS9vEvJJAz2FbJsML6zMGBPFUdkIUulARRrQUDxdzVjiFZKWoMdkrnbV/986+Er
	U6+UYPMWBBypyv7kgCRn/TsXurW+QlQYYYYwtejK7L5VlBXsT3EtG9kksKXlISWnASVxlKO3ZRlBw
	Oh4wTIgg==;
Received: from andy by mail.bitfolk.com with local (Exim 4.94.2)
	(envelope-from <andy@strugglers.net>)
	id 1vTUUt-0002lB-VD
	for linux-raid@vger.kernel.org; Thu, 11 Dec 2025 00:25:31 +0000
Date: Thu, 11 Dec 2025 00:25:31 +0000
From: Andy Smith <andy@strugglers.net>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: Possible issue with software RAID 1 in case of disks with
 different speed
Message-ID: <aToPez8qzmWFsuV6@mail.bitfolk.com>
Mail-Followup-To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <ac13d188ba7e2d5b0e2a8943d720f1903003d548.camel@mail.fernfh.ac.at>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac13d188ba7e2d5b0e2a8943d720f1903003d548.camel@mail.fernfh.ac.at>
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL: http://strugglers.net/wiki/User:Andy
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false

Hi,

On Sun, Dec 07, 2025 at 02:41:37PM +0000, Christian Focke-Kiss wrote:
> Conclusion:
> I suspect software RAID 1 has issues if one disk of a three disk RAID 1
> set is significantly slower than the other two disks.

As others have mentioned I suspect your problem is USB. At no point in
the last 25 years have I found it a reliable way to have permanently
attached storage.

Storage with wildly different latency isn't a great setup but I haven't
found MD RAID-1 to have a big problem with it, not to the point of
instability.

write-mostly hasn't tended to have a huge effect for me unless the two
devices are radically different in performance. MD RAID already sends
reads to the device with the lowest amount of pending IO so all else
being equal, if you pair a SSD with a HDD, the SSD will get more reads
because they will complete sooner. Though do note that with RAID-1 a
single sequential read will all come from one device. It is only when
there are multiple threads reading that balancing can take place.

Thanks,
Andy

-- 
https://bitfolk.com/ -- No-nonsense VPS hosting
