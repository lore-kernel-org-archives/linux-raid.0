From: NeilBrown <neilb@suse.de>
Subject: Re: mystified by behaviour of mdadm raid5 -> raid0 conversion
Date: Thu, 8 Nov 2012 09:00:35 +1100
Message-ID: <20121108090035.324782ee@notabene.brown>
References: <CAH4Nvfn6Ek50DEqFr_hWrpeK9qrBqrGsfsG9ULmLTReJSpGWSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9hJZk6r6SjBTOdezSNV_0R3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH4Nvfn6Ek50DEqFr_hWrpeK9qrBqrGsfsG9ULmLTReJSpGWSw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Geoff Attwater <geoffwater@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/9hJZk6r6SjBTOdezSNV_0R3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 7 Nov 2012 22:47:20 +1100 Geoff Attwater <geoffwater@gmail.com> wro=
te:

> I have a relatively unimportant home fileserver that uses an mdadm
> raid5 across three 1TB partitions (on separate disks - one is 1.5 TB
> and has another 500GB partitition for other stuff). I wish to convert
> it to raid10 across 4 1TB partitions by adding a fresh drive.
>=20
> The mdadm man page, section *Grow Mode* states that it may
>=20
> "convert between RAID1 and RAID5, between RAID5 and RAID6, between
> RAID0, RAID4, and RAID5, and between RAID0 and RAID10 (in the near-2
> mode)."
>=20
> Conversion between RAID5 and RAID10 directly is not supported (mdadm
> tells you so if you try it).
> So my plan was to do a three stage conversion:
>=20
>  1. back everything up
>  2. convert from 3-disk raid5 -> 2-disk raid0 (now with no redundancy,
>  but it's backed up, so that's ok)
>  3. convert the 2-disk raid0 -> 4-disk raid10
>=20
> All of these have the same logical size (2TB). This is on an Ubuntu
> 12.10 system.
> mdadm --version reports:
> mdadm - v3.2.5 - 18th May 2012
> uname -a reports:
> Linux penguin 3.5.0-18-generic #29-Ubuntu SMP Fri Oct 19 10:26:51 UTC
> 2012 x86_64 x86_64 x86_64 GNU/Linux
>=20
> I searched around to see if anyone had followed this kind of procedure
> before, but didn't find anything directly addressing exactly what I
> was trying to do (I saw much more about raid0 -> raid5 type
> conversions, while adding a device and the like and nothing much on
> going the other way), so I proceeded based on what I understood from
> the man page and other general stuff on mdadm raid reshaping I read.
>=20
> for stage 2, I used the command
>=20
>     mdadm --grow /dev/md0 --level=3Draid0 --raid-devices=3D2
> --backup-file=3D/media/newdisk/raid_to_0_backup
>=20
> where the backup-file is on another disk not in the array. I put the
> --raid-devices=3D2 in to make it clear that what I was after was 2x1TB
> disks in RAID0 and one spare (the same logical size), rather than a
> larger logical size 3TB three-disk RAID0. Although based on Neil
> Brown's blog post at http://neil.brown.name/blog/20090817000931 it
> seems the conversion should generally operate by reshuffling things
> into an equal-logical size array anyway, so that perhaps wasn't
> necessary.
>=20
> This began a lengthy rebuild process that has now finished. However,
> at the end of the process, after no visible error messages and
> obviously a lot of data movement seen via iostat, `mdadm --detail
> /dev/md0` showed the array as *still raid5* with all disks used, and
> the dmesg output contained these relevant lines:
>=20
>     [93874.341429] md: reshape of RAID array md0
>     [93874.341435] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>     [93874.341437] md: using maximum available idle IO bandwidth (but
> not more than 200000 KB/sec) for reshape.
>     [93874.341442] md: using 128k window, over a total of 976630272k.
>     =3D=3D=3D snip misc unrelated stuff  =3D=3D=3D
>     [183629.064361] md: md0: reshape done.
>     [183629.072722] RAID conf printout:
>     [183629.072732]  --- level:5 rd:3 wd:3
>     [183629.072738]  disk 0, o:1, dev:sda1
>     [183629.072742]  disk 1, o:1, dev:sdc1
>     [183629.072746]  disk 2, o:1, dev:sdb1
>     [183629.088584] md/raid0:md0: raid5 must be degraded! Degraded disks:=
 0
>     [183629.091657] md: md0: raid0 would not accept array

These last two are the interesting messages.
The raid0 module in the kernel will only access a raid5 for conversion if it
is in 'parity-last' layout, and is degraded.  But it isn't.

mdadm should fail and remove the 'parity' disk before trying to convert to
raid0, but it doesn't.
I guess I never tested it - and untested code is buggy code!

You could be able to finish the task manually.
 - fail the last (parity) device
 - remove that device
 - echo raid0 > /sys/block/md0/md/level

So:
  mdadm /dev/md0 -f /dev/sdb1
  mdadm /dev/md0 -r /dev/sdb1
  echo raid0 > /sys/block/md0/md/level

However you should double-check that 'sdb1' is the correct device.  Look in
the output of 'mdadm -D' and see what raid device number '2' is.

I'll add this to my list of things to fix.

Thanks,

NeilBrown


--Sig_/9hJZk6r6SjBTOdezSNV_0R3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUJraAznsnt1WYoG5AQJn2w/+KCn0ZnXdzVtedYBmco8V6wJlitD0U6jk
zq2+7WXGCe9MzSQm1oIeqOi+1UIyu4xFDWiOIg7xLclyw/27UGq8LOpY8pgly5B5
rqUVWSKVUu9w/SIPeOONlUQScKZ1IBOFJBb4YiEGCZlVUsx8r0Y8n0WaS5kcUM1p
82tv+a+AEXtBo8wzrRTKJ1VekiTsMN0WdQ6O6jt3osomk0pNVQCOYL8Sk5Erti9E
6x4dlpSseUutqiUz4mrVQQRQ/JVWfQ/UXXw8/s0C0RaOoULa+uUG2IZfAcza6aD6
d24ZwzCAu8/JYA5D7DCEdQg/uYdwLUVskjpXMmoAhSlNF+xfT9+O87uWex89VYre
KO+JW3stpBSdXvD7W0+XSu5f2BS1CLDu63GLIF1mHjAFuLyCzbrY5XKkRlkumuGb
qYjmVR4M5Rywx1VKbxQ7p6VEiwZm/J1cOesVIC4pocCWrFe2c1NvM10PSNM4HvYa
B28Fd+saxr0hZL9CQfqLUF5H5eC03zyOnuFR9ARppJroQDnMS1Ckb5YdKRp0jicg
XzFTBM9dTarbinJezzVOYYzL8qZDdZexKGWCvdT/lYpO6ZzvTe0uuvU2a3tfvlpC
EYHtmLD3DSdankaKFLZWs+WopHSt6EMnWeEdT103LIN39sWMzpbM+QtBRlvZZl0X
PAlNVrQAmJA=
=eRHw
-----END PGP SIGNATURE-----

--Sig_/9hJZk6r6SjBTOdezSNV_0R3--
