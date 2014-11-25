From: NeilBrown <neilb@suse.de>
Subject: Re: raid10 - won't rebuild - assigns all added disks as spares
Date: Tue, 25 Nov 2014 13:28:10 +1100
Message-ID: <20141125132810.3b4aa867@notabene.brown>
References: <5473E018.3020507@infinitedepth.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/5NuVqJsulfziQQv+3peEfMX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5473E018.3020507@infinitedepth.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Molyneux <jonathan@infinitedepth.com.au>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/5NuVqJsulfziQQv+3peEfMX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Nov 2014 12:49:12 +1100 Jonathan Molyneux
<jonathan@infinitedepth.com.au> wrote:

> Hi Everyone,
>=20
> Have a strange situation that hasn't happened before.
> Running Debian 7.7 with kernel version 3.2.63-2+deb7u1.
> Have a raid10 that runs the server (boot's off a raid1) that after=20
> replacing a failed disk, just won't rebuild.
>=20
> This is what it looks like without the disk (failed & removed):
> md1 : active raid10 sda2[6] sdc2[4] sdb2[1]
>        1952987136 blocks super 1.2 512K chunks 2 far-copies [4/3] [UUU_]
>        bitmap: 8/15 pages [32KB], 65536KB chunk
>=20
> Then when the disk is added:
> md1 : active raid10 sdd2[5](S) sda2[6] sdc2[4] sdb2[1]
>        1952987136 blocks super 1.2 512K chunks 2 far-copies [4/3] [UUU_]
>        bitmap: 8/15 pages [32KB], 65536KB chunk
>=20
> Nothing unusual is being spat out in dmesg.
> When removing the disk:
> [313434.073997] md: unbind<sdd2>
> [313434.138307] md: export_rdev(sdd2)
> When adding the disk:
> [313468.056484] md: bind<sdd2>
>=20
> This is a strange one that I haven't had before.
> Any thoughts on how to kick the rebuild off without needing a reboot ?

I'm sure I've seen this bug before... and fixed it.
I don't remember the details and cannot find anything obvious in change log=
s.

You could try

   echo recover > /sys/block/md1/md/sync_action

Alternately, if you are re-adding a disk that had just been removed, you co=
uld

   mdadm /dev/md1 --remove /dev/sdd2
   mdadm --zero /dev/sdd2
   mdadm /dev/md1 --add /dev/sdd2

that will force a full recovery instead of just a bitmap-based recovery.
That will of course take longer than a bitmap-based recover, but seeing the
bitmap based recovery isn't starting, that could still be an improvement.

NeilBrown

--Sig_/5NuVqJsulfziQQv+3peEfMX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVHPpOjnsnt1WYoG5AQJG3BAAh07i1OA7869YcJI+CeZ1EfRijQj+J3oa
sv9ZPfmHVyrjMZkKWiwMskQycsjFP+pjkAVrB5HCCzby9y/zUjCALVbxUCFr1Ddb
KleGvdy4eWHwf5AQP1PKd800osH7qoJmshrTHkytxluZk9I7Etrx428TCHSjmRZ0
OGVDfxHA72XIxzk/+LIX/2ew/hxTdCe9ObDnNk+6YpAErlxZ6snCTP+xtxq4c83B
Yv9O+WpEUoDlBIwqMVdAJMpp0jOSpQsG4wjplsuG4qNxWXobpGEgfmQBaifrD/lz
op5IQqnEfIKUXcxYdBAkBPLJd1tFf5cndLRIIjaSQshwlH9NX+qNtIc8zIPXJFDb
TndSDsT7CFXKJJ9RC8KP0mZamCDu26B0R22SRNGb1P2TQWThViBNQ1hHG3y5ZypF
e56OfwqKw8gRqMa1rbrBWiTKNv4Byaa0DN6RomT7pRH89jBOwo36dv4aSIR5/9yP
Pq/eXEhooWtIVs05NT7tSX3iELDY5cnx9I0km6kDq0i8IeOOJrgi2+5PsEQNtWD3
zbZj2bfW5/eTqOFSEdT7HkA330PV8L71KhMe8OXFwoVTe9UBgsJahMFeGTm0o9LG
Tq9V2VJMxMn0xzpAH+DrRbhKKM46pn/Rehp3cipFEYkLx0IuAXyYksIo2bxPWCQY
J4jkj1rwyM0=
=IiPb
-----END PGP SIGNATURE-----

--Sig_/5NuVqJsulfziQQv+3peEfMX--
