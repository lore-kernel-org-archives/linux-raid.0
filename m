From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID10 only using 2/4 drives
Date: Wed, 11 Jan 2012 15:43:41 +0000
Message-ID: <20120111154341.GA11455@cthulhu.home.robinhill.me.uk>
References: <4F0DA1F6.9070700@yagermaterials.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F0DA1F6.9070700@yagermaterials.com>
Sender: linux-raid-owner@vger.kernel.org
To: Josh Reynolds <josh.reynolds@yagermaterials.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Jan 11, 2012 at 08:51:34AM -0600, Josh Reynolds wrote:

> Hello! 1st post on this mailing list, so be gentle.
>=20
> I've got a production Ubuntu box that I used the installer to create a=20
> raid10 system on several months ago. I pretty much setup the box and=20
> then left it alone, to run a couple of different things and some vm's.
>=20
> I really started to realize something was wrong fairly recently when my=
=20
> disk size was showing approx 1/2 of what I thought it should for a=20
> raid10. Also, my disk speeds were... not something I'd expect for 4 drive=
s.
>=20
> After looking into it, I realized mdadm had marked two of the drives as=
=20
> spares. WTF.
>=20
> To make sure that I wasn't crazy, I wiped out a partition on each drive,=
=20
> and created a raid10 by hand. My original system array is md0, the other=
=20
> is md1.
>=20
> ----------------------------
> josh@virtserver:~$ cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid10]
> md1 : active raid10 sda2[0] sdd2[3] sdc2[2] sdb2[1]
>        46868480 blocks super 1.2 512K chunks 2 far-copies [4/4] [UUUU]
>=20
> md0 : active raid10 sdd3[4](S) sdb3[3](S) sdc3[2] sda3[0]
>        951370752 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU]
>        bitmap: 3/8 pages [12KB], 65536KB chunk
> ---------------------------
>=20
> I notice the 2nd array I created is showing the raid1 and raid0=20
> personalities... and I have a feeling that's what is gimping the md0 arra=
y?
>=20
No, that's nothing to do with it. The "Personalities" line is printed as
a header and just reports all the personalities loaded (it doesn't just
apply to the array immediately following). Presumably something on your
system is loading the raid0 and raid1 modules (or they're compiled in)
as they're not required for raid10.

> I've tried fail/remove/adding those two partitions marked as spares, and=
=20
> it never adds them back as active members.
>=20
That won't make any difference, no. The array configuration shows it's
configured as a 2-disk array, so any extra disks added will just stay as
spares. I can't see any way for this to have happened without having
explicitly created the array with 2 active drives and 2 spares
specified. Either that's a bug in the Ubuntu installer, or there was a
mistake/misunderstanding made when specifying the parameters.

Unfortunately you can't currently grow a RAID10 array, so your only
option would be to recreate the array. If it's your root filesystem then
you'll need to do this via a boot CD. You can do it without losing data
(hopefully) by dropping the two spares from the array and creating a
new, degraded, RAID-10 array using these. Then copy the data across,
drop the old array, and finally add those drives into the new array.
Providing there's no errors during the final rebuild process, then no
data will be lost. Of course, a backup would definitely be recommended
prior to carrying this out.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk8Nri0ACgkQShxCyD40xBLdWgCgzgDWyeDVabsfaYF4WJzbDZd9
Z10AoKwiWLSB7XwO9lxRw0GPA7SYtLz9
=1HtM
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
