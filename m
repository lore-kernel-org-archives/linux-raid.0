From: NeilBrown <neilb@suse.com>
Subject: Re: badblocks seem to be causing problems with raid6 - badblocks list replicating all all drives
Date: Mon, 21 Dec 2015 15:00:16 +1100
Message-ID: <87si2w4fjj.fsf@notabene.neil.brown.name>
References: <3fafa3e9267b4ba0b5f9d61d3a416cf5@digitallyhosted.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3fafa3e9267b4ba0b5f9d61d3a416cf5@digitallyhosted.com>
Sender: linux-raid-owner@vger.kernel.org
To: matt@digitallyhosted.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12 2015, matt@digitallyhosted.com wrote:

> Hello,
>
> I posted a while back about getting buffer i/o errors in my dmesg logs=20
> to my raid array, something along the lines of this:
>
> [158219.456484] EXT4-fs warning (device md4): ext4_end_bio:329: I/O=20
> error -5 writing to inode 125274714 (offset 176160768 size 8388608=20
> starting block 4955235712)
> [158219.456487] Buffer I/O error on device md4, logical block 4955235584
> [158219.456490] Buffer I/O error on device md4, logical block 4955235585
> [158219.456491] Buffer I/O error on device md4, logical block 4955235586
> [158219.456491] Buffer I/O error on device md4, logical block 4955235587
> [158219.456492] Buffer I/O error on device md4, logical block 4955235588
> [158219.456493] Buffer I/O error on device md4, logical block 4955235589
> [158219.456494] Buffer I/O error on device md4, logical block 4955235590
> [158219.456495] Buffer I/O error on device md4, logical block 4955235591
> [158219.456496] Buffer I/O error on device md4, logical block 4955235592
> [158219.456497] Buffer I/O error on device md4, logical block 4955235593
> [158219.456580] EXT4-fs warning (device md4): ext4_end_bio:329: I/O=20
> error -5 writing to inode 125274714 (offset 176160768 size 8388608=20
> starting block 4955235456)
> [158219.456663] EXT4-fs warning (device md4): ext4_end_bio:329: I/O=20
> error -5 writing to inode 125274714 (offset 176160768 size 8388608=20
> starting block 4955235200)
> [158219.456747] EXT4-fs warning (device md4): ext4_end_bio:329: I/O=20
> error -5 writing to inode 125274714 (offset 176160768 size 8388608=20
> starting block 4955234944)
> [158219.456829] EXT4-fs warning (device md4): ext4_end_bio:329: I/O=20
> error -5 writing to inode 125274714 (offset 176160768 size 8388608=20
> starting block 4955234688)
> [158219.456912] EXT4-fs warning (device md4): ext4_end_bio:329: I/O=20
> error -5 writing to inode 125274714 (offset 176160768 size 8388608=20
> starting block 4955234432)
> [158469.158278] EXT4-fs warning (device md4): ext4_end_bio:329: I/O=20
> error -5 writing to inode 123995503 (offset 0 size 8388608 starting=20
> block 4970080384)
> [158469.158281] buffer_io_error: 1526 callbacks suppressed
>
> I am now using the latest mainline kernel, 4.3.0 and I believe something=
=20
> is going wrong with the badblocks implementation.
>
> I originally had 3 drives, all with the same badblocks list.  This array=
=20
> has been running a while so I have no idea how these 3 discs all ended=20
> up with the same list of badblocks.
>
> Now, if I remove any drive, which has no badblock entries, and re-add=20
> it.  Once the sync is complete I end up with another drive with the same=
=20
> badblocks list.

An entry in the bad-blocks list means that the data at that location is
not available, possibly because the block is bad.

If you have a degraded RAID6 where any appears in 2 or more bad-blocks
lists, then it is not possible to recover the data at that address when
a spare is recovered.  So the same address will be added to the bad
block log on the spare.

You could remove he bad block from all the device by writing to all of
the affected blocks at once, but that is admittedly a little difficult
to manage.

I probably need to make it possible to clear the bad block log by a
successful write to just a single data block (and the matching parity
blocks).  I've added that to by to-do list.

I've just push out a modification to mdadm so you can run
  mdadm --assemble --update=3Dforce-no-bbl /dev/md/whatver list of devices

and it will remove the bad-block lists even though they are not empty.
So if you

 git clone git://neil.brown.name/mdadm
 cd mdadm
 make
 ./mdadm --stop /dev/md4
 ./mdadm --assemble /dev/md4 --update=3Dforce-no-bblk list-of-devices

it should get rid of your problem.
However, as your mail is 6 weeks old (I was on leave...) maybe you have
already found another solution.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWd3lQAAoJEDnsnt1WYoG5RvcP/iRSy2NTqcJwJ3ZAb2WZ2S1u
DNQpZvkPrdIQPkGVMyHfK3c30Tm4idI7dY3IwWyTD0lsR3qYcR2oXmAm/U3MPi7l
e+o72Kn6ODtPyc2yi5CwCXQYvayxfbaCaWChgXf1WYyr4mGs81TOmXR0GsZAKvLN
PWwWEdjSqGnNQ1iXu8UmdxigXQ9Uiw7Qi8jTEMeCDB6mwgLb8fgS6EQpeGS/bB7d
sSnu+NKdM9riiXLkXUF0DQivyRRTzonBgARyqiJCuYSlGYeDROQckqoV2t3CEiBp
IyA48CoFAQmg+RaN1daab71PbGU54kz1bhJ1Gl99tkdAJVY2F9lNBUErQENiSKhN
7p7zIOwhCtOw/mV2YkOBvc7TaazTvJ/lAhz/U/wDDiYA8Xr7MOJyiJDKaB/l3aS3
0HuXRhTZmM9WF/6bRvRwPCGPQr3DTVtf8i171x3v9ejRAvRl8oRZ6LgAoOph7UXW
OAgULNroWu4y+AeP7e6mqekCuwhX9O9djoQCHMsWeCUfQV/nbUPzFAgDf/V2Q3OW
swC0/j7mM039hIVqFsjpyQjCE3yPFcFcikmFdFN3wPsrztl8wRKlQXE55N6WJGI4
6EaYZD2hG/0yebEu0H277xGtDJEkh1l8/12L/RYL0KJ1Y7nwhgm2xLrIN/eNZqWO
EdQ5G/T+FckKPRs/qFhd
=XCH7
-----END PGP SIGNATURE-----
--=-=-=--
