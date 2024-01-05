Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FF6250E7
	for <linux-raid@vger.kernel.org>; Fri,  5 Jan 2024 09:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kI9+B9Vs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704448727; x=1735984727;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2KkKqxuIAA5INOrR5c2jJjdKplze9tk/W2QDQ+V0fZ8=;
  b=kI9+B9VscjCJ/Iyq9ghTYtKI7mxvIZgkoz69Cw8eEXwsbR20VV03sXlk
   ealvPXKiF1aEnNkVbi/nKPPSIvQuspX1OFfhqSyRnILnyeonQSrsNlSjH
   3CEUh1GfXworjcATqHPFENqhE0GMy2/mN4qPFI369ZcVoyAqsAOarp6V8
   ZcObIftVtwCPy51WKoUvICCkGX2+oJpB17cHkbHQxbpL8fQeQxPrkyK0E
   m4EsOVgWM4QHfizWJEdGygna1aZPiBBkBrCZYUcub/TU0QYO/OaBKz2z5
   n6v7i496OU305ecglgCX+IPbWacIRSoOfshOl1GGH6F0t/r+JIy9iHOMq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="4845444"
X-IronPort-AV: E=Sophos;i="6.04,333,1695711600"; 
   d="scan'208";a="4845444"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2024 01:58:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="809503814"
X-IronPort-AV: E=Sophos;i="6.04,333,1695711600"; 
   d="scan'208";a="809503814"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.149.42])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2024 01:58:32 -0800
Date: Fri, 5 Jan 2024 10:58:27 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Song Liu <song@kernel.org>
Cc: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>,
 linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH mdadm] tests: Gate tests for linear flavor with variable
 LINEAR
Message-ID: <20240105105827.00007e96@linux.intel.com>
In-Reply-To: <CAPhsuW4L_nZwMfUYMzNg9_p5OyePpy2H2sFqC5-cVcHgFh48Sw@mail.gmail.com>
References: <20231221013914.3108026-1-song@kernel.org>
	<1faa5e2e-e4c6-4f82-9ceb-7440939bc167@linux.intel.com>
	<CAPhsuW4L_nZwMfUYMzNg9_p5OyePpy2H2sFqC5-cVcHgFh48Sw@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Dec 2023 00:12:43 -0800
Song Liu <song@kernel.org> wrote:

> On Thu, Dec 28, 2023 at 6:28=E2=80=AFAM Mateusz Kusiak
> <mateusz.kusiak@linux.intel.com> wrote:
> [...]
> >
> >  # create a raid0, re-assemble with a different super-minor
> > +
> > +if [ "$LINEAR" !=3D "yes" ]; then
> > +  echo -ne 'skipping... '
> > +  exit 0
> > +fi
> > +
> >  mdadm -CR -e 0.90 $md0 -llinear -n3 $dev0 $dev1 $dev2
> >  testdev $md0 3 $mdsize0 1
> >  minor1=3D`mdadm -E $dev0 | sed -n -e 's/.*Preferred Minor : //p'`
> >
> > Hi Song, this approach looks a bit dirty to me as it's omitting what's
> > already in the test suite. I would prefer adding additional param rather
> > than setting environment variable, so test execution flow stays unified=
 (as
> > far as I'm aware we do not use flags for now). Adding param is also a g=
ood
> > excuse to explain why linear is not tested by default in "--help". =20
>=20
> We have something similar to this in tests/00multipath, so I used
> this pattern.

Hi Song,

Please note that MULTIPATH env variable is handled inside testing
framework. This variable is set to yes if multipath module is available. It=
 can
be also disabled by --disable-multipath. It is described in help.

it is invoked by main() -> do_setup() -> check_env().

Now we need to handle both linear and multipath same way. There are two opt=
ions:
- disable them by default and add --enable-multipath and --enable-linear
  options,
- make linear to work same as multipath now, add --disable-linear flag.

I don't have strong preference. Both ways are acceptable for me.=20

You disabled testing those levels by default. It looks good to me but we ne=
ed
to explain it little in message to give user clue why those levels are
skipped. Test result should be possible straightforward for less experienced
users so please expand messages, like:
"Skipping, \$LINEAR set to \"$LINEAR\""

It i just an example, I didn't test it. The final message depends on
option you will choose.

Mdadm is a kind of user interface for MD driver. I expect that not only
developers are using this test suite. We need to keep it easy to use, messa=
ges
should be meaningful and helpful.=20

> >
> > Another thing is "--raidtype=3Dlinear" option, is probably redundant no=
w.
> >

Env variable are better implemented now than this --raidtype option. There =
is
more work to do to make --raidtype fully valid because --raidtype uses
filtering by test name. Test may define set of levels used, even if the name
doesn't point to any level. So yes, I think that we can eventually remove
--raidtype=3Dlinear as it is not really useful but I give it up to Song.

Thanks,
Mariusz
