Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBF213A879
	for <linux-raid@vger.kernel.org>; Fri, 26 Apr 2024 08:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714120609; cv=none; b=ltU46ZrW0S/auXZQSohsf1Holi90CM6EIZDqkfki+KUvG3Pak++9OBISKkc72UIhG0UHL4gSsk7p43f/OXjoalBMjYwQcT27FTW8rqPSJivftQ7WfJ3uRV2DSXp4J0RnG+pE2SMgoiwpOvLuq5ZtGci2/OlVBDHuisjMN6pTSdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714120609; c=relaxed/simple;
	bh=Qe9RfP52qopEkGAdklZw6dy0PRXblJBAOcckyTZu4C8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A8Lz3flrM+hJ3M2NBVbVcV2WaZ3pxNk3nEaAh4I7WTupO4nacQHVkiuV3e1ux6En/BjDUV2Vj5wAbJOi2/NW26RoazoBinLY8n3xKMUfBQdDvcDBJRu8ArnoQETUnzMnWcuW56vfwuokhBsYuCH6t4wP9qloSBj9bSTnP8/MoJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JL0NqtcH; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JL0NqtcH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714120608; x=1745656608;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qe9RfP52qopEkGAdklZw6dy0PRXblJBAOcckyTZu4C8=;
  b=JL0NqtcHSW4EZ9KERZUK3ftFvXi6RdJf29/URkpYqx4F2eoQbXLAhHnM
   8w8WVPb6ajslFQ3UMRXTtIWrtCbyarvofYyMOQJhA5hfboxP0oqLwHlcw
   I+4ZCuSE6rh/Cl9M4lOm3xpNkczbgHmchMxpgX5FKDGgfYEwVlA4ueaij
   H4fX+r0o1b1rw5WBsF2mqGOhjQ+0X+JLCMGIoz6yo6FfvGvAhFmw7G5g4
   hYO+HpCa3+r+dSk9KTsX40HgfQcj83jKa4Bp58wKPB1yeng0sSZ9YFF5s
   0zaR4C/mxsyDfOTQc03nQY0rYt/XTOjdnVbFmFLQ2W8rerTqtEejomOWQ
   w==;
X-CSE-ConnectionGUID: Y/i8cfzcTAK3pYBef3Lqgw==
X-CSE-MsgGUID: sLwmIkOZRG2q5YA/3he6rg==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="10063673"
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="10063673"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 01:36:48 -0700
X-CSE-ConnectionGUID: 6mtHI9PaRjenEVPhEe7v/g==
X-CSE-MsgGUID: NeCYTsXpQLGsbi0Y15A3+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="25362241"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.82.157])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 01:36:46 -0700
Date: Fri, 26 Apr 2024 10:36:40 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Paul E Luse <paul.e.luse@linux.intel.com>, Song Liu <song@kernel.org>,
 Kinga Tanska <kinga.tanska@linux.intel.com>, Jes Sorensen
 <jes@trained-monkey.org>, linux-raid@vger.kernel.org
Subject: Re: [PATCH 0/1] Move mdadm development to Github
Message-ID: <20240426103640.0000549e@linux.intel.com>
In-Reply-To: <f8044311-765d-4743-8b20-0d68a56044ec@molgen.mpg.de>
References: <20240419014839.8986-1-mariusz.tkaczyk@linux.intel.com>
	<f8044311-765d-4743-8b20-0d68a56044ec@molgen.mpg.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Apr 2024 08:46:18 +0200
Paul Menzel <pmenzel@molgen.mpg.de> wrote:

