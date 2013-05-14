From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Corruption during RAID5->RAID6 migration
Date: Wed, 15 May 2013 02:08:14 +0600
Message-ID: <20130515020814.77ff1407@natsu>
References: <CAJDy474SBN7qMgccmkzc++=ZP43L1M=jVkyx_YVkqdZmbvwZfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kbyrbz=39efYvLbVX8gXYx2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJDy474SBN7qMgccmkzc++=ZP43L1M=jVkyx_YVkqdZmbvwZfg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: James Doebbler <jamesdoebbler@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kbyrbz=39efYvLbVX8gXYx2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 May 2013 14:56:22 -0500
James Doebbler <jamesdoebbler@gmail.com> wrote:

> Hello,
>=20
> I have encountered a scary situation with corruption on my RAID array
> and would like any help/advice/pointers that might help me
> save/recover any data I can.  I'll try to describe the situation as
> best I can, so forgive the length of this email.
>=20
> I have a personal file and media server running Ubuntu Linux Server
> 12.04.2, kernel version 3.2.0-41-generic.  I have a mdadm RAID5 array
> of 2TB disks that I've been adding disks to and growing as needed off
> the past couple of years and everything has been great other than a
> non-zero mismatch_cnt.  The array was currently at 10TB/6 device and I
> decided it was time to move to a RAID6 array since the number of
> devices was getting large.  I wanted to minimize the chance of a total
> failure during a rebuild as well as hopefully be able to resolve any
> future mismatch_cnts correctly with the extra parity information.
>=20
> I had read on Neil Brown's blog that the migration would be much
> faster if I was also adding capacity, so I installed two new 2TB
> drives, added them to the array (as spares) and started the
> reshape/grow. I've appended the commands used and mdadm output to the
> end of this email.
>=20
> The reshape seemed to be going along as expected except I was only
> getting ~5MB/s instead of the ~40MB/s I usually see.  Several hours
> later I noticed that some of my recent downloads were corrupt when
> extracting from archives.  I created some files from data in
> /dev/urandom and calculated the md5sum.  A minute or so later I
> recalculated the sum, and it was different.  Similarly, copying the
> file resulted in another md5sum that was not the same as the previous
> two.
>=20
> At that point I am not sure where the problem is, but I know my RAID
> array is no longer correctly returning the data I store to them.  I do
> not have verification data for most of the data already on the drive,
> so I do not know if there is a problem reading any data, or a problem
> writing new data (in which case my pre-existing data might be okay).
>=20
> Running iostat, I noticed that one drive was the bottleneck
> (/dev/sdh).  It was one of the new drives and even though I had tested
> them thoroughly, I worried that it was this drive that was returning
> bad data or something.  I failed the drive in question and the RAID
> reshape sped up considerably (to ~35MB/s).  However, doing the same
> md5sum of new random data files with the drive non-active in the array
> still failed in the same way.
>=20
> I then became worried about a hardware problem with my RAM or SATA
> card

Which SATA card (vendor/model)?

Also describe what exactly you have connected and to where, e.g. do you also
use the onboard controller of your motherboard (vendor/model?) for how many
drives, and to which port and on which of the controllers you have added any
new drives recently.

Mentioning HDD models also won't hurt. Really, it's almost like you wrote a
long winded post but gave barely any significant details whatsoever.

--=20
With respect,
Roman

--Sig_/kbyrbz=39efYvLbVX8gXYx2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlGSma8ACgkQTLKSvz+PZwhYPwCfQU0yIUXG0z/m3ado2+51N+8A
Bz8AnicoKOdf1Z/Wcusri25mUS/6K/mV
=rJq2
-----END PGP SIGNATURE-----

--Sig_/kbyrbz=39efYvLbVX8gXYx2--
