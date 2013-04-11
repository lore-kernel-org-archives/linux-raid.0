From: NeilBrown <neilb@suse.de>
Subject: Re: Persistent failures with simple md setup
Date: Thu, 11 Apr 2013 17:33:20 +1000
Message-ID: <20130411173320.4d833feb@notabene.brown>
References: <1565063.1kpR7lz4Ph@xrated>
	<2777026.gm19DAWULs@xrated>
	<20130321142459.2cd6b4da@notabene.brown>
	<113804746.rOsYdmQaaH@xrated>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=+MVs1lX8YI+lu=a/v6GpC1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <113804746.rOsYdmQaaH@xrated>
Sender: linux-raid-owner@vger.kernel.org
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/=+MVs1lX8YI+lu=a/v6GpC1
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Apr 2013 15:44:25 +0200 Hans-Peter Jansen <hpj@urpla.net> wrote:

> On Donnerstag, 21. M=E4rz 2013 14:24:59 NeilBrown wrote:
> >=20
> > Thanks! Unfortunately it is not as helpful as I hoped, but it does sugg=
est
> > that "udevadm settle" does sometimes appear to misbehave even if there
> > aren't any problems with the md array.
> >=20
> > Could I ask for one more?
> > Prefix the "udevadm settle " command with
> >   strace  -o /tmp/udevadm.trace -s 500
> >=20
> > (making sure that you have 'strace' installed) and then post the
> > "/tmp/udevadm.trace" file.  Hopefully that will at least allow me to ru=
le
> > out some possibilities.
>=20
> After reducing the timeout to 40 secs, we're able to catch a failure today
> with two degraded arrays: md0 and md1.
>=20
> Cheers,
> Pete

Thanks.

There is a similar bug report open at
  https://bugzilla.novell.com/show_bug.cgi?id=3D793954

I received a generally similar trace there and have been looking at yours
and those and the code and not getting very far.

The  traces show the /run/udev/queue.bin getting bigger and bigger, then
shrinking down to '8':
=20
 %zgrep 'fstat64(4,' /tmp/udevadm.trace.gz | sed 's/.*st_size=3D\([0-9]*\),=
.*/\1/'

This is expected.  Whenever the queue becomes empty, the file is reset
(normally 'add' and 'remove' records are simply appended).
It is supposed to also be shrunk when it is bigger than 4K and over half of
the file is wasted (due to add/remove pairs) but the calculation of wastage
is broken and I think this never happens.

Nevertheless there seems to be a correlation between the times when it fails
and the max size of the queue.bin file.  In the files from the buzilla, the
times that it works, the queue.bin file never gets big.

But that could just be an accident.

In any case it is clear that udevadm is working correctly.  Which seems to
suggest that maybe 'udev' is messing with the queue.bin file.  Either that =
or
I'm misunderstand some other details and am entirely on the wrong path.

But I've gone over the udev code again and again and I cannot fault it.

So I'm still stumped.

Thanks for your help though.
NeilBrown

--Sig_/=+MVs1lX8YI+lu=a/v6GpC1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIUAwUBUWZnQDnsnt1WYoG5AQJPkg/45DNZ3uCFgQrxfsDMJvNcx6BvtwP826BN
J5yKIWhThlWor0Wu2gC4daQ9Diik4GYGK5Gyww0Qhjf2mUuCt684ZL8YQXk+aqgn
bKW0Ex+aAWKzlRVtvUwh39/UWISA3h7vjQKHaW4jChTC59cCYVJz5FmwDRLmtH2Y
wAQMdX9dhmKmZi0aCDpl9Z3aLBnMcmsX02tVThEY1XJ0eA5K376IXY+Fqk2Sx/qc
zjPfzCls+fZmdAxR//ulppjYf2fPVoZs9IM2BGKhZLPvjaJuo3WOu+bRu4oPmWEn
i5MeyJ2oxXWs5214L8Y1TpERTBPCMsTgAADqYM9HzPB5gaH4OdyPg7eCr0d3UhQT
+1bUl9Yu7NNEW3wUitJ3VXlFss1VxmlP4F1W/BjkPiJG51g1fLf0f/Ctzfurffzq
BviLU93otXIgyZWXV0vIcAlQxa67Ku9OYiPfVOTdmH7zNUtl3I85eC5ByQGBqJwX
qpj5vuI2YkRS9yQ9ZnqEOPlR8qyxZFsoqsS4v6qA3yEB1Qqdtsz7QoYBfF3KGqB/
VjdE6SrIouA+n2aDRWOJRmJZCRIRs6ezP8YZIDX2ZEWmD0fRbGhFeAtZ0BlHNNCj
Qbgyqeb/aFygOPYn9QoKTd9SgYwlZfEqPboIa8yjuWfWnHN+y+rvh5YNKCE5Giet
EaKEKzU2EQ==
=s29E
-----END PGP SIGNATURE-----

--Sig_/=+MVs1lX8YI+lu=a/v6GpC1--
