From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm raid6 recovery status
Date: Fri, 30 Mar 2012 06:41:45 +1100
Message-ID: <20120330064145.6747fff0@notabene.brown>
References: <B2B36B3006DB4C47A56D6BA19443F5D12DCEB542@IU-MSSG-MBX110.ads.iu.edu>
	<20120328151148.035bd737@notabene.brown>
	<B2B36B3006DB4C47A56D6BA19443F5D12DCEB63D@IU-MSSG-MBX110.ads.iu.edu>
	<20120329102704.14b08f2a@notabene.brown>
	<B2B36B3006DB4C47A56D6BA19443F5D12DCEBA2E@IU-MSSG-MBX110.ads.iu.edu>
	<B2B36B3006DB4C47A56D6BA19443F5D12DCEBAA4@IU-MSSG-MBX110.ads.iu.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8vYwYjtdvJgy6J4pp5hR=IE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B2B36B3006DB4C47A56D6BA19443F5D12DCEBAA4@IU-MSSG-MBX110.ads.iu.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Paramasivam, Meenakshisundaram" <mparamas@iupui.edu>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/8vYwYjtdvJgy6J4pp5hR=IE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Mar 2012 18:47:14 +0000 "Paramasivam, Meenakshisundaram"
<mparamas@iupui.edu> wrote:

>=20
> Clarification:
> >>should I do new array creation=20
> I meant running newfs on assembled 12 TB array, and restore data from bac=
kup, to resolve "df" reporting problem.

I would suggest asking on=20
    linux-ext4@vger.kernel.org

be sure to give lots of details - kernel version etc.
It would be worth running=20
   fsck -n /dev/md2
first and see if it reports anything strange.
Maybe  just a fsck will fix it.

NeilBrown


>=20
> ________________________________________
> From: Paramasivam, Meenakshisundaram
> Sent: Thursday, March 29, 2012 1:33 PM
> To: NeilBrown
> Cc: linux-raid@vger.kernel.org
> Subject: RE: mdadm raid6 recovery status
>=20
> Good news: Got ALL of our data back. [Actually it was 4.96TB not 7TB].
>                      mdadm is a good one.
>=20
> Bad news: "df" is reporting wrong, while "du" is showing full size.
> # df -kl /myarray
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/md2             11537161976    162432 10950945196   1% /myarray
> # du -sk /myarray
> 5326133556      /myarray
> #
>=20
> I never looked into du or looked in depth of the files & folders and simp=
ly got mislead by reported "df" usage; data was there all along. We definit=
ely want "df" for the array's filesystem (ext3) to report right.
>=20
> Now that we are backing up all of the data (at 400 Mbps) over network, I =
want to know if "df" reporting can be fixed easily or should I do new array=
 creation and restore data from backup.
>=20
> We are ordering a new RAID card, just to be on safer side.
>=20
> Sundar
>=20
> ________________________________________
> From: NeilBrown [neilb@suse.de]
> Sent: Wednesday, March 28, 2012 7:27 PM
> To: Paramasivam, Meenakshisundaram
> Cc: linux-raid@vger.kernel.org
> Subject: Re: mdadm raid6 recovery status
>=20
> On Wed, 28 Mar 2012 12:49:18 +0000 "Paramasivam, Meenakshisundaram"
> <mparamas@iupui.edu> wrote:
>=20
> > [root@in-rady-neuro9 ~]# df -kl /myarray
> > Filesystem           1K-blocks      Used Available Use% Mounted on
> > /dev/md2             11537161976    162432 10950945196   1% /myarray
> > Should be 7TB of used space.
>=20
> This is bad.  Something has happened to your filesystem.
> It is almost as though someone ran "mkfs" on the array.
> I don't know much about recovery after such an action, but I doubt you
> will get much back.
>=20
> >
> > [root@in-rady-neuro9 ~]# cat /proc/partitions
> > major minor  #blocks  name
> >
> >    8        0  438960128 sda
> >    8        1     512000 sda1
> >    8        2   51200000 sda2
> >    8        3  387247104 sda3
> >    8       16 1953514584 sdb
> >    8       32 1953514584 sdc
> >    8       48 1953514584 sdd
> >    8       64 1953514584 sde
> >    8       80 1953514584 sdf
> >    8       96 1953514584 sdg
> >    8      112 1953514584 sdh
> >    8      128 1953514584 sdi
> >  253        0  346226688 dm-0
> >  253        1   40992768 dm-1
>=20
> No md2 ???
>=20
> >
> > sd[b-i] are raid devices
> >
> > [root@in-rady-neuro9 ~]# mdadm --detail /dev/md2
> > /dev/md2:
> >         Version : 0.90
> >   Creation Time : Fri Dec 16 17:56:14 2011
> >      Raid Level : raid6
> >      Array Size : 11721086976 (11178.10 GiB 12002.39 GB)
> >   Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)  <<<=3D=3D=3D=3D=
=3D=3D Wrong! Should be 7TB of used array space.
>=20
> "Used Dev Size" isn't "how much of the array is used by the filesystem" -
> mdadm doesn't know anything about filesystems.
> It is "How much of each individual device is used by the array", which is
> usually a little less than the size of the smallest device.
> So 2TB is correct here.
>=20
>=20
> NeilBrown
>=20
>=20


--Sig_/8vYwYjtdvJgy6J4pp5hR=IE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3S6+Tnsnt1WYoG5AQIk4w//YRgDYjivDWIdem/7XIWrOCxrQhPMAjoL
JU80sPK2GaYFdVjRuqgKMa4PU5p+8x7dr7hQBTBvOuJImPwPFGWaLtVbaKmlIuAE
M/SGf8ugCvs2oRBEIZr4cnRPlOw0HPMedLZmalu22pLdRYO4gBbj3d/gL4UXiC4l
iDijJFpEoN1OQIuQUv6wcQzmhZrUgN9cERJj20zh1MdlywdJ0G/3g3vFz0NZffu7
g9kXPBA+3zuSmFrZhbkDWRxUK3snGVCZoNMmipemVFfSgRJeLet/VU8De9EiZfXR
Vacgh0Cbw6Fq2cA2nFJTm6haiL+TJcoqu8y5J3saQuSWqCZQ9DkErz9vUzF8quak
YHfZ1yf7Mdj0w5hK/FbJsIx58fj69t9QtFNUp1jxFbwlEEgdSwCOEpE2Ng4jgg+i
Dm9CbOvbehSF2lN7bkH6V3eCthufoXmNz6f22Mw5ZN4Fl/4IaKagMCuBiTEESUlf
IcwaOCMqaMr0ABd0b9+SBoANmQRbKfB/3Zwqvf0wqm/tBV5z7boa/ICL9z8ReV72
OlOwXgdgLmXIEGbm4vm1bNomX2IrM6XmQaB9f/3YFxd3yDERp2rA5F/E/0qgHSpZ
81/Abp2bqAzhO1HPJd8XnnhiVBbpV1sZzsXgiMCufLTLNGqIGTkf69z9AZp9RdAx
cyizOUPgh1A=
=Z6jw
-----END PGP SIGNATURE-----

--Sig_/8vYwYjtdvJgy6J4pp5hR=IE--
