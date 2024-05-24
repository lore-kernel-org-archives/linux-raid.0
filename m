Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184311802B
	for <linux-raid@vger.kernel.org>; Fri, 24 May 2024 15:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564241; cv=none; b=JE2DIlBLmHIiEMlKx2w5xL3HIAXw5k6W0pqjoyA11hnco/1VKXL/0qCeE4DZUt9CtCOeNdqhZjAHdZa92pXSRlBj8ypAiTEbjVhi2eE+FUid1sYMgXWF75fZznzM50IbupEvpX0jXUSZ+1551WI183JLEdmAB9RXW5B23KzoSx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564241; c=relaxed/simple;
	bh=7IeNFQfLtNnI/RP4SSNNxTNZY4X9ZAq+iHMaxHAkNPQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QmAaCAVMRLN4NuKM9KpNsB2XGjXr/vuoniUzTA49iDKKyLjnu2P2CJQ1bplToJKPed3BxC3OKGIznK/+BqCc+MSr61fXLCT3eY1cCJVRP9xAAHhAsgtpzHGhvOeJYIM+zDdpL9Cc19oh/H5MfTgvJ2vg8pl52k0VsfptndHxwiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=radoeka.nl; spf=fail smtp.mailfrom=radoeka.nl; dkim=pass (1024-bit key) header.d=kpnmail.nl header.i=@kpnmail.nl header.b=ErJscVLJ; arc=none smtp.client-ip=195.121.94.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=radoeka.nl
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=radoeka.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kpnmail.nl header.i=@kpnmail.nl header.b="ErJscVLJ"
X-KPN-MessageId: 9d6e4a26-19e1-11ef-903b-005056992ed3
Received: from smtp.kpnmail.nl (unknown [10.31.155.6])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 9d6e4a26-19e1-11ef-903b-005056992ed3;
	Fri, 24 May 2024 17:23:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kpnmail.nl; s=kpnmail01;
	h=content-type:mime-version:message-id:date:subject:to:from;
	bh=bbPMW3yOYb1eorxCLR2LHVNp5h/78yU5grXWuxJ/4yo=;
	b=ErJscVLJ13DXGfwcvArGMXDelyU0EPOF0uUDuOV7RChQvuRggS4RQF8h8R3lRbER2Lal3X6Eo+iQn
	 2Zp71FiGF1zGfjQ9/I87yXeIVeMC9NNCaHoodm5rE0s2ClDEtEp9PiQeGWU+bZXIPiA5KjjGCKLeAG
	 RLdYWgI9W3liTDno=
X-KPN-MID: 33|ujy0uHU57au7SzD1h55en89xk+31YVLhz2xhsOtMHq0HoYZlOKoO9MYwiMUMDjF
 U9gYp+Vp5Affo8GZDG0kJKkd8UJKjL/IE/erdUlND3sM=
X-KPN-VerifiedSender: No
X-CMASSUN: 33|wahfxAV2P3Z7tMQfJ75Uf7Qp1McMtt1nQC1pA4WeBq7THMW1eaf/Pci3cIXJJ3q
 ufehGj7vJ/CLr0VvD2s4N+w==
Received: from selene.localnet (80-60-179-152.fixed.kpn.net [80.60.179.152])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 9ed09e6b-19e1-11ef-9bdf-00505699772e;
	Fri, 24 May 2024 17:23:49 +0200 (CEST)
From: Richard <richard@radoeka.nl>
To: linux-raid@vger.kernel.org
Subject: Re: RAID-1 not accessible after disk replacement
Date: Fri, 24 May 2024 17:23:49 +0200
Message-ID: <4705980.vXUDI8C0e8@selene>
In-Reply-To: <87y180qyyk.fsf@vps.thesusis.net>
References: <1910147.LkxdtWsSYb@selene> <87y180qyyk.fsf@vps.thesusis.net>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Philip, Kuai,

Op donderdag 23 mei 2024 18:23:31 CEST schreef Phillip Susi:
> Richard <richard@radoeka.nl> writes:
> > I grew (--grow) the RAID to an smaller size as it was complaining about
> > the
> > size (no logging of that).
> > After the this action the RAID was functioning and fully accessible.
> 
> I think you mean you used -z to reduce the size of the array.  It
> appears that you are trying to replace the failed drive with one that is
> half the size, then shrunk the array, which truncated your filesystem,
> which is why you can no longer access it.  You can't shrink the disk out
> from under the filesystem.
> 
> Grow the array back to the full size of the larger disk and most likely
> you should be able to mount the filesystem again.  You will need to get
> a replacement disk that is the same size as the original that failed if
> you want to replace it, or if you can shrink the filesystem to fit on
> the new disk, you have to do that FIRST, then shrink the raid array.

I followed your advice, and made the array size the same as it used to be.
I'm now able to see the data on the partition (RAID) again.
Very nice.

Thanks a lot for your support.

-- 
Richard


