Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9844205F
	for <linux-raid@vger.kernel.org>; Mon,  6 May 2024 10:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714989714; cv=none; b=JZcUB2uVAazZ9zi6rHUdXtvVY2bMT+OCaQjMpCZwtxGhEkwEir+z4QSLB/lYInRU4boaam63iERz6Q58movV60ExpILE618AJg+i41de854iwAoVHpNPLFfLqivXsoJn8JUGL4ZNvVSP60neNqJiv4IdOmlMVjobF2Xb/R4ZDwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714989714; c=relaxed/simple;
	bh=blJawjKavZvYaf6O/vsiXPdcNXliVteyxUWvmpb9anY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bRNLI0TCSEgRn7AfTsDaSpyo4TXpk6TjYv6AJbyw9v8lfeU7jE7AcCS6Iz97dWfJ/Qw5QOlGBp9Ee+Vwlg8I4wXwVkCHzIlVbeaHhSt1DKviRtmu8wsC2XxXxvyVBULWjpbHPM2z9S7LS7a/9eyPN4h6tRte37DjPJexmnmveZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aHMuE7KD; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aHMuE7KD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714989713; x=1746525713;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=blJawjKavZvYaf6O/vsiXPdcNXliVteyxUWvmpb9anY=;
  b=aHMuE7KDIvLpXlQfdJ206Jgc2kMXETbxjbAPtqi+GDu25XubswEqywIq
   vFl6CY5V5INTDqtUZC85/YwtOAPA9of4I5VwjPS0bEAvJjZ/KekE04W+l
   VnhU0Dpq30mgkmG9OYwV82y3Epy+aUycF19lK04DWaRuwr2kiz2OpkyJj
   euWEDr4FJgflKEjT/xHcFHT62nCqc4xy5Ui1mhSjFQ3y8WI0F8FlNtnsF
   lBUS0wT9a4ty+dflYlfz2N97xMaUyHXHpyqpem7jBgWlsQF1fifR7PnIQ
   jc+Knbju2D7F3f1OneyqFbnzM0WzBCbPWFuW9EqsL7GB7CAau0pTn3PBA
   Q==;
X-CSE-ConnectionGUID: Pp6JMfl4Qj+i5dcekQb3jQ==
X-CSE-MsgGUID: 5s+2fIH1Qk+68CMvthElhw==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="22133186"
X-IronPort-AV: E=Sophos;i="6.07,258,1708416000"; 
   d="scan'208";a="22133186"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 03:01:52 -0700
X-CSE-ConnectionGUID: sYCzu6ZdSuW5Ho1UTq3mvg==
X-CSE-MsgGUID: yw1oGyOMSAmupJ02eY3sOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,258,1708416000"; 
   d="scan'208";a="28002007"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.116])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 03:01:50 -0700
Date: Mon, 6 May 2024 12:01:45 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Wols Lists
 <antlists@youngman.org.uk>, Paul E Luse <paul.e.luse@linux.intel.com>, John
 Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org, "yukuai (C)"
 <yukuai3@huawei.com>
Subject: Re: Move mdadm development to Github
Message-ID: <20240506120145.00007cff@linux.intel.com>
In-Reply-To: <85f74f83-bd1b-439d-874c-b3a38bdd2d71@suse.de>
References: <20240424084116.000030f3@linux.intel.com>
	<26154.50516.791849.109848@quad.stoffel.home>
	<20240424052711.2ee0efd3@peluse-desk5>
	<3ba48a44-07fd-40dc-b091-720b59b7c734@youngman.org.uk>
	<20240426102239.00006eba@linux.intel.com>
	<38770f23-92da-09a6-227f-11f1176294e2@huaweicloud.com>
	<85f74f83-bd1b-439d-874c-b3a38bdd2d71@suse.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Apr 2024 13:15:18 +0200
Hannes Reinecke <hare@suse.de> wrote:

> On 4/30/24 11:26, Yu Kuai wrote:
> > Hi,
> >=20
> > =E5=9C=A8 2024/04/26 16:22, Mariusz Tkaczyk =E5=86=99=E9=81=93: =20
> >> On Fri, 26 Apr 2024 08:27:44 +0100
> >> Wols Lists <antlists@youngman.org.uk> wrote:
> >> =20
> >>> On 24/04/2024 13:27, Paul E Luse wrote: =20
> >>>> * Instead of using the mailing list to propose patches, use GitHub P=
ull
> >>>> =C2=A0=C2=A0=C2=A0 Requests. Mariusz is setting up GitHub to send an=
 email to the=20
> >>>> mailing
> >>>> =C2=A0=C2=A0=C2=A0 list so that everyone can still be made aware of =
new patches in the
> >>>> =C2=A0=C2=A0=C2=A0 same manner as before.=C2=A0 Just use GitHub movi=
ng forward for actual
> >>>> =C2=A0=C2=A0=C2=A0 code reviews. =20
> >>>
> >>> Does that mean contributors now need a github account? That won't go
> >>> down well with some people I expect ...
> >>>
> >>> Cheers,
> >>> Wol =20
> >>
> >> Hi Wol,
> >>
> >> There are thousands repositories on Github you have to register to=20
> >> participate
> >> and I don't believe that Linux developers may don't have Github=20
> >> account. It is
> >> almost impossible to not have a need to sent something to Github. =20
> >=20
> > Will it still be able to send and apply patches through maillist? It's
> > important for us because I just can't create pr at GitHub in my
> > company, already tried with Paul, due to our company policy. :(
> > Although I can do this at home...
> >  =20
> I do think this is a valid point.
> (Having been in Beijing recently I do share the pain from Kuai :-)
>=20
> We really should keep the mailing list alive, and enable people
> to choose which interface suits them best.
> I don't have a problem in switching to github as the primary
> tree, but we should keep the original location intact as a
> mirror and continue to allow people to use the mailing list
> to send patches.
>=20
> This is especially important for low-volume mailing lists,
> where we have quite a few occasional contributors, and we
> should strive to make it as easy (and convenient) as possible
> for them.
>=20
> Cheers,
>=20
> Hannes
> >>

That one is good. For those exceptional cases I'm totally fine to do
review on ML but I will request the justification why pull request cannot be
created. I will create pull request myself or ask someone else to do this, =
not
a big deal.

I will send v3.

Thanks Kuai and Hannes,
Mariusz
