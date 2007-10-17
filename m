From: Nagilum <nagilum@nagilum.org>
Subject: Re: Unsure of changes to array
Date: Wed, 17 Oct 2007 16:53:06 +0200
Message-ID: <20071017165306.bl3iqgs7g0skkg40@cakebox.homeunix.net>
References: <47161684.7010604@bristol.ac.uk>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_7dhdah3x0ds8";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47161684.7010604@bristol.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Gazeley <jonathan.gazeley@bristol.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_7dhdah3x0ds8
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from jonathan.gazeley@bristol.ac.uk ---------
     Date: Wed, 17 Oct 2007 15:04:52 +0100
     From: Jonathan Gazeley <jonathan.gazeley@bristol.ac.uk>
Reply-To: Jonathan Gazeley <jonathan.gazeley@bristol.ac.uk>
  Subject: Unsure of changes to array
       To: linux-raid@vger.kernel.org


> Dear all,
>
> This is hopefully a simple question for you to answer, but I am fairly
> new to RAID and don't want to risk losing my data!
>
> My setup is as follows:
> - I have four 500GB disks. Each disk is split into a 5GB partition, and
> a 495GB partition.
> - The four 5GB partitions are in a RAID-5 array, md0. CentOS is
> installed on this 15GB partition.
> - The four 495GB partiions are in a RAID-5 array, md1. This partition
> holds my user data.
>
> However, I have decided I no longer wish to two arrays across the
> disks. I've added a fifth disk on which I have installed the OS without
> RAID, meaning the old md0 is currently unused. Can I simply remove the
> four 5GB partitions, and resize the four 495GB partitions to fill the
> entire disk? Will this break anything?
>
> Before anybody tells me off for having the OS on a non-RAID disk, this
> is a home server and therefore high availability is not an issue. But
> keeping my data safe against disk failures is important to me.
>
> Cheers,
> Jonathan
>

----- End message from jonathan.gazeley@bristol.ac.uk -----

***CAUTION***CAUTION***CAUTION***
Do backups if you can..
Are the RAID partitions on your disk the first partition or a different one?
If its not the first partition you'll have _move_ your partition to =20
the beginning of the disk.
So assuming your first disk is /dev/sda, sda1 your OS partition which =20
want to recycle, sda2 your RAID partition you could do:
  dd if=3D/dev/sda2 of=3D/lots_of_space_here/sda.dump
then repartition your sda, now sda1 is your RAID partition and it =20
spans across the whole drive
  dd if=3D/my_new_disk/sda.dump of=3D/dev/sda1

After that you should be able to assemble your RAID again with =20
/dev/sda1 instead of /dev/sda2. If that works, continue with the other =20
disks.
If it doesn't work your array should be degraded and you should still =20
be able to add /dev/sda1 and then md should sync to it to become clean =20
again.
Note that during this whole operation you will be vulnerable to any =20
disk failures. You may think about buying another disk and converting =20
to raid6 for an additional layer of protection before attempting this.
If you have friend who has a faint idea what you do have him join you =20
to look over your shoulder and stop you from doing silly mistakes =20
(e.g. mixing up "if" and "of" during dd). This is a very dangerous =20
undertaking make one mistake and your data may be gone...
I hope this helps..
Alex.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..


--=_7dhdah3x0ds8
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHFiHRAKWN2UY+sLwRApl0AJ9PfeWCtPNvIng5Y08l19XETg44aQCgi/Eg
MqPpHAKu1pzrK5Lg3Ird0Yg=
=gLm/
-----END PGP SIGNATURE-----

--=_7dhdah3x0ds8--
