Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD66BE5B
	for <linux-raid@vger.kernel.org>; Mon,  8 Jan 2024 08:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E5rTNpw5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704703164; x=1736239164;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lwFCZmqyZV4o3mieeVGuRxhMITrnH9n4tI83z+gvuXs=;
  b=E5rTNpw5hz/fWt86yCa3DXtCV/XMmPF6CSeW9NTK5l7VQb7mdAt8Adfs
   U5c8AtTyR3mUcCNLga2meQpS712fxtzFimVW7eJt/VL1XzQxR8bQRF6wd
   SqxymjgNxDq/TSU0m6d9g+keCMHqYJ2qc+8sBfb1m+3H6N2Iu13in31FA
   psO0uRLttMl2GZc9WUWFOqzDUVAAxbewjLOrBxwWovtrakD0VHRA6Gj3P
   naOEmc8WruwM3eFM63VB0Lul2PrfqcK7RPBae1ooCiu3B9Ern5uOfFVR5
   lOh4JjgeuNXDkHXwW08UnhJiDXThpvOpDxTaA0W46nrG8954hV0BcfxxD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10946"; a="4583869"
X-IronPort-AV: E=Sophos;i="6.04,340,1695711600"; 
   d="scan'208";a="4583869"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 00:39:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10946"; a="784793569"
X-IronPort-AV: E=Sophos;i="6.04,340,1695711600"; 
   d="scan'208";a="784793569"
Received: from sfiros-mobl.ger.corp.intel.com (HELO localhost) ([10.249.133.118])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 00:39:22 -0800
Date: Mon, 8 Jan 2024 09:39:16 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Song Liu <song@kernel.org>
Cc: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>,
 linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH mdadm] tests: Gate tests for linear flavor with variable
 LINEAR
Message-ID: <20240108093916.00006b6e@linux.intel.com>
In-Reply-To: <CAPhsuW5_tidq_kh7NEzBvvyLQZX4cRj3vE8L=g7y1-HxM8DUzA@mail.gmail.com>
References: <20231221013914.3108026-1-song@kernel.org>
	<1faa5e2e-e4c6-4f82-9ceb-7440939bc167@linux.intel.com>
	<CAPhsuW4L_nZwMfUYMzNg9_p5OyePpy2H2sFqC5-cVcHgFh48Sw@mail.gmail.com>
	<20240105105827.00007e96@linux.intel.com>
	<CAPhsuW5_tidq_kh7NEzBvvyLQZX4cRj3vE8L=g7y1-HxM8DUzA@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 5 Jan 2024 15:18:07 -0800
Song Liu <song@kernel.org> wrote:

> Hi Mariusz,
>=20
> Thanks for these explanations.
>=20
> On Fri, Jan 5, 2024 at 1:58=E2=80=AFAM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> > =20
> [...]
> >
> > It i just an example, I didn't test it. The final message depends on
> > option you will choose.
> >
> > Mdadm is a kind of user interface for MD driver. I expect that not only
> > developers are using this test suite. We need to keep it easy to use,
> > messages should be meaningful and helpful.
> > =20
> > > >
> > > > Another thing is "--raidtype=3Dlinear" option, is probably redundan=
t now.
> > > > =20
> >
> > Env variable are better implemented now than this --raidtype option. Th=
ere
> > is more work to do to make --raidtype fully valid because --raidtype us=
es
> > filtering by test name. Test may define set of levels used, even if the=
 name
> > doesn't point to any level. So yes, I think that we can eventually remo=
ve
> > --raidtype=3Dlinear as it is not really useful but I give it up to Song=
. =20
>=20
> How about we add something like the following on top of this patch?
>=20
> Thanks,
> Song
>=20
> diff --git i/test w/test
> index b244453b1cec..49a36c3b8ef2 100755
> --- i/test
> +++ w/test
> @@ -140,6 +140,7 @@ do_help() {
>                 --raidtype=3D
> raid0|linear|raid1|raid456|raid10|ddf|imsm
>                 --disable-multipath         Disable any tests
> involving multipath
>                 --disable-integrity         Disable slow tests of
> RAID[56] consistency
> +               --disable-linear            Disable any tests involving l=
inear
>                 --logdir=3Ddirectory          Directory to save all logfi=
les in
>                 --save-logs                 Usually use with --logdir tog=
ether
>                 --keep-going | --no-error   Don't stop on error, ie.
> run all tests
> @@ -255,6 +256,9 @@ parse_args() {
>                 --disable-integrity )
>                         unset INTEGRITY
>                         ;;
> +               --disable-linear )
> +                       unset LINEAR
> +                       ;;
>                 --dev=3D* )
>                         case ${i##*=3D} in
>                         loop )
> diff --git i/tests/func.sh w/tests/func.sh
> index 5053b0121f1d..d7561f3c20cf 100644
> --- i/tests/func.sh
> +++ w/tests/func.sh
> @@ -123,6 +123,14 @@ check_env() {
>         modprobe multipath 2> /dev/null
>         grep -sq 'Personalities : .*multipath' /proc/mdstat &&
>                 MULTIPATH=3D"yes"
> +
> +       # Check whether to run linear tests
> +       modprobe linear 2> /dev/null
> +       grep -sq 'Personalities : .*linear' /proc/mdstat &&
> +               LINEAR=3D"yes"
> +       if [ "$LINEAR" !=3D "yes" ]; then
> +               echo "test: skipping tests for linear, which is
> removed in upstream 6.8+ kernels"
> +       fi
>  }
>=20
>  do_setup() {

Approach looks good to me but multipath case handling is missed. Can we add=
 a
message for Multipath?

Thanks!
Mariusz
