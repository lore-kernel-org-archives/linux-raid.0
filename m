Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QDjeimSa"
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4DFA8
	for <linux-raid@vger.kernel.org>; Fri, 24 Nov 2023 04:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700827473; x=1732363473;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NEiox36NcWmJ/gH3fJXHCgAHDG/155kjruJi/y9ccX8=;
  b=QDjeimSaOU2Il0e84D4839UVADNYpz0yCDWXZLlinU0SSXruz8eKXiQm
   QdS+0w01IPnXy/4875UZhBpyJkYML4mxU7eF8mhwUaHNgz+UMqcMQC8kK
   zVP/NfeJg8F+cb+U4R9PNCeC1XBPT4jzxRDhuVP6odJSXOSOcn/bM5PpG
   idXbtGwVRjPJi3lVJ/uYh9P0hhsw23ppa1x8eg4+WrSVy4B/woYPMZdbh
   oVjd1Z1RKx0pQYvaF5MM0NcQI59zKcjGmMw0bzuHkUYl/JRsvq/eD30GC
   h5lHltRdPAgwZ2I3NPeZVSvq+ulYZ0udB86d0Fl3gDip8u7iwuOdWkqln
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="391288430"
X-IronPort-AV: E=Sophos;i="6.04,224,1695711600"; 
   d="scan'208";a="391288430"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2023 04:04:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="1099074162"
X-IronPort-AV: E=Sophos;i="6.04,224,1695711600"; 
   d="scan'208";a="1099074162"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.138.202])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2023 04:04:31 -0800
Date: Fri, 24 Nov 2023 13:04:26 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Erik =?ISO-8859-1?Q?Starb=E4ck?= <erik.starback@uppmax.uu.se>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: SMART-info used by mdadm/mdmon?
Message-ID: <20231124130426.00006609@linux.intel.com>
In-Reply-To: <e7dd3ccf8b7c42298b49f17b3ba0794c@uppmax.uu.se>
References: <e7dd3ccf8b7c42298b49f17b3ba0794c@uppmax.uu.se>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Nov 2023 10:41:37 +0000
Erik Starb=E4ck <erik.starback@uppmax.uu.se> wrote:

> Hi!
>=20
> I try to understand if mdadm/mdmon use SMART-information to realize if a =
disk
> is broken (or will soon be broken), or if they only use more concrete
> information about read/writes and different response times to kick out a =
disk
> from a mdadm-raid.

Hello Erik,
No mdadm and mdmon do not use SMART to make decision about disk in raid
array. I think that it is not a task for mdadm to do so. mdadm is a MD mana=
ger-
it cares about making requesting action possible when the problem is you as=
king
about it more predicting drive failure.
mdadm will complete the action requested by other utility which may be
projected to track and analyze SMARTs.

mdadm reacts on "remove" event triggered by udev so it means that device
must be removed by the device driver first.
Another way is high error rate from device - in this case MD drives kicks o=
ut
the drive itself. However it is rather sporadic and happens only on certain
conditions like high workload.

Hope it is helpful!
Mariusz
>=20
> /Erik Starb=E4ck, UPPMAX Uppsala University
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
> N=E4r du har kontakt med oss p=E5 Uppsala universitet med e-post s=E5 inn=
eb=E4r det
> att vi behandlar dina personuppgifter. F=F6r att l=E4sa mer om hur vi g=
=F6r det kan
> du l=E4sa h=E4r: http://www.uu.se/om-uu/dataskydd-personuppgifter/
>=20
> E-mailing Uppsala University means that we will process your personal dat=
a.
> For more information on how this is performed, please read here:
> http://www.uu.se/en/about-uu/data-protection-policy
>=20

