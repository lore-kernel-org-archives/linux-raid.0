Received: from mail.minuette.net (mail.minuette.net [198.50.230.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D1810A28
	for <linux-raid@vger.kernel.org>; Sun, 28 Apr 2024 22:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.50.230.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714343938; cv=none; b=D1YEmLd2kTqxQ8wJymYkdr256rpclzMN8QDgX+7zhFgS4+UWxF89EaVYlsO5NRGLf7xaeGEQ8j2hUcyAeFpfBEqGpWPcGlZyjpRenqYvgTc85bsuYF1L4G/W4KzMCwjhxgVRkfJpv1bYc4T8rA/DzOBxWpTMIA2lZlD0oqNLUCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714343938; c=relaxed/simple;
	bh=5vxq2KLdFy/meBnURwMyTC5lDIA/Px0gLmYCmZnKXFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QQILDj9r6avOkKMYdqT85f5L02wNID3/GJEnZZmxZ4aVjAiyhEwXbd5nAl8AUJQvvHFNMQZ3fJOSEK/YHvouwD7R24uY2nknrkbfi5x0lm8EeD+zQQdBSZixrYUghOYJywVn4h8quN1vBmyunF9WU+HLkGofrm4/Ax/51cqdHVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=minuette.net; spf=pass smtp.mailfrom=minuette.net; dkim=pass (4096-bit key) header.d=minuette.net header.i=@minuette.net header.b=aomVDT5X; arc=none smtp.client-ip=198.50.230.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=minuette.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=minuette.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=minuette.net header.i=@minuette.net header.b="aomVDT5X"
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.minuette.net 7EEEE63C8E93
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=minuette.net;
	s=default; t=1714343935;
	bh=2Ms8VnH2i43SAzAkwtfwBPyyL69I30+G7Pl41VH4iWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aomVDT5X0venkcezaOEhu/hV/A86Fkm1lETrBsJcwrZnzE65AlRR3xc0Mv+0YI1XU
	 M0LiW9msIcWX/LGqVimOjO5vtlJWksZl99XENo3dXMctUjZSitv1XXctdUkNr9RKj8
	 vap+S1JhEke8AEDpmaXbBYA3AfNud3T3XLdxDY6KBrrQNS2EY0lG0Isb2j6/SVinNU
	 cXNIRzyyJ5PYTw0QrbAXRTe07T+1TReFBAlw3MTMpZIldbSGQVQmrhX9BQSg4ktW6y
	 uEka5pq5dhfobOHbOAM53FIkVoafsg8SW/zVOhYY7+/1Nn0O6pizhCrqe2mBFljjvT
	 30JusFkfwOTnn6c74vxOY9ouT2V5CAsXzkG5Epfm4QpQILQyBSqfxqSulyoWVU0Q6K
	 2phyzDDbgSTESx6p0Tzvu8lrvLsUUT8u88+jPHV/9oByeiEq+3O5E2VygZhcuRE+s8
	 l3lV8yMAtlCghv1cOPdpHPVnN54S0vacCeebDuTV6g0oI7rDNevPMLaRxPdPjRNG8m
	 7v+cYZNQ1+CQFQl1yBdSwbaXU5RSCuLhPZt2uIaplTJn2Iq+SHzUJDRpqnXEuZbMlD
	 525w+zsDESS/pLfEw9TrdbLxVV7LfPf4+zlpPicApH57d2ouc25ljC8VYYAyFY5c1c
	 4l1+JVvSjueqfLFmWuhvcuCM=
From: Colgate Minuette <rabbit@minuette.net>
To: Roman Mamedov <rm@romanrm.net>
Cc: Paul E Luse <paul.e.luse@linux.intel.com>, linux-raid@vger.kernel.org
Subject: Re: General Protection Fault in md raid10
Date: Sun, 28 Apr 2024 15:38:54 -0700
Message-ID: <12425094.O9o76ZdvQC@sparkler>
In-Reply-To: <20240429032529.2281222d@nvm>
References:
 <8365123.T7Z3S40VBb@sparkler> <2322142.ElGaqSPkdT@sparkler>
 <20240429032529.2281222d@nvm>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sunday, April 28, 2024 3:25:29 PM PDT Roman Mamedov wrote:
> On Sun, 28 Apr 2024 15:16:27 -0700
> 
> Colgate Minuette <rabbit@minuette.net> wrote:
> > I just tried RAID10 on the same HBA/cables with 4 seagate 4TB SAS HDDs,
> > and it is functioning correctly. Syncing correctly and able to write/read
> > from the md device.
> 
> With those 15 TB SSDs, maybe something wonky with the large size?
> 
> Did you try creating a smaller partition on each, maybe just start with 4,
> to not redo all of them, since you say 4 also repros the issue. Test with a
> 4 TB or even 1TB partitions as RAID members.

Created a 2TB partition on 4 of the drives, created md RAID10 on the 2TB 
partitions, and got another protection fault shortly after starting the array.

[  515.504412] md/raid10:md51: not clean -- starting background reconstruction
[  515.504414] md/raid10:md51: active with 4 out of 4 devices
[  515.530362] md51: detected capacity change from 0 to 8388079616
[  515.530445] md: resync of RAID array md51
[  524.083652] general protection fault, probably for non-canonical address 
0xb1c8a7fff899a: 0000 [#1] PREEMPT SMP NOPTI


-Colgate


