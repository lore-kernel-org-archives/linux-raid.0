From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID5 recovering
Date: Mon, 15 Apr 2013 16:19:39 +0100
Message-ID: <20130415151939.GA8383@cthulhu.home.robinhill.me.uk>
References: <516C04FB.3030604@inserm.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <516C04FB.3030604@inserm.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Pierre Martineau <pierre.martineau@inserm.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Apr 15, 2013 at 03:47:39PM +0200, Pierre Martineau wrote:

> Dear Raid experts,
>=20
> I have a Raid5 volume that recently crashed and I need you advices=20
> before doing some irreversible action.
>=20
> Let me first summarize the past and current state.
>=20
> 1) I had a nicely running RAID5 volume with 3 x 1 To disks (LVM on top=20
> and several LVM volumes in ext3 and axt4) but volume was now a bit too=20
> small and I decided to add a new 1 To disk.
>=20
Given the rebuild time for a 1To disk, I'd be wary of running RAID5 - if
you have the space, adding another disk and going to RAID6 will be much
safer.

> 2) I added a new disk and did not do anything for a couple of days (Raid=
=20
> still running with 3 disks)
>=20
> 3) One of the old disk failed and was ejected from the RAID.
>=20
> 4) The ejected disk was not even present as /dev/sdX. I thus tested the=
=20
> connections and the disk came back.
>=20
> 5) I resync the ejected disk and I was back with my original 3 disk array.
>=20
> 6) I waited 2-3 days and everything was fine. I then added the new disk=
=20
> and resync.
>=20
> 7) I had now a running 4 disk RAID5 array, I created a new volume and=20
> started copying on it.
>=20
> 8) During the week-end, 2 disks were ejected from the array, the new=20
> installed one and the same than previously (step 3)
>=20
> 9) Again the 2 disks were not present in /dev/sdX. I thus checked again=
=20
> the connections and the problem was a molex connector. The two ejected=20
> disks were on the same molex and this explains why both were detected as=
=20
> faulty.
>=20
> Now, my list of errors as a newbie.
>=20
> 4) I did not save all the informations before proceeding (mdadm=20
> --examine, /etc/mdadm/mdadm.conf, syslog, ...)
>=20
> 5) I tried to assemble the disks with
> mdadm --assemble --scan
> with no result
>=20
> 6) I thus tried and this is my big error I think !!!
> mdadm --assemble /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
>=20
> I forgot in this command /dev/md0 after assemble.
> Because of this /dev/sdb1 suberblock was removed and now mdadm--examine=
=20
> /dev/sdb1 returns "No md superblock detected on /dev/sdb1"
>=20
> I would like now to be more cautious. If some nice expert from the list=
=20
> would be nice enough to tell me if the proposed method described below=20
> is the right approach I will be grateful for the rest of my life :-)
>=20
> 7) I read the RAID wiki and the list.
>=20
> 8) I saved
> mdadm --examine /dev/sd[bcde]1
> dmesg
> syslog
> /etc/mdadm/mdadm.conf
> fdisk -lu /dev/sd[bcde]
>=20
> I put the content of this files at the end of this message (except dmesg=
=20
> and syslog because they are very long).
>=20
> 9) /dev/sdd is the new disk. This is clear in the fdisk listing since it=
=20
> is a 4K sector disk.
> The normal order of the raid is thus (see mdadm --examine /dev/sd[de]1)
> sdb1 sdc1 sde1 sdd1
>=20
> 10) Events are
> /dev/sdb1: no md superblock (see 6)
> /dev/sdc1: Events : 112358
> /dev/sdd1: Events : 112333
> /dev/sde1: Events : 112358
>=20
> It seems that sdd was the first disk removed.
> Presumably sdb1 is in sync since it was running with sdc1 when the sdd1=
=20
> and sde1 were ejected from the array (see 8) but I can't be sure since I=
=20
> stupidly erased its superblock!
>=20
> 11) I propose to re-create the array with the --assume-clean option,=20
> then check everything using "fsck -n" and "mount -o ro"
> the command would be:
>=20
> mdadm --create /dev/md0 -e 0.90 --assume-clean --level=3D5 --n=3D4 \
> --chunk=3D64 --size=3D976759936 /dev/sdb1 /dev/sdc1 /dev/sde1 /dev/sdd1
>=20
<-- snip -->

Have you tried to force assemble the array first? Recreating the array
is a risky option, so should be avoided if possible. First try doing:
  mdadm -Af /dev/md0 /dev/sd[cde]1

If that works then you'll need to re-add (and rebuild) /dev/sdb1. If it
doesn't work, try rerunning (after making sure the array is stopped) and
adding "-vvv" for extra verbosity, then send through the output from
that and anything relevant from dmesg.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlFsGooACgkQShxCyD40xBIUSwCgqyISrpflmdXGwg4cgxGAHrwZ
JsoAn2ivb+wfQ9ziFfpScap70q0ac/DC
=nGwQ
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