> Dear Mariusz,
>=20
>=20
> Thank for bringing this topic up for discussion. Unfortunately, I have=20
> to reply with negative comments.
>=20
>=20
> Am 19.04.24 um 03:48 schrieb Mariusz Tkaczyk:
> > Thanks to Song and Paul, we created organization for md-raid on Github.
> > This is a perfect place to maintain mdadm. I would like announce moving
> > mdadm development to Github.
> >=20
> > It is already forked, feel free to explore:
> > https://github.com/md-raid-utilities/mdadm
> >=20
> > Github is powerful and it has well integrated CI. On the repo, you can
> > already find a pull request which will add compilation and code style
> > tests (Thanks to Kinga!).
> > This is MORE than we have now so I believe that with the change mdadm
> > stability and code quality will be increased. The participating method
> > will be simplified, it is really easy to create pull request. Also,
> > anyone can fork repo with base tests included and properly configured.
> >=20
> > Note that Song and Paul are working on a per patch CI system using GitH=
ub
> > Actions and a dedicated rack of servers to enable fast container, VM and
> > bare metal testing for both mdraid and mdadm. Having mdadm on GitHub wi=
ll
> > help with that integration. =20
>=20
> Improved testing sounds good. Thank you. I do not think though, that=20
> using GitHub is a requirement for that, and there are a lot of bots on=20
> the Linux kernel mailing list doing this without GitHub.

Hi Paul,

At some point Paul Luse and Song Liu decided that they will choose Github f=
or MD
CI and Paul is busy working on creating dedicated Github runners for MD CI.
Moving mdadm development then is a logical next step as I want to reuse the
prepared hardware resources simple way.

>=20
> > As a result of moving to GitHub, we will no longer be using mailing list
> > to propose patches, we will be using GitHub Pull Requests (PRs). As the
> > community adjusts to using PRs I will be setting up auto-notification
> > for those who attempt to use email for patches to let them know that we
> > now use PRs.  I will also setup GitHub to send email to the mailing list
> > on each new PR so that everyone is still aware of pending patches via
> > the mailing list. =20
>=20
> In my experience, using GitHub for code review is far inferior to using=20
> mailing lists or Gerrit. First, you cannot comment on the commit=20
> message. As a result, projects using GitHub have a really low-quality=20
> git history. Also, you only cannot comment single parts of a line in the=
=20
> diff.

These are known limitations. I understand your objections here.

We have to accept them. Commits will be as good as maintainers cares about =
them.
Please keep in mind that except Intel, the activity around mdadm is low.
I'm receiving 1 patchset within 2 weeks. I can deal with those limitations =
and
I don't need customized and advanced solution with huge maintenance cost (at
least for now). If that will be changed- we will propose something else.

There are many Github actions we can setup to help us with review.

>
> The =E2=80=9Cone thread=E2=80=9D discussion model is also a pain, as most=
 people using=20
> Web forms do not correctly cite and quote, and with more than three=20
> answers you loose the overview. For some reason people think more about=20
> their reply, using mailing lists than Web forms.

We cannot ban less experienced users from participating. I want to make mda=
dm
development more attractive. I know that generally folks here are well
experienced in Linux netiquette, having github will change that.

It is another trade-off I agree to take.

>=20
> Using different forums for discussions should also not be allowed.=20
> People should just subscribe and monitor one forum.

For young developers Github is natural work environment. If they want to to
fill issue (as they do for thousand other projects)- they can. If github md=
adm
maintainers cannot support them, we will redirect them to mailing list for
wider audience.

>=20
> So, I strongly oppose this move, but I am also aware, that I am not=20
> doing a lot of development contribution.

The true is that mdadm is a small and "simple" userspace project. There is =
not a
tons of development around it. Please help me keep simple things simple.
We can achieve CI, (probably) "sufficient" review system and simplified well
known on market participating process in few clicks. Maintenance of review
solution will not belong to us (expect custom GH runners).

For these reasons, I see it a natural next step to grow but I'm also famili=
ar
with Github limitations. I have to deal with them in other projects I'm
maintaining or participating.=20

I also know that I can count of support from Linux Foundation in case of sp=
ecial
needs (like additional resources). That is also great.

Thanks,
Mariusz
