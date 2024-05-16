Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5197D142912
	for <linux-raid@vger.kernel.org>; Thu, 16 May 2024 09:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715850175; cv=none; b=d/Rr20cwyXmhGPjgTTOwe8vTN3l6ZzKH+HlkxGB74Gqa7j/3VT8x2NZ9qmbE7bVgp03R34gnB5lkplpd6ZVtiYtgS8s6dM1JJ+oNmhIapU1R07KDNxolSVZINbbOf92ffM+F8ekvuwsCz/YgF8tenxof+Iy03sr10LkDDyPBp30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715850175; c=relaxed/simple;
	bh=Q7phT/jPu9c3Ut1JJeFuVsaLWoDJhATYzWMUHgZLSc4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RdpcAHu+mK+nFUzBvK2En/TrlPAeUjk1WL9HGbt4SPNWogmmQZfXPcNojapy0b9AFQgFf2ulN9acuN7WqhVn1x23HucsmrynRwSWfic5XLx9HieAirrD7QE7QJwF7/eCvmADULWivGE5StRo2BBr8rnQrU+kVFiYzT0utwmnMaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=frZFVfDF; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="frZFVfDF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715850175; x=1747386175;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q7phT/jPu9c3Ut1JJeFuVsaLWoDJhATYzWMUHgZLSc4=;
  b=frZFVfDFpeg2WvRPRWXnwQwFzKtk6Nx1fsQizJHsTrr7HUIGGY2m/Jxo
   qsB0Kld630IQhDPsVLHfEhHQoOrdKnyyPviZNp9v/dRYXRyHvasY2I4NR
   ZAgeKGl4wpDfJygdlNwByFygDi54lcl2KeqQ0VGoug7Oy83Cbtf97LcuO
   8b684t75mcR1zCL11TYTlkUNzr1MhSnnk1ziYg7Gz7O0P1BFX8aOYsSF6
   dhIIwUu+BpC1qBbilMvY7zCpmk7lyAyIDtux8v8G1Lxny8UrsG6wdPirQ
   sfTWVeZV0Gr3s/a3YkBSyuA8uTgm8Vm73K9ZLDpRC/jZN49oMoVAk5MQi
   g==;
X-CSE-ConnectionGUID: RaPrCW50QQOOuJDXoqkdmQ==
X-CSE-MsgGUID: L83wagvCTGO3tb0l0O5xKw==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="12068922"
X-IronPort-AV: E=Sophos;i="6.08,164,1712646000"; 
   d="scan'208";a="12068922"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 02:02:54 -0700
X-CSE-ConnectionGUID: 4Aji5euwQhebOLo7IwWDgQ==
X-CSE-MsgGUID: x5lOVlFiQ0+nzVkizKLwGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,164,1712646000"; 
   d="scan'208";a="31467126"
Received: from bkucman-mobl1.ger.corp.intel.com (HELO localhost) ([10.246.27.171])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 02:02:51 -0700
Date: Thu, 16 May 2024 11:02:46 +0200
From: Blazej Kucman <blazej.kucman@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: Blazej Kucman <blazej.kucman@intel.com>,
 mariusz.tkaczyk@linux.intel.com, jes@trained-monkey.org,
 linux-raid@vger.kernel.org
Subject: Re: [PATCH v2 2/6] Add reading Opal NVMe encryption information
Message-ID: <20240516110246.00003281@linux.intel.com>
In-Reply-To: <20240515162656.00003dee@linux.intel.com>
References: <20240322115120.12325-1-blazej.kucman@intel.com>
	<20240322115120.12325-3-blazej.kucman@intel.com>
	<CALTww2_=gHgut3M=q6SqjenG1oS3FAmG5N+FdQ0fahexZ39PSg@mail.gmail.com>
	<20240515162656.00003dee@linux.intel.com>
Organization: intel
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 15 May 2024 16:26:56 +0200
Blazej Kucman <blazej.kucman@linux.intel.com> wrote:

> On Wed, 15 May 2024 11:20:33 +0800
> Xiao Ni <xni@redhat.com> wrote:
>=20
> >
> > Hi all
> >=20
> > In i686 platform, it reports error:
> >=20
> > drive_encryption.c: In function =E2=80=98nvme_security_recv_ioctl=E2=80=
=99:
> > drive_encryption.c:236:25: error: cast from pointer to integer of
> > different size [-Werror=3Dpointer-to-int-cast]
> >   236 |         nvme_cmd.addr =3D (__u64)response_buffer;
> >       |                         ^
> > drive_encryption.c: In function =E2=80=98nvme_identify_ioctl=E2=80=99:
> > drive_encryption.c:271:25: error: cast from pointer to integer of
> > different size [-Werror=3Dpointer-to-int-cast]
> >   271 |         nvme_cmd.addr =3D (__u64)response_buffer;
> >       |                         ^
> > cc1: all warnings being treated as errors
> > make: *** [Makefile:211: drive_encryption.o] Error 1
> >=20
> > The pointer should be 32bit and it tries to convert to 64 bit.
> >=20
> > Best Regards
> > Xiao
> >  =20
>=20
> Hi Xiao,
> Thanks for reporting the issue, I'm already working on a fix,
> I'm currently in the fix testing phase.
>=20
> Thanks,
> Blazej
>=20

Hi Xiao,
I sent fix to review.
https://github.com/md-raid-utilities/mdadm/pull/9

Regards,
Blazej
