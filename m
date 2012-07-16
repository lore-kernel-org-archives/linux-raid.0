From: NeilBrown <neilb@suse.de>
Subject: Re: commit backport request
Date: Mon, 16 Jul 2012 13:23:00 +1000
Message-ID: <20120716132300.11fad63c@notabene.brown>
References: <20120709140230.3cf926ec@notabene.brown>
	<20120711220740.GE10930@kroah.com>
	<20120712141422.05809022@notabene.brown>
	<CAGRgLy4tBOS1B8raJmxoge1CaWc-18=c_fMe6E_oCqa1ntSHzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aPRFa33bn_DTpppW97p8.AW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4tBOS1B8raJmxoge1CaWc-18=c_fMe6E_oCqa1ntSHzQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/aPRFa33bn_DTpppW97p8.AW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Jul 2012 00:28:00 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi,
> Is there any indication that can tell I am hitting this particular issue?
> I think I hit something similar to that once, IOs were hang within a
> raid5 and not returning. I issues w > sysrq-trigger and also have most
> of the procfs/<pid> info, so is there something I can look at to
> confirm?

IO stops, processes get blocked in get_active_stripe().  Increasing
stripe_cache_size allows a bit more IO through it eventually all fills up
again.

NeilBrown

>=20
>=20
>=20
> On Thu, Jul 12, 2012 at 7:14 AM, NeilBrown <neilb@suse.de> wrote:
> > On Wed, 11 Jul 2012 15:07:40 -0700 Greg KH <gregkh@linuxfoundation.org>=
 wrote:
> >
> >> On Mon, Jul 09, 2012 at 02:02:30PM +1000, NeilBrown wrote:
> >> >
> >> > Hi Mr Stable,
> >> >
> >> >  please apply patch
> >> >
> >> > commit fab363b5ff502d1b39ddcfec04271f5858d9f26e
> >> > Author: Shaohua Li <shli@kernel.org>
> >> > Date:   Tue Jul 3 15:57:19 2012 +1000
> >> >
> >> >     raid5: delayed stripe fix
> >> >
> >> >
> >> > to 3.4.y and 3.2.y.
> >> >
> >> > It fixes a deadlock in RAID5 which can cause all IO to hang.
> >> > It has been demonstrated to fix a real-life problem (the race is not
> >> > theoretical).
> >>
> >> Is it also needed for 3.0.x?  It seems to apply there just fine.
> >
> > Yes it is.  Don't know why I missed that.
> > I see you've already included it - thanks.
> >
> > NeilBrown


--Sig_/aPRFa33bn_DTpppW97p8.AW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAOJFDnsnt1WYoG5AQKCTA/9FKM7GzFN0ve5hEeXuj6d5yr558V0JnsP
OEqADLyKhxH/0RV/AxN/+CJWu2yEHqXDYAi4y5DIzVRlUU/ddSebe9ejNAT9wpkR
PQEjgZHNFNXB50rIlKwIJBHwYUm09v9FfPndYYtQbyZerG7HQYjxcQB0vxkjykix
48ccg1oFpUn4wmpebrMMPdAYDMOoP29fed5AodfmrEkNI7fk58051fIpuVvRJROC
BqRzCRojpBzsMuLUp6s4AV3fLmrPheH/pcR8uuMMsuxSLrtsi1yzpvFKaIz+zGrg
8ZRvJd7sXoNFP+PX5eaUp/ZX8R+9Y4aW2xFF0TrZ8Q6riiWHN0u4T52+ic9+IcW4
H6X6FjvvMHYqoU2Z66Cjpo26oaNio1hWCid7zRK2O92ZhnLbmHy540eR4YJd5nrJ
AK4suqdXIKnicD47LtGXIpMAh/5rhckc1FWObOtuPGxHs9xFhfgvCXT7sBFPzdyX
5nFbDPxYEPoygQI6qEBrBPPY8RzyBmdHdgYNf1Vlrl9cxEspWbLyQBIo7XPIsb81
/tUwwcXqSzgCqLkdWkGTATNY2sF5bOc1vyOg/cB8XkCBPi1KV4tsXjrghLt7sXNG
nX/KcFJdDyjGHBWlgXmacjNLmGefQWmwT97EgYv1gURyzu8osQSoyqDXAr1H/D2j
/4sqn03oYGM=
=s0oP
-----END PGP SIGNATURE-----

--Sig_/aPRFa33bn_DTpppW97p8.AW--
