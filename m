From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5 NAS Recovery...00.90.01 vs 00.90
Date: Thu, 22 Nov 2012 16:02:48 +1100
Message-ID: <20121122160248.42189273@notabene.brown>
References: <CAKcp_7ZrR+L5jZBK3cd-z780Cw76XpwMuWmwtUGt=ecwbx_LPg@mail.gmail.com>
	<20121121083936.1a4d4b13@notabene.brown>
	<CAKcp_7YdAgfoVM_j+jQNE61cLoEVd+y75zfyPNy1wv9w7+jfdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Qcb9.+21rk8e3S+CZeYWc53"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKcp_7YdAgfoVM_j+jQNE61cLoEVd+y75zfyPNy1wv9w7+jfdQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stephen Haran <steveharan@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Qcb9.+21rk8e3S+CZeYWc53
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Nov 2012 12:29:53 -0500 Stephen Haran <steveharan@gmail.com> wro=
te:

> Thank you Neil for your reply comments below...
>=20
> On Tue, Nov 20, 2012 at 4:39 PM, NeilBrown <neilb@suse.de> wrote:
> > On Tue, 20 Nov 2012 15:41:57 -0500 Stephen Haran <steveharan@gmail.com>=
 wrote:
> >
> >> Hi, I'm trying to recover a Western Digital Share Space NAS.
> >> I'm able to assemble the RAID5 and restore the LVM but it can't see
> >> any filesystem.
> >>
> >> Below is a raid.log file that shows how the raid was configured when
> >> it was working.
> >> And also the output of mdadm -D showing the raid in it's current state.
> >> Note the Version difference 00.90.01 vs. 0.90. And the array size
> >> difference 2925293760  vs. 2925894144
> >> I'm thinking this difference may be the reason Linux can not see a fil=
esystem.
> >
> > Probably not - losing a few blocks from the end might make 'fsck' compl=
ain,
> > but it should still be able to see the filesystem.
> >
> > How did you test if you could see a filesystem?  'mount' or 'fsck -n' ?
>=20
> Yes I tried both mount and fsck. It can't find the superblock.
> Testdisk finds ext3 partitions but can not see data.
> But looking with hexedit the data appears to still be there.
>=20
> > It looks like you re-created the array recently (Nov 18 12:07:53 2012) =
 Why
> > did you do that?
>=20
> The end user attempted a firmware upgrade on the NAS box and could not ac=
cess
> their data afterwards. Not sure if the firmware update or the end user
> did the re-create.

It looks like the devices have been repartioned.  The /dev/sdX4 partitions
are 200Meg smaller than they were before.  Quite possible the start of the
partitions has moved as well as the end.
So the array created in these partitions will be quite different to what it
was before.

I don't suppose you have the old partition tables, like you have the old
"mdadm --detail" output?

If not, you need to find where the ext3 superblock is, deduce from that whe=
re
the start of the device should be (I don't know if the superblock is at the
start of the device, or in the second block) and then recreate the partition
table.
The X4 partitions need to be at least 128K larger than the "used device siz=
e".

Good luck.

NeilBrown

--Sig_/Qcb9.+21rk8e3S+CZeYWc53
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUK2x+Dnsnt1WYoG5AQIZwxAAstVSZ4zM1Myo4WVcatVr0NR4R7IdEIX4
icukEifF1P9ybild34FBMKZU/McotaBs30UVujnbT+4XcLhxLkoJZMuxAVcdPwA8
5FXn+B3tw2L2040LJYrlp+UBAUi87CDfmcljQ+4b9kmCaLpFiM7XaoD91M8xTRPA
powuCsuV1bazrBEspmzCJf653AJdOJ21Geshoko2V5mznZjLEF4OmWMV9qPb0VwZ
jASCjPu61/+VCVIBG3pZSy/k2aoz1lf9lAa9FMKoOwrHkkClEoxzHifWgteEfpfI
YKcuvlfGkAoaFC/hdrVRzsS9QprioGU/iJGEEM4jLvecQjCdR29mJFe79K3zeuvb
cp4ym0gorPckreegGkIe/HeGRktpGsi3QDKVmPy2WS9Rms+SPGq++CtaVFOFGZha
pqR0hFPDB5mILBejfmwW8krjaAkcwZzcfiBudJgtP9sXzs+GzwJM69zzeQH5ZDGS
q4t+qiqeUdB0ObDpX/qWRAxfpoOkTjYVnLsjkx3MNGAlKDXA6yocv7DfRKDpfyVA
pomtD1c5AVVKXc1owQ8JUt/W852k64p3f18pnkUtMqmD79lA8YY9n6AxkPuAIiFZ
rh4tHaiQ0u3obVQQQn+MOireATIon/SO1bo4hN9b7E4+tvcdF1VlDS4eSfzSoK5n
Cdgmw0mGthQ=
=+3ik
-----END PGP SIGNATURE-----

--Sig_/Qcb9.+21rk8e3S+CZeYWc53--
