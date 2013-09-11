From: NeilBrown <neilb@suse.de>
Subject: Re: write-refresh md array (feature request)
Date: Thu, 12 Sep 2013 09:05:48 +1000
Message-ID: <20130912090548.5613ab26@notabene.brown>
References: <20130910181905.GC21530@khazad-dum.debian.net>
	<CAA9_cmc+hJ9MrGyZDRXbUPNPcpgwm1RNvWQ4yX65zqKZy4puuQ@mail.gmail.com>
	<20130911123222.GA1736@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Jh15iB6iAlbe1Femq2SwmW+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130911123222.GA1736@khazad-dum.debian.net>
Sender: linux-raid-owner@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Jh15iB6iAlbe1Femq2SwmW+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Sep 2013 09:32:23 -0300 Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:

> On Tue, 10 Sep 2013, Dan Williams wrote:
> > On Tue, Sep 10, 2013 at 11:19 AM, Henrique de Moraes Holschuh
> > <hmh@hmh.eng.br> wrote:
> > > (please CC me on replies).
> > > I've been in several situations where it would have been helpful to b=
e able
> > > to refresh weak sectors by rewriting the whole md raid component devi=
ce,
> > > without the need to increase array failure risk through a fail+remove=
+add
> > > cycle for the component device.
> > >
> > > How difficult would it be to implement a "refresh" as a Linux md driv=
er
> > > sync_action, pigging back on "check" ?
> > >
> > > Are there any drawbacks to write-refreshing component devices?
> > >
> >=20
> > Why is "check" insufficient?  If it trips over any bad sectors it will
> > re-write them.
>=20
> The idea is to rewrite the sector _before_ it goes bad.
>=20
> Consumer SATA HDDs nowadays not only apparently fail to properly remap
> sectors because they don't track anymore that some sectors in that subtra=
ck
> were reported uncorrect a number of times (and thus are "weak").  They al=
so
> appear to not write-refresh sectors that required ECC correction, except
> maybe during an offline SMART test routine.
>=20

My view on this is that it has nothing to do with RAID.  If it is valuable =
to
"write-refresh" a device in a RAID array, then it would equally make sense =
to
write-refresh a device that wasn't in a RAID array.

So any solution to this should try to address the whole problem.

NeilBrown

--Sig_/Jh15iB6iAlbe1Femq2SwmW+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUjD3TDnsnt1WYoG5AQJxwQ//TWSH67qrrGz3+LsoRtrCYvhsHG5CpPca
no/ahhTmNv91bEtaus9P8Gya0JXOQx4X2prF7UeWoYDOwqEn8C97RMAj+OXbQr+V
l4AgxpQrQhn+furmCj4j+rEIB0otjMyLK8S8cusVWtCGZHTFWWrHZhHwd9D1Ukwg
TvIOtJvXzJLTVG48tH28bp08mV6ixwd/wyrbMYa1mF4+e9QLUH8Yi/9hqp9Sp1ol
Sgy6ntBYa70/SmUM7rAu7azlytwagFdriXvyxmiHc2soTPssWaiiDEABD05KyzMN
C5KM5iKoKaaYso0+PAwRO5gVuOokmejHgBUrcU2wGlmSH7YmNMEV9aJQaqj4llNW
Lw2PCUdg3UUdbnb8etDbeOiklsH6NVpPy5WeYM1XO7in4SNtJQEpvJ8Ox3M5FpeQ
HbRMrm4KnOHXEZ83RupJ6zMZ9ke8qk4okAyHCXWxKIMeRIWUgTxzFD+lP617hgjf
ELoC4fbHAfJcRxs4eTF/rtG8pCipm16wrVyrj05xejBw8vzaK73b1pwvqoXJziam
+iascjibBd6nOcOJVla9v/ip+cIUOGo5ltpJOa+P73+YjSyjcaGjToEhLKTiGU0G
0QzGcswlmyWS5faGsIGZbJtDptmTJacWwaxnnW02BRsQOE9bNxVwrN9A471JfRVc
VG+H/xGucIw=
=IvBn
-----END PGP SIGNATURE-----

--Sig_/Jh15iB6iAlbe1Femq2SwmW+--
