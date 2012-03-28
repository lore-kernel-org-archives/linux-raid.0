From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm raid6 recovery status
Date: Thu, 29 Mar 2012 10:27:04 +1100
Message-ID: <20120329102704.14b08f2a@notabene.brown>
References: <B2B36B3006DB4C47A56D6BA19443F5D12DCEB542@IU-MSSG-MBX110.ads.iu.edu>
	<20120328151148.035bd737@notabene.brown>
	<B2B36B3006DB4C47A56D6BA19443F5D12DCEB63D@IU-MSSG-MBX110.ads.iu.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/y3YteD4HgWCNEH.zqgpdUas"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B2B36B3006DB4C47A56D6BA19443F5D12DCEB63D@IU-MSSG-MBX110.ads.iu.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Paramasivam, Meenakshisundaram" <mparamas@iupui.edu>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/y3YteD4HgWCNEH.zqgpdUas
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Mar 2012 12:49:18 +0000 "Paramasivam, Meenakshisundaram"
<mparamas@iupui.edu> wrote:

> [root@in-rady-neuro9 ~]# df -kl /myarray
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/md2             11537161976    162432 10950945196   1% /myarray
> Should be 7TB of used space.

This is bad.  Something has happened to your filesystem.
It is almost as though someone ran "mkfs" on the array.
I don't know much about recovery after such an action, but I doubt you
will get much back.

>=20
> [root@in-rady-neuro9 ~]# cat /proc/partitions
> major minor  #blocks  name
>=20
>    8        0  438960128 sda
>    8        1     512000 sda1
>    8        2   51200000 sda2
>    8        3  387247104 sda3
>    8       16 1953514584 sdb
>    8       32 1953514584 sdc
>    8       48 1953514584 sdd
>    8       64 1953514584 sde
>    8       80 1953514584 sdf
>    8       96 1953514584 sdg
>    8      112 1953514584 sdh
>    8      128 1953514584 sdi
>  253        0  346226688 dm-0
>  253        1   40992768 dm-1

No md2 ???

>=20
> sd[b-i] are raid devices
>=20
> [root@in-rady-neuro9 ~]# mdadm --detail /dev/md2
> /dev/md2:
>         Version : 0.90
>   Creation Time : Fri Dec 16 17:56:14 2011
>      Raid Level : raid6
>      Array Size : 11721086976 (11178.10 GiB 12002.39 GB)
>   Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)  <<<=3D=3D=3D=3D=3D=
=3D Wrong! Should be 7TB of used array space.

"Used Dev Size" isn't "how much of the array is used by the filesystem" -
mdadm doesn't know anything about filesystems.
It is "How much of each individual device is used by the array", which is
usually a little less than the size of the smallest device.
So 2TB is correct here.


NeilBrown



--Sig_/y3YteD4HgWCNEH.zqgpdUas
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3OeSDnsnt1WYoG5AQLwQg/+P270Ji+w8wAfDOTMU67qO39jsZgkSVjN
zuukAYObQfRCCVFd/RlIzx/OKaQwBdaLwwNH1x8yT+QG11ImBa7ZGfiJ/NtspyHW
8kKLbq6DBn7IoPC8jtU+pR3DhMkNQcnpEIil8gOnMyYud/a+U0OFqk1K07hVm4Bb
cSm4HYwuBkWP+eRbnDlXnB2zyVfxp0Z3rff78xdMpuVEBhApKbj0ydp2wO4VdBFV
O1T3IytUy/i9hfeTAzyrodEUWClxoei/tAz8tGXqGApyuGI+XmxTCUaXLYt2bDC7
BbR7SmOfX8gmoAYXOtSHluCMjYzcNmbqRcR/+awi9y278HUcpf/EJYtshJwMdD2/
Ew7lQcU7mY6DMGoKusHPXujobZK3L7ETBcau1fKWAevJPPot86G2+039wGUcATCM
TLBiNd3upaFRAtO4FSbMlHTPR4lClqqg7JUK8TX1SQK0FxsoLi76DWaRQCbW3RqS
bFI5wHQ/SmQELohPqP8KQ0WvX6Wn3TE33bZFoxx0WdJ1QuGJn/wGcOY6VPP5FaIt
Ch09/qG7hDELVkiWdlVu+2cDfM2O42PmHXzG/fvzfEi4i/FralLLRti+noM/ce23
mNUlDyIHRzDgYPr/aKM5gbZmJoseqMCpDoa6R3E2tUw3dK2KGSMcdruhnOkMvqBA
fEgBe0NI2qM=
=3+oQ
-----END PGP SIGNATURE-----

--Sig_/y3YteD4HgWCNEH.zqgpdUas--
