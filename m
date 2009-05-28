From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Upgrading a software RAID
Date: Thu, 28 May 2009 16:08:49 +0100
Message-ID: <20090528150849.GB30322@cthulhu.home.robinhill.me.uk>
References: <20090528141457.GA30322@cthulhu.home.robinhill.me.uk> <4A1EA095.9090406@usherbrooke.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aVD9QWMuhilNxW9f"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A1EA095.9090406@usherbrooke.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu May 28, 2009 at 10:32:53AM -0400, Maxime Boissonneault wrote:

>
> Robin Hill a =E9crit :
>> On Mon May 25, 2009 at 01:05:15PM -0400, Maxime Boissonneault wrote:
>>
>>  =20
>>> Hello,
>>> I am using Ubuntu Hardy with 3x500GB drives and the following RAID
>>> configuration :
>>>
>>> /boot is on a 100MB RAID1
>>> / is on a 30GB RAID0
>>> /home is on a 906GB RAID5
>>>
>>>    =20
>> Ouch - why RAID0 for /?  If you lose a single drive then all the
>> configuration, etc. is down the drain.  I'd suggest rethinking this
>> while you're going through the rebuild process anyway.
>>
>>  =20
> That is why I do backups of / on /home regularily. I first did a RAID0 fo=
r=20
> performance. I did some testing on performance of RAID0,1,5 and RAID1 was=
=20
> pretty lousy (I put the results of my tests here :=20
> http://cqed.physique.usherbrooke.ca/~mboisson/htpc.php?sec=3Draid_test )
> I guess I should have used a RAID5, but RAID1 seems like a terrible idea=
=20
> considering the really bad performances.
>
There's definitely something up with the RAID1 there - there's no way it
should be that much slower than a single disk (it ought to be about the
same speed).  There have been some recent fixes to RAID1, so a more
recent kernel may help as well.  RAID10 could also be worth considering
as an alternative.

>>> I want to replace the 3 drives by 3 1TB drives.
>>>
>>> Here is how I planned to do it :
>>> 0- Backup my /home on some external disk.
>>> 1- backup / with something like :
>>> sudo tar cvpzf /backup.tgz --exclude=3D/media --exclude=3D/proc
>>> --exclude=3D/lost+found --exclude=3D/backup.tgz --exclude=3D/mnt --excl=
ude=3D/sys
>>> --exclude=3D/home /
>>> mv /backup.tgz $1
>>>    =20
>> You'll need to do the tar in single user mode (init 1) to ensure there's
>> no open files when you're backing up (or use a bootable CD).
>>  =20
> I used this backup before to restore the system and it seemed to work=20
> pretty well.
>
Okay - this'll depend on what you're running - databases in particular
can have major issues with backing up while open.

>> An easier option (assuming you want to keep the arrays as currently
>> setup) would be to boot from a CD and do a full copy of each of the
>> 500GB disks to the 1TB disks.  You'll then just need to resize the
>> last partition (assuming /home is set up on the last partition on the
>> disks anyway) and grow the array and filesystem.
>>
>> A _better_ option (if possible) would be to install all the drives in
>> the system concurrently, then you can boot from CD and create arrays on
>> the new drives and copy the data across.  You'll also need to update
>> mdadm.conf (and the initrd if you're using one) to indicate the new
>> array IDs.
>>
> I can not install more drives in the computer. It is a home theater=20
> computer in a small case. I was expecting to be able to let the raid mana=
ge=20
> the copies itself.
>
If you've got the ports (and power), you could just leave the case open
and the disks outside until you've finished the copy.

> If the / was on a RAID5, would it be able to boot with 2 disks ?
> If so, is it possible to convert my RAID0 to a RAID5 ?
> For example, I could boot on a CD, backup / onto /home, delete the RAID0=
=20
> array and recreate it as RAID5, then restore the backup. Would this work ?
>
Yes, a RAID-5 will run fine with just two disks. You could certainly
boot from CD, backup, recreate the RAID, then restore - you'd probably
need to update the mdadm.conf file (and the initrd) to indicate the new
array UUID and details though.

You may also want to read through the GRUB section on
http://en.gentoo-wiki.com/wiki/RAID/Software to see how to install grub
onto all the drives (avoiding the issue of which drive is currently
being booted from).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--aVD9QWMuhilNxW9f
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoeqQEACgkQShxCyD40xBJ8iwCg3StrlbFgUbNlZKz7/D1QnW6b
xWYAoKyrKwDU/GyuJxefXVa5PrbJEAvv
=f611
-----END PGP SIGNATURE-----

--aVD9QWMuhilNxW9f--
