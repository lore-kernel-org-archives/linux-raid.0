From: Doug Ledford <dledford@redhat.com>
Subject: Re: md0: unknown partition table - should I worry?
Date: Wed, 11 Nov 2009 15:46:50 -0500
Message-ID: <4AFB22BA.5060806@redhat.com>
References: <200911102324.47474.Dexter.Filmore@gmx.de> <20091111090355.GA9137@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCB561381489AF0B989257424"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091111090355.GA9137@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCB561381489AF0B989257424
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/11/2009 04:03 AM, Robin Hill wrote:
> On Tue Nov 10, 2009 at 11:24:44PM +0100, Dexter Filmore wrote:
>=20
>> Today md0 degraded (debian 5.0 i386, raid5, 5x500 samsung sata) so I c=
hecked=20
>> the logs and noticed on each rebootI got this in /var/log/messages:
>>
>> md0: unknown partition table
>>
>> md0 is all LVM2 and volumes mount fine, so is this normal?=20
>>
> If you're using whole-disk RAID rather than RAID on partitions then thi=
s
> is normal, yes.  Something (possibly udev, in order to create the
> relevant dev entries) is trying to read the partition table and failing=

> as there isn't one.

Actually, it doesn't matter if you make your md device out of whole
disks or not, it's the attempt to find a partition table on the md
device itself that is generating this message.  This is a side effect of
the recent kernel change to allow any block device to be partitioned and
merely indicates that no partition table was found on your md device.
It's normal.  In fact, it might be worth suggesting that the message go
away.  If there's no partition table people generally know that because
there are no partitioned dev files ;-)


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigCB561381489AF0B989257424
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr7IroACgkQg6WylM+/8ZQUuACdFtg6/zp45g2f8TtxnkkCnype
+9cAoI03jisBFHv8cIYaf8ej4A/AV/XM
=NPW+
-----END PGP SIGNATURE-----

--------------enigCB561381489AF0B989257424--
