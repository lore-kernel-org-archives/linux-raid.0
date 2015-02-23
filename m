From: NeilBrown <neilb@suse.de>
Subject: Re: Optimal chunk size for RAID5?
Date: Mon, 23 Feb 2015 14:28:57 +1100
Message-ID: <20150223142857.50206a19@notabene.brown>
References: <mccemd$8pi$1@ger.gmane.org>
	<20150222173047.1ea65d67@natsu>
	<CAB-428=7y-KSbCeXo6y6o5Jfzgf-5h6pfYxY+4Z74bqYp=oMUg@mail.gmail.com>
	<20150223085358.302830d1@notabene.brown>
	<mce06j$i2h$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/R.6+TIzu8MF1+lrPCP.bOfY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <mce06j$i2h$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christer Solskogen <christer.solskogen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/R.6+TIzu8MF1+lrPCP.bOfY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Feb 2015 02:36:18 +0100 Christer Solskogen
<christer.solskogen@gmail.com> wrote:

> On 22.02.2015 22:53, NeilBrown wrote:
>=20
> > There is no "Optimal" without reference to a particular work load.  Or
> > particular hardware.
> >
>=20
> Do you know of such a reference? I mean, some stats that show type of=20
> workload / chunk size. The only one I've found is the 5 year old=20
> benchmark that was done (=20
> http://louwrentius.com/linux-raid-level-and-chunk-size-the-benchmarks.htm=
l)=20
> - which shows that under benchmarking with dd that 64 is preferred.
>=20

Interesting graphs ... but when you see a big jump like they show between 64
and 128K chunk sizes for RAID5/6, that doesn't mean "64K is better" but
"something strange is happening here".  My guess is that read-ahead is
working very well for some reason.

If your actually workload is writing 10GB files with 'dd', then the graphs
might be useful.  For other workloads ... it's hard to tell.

Nothing beats performing your own tests on your own hardware with your own
choice of filesystem and getting your own results.

I did some tests myself recently (which I really want to automate and turn
into web pages etc ... one day).
For RAID5 on 4 drives I used chunk sizes of 4, 16, 64, 256, 1024 and applied
a variety of fio loads use XFS.

The only load that showed significant variation of chunk sizes was sequenti=
al
read which gets generally faster with larger chunk sizes, though for some
layouts (I tried la, ls, ra, rs) 1024k chunks were worse than 256k.

So any reference you find will probably lead you astray.

NeilBrown

--Sig_/R.6+TIzu8MF1+lrPCP.bOfY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOqeeTnsnt1WYoG5AQJO0Q//Ydc2th64Wma2OxvqvPC8pXE/93wrLQy2
kC22qlrn6afKe9Aj2hDOk+KhxXmo7hpctnD6F+8hOiQUX0MAtoIrW5cPzi2ZyVmn
+R3/oo9vnSKZSvd1r1WPCGwUSKMaoCr09ZA77UgyVE8/KE+BvsAH23b/99p45vpo
e8RxmuJFf7QUrrnfxBjFfUaJ6QeI+pJr1rguwOA6tENdc8etXZMMMkxH+Qr3ZxGF
H+GsJmcOin+T2qndoFZC1PsVmYMe2mabBzXQjjVkgR/+XhW89Cpgdlrfs4NSUXyB
nF2WHCkIBZPXAxGhzFm0QWFdJ9WDK3SOTmc6kqXZuEM1XuI/eYtOh0W/LHr2RGc1
SYriKaaG/1ACuY5UbzNovyjMuQYknDJP6It119qm4dKyHJkt1wPSXA2fMUlTLfs+
a902Cy9XHwPJ3mm8rpIuClxVcqdcK7DbjyMLHrYqKlnCcF5aeG9r6EOfHSb81yG1
PFQI6oxlcri8qwIAiu1WtqasCZw+ZDPSzXwN9naGB/bZrPbhRgmcB2x87xoaE+rN
gTkTeEwGZgnSvxh+TRqlA031RUSsg19Oevy/LwBjX22IuJsWIRkVNU6PNhMfL9Ah
QIzE+0pJjZX2+CHL4hfQJA8vWPV7dm4O99P7y/7rfOYGbnM0DTalrXH2c37wzQbP
hUwdTlEqQMk=
=HJ6O
-----END PGP SIGNATURE-----

--Sig_/R.6+TIzu8MF1+lrPCP.bOfY--
