Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CA618C17B
	for <linux-raid@vger.kernel.org>; Mon, 15 Jul 2024 14:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721054069; cv=none; b=UIftK9adRA4J+N4RosEYNj3qmcqdMc1Ol8dVDPX3SmhsdP1Fj4juXniAt84iKUflbqLXwC3KKnjTRN4QqFNUoiOuoKtdvZj+ZuzbeLDJmoW+bm4Fsoc1b2VsfUPKjminz9RpTNSw4NKoEgttogfiFIz2EQx8rDUnUgQVwwE+7ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721054069; c=relaxed/simple;
	bh=tkU+wIi2KgoQqqOObBr27B3a4z3i6OAkahjnIo3nQek=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MsRc4iUS5kIGIKYClSplEe9jzSO0Kv/2ocHrwhrfDOgSnAK0g1Jx2OwvxLaW6u4mozSOQpcUpdvhPfI/3lea/EUoM7PfKQHiLMJ2iDTgV3cHLZQhw3+USFA1A4hsp2038QPnC803youppXPqypy5Yp25BvoGKIrJh4t11unAIDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QSL1oucX; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QSL1oucX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721054069; x=1752590069;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tkU+wIi2KgoQqqOObBr27B3a4z3i6OAkahjnIo3nQek=;
  b=QSL1oucXDik8V5NqQsUS+q3jbGHTKLgIAK6fLm9bxD6fLiakic7GIZW+
   UsoWVLL4hMFoikJYs0nLK309qJSu0mJcZ1qHS095QG+z0fToBw74WMv/3
   4rnoO6leLZAEw/JPpVblElLWYYqN9ln5FOKJVsqI6JrEugul7O8VZ6/RT
   v3vEOOO9zx3sDoZu8hwLDsHPPJvY3fRKrpYUeEJHAS8BcCBYzct1KGqqx
   far/mfs4XltUFxYHKT7PVygkmjzjxOvlgfyLOPIlm929+StfRet36gny4
   ATChg15xeMSUBwKPbHi/Er3IF8TLB6aFHuyQzIbksPz1HRJkXbC268dsK
   Q==;
X-CSE-ConnectionGUID: 4yPUo1qzRHqaiAvse6bZTg==
X-CSE-MsgGUID: NONiMMC8Q4qOabtlPxOnlg==
X-IronPort-AV: E=McAfee;i="6700,10204,11134"; a="29825296"
X-IronPort-AV: E=Sophos;i="6.09,210,1716274800"; 
   d="scan'208";a="29825296"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 07:34:28 -0700
X-CSE-ConnectionGUID: DPau6MUZTvKDvqm4Oh+JfA==
X-CSE-MsgGUID: ngYycLW2Q6a8YA5AwoQghQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,210,1716274800"; 
   d="scan'208";a="49532425"
Received: from marekdux-mobl5.ger.corp.intel.com (HELO localhost) ([10.237.142.63])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 07:34:27 -0700
Date: Mon, 15 Jul 2024 16:34:21 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Justinas =?utf-8?Q?Naru=C5=A1evi=C4=8Dius?= <contact@junaru.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: Possibly wrong exit status for mdadm --misc --test
Message-ID: <20240715163421.000036b4@linux.intel.com>
In-Reply-To: <ZpSsuO1hhmCKrexX@bbqfortress>
References: <ZpSsuO1hhmCKrexX@bbqfortress>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Jul 2024 07:59:36 +0300
Justinas Naru=C5=A1evi=C4=8Dius <contact@junaru.com> wrote:

> Hello,
>=20
> After reboot raid1 array with one failed drive is reported as degraded
> (failed drive reported as removed):
>=20
> > root@rico ~ # mdadm --detail /dev/md127
> > /dev/md127:
> >            Version : 1.2
> >      Creation Time : Thu Feb 21 13:28:21 2019
> >         Raid Level : raid1
> >         Array Size : 57638912 (54.97 GiB 59.02 GB)
> >      Used Dev Size : 57638912 (54.97 GiB 59.02 GB)
> >       Raid Devices : 2
> >      Total Devices : 1
> >        Persistence : Superblock is persistent
> >
> >        Update Time : Mon Jul 15 07:25:12 2024
> >              State : clean, degraded
> >     Active Devices : 1
> >    Working Devices : 1
> >     Failed Devices : 0
> >      Spare Devices : 0
> >
> > Consistency Policy : resync
> >
> >               Name : sabretooth:root-raid1
> >               UUID : 1f1f3113:0b87a325:b9ad1414:0fe55600
> >             Events : 323644
> >
> >     Number   Major   Minor   RaidDevice State
> >        -       0        0        0      removed
> >        2       8        2        1      active sync   /dev/sda2 =20
>=20
>=20
> However testing such state with mdadm --misc --test returns 0
>=20
>=20
> > root@rico ~ # mdadm --misc --test /dev/md127
> > root@rico ~ # echo $?
> > 0
> > root@rico ~ # =20
>=20
> From man page:
>=20
> > if the --test option is given, then the exit status
> >               will be:
> >               0      The array is functioning normally.
> >               1      The array has at least one failed device.
> >               2      The array has multiple failed devices such that it=
 is
> > unusable. 4      There was an error while trying to get information abo=
ut
> > the device. =20
>=20
> From --help output:
>=20
> > root@rico ~ # mdadm --misc --help| grep test
> >   --test        -t   : exit status 0 if ok, 1 if degrade, 2 if dead, 4 =
if
> > missing =20
>=20
> Would expect the exit code to be 1.
>=20
> Can anyone confirm this is expected behaviour?
>=20
> > root@rico ~ # mdadm -V
> > mdadm - v4.3 - 2024-02-15
> > root@rico ~ # =20
>=20
> --
>=20
> Regards,
> Justinas Naru=C5=A1evi=C4=8Dius
>=20

Hello,
This is old functionality but from what I can see it has sense if you are
sending Manage command like mdadm --remove. This --test command shouldn't
be used separately and that is why it is not working for you.

Thanks,
Mariusz
