From: NeilBrown <neilb@suse.de>
Subject: Re: md device is read only mode
Date: Tue, 10 Jul 2012 07:42:01 +1000
Message-ID: <20120710074201.76846af5@notabene.brown>
References: <20120705172748.GA6464@lazy.lzy>
	<20120709114022.58f5d52b@notabene.brown>
	<20120709173406.GA4206@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DWdiJqTpuUA=Ex0NONkVDpr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120709173406.GA4206@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/DWdiJqTpuUA=Ex0NONkVDpr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Jul 2012 19:34:07 +0200 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> Hi Neil,
>=20
> please see one comment below.
>=20
> On Mon, Jul 09, 2012 at 11:40:22AM +1000, NeilBrown wrote:
> [...]
> > The mount system call will notice that the device is read-only, and wil=
l make
> > assume the read-only mount option.
>=20
> OK, so it should work as expected.
>=20
> The story was this.
> After fixing the RAID-5 superblock problem, we
> wanted to see if the filesystem was still OK.
> So we started the RAID in r/o mode (so to avoid
> any possible further damage from mount) and then
> mounted the filesystem (actually, now that I
> think of it, there was an LVM layer in the middle).
> This mount caused a kernel error report (I do
> not know if BUG() or else).
>=20
> Is there any explanation for that?

Probably LVM isn't detecting that the underlying device is readonly and so
forcing the upper device to be readonly.
md doesn't do this either - it should.

NeilBrown

--Sig_/DWdiJqTpuUA=Ex0NONkVDpr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/tQKTnsnt1WYoG5AQJrkw//evleuHTCd1mf+VTDtJDMcnPkW3Epac9a
FEWNFbQfBGhyxUrjdtAnInMy2z/zUkaaIkA3+4J2iR5kfZ0j6VttkMlUWJzF6l+R
wTTt3rkGVuIsEmkggkH557GVXH/mNKoN8J+jGwdWZ67V/YPIcITA1WIt2PeqFZEc
suYsahA73sKfNFg8IViumhtmWSxyBxM+PcDykL38ZUFq8iP8oSaW+KTq8aSV+3Vn
5nKI9wsxSu6hpQ7k+M/WDmB/2SSADRIUWqUvXWWZNNP1X17/g1jONQTQ4+t7opNR
u9hogyE9JedvTmBlgn94im7naQtt2ZP4/WBLeefKvK8aQFZd69ey5xtc0/fswg5s
R8lhyd4cDShLZfWGcOcbQeXXPg8sZmkf/Q3aKt5ydTqB8gAVULzQsB3I+rTYpD9z
JVSyv7oXoQ0MdmwT/nX1fRSK6hDZHLDJpWCmHcYcVErLObNSmAO0yGCNrayM80uj
WwEmLB209HkkApz2FupPMEBinjUbvBTR1NeD+HVwZ4PzRfvxCSYEhjpk/lErQcPR
Hi00wivJrKqK+/WbxCXhWN6/M7eHu5I7BxjJpcPIsIyf3e5phLlQoNo7BrpxFBt6
IjAxB5rg/Rzw6YgcqjCKPBmbQjpVIfZXkE9vcT75T6+hqwkkbaImi3G+duERKHoH
u2ECQE7i9gQ=
=43Yj
-----END PGP SIGNATURE-----

--Sig_/DWdiJqTpuUA=Ex0NONkVDpr--
