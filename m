From: NeilBrown <neilb@suse.de>
Subject: Re: Problem with Raid1 when all drives failed
Date: Mon, 24 Jun 2013 17:08:24 +1000
Message-ID: <20130624170824.39dc8d99@notabene.brown>
References: <84A53BEA6EAC69439B7E311E9B17A76F0174829C@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+YVXI5Y2PLTUwV0TlDb.vma"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84A53BEA6EAC69439B7E311E9B17A76F0174829C@IRSMSX105.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/+YVXI5Y2PLTUwV0TlDb.vma
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Jun 2013 06:22:32 +0000 "Baldysiak, Pawel"
<pawel.baldysiak@intel.com> wrote:

> Hi Neil,
>=20
> We have observed a strange behavior of a RAID1 volume when all its drives=
 failed.
> Here is our test case:
>=20
> Steps to reproduce:
> 1. Create 2-drives RAID1 (tested on both native and IMSM metadata)
> 2. Wait for the end of the initial resync=20
> 3. Hot-unplug both drives of the RAID1 volume
>=20
> Actual behavior:
> The RAID1 volume is still present in OS as a degraded one-drive array

That is what I expect.

>=20
> Expected behavior:
> Should a RAID volume disappear from OS?

How exactly?  If the filesystem is mounted that would be impossible.

>=20
> I see that when a drive is removed from OS udev runs "mdadm -If <>" for m=
issing member which tries to write "faulty" to the state of array's member.
> I see also that md driver prevents from doing this operation for the last=
 drive in a RAID1 array, so when two drives fail nothing really happens to =
the one that fails as the second one.
>=20
> It can be very dangerous, because if user has mounted file system at this=
 array it can lead to unstable work of system or even a system crash. More =
over user does not have proper information about the state of an array.

It shouldn't lead to a crash.  But it could certainly cause problems.
Unplugged active devices often does.

>=20
> How should it work according to the design? Should mdadm stop volume when=
 all its members disappear?

Have a look at the current code in my "master" branch.  When this happens it
will try to stop the array (which will fail if the array is mounted), and
will try to get "udisks" to unmount the array (which will fail if the
filesytem is in use).
So it goes a little way in the direction you want, but I think that what you
are asking for is impossible with Linux.

NeilBrown


--Sig_/+YVXI5Y2PLTUwV0TlDb.vma
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUcfwaTnsnt1WYoG5AQIuTw//f4bom1nNGb+Md95zghbUsRYvh/DgH7Lh
C0VgEzdzAd43M3ruSlhVLD/otgTBX2Upq1QGW67fAOWjNnXlOItXgwIeGwDF+5mB
wV1GtgVujzVDijqXkMHLT8txRzr0wrtI1uGc2jaD7x37sWPbcl/WDs4w4jILMz+t
OsbJWFSYcWPQefYzsRlcknJuEbqAymnsP68W1N24ZfNQ4lvGZYfMHQjTyqevu4G4
w0I5D440nx3MPub9xCdYAzKb9VCGkAsc3TEisKk57AQZxuKSd18kcMJ+43eK0WBX
62yTurseEq9w8ipxxcXT6yzRAikztr7C3bLb+f776YQS0JMa9Z8OAk2iAOCMaNVe
J04Yj8DaRLcU2A532M69EphDfLXb6X45nObf03DP4bR7a5uw7LJ9A9ID2k9SAruB
y2xZ5W2A7SqtcCBOF/jLTN9d/+t1R5cFDxI8E26X57AUNgZotSIiYuD5N1jRmrHi
U3qO/TOpyCYL4yfNU1PE6A6ZY+VjBteFVOVOojwqeQXbwVJO4mqjPILpszdUDsxX
w1iZMf8ErvPdTQGM2Qom4vfq1/7KDAKBtlJfw0SSlfWETyfwpU9kW8ansUZ167LD
KRdrudfbNMa7grlii5QyMdb2VD8hNKmLXdxJa2P+3B/YaDevbOMOQzMUrj5fIzh7
DOFfhP/2T1s=
=TYAY
-----END PGP SIGNATURE-----

--Sig_/+YVXI5Y2PLTUwV0TlDb.vma--
