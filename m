From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Adding a new disk after disk failure on raid6 volume
Date: Tue, 20 Dec 2011 09:21:46 +0000
Message-ID: <20111220092146.GA10387@cthulhu.home.robinhill.me.uk>
References: <75d55f4581b6ae45b8131ff989836028@systella.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <75d55f4581b6ae45b8131ff989836028@systella.fr>
Sender: linux-raid-owner@vger.kernel.org
To: BERTRAND =?iso-8859-1?Q?Jo=EBl?= <joel.bertrand@systella.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Dec 20, 2011 at 09:46:13AM +0100, BERTRAND Jo=EBl wrote:

> Hello,
>=20
> I use several softraid volumes for a very long time. Last week, a disk=20
> has crashed on a raid6 volume and I have tried to replace faulty disk.=20
> Today, when Linux boots, it only assembles this volume if the new disk=20
> is marked as 'faulty' or 'removed', and I don't understand...
>=20
> System is a sparc64-smp server running linux debian/testing :
>=20
> Root rayleigh:[~] > uname -a
> Linux rayleigh 2.6.36.2 #1 SMP Sun Jan 2 11:50:13 CET 2011 sparc64=20
> GNU/Linux
> Root rayleigh:[~] > dpkg-query -l | grep mdadm
> ii  mdadm                                 3.2.2-1
>=20
> Faulty device is /dev/sde1 :
>=20
> Root rayleigh:[~] > cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md7 : active raid6 sdc1[0] sdi1[6] sdh1[5] sdg1[4] sdf1[3] sdd1[1]
>        359011840 blocks level 6, 64k chunk, algorithm 2 [7/6] [UU_UUUU]
>=20
> All disks (/dev/sd[cdefghi]) are same model (Fujitsu SCA-2 73 GB) and=20
> each disk only contains one partition (type FD, linux autodetect). If I=
=20
> add /dev/sde1 to raid6 with mdadm -a /dev/md7 /dev/sde1, disk is added=20
> and my raid6 runs with all disks. But I obtain the same superblock on=20
> /dev/sde1 and /dev/sde ! If I remove /dev/sde superblock, /dev/sde1 one=
=20
> disappears also (i think that both superblocks are the same).
>=20
<- SNIP info ->
>
> All disks return same information except /dev/sde when it is running=20
> (mdadm --examine /dev/sde and mdadm --examine /dev/sde1 return the same=
=20
> information). What is my mistake ? Is this a known issue ?
>=20
It's a known issue with 0.9 superblocks, yes. There's no information in
the superblock with allows md to tell whether it's on the partition or
the disk, so for full-disk partitions the same superblock could be valid
for both. 0.1 superblocks contain extra information which can be used to
differentiate between these. I'm a little surprised that the other
drives don't get detected in the same way though.

The standard suggestions are either to change the mdadm.conf file to
look only at partitions for arrays (e.g. DEVICE /dev/sd*1), or (more
complicated) to re-create the array using a version 1 superblock. This
can be done without losing the data, but you need to be very careful to
use the 1.0 superblock and the exact same parameters you used for the
original array (with the disks in the same order). Neil has posted
instructions for this fairly recently, so you should be able to find
those in the archives.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk7wU6kACgkQShxCyD40xBIaqQCfZuzwZ018sWGrwVWVhIFvg8vi
tm0An08jJBbEdcBHkwb+Jj0pIKEHtzda
=tLtp
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
