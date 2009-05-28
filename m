From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Upgrading a software RAID
Date: Thu, 28 May 2009 15:14:57 +0100
Message-ID: <20090528141457.GA30322@cthulhu.home.robinhill.me.uk>
References: <4A1ACFCB.7010604@usherbrooke.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A1ACFCB.7010604@usherbrooke.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon May 25, 2009 at 01:05:15PM -0400, Maxime Boissonneault wrote:

> Hello,
> I am using Ubuntu Hardy with 3x500GB drives and the following RAID
> configuration :
>
> /boot is on a 100MB RAID1
> / is on a 30GB RAID0
> /home is on a 906GB RAID5
>
Ouch - why RAID0 for /?  If you lose a single drive then all the
configuration, etc. is down the drain.  I'd suggest rethinking this
while you're going through the rebuild process anyway.

> I want to replace the 3 drives by 3 1TB drives.
>
> Here is how I planned to do it :
> 0- Backup my /home on some external disk.
> 1- backup / with something like :
> sudo tar cvpzf /backup.tgz --exclude=3D/media --exclude=3D/proc
> --exclude=3D/lost+found --exclude=3D/backup.tgz --exclude=3D/mnt --exclud=
e=3D/sys
> --exclude=3D/home /
> mv /backup.tgz $1
You'll need to do the tar in single user mode (init 1) to ensure there's
no open files when you're backing up (or use a bootable CD).

> 2- Replace 1 disk
> 3- Boot and let the RAID1 and RAID5 reconstruct
You'll have to boot to a CD then - your root FS is trashed at this
point.

> 4- Replace 1 other disk
> 5- Boot and let the RAID1 and RAID5 reconstruct again
> 6- Replace the last disk
> 7- Boot and let the RAID1 and RAID5 reconstruct one last time
> 8- Boot and restore the backup on the RAID0 / partition.
> 9- Resize the /home partition to 1 TB.
>
> I suspect there will be a problem replacing the primary disk, but I guess=
ed
> that I could solve this simply by changing which is the primary disk in t=
he
> BIOS.
>
> Is there any other problem that will or could happen ?
>
See above - your current plan is pretty much doomed I'm afraid.

> For example, I am not sure if the raid manager is on the /boot partition =
or
> on the /. I guess if it is on /, it won't work at all since the raid=20
> manager
> itself won't be able to run ?
> Also, is it possible to boot and access a command line to restore the=20
> backup
> with a failed / partition ?
>
> I am also unsure about how I should proceed to resize the /home partition.
> Is this done through mdadm ?
>
No, you'll have to delete & recreate the partition using fdisk.

> Please enlight me on any problems that I will have.
>

An easier option (assuming you want to keep the arrays as currently
setup) would be to boot from a CD and do a full copy of each of the
500GB disks to the 1TB disks.  You'll then just need to resize the
last partition (assuming /home is set up on the last partition on the
disks anyway) and grow the array and filesystem.

A _better_ option (if possible) would be to install all the drives in
the system concurrently, then you can boot from CD and create arrays on
the new drives and copy the data across.  You'll also need to update
mdadm.conf (and the initrd if you're using one) to indicate the new
array IDs.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoenGAACgkQShxCyD40xBKNYgCgs6eEdXDTWV0Dd+LRM+H7e6On
D94Anj1KYgXnZz3v78GSyN7gKCyo+A5i
=1D+/
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
