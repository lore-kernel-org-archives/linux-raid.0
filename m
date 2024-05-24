Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA79126F04
	for <linux-raid@vger.kernel.org>; Fri, 24 May 2024 15:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716566161; cv=none; b=a9Ovkga7D8aO9lLgdFcnol8xAI6kom0pdpcT8LoHfVV3b4JWh4sOLjh67SJsnrHamrt3HipwO+ZNVRGBnVwHhJv4UcqD/dkWyks7jEo8LyVUZDDPCnh0+wmAkgmCQQcchKV3aLz9nETEcAXZJIdL4hkENlcDy3gS8xnVTJDRjcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716566161; c=relaxed/simple;
	bh=1zyd8ivPk4WrPjUBO/QOiurdqW1nXHbtFWput7JpyZo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D+GXOiK7CAQuA9JUf701SyIu1SIenc58TOQ9K6ZqrCF5xKHdeLCRoJY+jFodPk80eBnMOJFuljXABE7QqJ54e6LeCEodnZ36ropWdzjWl3lkqwVaBrTpNyLHA+v4RInsNtzQnZFaQk7jj7ggPuabLaY2tijMmfaO/sGJnR1Hoxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=radoeka.nl; spf=fail smtp.mailfrom=radoeka.nl; dkim=pass (1024-bit key) header.d=kpnmail.nl header.i=@kpnmail.nl header.b=h/O3aFkM; arc=none smtp.client-ip=195.121.94.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=radoeka.nl
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=radoeka.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kpnmail.nl header.i=@kpnmail.nl header.b="h/O3aFkM"
X-KPN-MessageId: 1984ca7b-19e6-11ef-903b-005056992ed3
Received: from smtp.kpnmail.nl (unknown [10.31.155.7])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 1984ca7b-19e6-11ef-903b-005056992ed3;
	Fri, 24 May 2024 17:55:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kpnmail.nl; s=kpnmail01;
	h=content-type:mime-version:message-id:date:subject:to:from;
	bh=rDByJpXLZAEw5E2kylTrNpMiDLpbzqCIryOa8AeHSCM=;
	b=h/O3aFkMu/QJI/nUzToUXUw5Oq4i1nYSC7MYseJ7eZIJOHbacmtnJ6l+GB9D1kPijVURkeujACWQ+
	 wsRqA5SO9KhZutKR8ialBRQ+5k66m5jI4KkBFXU4XyaqgYUD7hlaxP4gDDi+JFklAm5U23Y32QeIFW
	 ude0gMdJx2GyzjOo=
X-KPN-MID: 33|ja8PoSweTuqXNgixnLMNs1qiJWmQgpI3hBm8SPtLZ9eNgXJeL0eKWmpf18dVmQc
 WTamUBELBs+ozqF/A7wNvDI4E7b+Os2mfGvqJ5+uICTI=
X-KPN-VerifiedSender: No
X-CMASSUN: 33|cxx3TboupckwrAmaPhkezui3M5k02PM/tKS36WEdaCxySq5Nc/vxjdUUxosMI+p
 6Yu8J/nSgo5suwb81zeGyCQ==
Received: from selene.localnet (80-60-179-152.fixed.kpn.net [80.60.179.152])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 1af0548c-19e6-11ef-8135-005056998788;
	Fri, 24 May 2024 17:55:55 +0200 (CEST)
From: Richard <richard@radoeka.nl>
To: linux-raid@vger.kernel.org
Subject: Re: RAID-1 not accessible after disk replacement
Date: Fri, 24 May 2024 17:55:55 +0200
Message-ID: <26411775.1r3eYUQgxm@selene>
In-Reply-To: <4705980.vXUDI8C0e8@selene>
References:
 <1910147.LkxdtWsSYb@selene> <87y180qyyk.fsf@vps.thesusis.net>
 <4705980.vXUDI8C0e8@selene>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Op vrijdag 24 mei 2024 17:23:49 CEST schreef Richard:
> Philip, Kuai,
> 
> Op donderdag 23 mei 2024 18:23:31 CEST schreef Phillip Susi:
> > Richard <richard@radoeka.nl> writes:
> > > I grew (--grow) the RAID to an smaller size as it was complaining about
> > > the
> > > size (no logging of that).
> > > After the this action the RAID was functioning and fully accessible.
> > 
> > I think you mean you used -z to reduce the size of the array.  It
> > appears that you are trying to replace the failed drive with one that is
> > half the size, then shrunk the array, which truncated your filesystem,
> > which is why you can no longer access it.  You can't shrink the disk out
> > from under the filesystem.
> > 
> > Grow the array back to the full size of the larger disk and most likely
> > you should be able to mount the filesystem again.  You will need to get
> > a replacement disk that is the same size as the original that failed if
> > you want to replace it, or if you can shrink the filesystem to fit on
> > the new disk, you have to do that FIRST, then shrink the raid array.
> 
> I followed your advice, and made the array size the same as it used to be.
> I'm now able to see the data on the partition (RAID) again.
> Very nice.
> 
> Thanks a lot for your support.

I'm getting a bigger drive.  That means that I'm going to get the following 
setup:

/dev/sda6 403GB  (the one that is now the active partition)

I'll make /dev/sdb6 the same size, also 403 GB.

The array size is now set at 236 GB (with sda6 having a size of 403GB).

Once both 403GB partitions are part of the array, would it then be possible to 
grow the array from 236GB to 400GB?  Or will that result in problems as well?

-- 
Richard



