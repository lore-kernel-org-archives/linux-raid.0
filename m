From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC PATCH 0/4] md/mdadm: introduce request function mode
 support
Date: Tue, 24 Jun 2014 17:09:01 +1000
Message-ID: <20140624170901.54cb3ae8@notabene.brown>
References: <20140602202050.14903534@notabene.brown>
	<1401901802-16296-1-git-send-email-sebastian.riemer@profitbricks.com>
	<53A040B5.5050008@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OlqN9tJcfpbG8giAGVm7lqw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53A040B5.5050008@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/OlqN9tJcfpbG8giAGVm7lqw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Jun 2014 15:20:53 +0200 Sebastian Parschauer
<sebastian.riemer@profitbricks.com> wrote:

> Hi Neil,
>=20
> have you already had the time to look at these patches?

I have now looked through them at last.  Sorry for the delay - there was a
week of leave in there and various other distractions.

The improved accounting is probably a good idea.  The extra malloc for each
request is a bit unpleasant.
For raid1 and raid10 we could use the r1_bio they already allocate to store
the extra data.  For raid5/6 we could possibly do something similar though
the results might be a little less precise.

For raid0 and linear I'd rather not intervene at all.  The underlying devic=
es
will report accurate statistics which can be combined to get correct
statistics for the overall devices.

The request function support is a bit of a mix.  In some ways it is quite
nice and localised.  However I'm not thrilled with the extra work queue, and
I don't really understand why md_process_request() allocates a new
md_request_clone and clones all the bios... I wonder if that is only needed
for RAID0, not for higher levels.


I still don't think any of this should  be applied to RAID0.  I asked about
that before and you didn't really provide an explanation.

RAID0 simply maps the bio to a different device and offset and sends it dow=
n.
So the queue management on the underlying device should be able to provide
all the fairness etc that you need.

So if you have RAID0 over RAID1, then I can understand the desire to use
requestfn rather than make_requestfn on the RAID1, but not on the RAID0.

Have you tried that configuration?  i.e. the RAID0 made without
--use-requestfn and the RAID1s made with it?  Does that work well as well as
with both arrays using requestfn??

The graphs you posted subsequently certainly look impressive, but I really
want to make sure I understand what is really needed.

Thanks,
NeilBrown




>=20
> We have this in production with cfq scheduler already on two storage
> servers and customers noticed a huge performance boost. Also our
> monitoring shows higher and smoother iop numbers.
>=20
> Cheers,
> Sebastian
>=20
>=20
> On 04.06.2014 19:09, Sebastian Parschauer wrote:
> > Patches apply to linux v3.15-rc8 and mdadm master commit 8a3544f895.
> >=20
> > Florian-Ewald Mueller (3):
> >       md: complete bio accounting and add io_latency extension
> >       md: introduce request function mode support
> >       md: handle IO latency accounting in rqfn mode
> >=20
> > Sebastian Parschauer (1):
> >       mdadm: introduce '--use-requestfn' create/assembly option
> >=20


--Sig_/OlqN9tJcfpbG8giAGVm7lqw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU6kkDjnsnt1WYoG5AQIsjxAAkpFTrTaYAqieYThj8eHrvdjzmgXS0MjJ
+eAFUuu9XrVXavQuLsClcJu7snubl1yqsrkvDL0WDRLAOkNv+YI/SVcgma+f6Tv/
Ipnh54yjTEkUf+9DwGFT5Hb700dUig6sOXpzkPxkPun+u/sg1AWjHIiCXaOdaFT4
iCil2A7ZnPwyCYWPVNIGT+BSllhL5BVI4oRLvnVf92OasEeB8US9pmMMb1TuCQXI
u31DulukjwkxywCqGMG60fft06TaYpG5LOlhVjIoPLcPWpfeSmFgzikExJFG/EQO
mr80MMYVAw8rdRsZAmSUotWJKoVEebGxl4XrA4n+ACSVtGHPB6mtDG67SXu+Bzxd
OPcG1IjS4K6cSGfjRvMyE7ItKF2lD6siowxkVEWqyTvUkATPER6xVcXPmdIGLFlE
Ijlk04Eb1d9r3DeUfp3oQZRVywyZPjaTVdVTZkKCvD2vBsSXXJGoJbg1ucERD6dg
cuWZsbXtBZdS2rh/ucPGr2zWRaPTwy1UofjMHbWFcaL9+hg5JvwoVW6ZNfUs9BNO
n2Wl+SN9CJhsf5PP7WpsiHLswyNY7lloDIyUh/pnS05HR2d0eIdUsVMSdDcSRCUl
Se43QAIymeAvnLIsWNcpmQ9NqorVr8fLyk3oTdL68Reesiwg1zRTC71NuMOostgn
qR/nnSSTgBw=
=bAXU
-----END PGP SIGNATURE-----

--Sig_/OlqN9tJcfpbG8giAGVm7lqw--
