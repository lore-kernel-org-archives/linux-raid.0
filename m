From: NeilBrown <neilb@suse.de>
Subject: Re: strange problem with raid6 read errors on active non-degraded
 array
Date: Wed, 2 Jul 2014 20:45:02 +1000
Message-ID: <20140702204502.6b538fa8@notabene.brown>
References: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NzeBmlijQzs9UK+/WBQQ+xN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt>
Sender: linux-raid-owner@vger.kernel.org
To: Pedro Teixeira <finas@aeiou.pt>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/NzeBmlijQzs9UK+/WBQQ+xN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 02 Jul 2014 10:32:41 +0100 Pedro Teixeira <finas@aeiou.pt> wrote:

> - I'm having the following problem on a raid6 md volume consisting og =20
> 16 1TB Seagtes SSHD's. ( using kernel 3.15.3 or 3.14.0 ) mdadm is 3.3.
>=20
>   - every time I run a fsck.ext4 I will get the exact same errors ( =20
> ...short read ). Forcing a repair on the md0 volume shows no errors =20
> and completes without problems. All disks are active and the volume is =20
> not degraded, still I can't get rid of the short errors on those 16 =20
> blocks and when the filesystem is mounted the read errors will come up =20
> from time to time as they are probably in use.
>=20
> - If I try to read those blocks with DD  ( dd if=3D/dev/md0  of=3Dtest.tx=
t =20
> seek=3D458227712 count=3D6 bs=3D4096 ) it will instantly create a 1.8T fi=
le =20
> but the file doesn't appear to have nothing on it ( and the file =20
> doesn't take the 1.8T on disk as the disk is much smaller )
>=20
> - this started happening after having a three disk failure. I =20
> recovered from that failure by recreating the array with the =20
> non-failed 13 disks plus the last failed one ( events didn't differ =20
> much ). I then readed the other disks. The failed disks are all =20
> physically good, tested them with hdat2 and they don't have read/write =20
> errors so I reused them. I don't know why they failed, maybe some =20
> incompatibility with SSHD's and the LSI HBA controller..
>=20
> root@nas3:/# dd if=3D/dev/md0  of=3Dteste.txt seek=3D458227712 count=3D6 =
bs=3D4096
> 6+0 records in
> 6+0 records out
> 24576 bytes (25 kB) copied, 0.0019239 s, 12.8 MB/s
> root@nas3:/# ls -lah teste.txt
> -rw-r--r-- 1 root root 1.8T Jul  2 10:22 teste.txt
> root@nas3:/#
>=20
>=20
>=20
> root@nas3:/# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sde[0] sdq[15] sdp[14] sdo[17] sdn[19] sdm[16] =20
> sdl[18] sdk[9] sdj[8] sdi[7] sdh[6] sdg[5] sdf[4] sdb[3] sdd[2] sdc[1]
>        13672838144 blocks super 1.2 level 6, 512k chunk, algorithm 2 =20
> [16/16] [UUUUUUUUUUUUUUUU]
>=20
> - When doing a fsck.ext4 of /dev/md0 it returns the following ( and I =20
> can do it over and over again with the exact same errors) :
>=20
> root@nas3:/# fsck.ext4 -f /dev/md0
> e2fsck 1.42.10 (18-May-2014)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Error reading block 458227712 (Attempt to read block from filesystem =20
> resulted in short read) while reading inode and block bitmaps.  Ignore =20
> error<y>? yes


Can't possible happen!

(Do worry, I say that a lot - I'm usually wrong).

What sort of computer?  Particularly is it 32bit or 64bit?

Try using 'dd' to read a few meg at various offsets (1G, 2G, 4G, 6G, 8G, ..=
..)
and find out if there is a pattern, where it can read and where it cannot.

NeilBrown


--Sig_/NzeBmlijQzs9UK+/WBQQ+xN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU7Pirjnsnt1WYoG5AQIEKRAAlBMHmbP++rc+Kpi7Ozj6dS3BjqbPdE1V
MnrJyDWH34UebXLws7T0Ex5SyModjj8NLCzgQYZIq4UH9OLMx3i+PMbjq1s8tlBA
eCC6puiRduz2R4Z+FcTCsbD3pqTIOlApKaYK843xnh28Yv1OcjKkuLuVFBzNFd9o
kinnRhMyCzs5zWm6ciHfdgVuBDUPzZFD+/PFchBsvP49xTYsvlO5mwZUNJk1AIJ0
3QRVvoNFezCKx6BIz7J7SIWb/NYszzfjFAOEpnfM2SwgO7iuc00Asy3JS2AaSeiu
a2ekh8hXb6oYmVJZWkOf6cJrUYEyIXPTr2MkJL+m4dD8YEbO6O1cc72V+5j2mdA/
AJvL+OO70PlJBfkzGAyYDxRY6agPwogxzoZkMHQDQ7nNSCZZYWxCiFYXZwYdHAOU
n3Ag643E9EOjiWgOA2PwVHwOTXWEZ6UeDefh5rpcWZJ/6BVaYfrEugtLt8bxW1PG
vMhoLpw1WjF+V50dkkqD0DWVAnIX+zSxdGmrtfYeYV25DpGWlT7Pe/7SlH5kj+So
98lHdW3BI20mJNFqSlxuV/DAv+K2FStTmV4yu+5Kge1pzbMQtvo1sCRb+OHIJPnJ
SZYWR8IWj4dk8FT/QvLb9zh2DpKC7RcdZvwRnfpOVusMa6NF4Hk9aX2Qe0a8ToKH
wVWAS4mMGBQ=
=Hvcg
-----END PGP SIGNATURE-----

--Sig_/NzeBmlijQzs9UK+/WBQQ+xN--
