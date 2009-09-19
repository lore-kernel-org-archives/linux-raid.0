From: Bryan Mesich <bryan.mesich@ndsu.edu>
Subject: Re: mismatch_count != 0 on multiple hosts
Date: Fri, 18 Sep 2009 19:33:57 -0500
Message-ID: <20090919003357.GA19690@atlantis.cc.ndsu.nodak.edu>
References: <20090916171714.GA24629@atlantis.cc.ndsu.nodak.edu> <slrnhb2ek3.dbe.Mario.Holbe@darkside.dyn.samba-tng.org>
Reply-To: Bryan Mesich <bryan.mesich@ndsu.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <slrnhb2ek3.dbe.Mario.Holbe@darkside.dyn.samba-tng.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 16, 2009 at 09:20:35PM +0200, Mario 'BitKoenig' Holbe wrote:
> Bryan Mesich <bryan.mesich@ndsu.edu> wrote:
> > The most popular mismatch_cnt values are 128 and 256.  The worst I
> > found was 21504 and 7168.  I find it interesting that all are
> > divisible by 128.
>=20
> They should not appear on RAID5.

I would agree.  The only reason I mentioned RAID5 was to remove the
possibility that the HD were spontaneously flipping bits.  Our SAN
environment looks like the following:


|     Initiaror      |              FC Target                |
--------------------------------------------------------------
                        Block Dev -> LVM -> RAID5 -> Block Dev
ext3 -> LVM -> RAID1 {
                        Block Dev -> LVM -> RAID5 -> Block Dev

Since the RAID1 block devices on the initiator are sitting on a=20
underlying RAID5 array (on the target), we should not notice=20
random bit flips (or otherwise corruption) that a single drive=20
might.

This is only one example of many that I have.  I've found mismatches
on other RAID1 arrays that are comprised of SATA, SAS, SCSI and/or SAN=20
volumes (as shown in the above example).

> What kinds of filesystems reside on the RAID1s? If it's ext[23] (well,
> most likely on SANs it's not :)), then these mismatches are very likely
> located in inode blocks.

Yes, we are running ext3 :).

There is only 1 array that is running something else (ext4).

I'm not sure if I follow you on the inode problem.  If there was a
problem, shouldn't the problem be replicated to both block devices?

> I've noticed this quite often on RAID1s up to 2.6.26, especially on
> filesystems with heavy inode fluctuation (remove, create files).
> Starting with .26 (i guess, maybe later) I didn't see them anymore.
> Maybe yours on newer kernels are just brownfields? Correct them and see
> if they appear again?

The majority of our boxes are running the default RHEL 2.6.18 kernel.
I would be quicker to blame the RHEL kernel (missing
patches/back-ports), but I am seeing this on machines that are running
mainline kernels (as new as 2.6.29).

I'm not sure that that the problem can be attributed to heavy inode=20
fluctuation since one of my worst offending arrays has only 119 files
on it (vmware guests w/pre-allocated disk) and is running ext4.  Even=20
if there is FS problems, why doesn't the problem get replicated to both=20
sides of the mirror?

I worry about running a repair for fear that I might tromp over
something.  I was hoping that future writes might fix some of the
problem?

> > So, is there anyway to get an output on which blocks do not match?  I'd
> > like to see how they are different, if at all.
>=20
> just cmp -l the components, as you did before md brought up the
> sync_action check target :)

Thanks for the tip :)

Bryan

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkq0JvUACgkQlSl3SAlkhEcsUACfd0+bJNkAFcvfSjdHUpSWZ2wA
zsEAn35TrTjPCTmHt94/PjbIFlIrBRti
=D4J6
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
