From: NeilBrown <neilb@suse.de>
Subject: Re: Optimal chunk size for RAID5?
Date: Mon, 23 Feb 2015 08:53:58 +1100
Message-ID: <20150223085358.302830d1@notabene.brown>
References: <mccemd$8pi$1@ger.gmane.org>
	<20150222173047.1ea65d67@natsu>
	<CAB-428=7y-KSbCeXo6y6o5Jfzgf-5h6pfYxY+4Z74bqYp=oMUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/g+WnCBYyawu=bAt671D/.SV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB-428=7y-KSbCeXo6y6o5Jfzgf-5h6pfYxY+4Z74bqYp=oMUg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alireza Haghdoost <alireza@cs.umn.edu>
Cc: Roman Mamedov <rm@romanrm.net>, Christer Solskogen <christer.solskogen@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/g+WnCBYyawu=bAt671D/.SV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Feb 2015 08:33:02 -0600 Alireza Haghdoost <alireza@cs.umn.edu>
wrote:

> On Sun, Feb 22, 2015 at 6:30 AM, Roman Mamedov <rm@romanrm.net> wrote:
> > On Sun, 22 Feb 2015 12:31:23 +0100
> > Christer Solskogen <christer.solskogen@gmail.com> wrote:
> >
> >> There are so many different views on the internet
> >
> > ...and yet you're asking for some more? :)
> >
> >> Is there even such a thing as optimal chunk size?
> >
> > 64K should be fine:
> > http://louwrentius.com/linux-raid-level-and-chunk-size-the-benchmarks.h=
tml
> >
>=20
> I have seen that people report 64K chunk size results better
> performance. However, I was not able to find why mdadm maintainers
> decided to switch into 512K default chunk size a few years ago ? Was
> that decision related to the write-intent bitmap overhead ?

No, write-intent-bitmap sizing is completely independent from chunk sizes.

I don't remember the detail for the change, but some measurement must have
gone faster with larger chunk size.

single threaded loads tend to prefer large chunk sizes.
multi-threaded small-request random IO tends to prefer smaller chunk sizes.

There is no "Optimal" without reference to a particular work load.  Or
particular hardware.

NeilBrown



--Sig_/g+WnCBYyawu=bAt671D/.SV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOpQADnsnt1WYoG5AQJs1RAAmgemmMd1g3oStyTQyoHkApPn7ZI1fVuV
3Cul4ML99mvMTHOS9b7AQ3zx8I/q3or7gF3Ei25REpRZa3PPeCsLvjHR43LuX4it
MYkMkW3zDSamwhirCf85qLp128YBjaBrFqARkcsZmkt8Pij0iUO21MYidJnJW3RI
X3JPjMsfwItL4ftaUVfqMB1JEfyv33/pbszo8PYNqsRonr7zBj+uQtHxutJdMgXc
VGn9RB3NJxoY6+NvXC6q7cvGysX/Jl0048bmK/Kzmk/2yRhkzoMUmKpSOIEgoSsS
dzR3Wj6EVowqz/LrPf9DpM8rPSl+8GWhcQnYq4UNWLVMZ5tW+MsS8mOl4E4zUqsz
WZ0aD0Dr8d+SQciVwqnaMg/bVjvVXjlfWGz4Mcb96APt/cVgsFuNbH22ITGKrTbe
/xzqS8g/0jofqOmQ7k3Ml061QsfBRtJfjeinmuG97hvot2CuEnjyhdbClkhJs6n2
ihsM/VAMirdyHwgN2F6vBltxBTSF3fgQzdW+yrGIcwc6az4EJ45O1k0lWfkIntIL
eT0AIFYZ56Y47wiMYxaAkCTfw6IpzpsUyB819dEXywX7dB9FE1KPnW7DsJY4croD
c5nNpI1JT+4CkJl+0kpjeb+ftCsfyP9/QCskm/tpdFhK/n9v7toBoKqQeZye2n6z
JJbcLQn3QB4=
=duyr
-----END PGP SIGNATURE-----

--Sig_/g+WnCBYyawu=bAt671D/.SV--
