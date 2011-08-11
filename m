From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Couldn't remove rebuilding drive from RAID5 rebuild, now can't
 add new drive to array?
Date: Thu, 11 Aug 2011 15:22:58 +0100
Message-ID: <20110811142258.GA8085@cthulhu.home.robinhill.me.uk>
References: <CAOS+5GES654yyRPYkvSC-r5q+4n-vXwph33v_6Bf51xANRcnJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOS+5GES654yyRPYkvSC-r5q+4n-vXwph33v_6Bf51xANRcnJQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Aug 11, 2011 at 02:48:29PM +0100, Another Sillyname wrote:

> I have a RAID5 array consisting of 4 drives that recently had a problem.
>=20
> One of the drives 'removed' itself from the array and when I added it
> back it started the background rebuilding I expected, however I then
> noticed from smartctl that the drive was showing 'imminent failure'
> due to 3300+ reallocated sector errors.
>=20
> At this stage I decided I wanted to pull the drive before it finished
> the rebuild and replace it.
>=20
> However after I stopped the array using:-
>=20
> mdadm --stop /dev/md126
>=20
> I was unable to put that drive into fail status
>=20
> mdadm --fail /dev/sdj1
>=20
> No Such Device
>=20
Well obviously you can't fail a drive from an array that isn't running
(not to mention that your fail syntax is wrong). What you should have
done (with the array running) is:
    mdadm /dev/md126 --fail /dev/sdj1

> At this stage I decided to leave the array offline till I had a
> replacement drive available to slot in.
>=20
> I now have the replacement drive and as I was unable to either fail or
> remove the offending drive I decided to do a physical pull of the
> drive, reboot the machine to show the drive remove and then a second
> reboot with the new blank drive available.
>=20
There's no need for all the rebooting. Simply replacing the offending
drive with the new one and restarting the array (either by reboot or
a controller scan and array re-assemble) would have worked fine.

> This seems to have partially worked in that
>=20
> mdadm -D /dev/md126
> /dev/md126:
>         Version : 1.2
>   Creation Time : Sat Aug  6 01:24:12 2011
>      Raid Level : raid5
>   Used Dev Size : 1953512960 (1863.02 GiB 2000.40 GB)
>    Raid Devices : 4
>   Total Devices : 3
>     Persistence : Superblock is persistent
>=20
>     Update Time : Sun Aug  7 05:23:45 2011
>           State : active, degraded, Not Started
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>            Name : MY_NEW_RAID
>            UUID : herro_this_isnt_needed
>          Events : 36003
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8      129        0      active sync   /dev/sdi1
>        1       0        0        1      removed
>        2       8      161        2      active sync   /dev/sdk1
>        3       8      177        3      active sync   /dev/sdl1
>=20
> Which is what I expected to see.
>=20
Yep, the removed drive is no longer in the array at all.

> However I cannot add the replacement drive into the array.
>=20
> ~ >:mdadm --add /dev/md126 /dev/sdj1
> mdadm: add new device failed for /dev/sdj1 as 4: Invalid argument
>=20
You really need to check dmesg here to see why it's been rejected.

> ~ >:mdadm --add --force /dev/md126 /dev/sdj1
> mdadm: set device faulty failed for /dev/sdj1:  No such device
>=20
I've no idea what it's doing here. Are you sure that's exactly what you
typed? If you'd missed a "-" before the force then it may be
interpreting it as "-f" instead, which would fail as /dev/sdj1 is not in
the array.

> ~ >:mdadm --re-add /dev/md126 /dev/sdj1
> mdadm: --re-add for /dev/sdj1 to /dev/md126 is not possible
>=20
As the new drive does not contain any array metadata, it can't be
re-added here.

> and even more confusingly
>=20
> ~ >:mdadm -E /dev/sdj1
> /dev/sdj1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : not needed
>            Name : My_NEW_RAID
>   Creation Time : Sat Aug  6 01:24:12 2011
>      Raid Level : raid5
>    Raid Devices : 4
>=20
>  Avail Dev Size : 3907027053 (1863.02 GiB 2000.40 GB)
>      Array Size : 11721077760 (5589.05 GiB 6001.19 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : not needed
>=20
>     Update Time : Sun Aug  7 05:23:45 2011
>        Checksum : 6172254 - correct
>          Events : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : spare
>    Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
>=20
> Could someone possibly point me in the right direction as to what I'm
> doing wrong?
>=20
What's the output of "cat /proc/mdstat" at this point? If it doesn't
show /dev/sdj1 as being in the array at all, then I'd go with trying to
add it again:
    mdadm /dev/md126 --add /dev/sdj1

If that still fails, check "dmesg", and possibly try running with -vv to
get a more verbose error.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5D5cEACgkQShxCyD40xBKThQCfWdOwq6P3/fpV+nLM6dxQpvHX
cpcAnjyURdyRa0jGsSKY8zbeiDFmJqYF
=WQ9x
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
