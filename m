From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm --fail doesn't mark device as failed?
Date: Thu, 22 Nov 2012 15:42:17 +1100
Message-ID: <20121122154217.63b6b3a9@notabene.brown>
References: <1353514677.5795.14.camel@corn.betterworld.us>
	<50AD0726.9090509@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/83KpqpsJgGH=/N7jysOK4Xh"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50AD0726.9090509@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: Ross Boylan <ross@biostat.ucsf.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/83KpqpsJgGH=/N7jysOK4Xh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Nov 2012 17:53:58 +0100 Sebastian Riemer
<sebastian.riemer@profitbricks.com> wrote:

> On 21.11.2012 17:17, Ross Boylan wrote:
> > After I failed and removed a partition, mdadm --examine seems to show
> > that partition is fine.
> >
> > Perhaps related to this, I failed a partition and when I rebooted it
> > came up as the sole member of its RAID array.
> >
> > Is this behavior expected?  Is there a way to make the failures more
> > convincing?
>=20
> Yes, it is expected behavior. Without "mdadm --fail" you can't remove a
> device from the array. If you stop the array with the failed device,
> then the state is stored in the superblock.
>=20
> There is a difference in the way mdadm does it and the sysfs method.
> mdadm sends an ioctl to the kernel. With the sysfs command the faulty
> state is stored immediately in the superblock.
>=20
> # echo faulty > /sys/block/md0/md/dev-sdb1/state
>=20

This is not true.  "mdadm --fail" and "echo faulty > state" have exactly the
same effect on the array.  They simulate an error occurring.


NeilBrown

--Sig_/83KpqpsJgGH=/N7jysOK4Xh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUK2tKTnsnt1WYoG5AQL/CxAAp67KMC+Ey/1S5zH2eaVC+LKDiiM338/F
OKkt+Q3fylAdKoVqIGXJ7e8iYI0BPJMGsPCTubq6Gqp234oXZ8KoYoQElHnE0jfy
xaDzRQ+vqG6kLiIH7/ZC/zudyf1EwGBkqcUB6WaR67lGKm7OFYtDxSLEcJMmjbdI
+HMhXR5HWmLK4WDMNPI0OirWTDCJDMixe0/+uDFJa69bNwvX8YbitZzCmgUzX7yE
P3uLMt7bDqoS3aGmrsKWojNO1JXZHGrT4Ra/tgf5+JPU60vPBDDXhbLqbGS4q4gj
Ys5gA0niEK2tm1GzQpZAHCGDNwX1J1X/H3zjHZLcIdFQ/3Ur8CdVbyLbh5NxCdus
BpihCM+DUUslmIu72ENXoJW7o2DA0rDz05tqrsSei2gPDkBR3iQGvfa8R5/aqn5K
lCiPLDaTskhjx/ymLgQP1wnTNcPYBUTIWeggw2tn9RGS4nIZ7wW2pk6yMhxJqwcH
IKgXZm+uMT4Bb9Ql1Bwt8/S4TpEcd8bACdrhvDxiPORlBdEnQSP7C4BymM0VWjF/
8MJ2acjwHn2wqC2nmBNT5sHCkTBgWCah/wDsTmjWVRmJUmVqYYAkU/mNBAFfcdZZ
6OWzDw61RHSpfWr7wvBE7XJF9hpC1qOrMQ+Ed9WKNdpO/+TvHaI5L515Iv1Z3ZDp
/Mb1Jbz4tvw=
=HrEM
-----END PGP SIGNATURE-----

--Sig_/83KpqpsJgGH=/N7jysOK4Xh--
