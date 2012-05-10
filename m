From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid10 deadlock at 'Failing raid device'
Date: Thu, 10 May 2012 13:03:04 +1000
Message-ID: <20120510130304.6e2f325f@notabene.brown>
References: <4FAB2C3F.3070105@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zfRDh_OCdKOSxkvyw126gAj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FAB2C3F.3070105@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Shuklin <george.shuklin@gmail.com>
Cc: linux-raid@vger.kernel.org, Jonathan Nieder <jrnieder@gmail.com>
List-Id: linux-raid.ids

--Sig_/zfRDh_OCdKOSxkvyw126gAj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 May 2012 06:47:27 +0400 George Shuklin <george.shuklin@gmail.com>
wrote:

> As Jonathan Nieder proposed, writing here about new deadlock bug I met=20
> recently with raid10.
>=20
> Summary: under some condition multiple simultaneously failing devices=20
> cause with some chance deadlock on operations with failed array.
>=20
> Conditions:
> 3 Adadptec raid controllers (Adaptec Device 028, aacraid). Every one do=20
> have 8 directly attached SATA disks   (without extenders or expanders).=20
> Those disks are configured as 'JBOD' and passed to linux almost 'as is'.=
=20
> Those disks joined in three raid10 arrays (by using linux raid). Those=20
> three arrays joined in raid0.
>=20
> Configuration looks like this:
>=20
>    3 x RAID10
> md101 [UUUUUUUU] --\
> md102 [UUUUUUUU] ------ md100 [UUU]  (raid0)
> md103 [UUUUUUUU] --/
>=20
> After that all disks are deconfigured from adaptec utility. They=20
> dissappear from /dev/, but /proc/mdadm shows arrays fine.  After that=20
> some io performed on raid0. That, of cause, causing failure on all raid=20
> arrays and return IO error to calling software (in my case it was 'fio'=20
> disk performance test utility).
>=20
> Two arrays fails gracefully, but one did not. It stuck with one disk=20
> (which one was not in system) and did not return anything to calling=20
> software, like it was in raid10 deadlock, which was fixed in commit d9b42=
d.
>=20
> Content /proc/mdstat after failure:
>=20
> md100 : active raid0 md103[2] md102[1] md101[0]
>   11714540544 blocks super 1.2 256k chunks
>=20
> md101 : active raid10 sdv[7](W)(F) sdu[6](W)(F) sdo[5](W)(F) sdn[4](W)(F)=
 sdm[3](W)(F) sdg[2](W)(F) sdf[1](W)(F) sde[0](W)(F)
>   3904847872 blocks super 1.2 256K chunks 2 near-copies [8/0] [________]
>   bitmap: 0/466 pages [0KB], 4096KB chunk, file: /var/mdadm/md101
>=20
> md103 : active raid10 sdr[0](W)(F) sdab[7](W)(F) sdt[6](W)(F) sdl[5](W)(F=
) sdaa[4](W) sds[3](W)(F) sdk[2](W)(F) sdz[1](W)(F)
>   3904847872 blocks super 1.2 256K chunks 2 near-copies [8/1] [____U___]
>   bitmap: 1/466 pages [4KB], 4096KB chunk, file: /var/mdadm/md103
>=20
> md102 : active raid10 sdw[0](W)(F) sdj[7](W)(F) sdy[6](W)(F) sdq[5](W)(F)=
 sdi[4](W)(F) sdx[3](W)(F) sdp[2](W)(F) sdh[1](W)(F)
>   3904847872 blocks super 1.2 256K chunks 2 near-copies [8/0] [________]
>=20
> I recheck - /dev/sdaa was no longer in system, but raid10 has think it wa=
s.
>=20
> In dmesg those messages repeat very fast:
>=20
> [4474.074462] md/raid10:md103: sdaa: Failing raid device
>=20
> It was so fast so I got race between logging to ring buffer and syslog ac=
tivity and got this in /var/log/messages:
> May 5 21:20:04 server kernel: [ 4507.578517] md/raid10:md103: sdaa: Faid =
device
> May 5 21:20:04 server kernel: [ 4507.578525] md/raid10:md103: sdaa: Faaid=
 device
> May 5 21:20:04 server kernel: [ 4507.578533] md/raid10:md103: sdaa: aid d=
evice
> May 5 21:20:04 server kernel: [ 4507.578541] md/raid10:md103: sdaa: Faid =
devic
> May 5 21:20:04 server kernel: [ 4507.578549] md/raid10:md103: sdaa: Faid =
device
> May 5 21:20:04 server kernel: [ 4507.578557] md/raid10:md103: sdaa: Faid =
device
> May 5 21:20:04 server kernel: [ 4507.578566] md/raid10:md103: sdaa: Faila=
id device
>=20
>=20
> It was with linux 3.2.0-2-amd64

Fixed by commit fae8cc5ed0714953b1ad7cf86 I believe.

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dcommitdi=
ff;h=3Dfae8cc5ed

  From: NeilBrown <neilb@suse.de>
  Date: Tue, 14 Feb 2012 00:10:10 +0000 (+1100)
  Subject: md/raid10: fix handling of error on last working device in array.

  md/raid10: fix handling of error on last working device in array.

  If we get a read error on the last working device in a RAID10 which
  contains the target block, then we don't fail the device (which is
  good) but we don't abort retries, which is wrong.
  We end up in an infinite loop retrying the read on the one device.

NeilBrown


>=20
>=20
> ---
> wBR, George Shuklin


--Sig_/zfRDh_OCdKOSxkvyw126gAj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6sv6Dnsnt1WYoG5AQKacw/+LIqj/bli5KEQ5u6/o0J2WsQoISKFfXEf
yzic91C8BFCujPi5ljdGm+GIItotVMofF0jUZd91GKNZNERu2Ja4lByzaC/CnGoO
+33gyfnIUdMLsgMkxrIfh+MKg7Jz+5H7cxJWxGuzNZ+MC1RsSHfYtnPPvf+SA7t3
dNuuP1P4u7TJrvQgkWA7BZaYYR88TuAoSsqJr9Uf+Lgvmbvy8hew6M2qA9tqvExo
7O/5Heu/jtfb3MkNRDd0NGQ+gCSrHDMJOnc2R05RL09g0PbojTOrUlhGnE5WxrDF
A8ua1VLmJCPyhjSj3XSJ46ti4Ijib9LXrqyiXD3eMQfvJWChb6JB5i98zhKnip+h
v5QFzpWM4Nw20A5bShkB7X2VDxHU/f5MHG5jIlgJ8IuQRyvr6UsZ4Y4wMXdAjUGN
vTUxOhcN5yq+ZVR867v/GYW65x51gQ8yOshJ0m85MZdyG/OAY4YXFUO0ZO8LR18f
YRm4UEHs2FR62JQSc6srjqdHDgY3dUkwaIThvnwNry/VJFP3wRrZZwMTt4mKblN7
rUcnJ0GGECCRU0UkNtX//VVHaV/hpGXF89zXLLAv6A/Fmg1oJQLV2CYZq3E6R9hL
3SKZq1Naf0Yoa4p/s2dK2beo7hOYAIHbPIAF9g7HJ5d4/PMINEHqNzng9x+SllO3
FFqO93gGpuQ=
=bSV6
-----END PGP SIGNATURE-----

--Sig_/zfRDh_OCdKOSxkvyw126gAj--
