Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0121D9682
	for <linux-raid@vger.kernel.org>; Thu, 17 Oct 2024 11:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729164400; cv=none; b=lBfyTGw16XK2jxtoMfxWfFizMNLwL44JQgwIGWyddnfipLsHWPIor29CIRpgbLMcbYOCx45yjrfifvHBrTyHF7gXXv89ve++7jeefCO0LK6brJzX7ehx6kx8FuiX5w3Y73BfMu6mkHJ1IyKW0UfSBbXp0d/NTRwRganaoFRg0/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729164400; c=relaxed/simple;
	bh=/J45AW9zfdu1PZFapwRpitxIzPtj3cxWYzgrpvi1fG0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LagYvSQXwFpgSB4CksBkT4+DK1KG4iFCemsseqXWky+U0bgQnxmx43/H8gExN6qsPtOcOwErq8aAm6a2b8hA/ohBlvVe/XbXkaIm6OLog4B7fUe/tFo2CEnOS7tiao8BXMxMm1G+G6WAPLxArqLJT1PjMbSoBFKIBlBkVU4PLxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ov6mhc8f; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ov6mhc8f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729164398; x=1760700398;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/J45AW9zfdu1PZFapwRpitxIzPtj3cxWYzgrpvi1fG0=;
  b=Ov6mhc8fsgLjLiLFVDbwkR/k9rUcSIfkbEbjZS1StErNW6xZG5GH52kA
   Hit9sCzM1Z6i/OzRNaxVRSOfOkyZ2+iV+auggIQntSLI5VIHSs1a2w83Q
   tPMM0Z1L66dinAcEC/9Iik9zCJduqga7Zx2+uIk8hm2Zi4RHke8WV8ZWf
   CP/GY4Nh2LC7PBqyt+Ulcql6bBiL5FQvi1zh4W87zy+zF5uV6c7LqNXw6
   8RbYUmRPuypc+uauLyoVNYFjUaLJh0lYYFAUpzczhi1R/mr8LCV27BbE0
   zVMf2cTmsX4TjmbDBwJTbyW2jA92tBmtHhXxwg3f/NX1y9YiA3nqSLE5q
   A==;
X-CSE-ConnectionGUID: Femf5HEwRZOF/Z4RQbTKUA==
X-CSE-MsgGUID: QO/oPcq4QL6fXqJnPij/0w==
X-IronPort-AV: E=McAfee;i="6700,10204,11227"; a="32443749"
X-IronPort-AV: E=Sophos;i="6.11,210,1725346800"; 
   d="scan'208";a="32443749"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 04:26:38 -0700
X-CSE-ConnectionGUID: mLFy6+3BTjmejeDkQtjVEQ==
X-CSE-MsgGUID: CjIDJWUeSQWabFKVLKwyRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,210,1725346800"; 
   d="scan'208";a="109268142"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.20.233])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 04:26:36 -0700
Date: Thu, 17 Oct 2024 13:26:31 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: Laurence Oberman <loberman@redhat.com>, "Hellwig, Christoph"
 <hch@infradead.org>, linux-raid@vger.kernel.org
Subject: Re: [PATCH] Add the ":" to the allowed_symbols list to work with
 the latest POSIX changes
Message-ID: <20241017132631.00004d46@linux.intel.com>
In-Reply-To: <CALTww29q5M_to+nN4G6rSdVMMbBj5orBjTE3dCUcBc6ZzAX1bg@mail.gmail.com>
References: <20241015173553.276546-1-loberman@redhat.com>
	<20241016101433.00005bb9@linux.intel.com>
	<5321cf0e579ee5e025396e9f9b62432dd2ed3458.camel@redhat.com>
	<CALTww29q5M_to+nN4G6rSdVMMbBj5orBjTE3dCUcBc6ZzAX1bg@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Oct 2024 17:24:59 +0800
Xiao Ni <xni@redhat.com> wrote:

> On Wed, Oct 16, 2024 at 9:11=E2=80=AFPM Laurence Oberman <loberman@redhat=
.com> wrote:
> >
> > On Wed, 2024-10-16 at 10:14 +0200, Mariusz Tkaczyk wrote: =20
> > > On Tue, 15 Oct 2024 13:35:24 -0400
> > > Laurence Oberman <loberman@redhat.com> wrote:
> > >
> > > Hello Laurence,
> > > Thanks for the patch.
> > >
> > > ":" is used internally by native metadata name, we have
> > > "hostname:name". We are
> > > searching for it specifically, for that reason I think that I cannot
> > > accept it.
> > > Name must stay simple.
> > >
> > > If you want this again, I need to full set of mdadm tests that is
> > > covering every
> > > scenario and is confirming that we are able to determine hostname (if
> > > exists)
> > > and name in every case correctly.
> > >
> > > There are some workaround in code for that, I can see that we are not
> > > appending
> > > homehost if ":" is in the name. It is not user friendly. I prefer to
> > > not
> > > allow ":" to keep in simpler unless you have really good reason to
> > > have it back
> > > - there is no reason in commit message.
> > >
> > > =20
> > > > Signed-off-by: Laurence Oberman <loberman@redhat.com>
> > > > ---
> > > >  lib.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/lib.c b/lib.c
> > > > index f36ae03a..cb4b6a0f 100644
> > > > --- a/lib.c
> > > > +++ b/lib.c
> > > > @@ -485,7 +485,7 @@ bool is_name_posix_compatible(const char *
> > > > const name)
> > > >  {
> > > >         assert(name);
> > > >
> > > > -       char allowed_symbols[] =3D "-_.";
> > > > +       char allowed_symbols[] =3D "-_.:"; =20
> > >
> > > Because the function has been made to follow POSIX, this cannot be
> > > simply added
> > > here. Please at least explain that in description.
> > >
> > > It is not POSIX compatible with this change.
> > >
> > > =20
> > > >         const char *n =3D name;
> > > >
> > > >         if (!is_string_lq(name, NAME_MAX)) =20
> > >
> > > Thanks,
> > > Mariusz
> > > =20
> >
> > Hello
> > Apologies Christoph and Mariusz, this could have definitely done with
> > more of an explanation.
> >
> > We have customers complaining about a regression in mdadm since these
> > changes happened. They have 1000's of raid devices that can no longer
> > be started because they have ":" in the name. Example
> > mdadm: Value "tbz:pv1" cannot be set as devname. Reason: Not POSIX
> > compatible.
> >
> > Should we add a --legacy flag where the original behavior is still an
> > option, what are your thoughts ?
> >
> > Regards
> > Laurence
> >
> > =20
>=20
> Hi Laurence and Mariusz
>=20
> Can we allow assemble an array whose devname has ":"? So the users can
> assemble the arrays which were created before patch e2eb503bd797
> (mdadm: Follow POSIX Portable Character Set).
>=20
> For creating an array, we can still follow the POSIX policy. So it can
> keep the naming rule simpler.
>=20

Thanks Xiao,

Please give me some time to reproduce and understand this case. I will find=
 some
time on monday, maybe tomorrow.

I hope that works for you guys.

Mariusz
