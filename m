From: NeilBrown <neilb@suse.de>
Subject: Re: Fake RAID 10 on ASRock Z97 Extreme3 with Slackware 14.1
Date: Tue, 4 Nov 2014 08:57:55 +1100
Message-ID: <20141104085755.3ef82b3d@notabene.brown>
References: <14976849ec4.ace7bf4939116.3019157828391505014@zoho.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/sSp=1CJtdK0MhF9cn3YXq/p"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <14976849ec4.ace7bf4939116.3019157828391505014@zoho.com>
Sender: linux-raid-owner@vger.kernel.org
To: gornea <gornea@zoho.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/sSp=1CJtdK0MhF9cn3YXq/p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 03 Nov 2014 17:47:48 +0100 gornea <gornea@zoho.com> wrote:

>=20
> Hello,
>=20
> I hope I'm on the right email list. I'm facing a problem during Slackware=
 14.1 installation. I have a ASRock motherboard (Z97 Extreme3) with Intel R=
apid Storage Technology 13. I have 4 identical new 4-TBy WD hard drives. I =
configured the option ROM for RAID 10. When booting with Slackware 14.1 CD =
md finds the array but it always mounts it read only. I tried to work on it=
 to make writable but I was not successful. I have tried to boot with the l=
atest Ubuntu Server CD and it works well. I have also tried to delete the R=
AID 10 in the option ROM and then create it with mdadm after booting with S=
lackware 14.1 and I always produces a read only volume. I get no errors or =
warnings and in general everything seems fine except that I can not write o=
n it (for example I can not create partitions). The md version with Slackwa=
re 14.1 boot disk is 3.2.6 and the kernel is 3.10.17. So I'm starting to wo=
nder if actually there is a know problem with that md/kernel? Or maybe ther=
e is a problem with the way I use it, but frankly I run out of ideas how to=
 proceed further. This is the output of /proc/mdstat
>=20
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]=
 [multipath]
> md126 : active (read-only) raid10 sda[3] sdb[2] sdc[1] sdd[0]
> 7814032384 blocks super external:/md127/0 64K chunks 2 near-copies [4/4] =
[UUUU]
>=20
> md127 : inactive sda[3](S) sdb[2](S) sdc[1](S) sdd[0](S)
> 9040 blocks super external:imsm
>=20
> unused devices: <none>
>=20
> Thanks a lot for any suggestion about how to proceed! I would like to ins=
tall the fake RAID if it is not impossible with Slackware 14.1. I know that=
 eventually it is possible to install a software RAID but I would like to u=
nderstand why the Intel fake RAID is not working with Slackware 14.1.
>=20

More likely a problem with Slackware than with the kernel/mdadm version.

It should a lot like "mdmon" isn't running.
If you simple run
   mdmon md127 &

you will probably get write access.
Mdadm should do this for you, or tell systemd to, depending on configuratio=
n.

NeilBrown

--Sig_/sSp=1CJtdK0MhF9cn3YXq/p
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFf6Yznsnt1WYoG5AQL3YhAAlOJHKkrJUS4dpX50p0ImQnFzygakqJyI
NWyR27amhb7uUtlJSVZbz3tNrXLSuc6r3A+hOGoMW0n7RSSzBZqKHE0sUY3CxXSX
4Ib/4frPc44mAh00ClLvwpzUpepXVnumvymQcYNTtRe/0hYrr6NrXN3QtSkjhFBl
YMpMGt+ZCFvNkxtmaoNXDfgwYIYjChHrKWsbLrsRLLeD+s19/eIsO1Q+q74czwWj
cKu4W/hxjXM7ZoNRR7FWpDZrof6M3J7ZXZIua2Mf3ElSKTW5uf+sKocGOv3G54/g
x2j2eFylumM/YyL81cy53HoQfridsjilSrBk9nrxTeCQdpaAlhuC/FZtyEOPunau
sjHSZNdIn42e5gb8fhWbszkfc3Egw33a5j2vRYcJ1aAsGjYgtvzoeF63MMhOeLJT
EhGrsV1pPPokwaQxjndvQUcscJZeCKPcDpsMwdulu5+yxHPghLQGHHUweUcFZ6p4
X9EBmOyf1cPK+7kKBSWaEPI5+ZHoEf46FjA17BRTXFWK3c3cNP6rsbOKGpPv6/UO
R8Kv2/LQOvuVXCK0c21PV+eE+RPD1JMbo5AJbwLUt9PTaAWeQli93ZrwcgJXEYM8
aPXewj4n1qmXkJ1pKeaDXx/crwgYOWiKYd4ENXR4x8Qqf9SoCZuzIZFIW9QN/IPX
FUK6M3GzKIA=
=SbUg
-----END PGP SIGNATURE-----

--Sig_/sSp=1CJtdK0MhF9cn3YXq/p--
