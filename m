Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF3A7BAE3
	for <linux-raid@vger.kernel.org>; Wed,  8 May 2024 08:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715157456; cv=none; b=pigflgbExVdv95+9E1j5wR9WPhBPfVKc93NzsjhTqXWTkBZ6agUxZ4EOKZ9xwmPVNV02H5VT1E7pSobuPcM+12gbGWIBZJlmLpqjXrxLvfbpjhlUOUlpKSXE41fd4fn+pLAj8o+O8gLyRTfDll5xHSqDxEatjuqzy7oznpgzKRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715157456; c=relaxed/simple;
	bh=eM7WfiAYcQvBYpaXBKJF5kyzeT3Bpg1rUa7C/LJ3yc4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IJLUv4f8woYQS6saprr2BTmUmWcnRoP4nbUaxcrE260SMGVcYttc80sS/qxlKsqvm2xfERy2LUFjefoYG8FboEnoe1RaA1c/dVILOndqZqLPZZebD0qvYr/PLT7tnNzFoXoK8b2nMuU0OknfVMDu2aLz+8wYCUKEuwUD+yIEyPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QHl4cfK7; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QHl4cfK7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715157455; x=1746693455;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eM7WfiAYcQvBYpaXBKJF5kyzeT3Bpg1rUa7C/LJ3yc4=;
  b=QHl4cfK7xVQKIqEB/OHJsosmM2pbNRvnIdO9Jm9dxZk35rIpyYQ/L1uk
   8Uz87mIE/Y12Am7AkWW/tkZohVjZdGB4HNxMYSj5RAFHWJylCz81V2lmE
   Yod1f5YfaOCsGn6GQ4D5hZDkQuAAymoC0BxENyC32i9abKDk1CWhAGWEM
   9rqJejWR8PmEALOW9pqm0iJroml3KYa3SK+jJuLwUtRYEX5nj5LehBBgi
   2HJ9LvRZrP3/IAt1ms4dLSwdcLrj8NUCa2ff0/hhseeUO20XKwFMzG4R7
   Gd38qOJxE5wZ5Squ9No6q8J2GAzQhxYJxVgJe3q1ZaO/fO6ZUlSHyQfQO
   Q==;
X-CSE-ConnectionGUID: wBQe4XmBRx+HK2itFZb7BQ==
X-CSE-MsgGUID: Q1fNujyMQ1GSMDhZDg6R9Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="28478782"
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="28478782"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 01:37:34 -0700
X-CSE-ConnectionGUID: QM1invU7S3Wo3BhyDPw0nQ==
X-CSE-MsgGUID: n3qUbIIYSfSM2ROl6VXiNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="29344049"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.29.120])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 01:37:32 -0700
Date: Wed, 8 May 2024 10:37:27 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 jes@trained-monkey.org, yukuai1@huaweicloud.com, ncroxon@redhat.com,
 colyli@suse.de
Subject: Re: [PATCH 5/5] tests/01raid6integ.broken can be removed
Message-ID: <20240508103727.000017bb@linux.intel.com>
In-Reply-To: <CALTww2_T1h5HpdzmTBx8N++V5wM_s4f-o7_mBcw4N0iZ5fOixA@mail.gmail.com>
References: <20240418102321.95384-1-xni@redhat.com>
	<20240418102321.95384-6-xni@redhat.com>
	<20240419120555.00002b95@linux.intel.com>
	<CAPhsuW5SihA0czyJUdG6XNhx4c+=W_XksoQS7cJ30chkBLgW4Q@mail.gmail.com>
	<CALTww2_T1h5HpdzmTBx8N++V5wM_s4f-o7_mBcw4N0iZ5fOixA@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Apr 2024 21:54:14 +0800
Xiao Ni <xni@redhat.com> wrote:

> On Fri, Apr 19, 2024 at 11:58=E2=80=AFPM Song Liu <song@kernel.org> wrote:
> >
> > On Fri, Apr 19, 2024 at 3:06=E2=80=AFAM Mariusz Tkaczyk
> > <mariusz.tkaczyk@linux.intel.com> wrote: =20
> > >
> > > On Thu, 18 Apr 2024 18:23:21 +0800
> > > Xiao Ni <xni@redhat.com> wrote:
> > > =20
> > > > 01raid6integ can be run successfully with kernel 6.9.0-rc3.
> > > > So remove 01raid6integ.broken.
> > > >
> > > > Signed-off-by: Xiao Ni <xni@redhat.com>
> > > > --- =20
> > > I don't follow the *.broken file concept. We could also describe that=
 in
> > > comment in the test, so LGTM for the changes.
> > >
> > > If you want to, you can remove all *.broken files and add some commen=
ts
> > > in test instead. If we have some tests failing marked as broken long =
time
> > > ago, you can either remove those scenarios as we are obiously not
> > > interested in fixing those scenarios. =20
> >
> > test script has options to skip broken tests (--skip-broken,
> > --skip-always-broken).
> > If we remove all the .broken files, we need to update the script to han=
dle
> > comments in the test file.
> >
> > Thanks,
> > Song
> > =20
>=20
> Hi all
>=20
> I'll try to fix all the broken test cases this time and remove the *.brok=
en
>=20
> Thanks
> Xiao
>=20
>=20

Anyway, this one removes one .broken file so applying!

Thanks,
Mariusz

