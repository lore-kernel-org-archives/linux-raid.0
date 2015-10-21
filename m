From: Neil Brown <nfbrown@novell.com>
Subject: Re: How to recover after md crash during reshape?
Date: Wed, 21 Oct 2015 12:35:04 +1100
Message-ID: <874mhl2ed3.fsf@notabene.neil.brown.name>
References: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
Sender: linux-raid-owner@vger.kernel.org
To: andras@tantosonline.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

andras@tantosonline.com writes:

Phil has provided lots of useful advice, I'll just add a couple of
clarifications;

>
>      mdadm --grow --raid-devices=3D10 /dev/md1
>
> Yes, I was dumb enough to start the process without a backup option -=20
> (copy-paste error from https://raid.wiki.kernel.org/index.php/Growing).

Nothing dumb about that - you don't need a --backup option.
If you did, mdadm would have complained.

You only need --backup when the size of the array is unchanged or
decreasing.
(or when growing to a degraded array.  e.g. you can reshape a 4-drive
 raid5 to a degraded 5-drive raid5 without adding a spare.  This will
 required a --backup.  I'm fairly sure it also requires --force because
 it is a very strange thing to do).

When reshaping it a larger array, mdadm only requires a backup while
reshaping the first few stripes, and it uses some space in one of the
new (previously spare) devices to store that backup.


>
> This immediately (well, after 2 seconds) crashed the MD driver:
>
>      Oct 17 17:30:27 bazsalikom kernel: [7869821.514718] sd 0:0:0:0:=20
> [sdj] Attached SCSI disk
>      Oct 17 18:39:21 bazsalikom kernel: [7873955.418679]  sdh: sdh1
>      Oct 17 18:39:37 bazsalikom kernel: [7873972.155084]  sdi: sdi1
>      Oct 17 18:39:49 bazsalikom kernel: [7873983.916038]  sdj: sdj1
>      Oct 17 18:40:33 bazsalikom kernel: [7874027.963430] md: bind<sdh1>
>      Oct 17 18:40:34 bazsalikom kernel: [7874028.263656] md: bind<sdi1>
>      Oct 17 18:40:34 bazsalikom kernel: [7874028.361112] md: bind<sdj1>
>      Oct 17 18:59:48 bazsalikom kernel: [7875182.667815] md: reshape of=20
> RAID array md1
>      Oct 17 18:59:48 bazsalikom kernel: [7875182.667818] md: minimum=20
> _guaranteed_  speed: 1000 KB/sec/disk.
>      Oct 17 18:59:48 bazsalikom kernel: [7875182.667821] md: using=20
> maximum available idle IO bandwidth (but not more than 200000 KB/sec)=20
> for reshape.
>      Oct 17 18:59:48 bazsalikom kernel: [7875182.667831] md: using 128k=20
> window, over a total of 1465135936k.
> --> Oct 17 18:59:50 bazsalikom kernel: [7875184.326245] md: md_do_sync()=
=20
> got signal ... exiting

This is very strange ... maybe some messages missing?
Probably an IO error while writing to a new device.

>
>  From here on, things went downhill pretty damn fast. I was not able to=20
> unmount the file-system, stop or re-start the array (/proc/mdstat went=20
> away), any process trying to touch /dev/md1 hung, so eventually, I run=20
> out of options and hit the reset button on the machine.
>
> Upon reboot, the array wouldn't assemble, it was complaining that SDA=20
> and SDA1 had the same superblock info on it.
>
> mdadm: WARNING /dev/sda and /dev/sda1 appear to have very similar=20
> superblocks.
>        If they are really different, please --zero the superblock on one
>        If they are the same or overlap, please remove one from the
>        DEVICE list in mdadm.conf.

It's very hard to make messages like this clear without being incredibly
verbose...

In this case /dev/sda and /dev/sda1 obviously overlap (that is obvious,
isn't it?).
So in that case you need to remove one of them from the DEVICE list.
You probably don't have a DEVICE list so it defaults to everything listed in
/proc/partitions.
The "correct" thing to do at this point would have been to add a DEVICE
list to mdadm.conf which only listed the devices that might be part of
an array. e.g.

  DEVICE /dev/sd[a-z][1-9]

> So, if I read this right, the superblock here states that the array is=20
> in the middle of a reshape from 7 to 10 devices, but it just started=20
> (4096 is the position).
> What's interesting is the device names listed here don't match the ones=20
> reported by /proc/mdstat, and are actually incorrect. The right=20
> partition numbers are in /proc/mdstat.
>
> The superblocks on the 6 other original disks match, except for of=20
> course which one they mark as 'this' and the checksum.
>
> I've read in here (http://ubuntuforums.org/showthread.php?t=3D2133576)=20
> among many other places that it might be possible to recover the data on=
=20
> the array by trying to re-create it to the state before the re-shape.
>
> I've also read that if I want to re-create an array in read-only mode, I=
=20
> should re-create it degraded.
>
> So, what I thought I would do is this:
>
>      mdadm --create /dev/md1 --level=3D6 --raid-devices=3D7 /dev/sdh2=20
> /dev/sdf2 /dev/sdi1 /dev/sdg1 /dev/sde1 missing missing

Phil has given good advice on this point which is worth following.
It is quite possible that there will still be corruption.

mdadm reads the first few stripes and stores them somewhere in each of
the spares.  md (in the kernel) then reads those stripes again and
writes them out in the new configuration.  It appears that one of the
writes failed, others might have succeeded.  This may not have corrupted
anything (the first few blocks are in the same position for both the old
and new layout) but it might have done.

So if the filesystem seems corrupt after the array is re-created, that
is likely the reason.
The data still exists in the backup on those new devices (if you haven't
done anything to them) and could be restored.

If you do want to look for the backup, it is around about the middle of
the device and has some metadata which contains the string
"md_backup_data-1".  If you find that, you are close to getting the
backup data back.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWJuvIAAoJEDnsnt1WYoG51zMP/35f8LPpGh+1k1FuOJRX25+l
ILwliYqgbMp+x7frpgMlVT7W1CXJJXEI5xxe0Zn/TJf6xr2I9aiwylGI7GBO7hJU
V6KuljXq6cRoJwdWzvYTqPsh4yaoKcNkg4SOgaTCEpDPLKTYQVn7nw6g6y0aY0m7
sk6Qnf7OitFJqEnMTox9VpW15EFfFfWuBOswFCHrzs2vZntm4NX57iVnG3kctp6O
pBR7oz5M9/m+FNtUFPTw2jmaGoJCqYZRHixQMt+8HtGLJJPr9MAbK70oTSYIEp7U
S/v08+QMYkbJccFCdctTyTDd94Ok6RHQD4xf2jxKeh2G/s/8Q4/+tGSf1WRXJxLB
9w21/xSaC9p/4meZjLl5YY2Vi7sU3TU/zvvRty8i6ySRTL+X0Yn+blapzvAbwFdF
N4I0noqiBiVczmj8QcPZKv21qVRgFu/SS1tyDWI4ntrO7EMCvHRuh6qu5edQfi0h
PdiV6A7Uqi9vHf6lCZad1jYHFWTFDuU0majVYyCghOXZ4j2GifM83+8zcIgbEhx8
SK1DzEHDgLmI3NhqS0tN2kxIPhDS/32Vm6SdZYm/lW35zeLDCehw0v/b6TmCUoGO
4U7VdRNNHuj+It+r9noKcqabhLsxwL/exxWUrp7Qn/NJKhHDEPSyLFB2V7crxjPw
Qhq9D5WyxpcALVMz5uv9
=n0sY
-----END PGP SIGNATURE-----
--=-=-=--
