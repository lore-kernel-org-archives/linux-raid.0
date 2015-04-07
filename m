From: NeilBrown <neilb@suse.de>
Subject: Re: Help recovering an interrupted raid0 reshape
Date: Tue, 7 Apr 2015 16:30:04 +1000
Message-ID: <20150407163004.7550da77@notabene.brown>
References: <CAC_83AFDEijn-7gNmnWNNabzcuPRMabNwr8xfRFt0xacsvZfog@mail.gmail.com>
	<20150407094608.4a9dd142@notabene.brown>
	<20150407115033.1d63b65c@notabene.brown>
	<CAC_83AFo47Zfe7rMqro7_k8dR-xpMcfiwQA7a9DTKpKPuHr=fA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//9IA8Zka+SNyjfAdlwsCwkJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC_83AFo47Zfe7rMqro7_k8dR-xpMcfiwQA7a9DTKpKPuHr=fA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Jonathan Harker (Jesusaurus)" <jesusaurus@gentlydownthe.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_//9IA8Zka+SNyjfAdlwsCwkJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Apr 2015 22:14:56 -0700 "Jonathan Harker (Jesusaurus)"
<jesusaurus@gentlydownthe.net> wrote:

> On Mon, Apr 6, 2015 at 6:50 PM, NeilBrown <neilb@suse.de> wrote:
> > On Tue, 7 Apr 2015 09:46:08 +1000 NeilBrown <neilb@suse.de> wrote:
> >
> >> On Fri, 3 Apr 2015 19:22:15 -0700 "Jonathan Harker (Jesusaurus)"
> >> <jesusaurus@gentlydownthe.net> wrote:
> >>
> >> >
> >> > Third, is it possible to resume the reshape? If not, can it be rever=
ted?
> >> >
> >>
> >> I'll have to get back to you on that.  Hopefully you can be patient a =
little
> >> longer.
> >>
> >> NeilBrown
> >>
>=20
> Thanks for taking the time to look into this. I've managed to be
> patient with the problem for about a week now (I was cautiously poking
> and prodding the array for a few days before reaching out to this
> list) so I think I can manage a little more patience.
>=20
> >>
> >
> > Hi again Jonathan,
> >  please report what version of mdadm and of Linux that you are running.
>=20
> My mdadm version is "mdadm - v3.3.1 - 5th June 2014" and my linux
> version (according to `uname -r`) is 3.16.2-3.
>=20
> >
> > Also is there any chance that you tried
> >    mdadm --assemble .... --update=3Drevert-reshape
> > ??
> > And if you did, why didn't you say so :-)
>=20
> During those first couple days I tried a couple assemble and
> incremental commands to try to get the reshape to restart, though I
> don't remember exactly what they were. It's possible I tried something
> as scary and irreversible as --update=3Drevert-reshape in some desperate
> haze, so let's assume I did, but I was trying hard to avoid any advice
> that included --force in the command.

Try:
  mdadm -S /dev/md124
  mdadm -A /dev/md124 --update=3Drevert-reshape /dev/md/alpha /dev/md/beta
  mdadm -S /dev/md124
  mdadm -A /dev/md124 -vvv /dev/md/alpha /dev/md/beta /dev/md/gamma

What does that report?

NeilBrown


--Sig_//9IA8Zka+SNyjfAdlwsCwkJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSN5bDnsnt1WYoG5AQJoyQ/+KSjKbolugU76lyIZvADmlmoTZh1EKS/Q
XUrI/biBZlVAiTBCQv3SrpWDWsa90sZRQ37ELk8wab1JYUXnAIoW/KW09o7PKTEQ
OHpfasfLxNG3sC2oBshGXD9FKJNkExEakkWxXKZE09fJnGcWJeCp4Q+x4XQSTJqx
xrz9MBi6q9iK5e1OOcks5jOoPGg7Ntrs/FlXGN0CLVmSwFvOTaBrtml+IFFFeXHP
J5AGMYg03T9zuSyxiV4WI3fRbqNaAL8jRPODfn9qHmHFca7uAS7UXGeyk2RUB7Yz
e7b36I3tte8w8z4TTYrpXxWLan4Qc6+6SB8iRDsP5Yc+oNVCrvrJmZr70SjRSnI2
NXBSMD0Vops7cZwX1wbKbmtgiU3bmC0beBwYuOk/aVOyzotCNnRLDpQhz+6+n5Rv
HTPgb2snDsplu5ZwmX8GH44ezhTkBH0C/8jN48g4f/yx8sRs2AF7zliFmv77o91Q
c+ei4Qxa0kj4YFTT2T+vFN2vJWQdwPcJ2Efr98+dh0oKNnWm7zf4ufm9QiRlfJyD
dTlvpAQo7qr4T3hhfP3Wzche7ULpB7j9EiQ3Dgg6qVHjPWTNs3TvAmMiceKwAUbS
CiCm39qJcyO+kdnB/e5HVYXho5uOSUScU//Tv9YrltdQWqLERV6p0eq76tKX80qv
7Kx/lX4M0Sk=
=h5RH
-----END PGP SIGNATURE-----

--Sig_//9IA8Zka+SNyjfAdlwsCwkJ--
