From: NeilBrown <neilb@suse.com>
Subject: Re: 9 second recovery when re-adding a drive that got kicked out?
Date: Tue, 06 Jun 2017 13:57:27 +1000
Message-ID: <87r2yxdazc.fsf@notabene.neil.brown.name>
References: <20170604223817.ntxlvafgfa2umww2@merlins.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170604223817.ntxlvafgfa2umww2@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 04 2017, Marc MERLIN wrote:

> Howdy,
>
> Can you confirm that I understand how the write intent bitmap works, and
> that it doesn't cover the entire array, but only a part of it, and once
> you overflow it, syncing reverts to syncing the entire array?
>
> I had a raid5 array with 5 6TB drives.
>
> /dev/sdl1 got kicked out due to a bus disk error of some kind.
> The drive is fine, it was a cabling issue, so I fixed the cabling,
> re-added it, and did
>
> gargamel:~# mdadm -a /dev/md6 /dev/sdl1
>
> Then I saw this:
> [ 1001.728134] md: recovery of RAID array md6
> [ 1010.975255] md: md6: recovery done.
>
> Before the re-add:
> md6 : active raid5 sdk1[5] sdb1[3] sdm1[2] sdj1[1]
>       23441555456 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/4]=
 [_UUUU]
>       bitmap: 3/44 pages [12KB], 65536KB chunk
>
> After the re-add (syncing now just to be safe):
> md6 : active raid5 sdl1[0] sdj1[1] sdk1[5] sdf1[3] sdm1[2]
>       23441555456 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5]=
 [UUUUU]
>       [>....................]  check =3D  0.8% (49258960/5860388864) fini=
sh=3D569.3min speed=3D170093K/sec
>       bitmap: 0/44 pages [0KB], 65536KB chunk
>
> https://raid.wiki.kernel.org/index.php/Mdstat
> Explains a bit, I don't think it says how big a page is, but it seems to
> be 4KB.
>
> So let's say I have 64MB chuncks, each take 16 bits.
> The whole array is 22,892,144MiB
> That's 357,689 chunks, or about 700KB (16 bits per chunk) to keep all the
> state, but there is 44 pages of 4KB, or 176KB of write intent
> state.
>
> The first bitmap line shows 3 pages totallying 12KB, so each page
> contains 4KB, or 2048 chunks per page.
> Did the above say that I had 6144 chunks that needed to be synced?

No.  It said that of the 44 pages of space that might be needed to store
16-bit counters that each represent 1 bitmap-chunk, only 3 of those
pages would contain non-zero counters, so only 3 had been allocated.

There could be as few as 3 chunks that need to be recovered, or there
could be as many a 3*2048 chunks, or any number in between.

Had you run "mdadm --examine-bitmap /dev/sdk1" before the re-add, it
would have told you how many bits were set at that time.

That "x/y pages" information never should have appeared in /proc/mdstat
=2D it is really just of interest to developers.  But it is there now, so
removing it is awkward.

>
> If so it would be 6144 * 65536KB =3D 393,216 MB to write
> They were written in 9 seconds, so the sync happened at 43MB/s, which is
> believeable.
>
> The part I'm not too clear about is 44 pages of intent isn't enough to
> cover all my data.

44 pages means 90112 16 bit counters, one for each 64M on each device.
90112 * 64M =3D 5632 GiB or 5905GB.
That is the size of each device.

One bit in the bitmap (one counter in the internal bitmap) corresponds
to "a set of data the might be out of sync" which, in your case, is a
64MB wide stripe across all devices.

So the numbers do add up.

NeilBrown

> Is the idea that once I overflow that write intent bitmap, then it
> reverts to resyncing the entire array?
>
> I looked at https://raid.wiki.kernel.org/index.php/Write-intent_bitmap
> but didn't see anything about that specific bit.
>
>
> Array details if that helps:
> gargamel:~# mdadm --examine /dev/sdl1
> /dev/sdl1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 66bccdfb:afbf9683:fcf1f12e:f2af2dcb
>            Name : gargamel.svh.merlins.org:6  (local to host gargamel.svh=
.merlins.org)
>   Creation Time : Thu Jan 28 14:38:40 2016
>      Raid Level : raid5
>    Raid Devices : 5
>
>  Avail Dev Size : 11720777728 (5588.90 GiB 6001.04 GB)
>      Array Size : 23441555456 (22355.61 GiB 24004.15 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D262056 sectors, after=3D0 sectors
>           State : clean
>     Device UUID : ca4598ba:de585baa:b9935222:e06ac97d
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Sun Jun  4 15:08:45 2017
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : d645f600 - correct
>          Events : 84917
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 0
>    Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
>
> Thanks,
> Marc
> --=20
> "A mouse is a device used to point at the xterm you want to type in" - A.=
S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet c=
ooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/7=
63BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlk2KCkACgkQOeye3VZi
gbmjaA//U/XbYMpvLkxg9weB1s3bF2nzXU2h/Z8o+K0HuQ8qIdqNLk4+IkoA5/K1
E6QuERT1mSQP9ikPNtPe16WsYg8KBhpIE+zpXEyTuemavRwe3bpc0X6nb4Vc7vFZ
yBbCkQl/+u8qrYLUqOr0TjoqLxNFuqBDInIMQZlBZdOYCz8BDeqPKBgiLRZtErs9
ADxF0V5G6qCUk3Fszc1tUvCHkBvK2Ay4BEs3SnYeqhV30b7pz2qYohRC3zZBYfMg
HYYZ5bZNvFiS66b44HsgO6wPM/h4YQckSWNhAwyxegyPQuH47wVmiotrqi6y+Wgs
IzLUJSy1gGcNdW3lawgdGf3FnbVQoxVYlI+Izj6BehxmpuW5CjedPPkVXKWFL3/U
78d30eCf4hqk+da1nBxz0GkUKqhk7f/5SxGijbC3u5XuchzpXdhpoSUn5IueIMWe
LhPqSz5euTTtEL54lCDzOyTFUCSY0mUVCclG2fiBT831iE5NgBO8IjsbNOiTUb4X
LNCx5vI0aum/NbmYk9q3oe5gy12rCYKt3Fv6DNkpK0st5CgSi+a6p/TK3sO9OLnv
EFzJatUVji8fNdgTc4v105l3UbrNtzff1d4LSdmHksDipwDfH/ELWlk1Hpp0oLTa
4OEaAuz4GOj3DVqxUmji2z8fCHjXGF5LaFoMs9xt40jlvtNaP0M=
=Yfmk
-----END PGP SIGNATURE-----
--=-=-=--
