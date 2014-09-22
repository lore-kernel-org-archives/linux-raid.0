From: NeilBrown <neilb@suse.de>
Subject: Re: not enough operational mirrors
Date: Tue, 23 Sep 2014 09:53:28 +1000
Message-ID: <20140923095328.0e6ed347@notabene.brown>
References: <CANs+QMzWWqh-5MemOrbguaq7fNzJPDaYUH66K0rgGrnaXY7FNA@mail.gmail.com>
	<20140922154717.6cd3cab2@notabene.brown>
	<CANs+QMxHe3SBAk=VaUQuwOSGyv9p8dJjFsxPT+hvf+c20T23=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/poF+lBUVPDUt.Uz.m57_pmF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANs+QMxHe3SBAk=VaUQuwOSGyv9p8dJjFsxPT+hvf+c20T23=g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Young <ian@duffrecords.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/poF+lBUVPDUt.Uz.m57_pmF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Sep 2014 10:17:46 -0700 Ian Young <ian@duffrecords.com> wrote:

> I forced the three good disks and the one that was behind by two
> events to assemble:
>=20
> mdadm --assemble --force /dev/md0 /dev/sda2 /dev/sdb2 /dev/sdc2 /dev/sde2
>=20
> Then I added the other two disks and let it sync overnight:
>=20
> mdadm --add --force /dev/md0 /dev/sdd2
> mdadm --add --force /dev/md0 /dev/sdf2
>=20
> I rebooted the system in recovery mode and the root filesystem is
> back!  However, / is read-only and my /srv partition, which is the
> largest and has most of my data, can't mount.  When I try to examine
> the array, it says "no md superblock detected on /dev/md0."  On top of
> the software RAID, I have four logical volumes.  Here is the full LVM
> configuration:
>=20
> http://pastebin.com/gzdZq5DL
>=20
> How do I recover the superblock?

What sort of filesystem is it?  ext4??

Try "fsck -n" and see if it finds anything.

The fact that LVM found everything suggests that the array is mostly
working.  Maybe just one superblock got corrupted somehow.  If 'fsck' doesn=
't
get you anywhere you might need to ask on a forum dedicated to the particul=
ar
filesystem.

NeilBrown


>=20
> On Sun, Sep 21, 2014 at 10:47 PM, NeilBrown <neilb@suse.de> wrote:
> > On Sun, 21 Sep 2014 22:32:19 -0700 Ian Young <ian@duffrecords.com> wrot=
e:
> >
> >> My 6-drive software RAID 10 array failed.  The individual drives
> >> failed one at a time over the past few months but it's been an
> >> extremely busy summer and I didn't have the free time to RMA the
> >> drives and rebuild the array.  Now I'm wishing I had acted sooner
> >> because three of the drives are marked as removed and the array
> >> doesn't have enough mirrors to start.  I followed the recovery
> >> instructions at raid.wiki.kernel.org and, before making things any
> >> worse, saved the status using mdadm --examine and consulted this
> >> mailing list.  Here's the status:
> >>
> >> http://pastebin.com/KkV8e8Gq
> >>
> >> I can see that the event counts on sdd2 and sdf2 are significantly far
> >> behind, so we can consider that data too old.  sdc2 is only behind by
> >> two events, so any data loss there should be minimal.  If I can make
> >> the array start with sd[abce]2 I think that will be enough to mount
> >> the filesystem, back up my data, and start replacing drives.  How do I
> >> do that?
> >
> > Use the "--force" option with "--assemble".
> >
> > NeilBrown


--Sig_/poF+lBUVPDUt.Uz.m57_pmF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCC2eDnsnt1WYoG5AQLTAQ//SAblLdVipCmBEhqSK3/xSRwTTn7240kY
0/ThLve8f6WItbiZsJ7lVDENRUc6OAoz2g3BPih5SYbsELHYKEjND1x4qCsQf9te
fbBz3CUgqK3IJFPEfYYA8r3Nzi5n2ORbmHfIbtwei7O9bNcmyNr8Za47UVM/8NAV
YxO5jeYrNTOLl/89Wc2qcVgXlCVTwbbF3vWN/agSIpO9QyY9ywfCasl9bTdK1c7A
G/MdoBLgq822xkiXvEJKOtLo1MVbuQlVwojBxfG4d00ROF0lZDef4/rmyPv2+VgE
k4fX8ZERU3jd9+F9wXb5gE+aud0/RC4hCO8HqGWCXGJ/uMrCNx48GrUYP8A8Li96
P30nMPouwkTvaqbhKUdyRD19UKAhT81jjJ+QraSIvHKWFgZD2ylxuIslAGkHjyRX
6o/RGnUl6YNkLvgQyNSJvFuIBphNX3YN4Xaqeu7E7UlXY40K1WFk2KBqv1FB1OYF
O1lvwpo9d9jR2AXZBR/gUU8LDPlMyxQuIl3cm6i98x6yS9YeOoWJruiZ56aoQ2hX
mXDAafEsEB0oXjN8C5y4IHGiEOS6u+I0HcPOXX9RkIhAqJeLDjnSoyva/hvVwLF7
sI/XWG/vYu61EfNKyJgh7VzJsp7d9h8i3fv8xY8t3OfZRHE84d/p0fkGASDVDRBg
YkFAaujhieI=
=UoOB
-----END PGP SIGNATURE-----

--Sig_/poF+lBUVPDUt.Uz.m57_pmF--
