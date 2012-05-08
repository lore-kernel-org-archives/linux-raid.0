From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC]md: using GFP_NOIO to allocate bio for flush request
Date: Wed, 9 May 2012 06:14:18 +1000
Message-ID: <20120509061418.0ee36272@notabene.brown>
References: <4F8BAED6.9090105@kernel.org>
	<20120508101800.GB9757@kernel.org>
	<CAA9_cmc4eT=uwXNdupkxK9_NWW4TLVab5-NBojL9PydHs73zfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CDHMQ_VPKhvMcGfwg/L2AhH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmc4eT=uwXNdupkxK9_NWW4TLVab5-NBojL9PydHs73zfA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Shaohua Li <shli@kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/CDHMQ_VPKhvMcGfwg/L2AhH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 8 May 2012 12:31:18 -0700 Dan Williams <dan.j.williams@intel.com>
wrote:

> On Tue, May 8, 2012 at 3:18 AM, Shaohua Li <shli@kernel.org> wrote:
> > On Mon, Apr 16, 2012 at 01:32:06PM +0800, Shaohua Li wrote:
> >>
> >> flush request is issued in transaction commit code path usually, so
> >> looks using
> >> GFP_KERNEL to allocate memory for flush request bio falls into the cla=
ssic
> >> deadlock issue. dm already gets it right.
> > ping!
> >
>=20
> This one should probably also be queued for -stable right?

I suspect so.

I've edited the commit-log message slightly and added a 'cc' for stable,
It is now in my for-next branch.  I'll push to Linus next week.

Thanks Shaohua,

NeilBrown

--Sig_/CDHMQ_VPKhvMcGfwg/L2AhH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6l+mznsnt1WYoG5AQLadBAArWqCrfTnhjZJ1E19STMKFB/Hk+vo98u+
+HuBnRyi5orXV4DiTRY/x5nKmrdRP/j9tPKUsSQOHntZC09zWDy2NwDZdxJ1xhc8
TlOAt1mEAb+mWD7Dgp1IgPBSVn2Bb/qwPWE6chqR2BbE+m1kPy4bPtEsbyiHEC+5
XDYO8vpJpoJ3QmOe2cWAC3BjYeKmd9EVFwrza0/JIvJlFp/mFVU1WRkNSAjkq2xy
huANZDW6ga8nOvRX7qi1KIwV5TSdwdgrg1jn2TnoOCBRIFvHGRMNRuscLPTQSdP6
eU7RnHtcEMkwZvoDDDpvN8ZXmg1kPmdue0j3v37wuqiUd2ul65EtDuAsAIeTQHRc
BI27PSK4inv8Yq/9G+h4RReQoS+iEVAKYTRXREHMgjDgku/3H9h2juoRY0j5yqG2
d8xLqbih4jePOQS2BkWLsuMaq2cy3YuaZXbU2YELlbKJF1qFbIp2vIIatq7GoqW+
3MSLcOG8a2E+r9nPovJA6tZMnvj/vBbSg8T4PnxBBfofD2QcwjPoNWfFYrEPrvqX
MIx7G0x5eCrmxeBoJeheGmZvHcA7VMMQfkBu8JvfE8c9AhANvFmsZPkrJ54UA/Iu
XxYi5vo9532Jl8ePNRvOUqwAthhC7DJoSXljXIVKy4EXVPHKcaHFTKJD/LgTRM1g
Yob9e85iJ44=
=kbQF
-----END PGP SIGNATURE-----

--Sig_/CDHMQ_VPKhvMcGfwg/L2AhH--
