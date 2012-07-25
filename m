From: NeilBrown <neilb@suse.de>
Subject: Re: Does mdadm require udev/sysfs to create imsm RAID1?
Date: Wed, 25 Jul 2012 11:24:35 +1000
Message-ID: <20120725112435.30517e97@notabene.brown>
References: <CABxOMqwmk8TBaj9KXz9X12PmFx5mRnUe-xv+DsP5pmqojK3Dng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/A/O=ZHhEiE/IhvlfanX.5_R"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABxOMqwmk8TBaj9KXz9X12PmFx5mRnUe-xv+DsP5pmqojK3Dng@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Scott Johnson <scottej23@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/A/O=ZHhEiE/IhvlfanX.5_R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Jul 2012 17:54:08 -0700 Scott Johnson <scottej23@gmail.com> wrot=
e:

> The question may seem strange but here's the problem I'm trying to solve.
>=20
> I have setup all the servers in my environment to PXE boot and nfs
> mount an older root filesystem that is a bit aged and predates udev
> and sysfs.  It just has the /dev/ device tree.
>=20
> This worked well for installing proprietary PCI highpoint 1720 raid
> drivers that aren't included in the kernel.  Then I would write my OS
> images to the drives after installing the raid driver.  However, now
> my latest hardware comes with the Intel IMSM and I don't need to use
> the pci raid anymore if I can get this on-board imsm raid to work.
>=20
> I built the latest mdadm (3.2.5) and added it to my root filesystem.
> The mdadm --examine /dev/sda seems to see that the drives are
> configured but mdadm create fails and the mdadm --assemble --scan does
> nothing.  I did configure the RAID1 array in the bios.
>=20
> I'm currently using an older 2.6.30 kernel, but should be new enough
> for imsm via mdadm.  If mdadm requires udev and sysfs info then I'll
> have to figure out how to include that into my root filesystem.
>=20
> -bash-3.1# uname -r
> 2.6.30
>=20
> -bash-3.1# mdadm -V
> mdadm - v3.2.5 - 18th May 2012
>=20
> -bash-3.1# cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> unused devices: <none>
>=20
> -bash-3.1# mdadm -E /dev/sda
> mdadm: /dev/sda is not attached to Intel(R) RAID controller.
> mdadm: /dev/sda is not attached to Intel(R) RAID controller.
> /dev/sda:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.1.00
>     Orig Family : 41dddea6
>          Family : 41dddea6
>      Generation : 00000035
>      Attributes : All supported
>            UUID : 64fabbb6:c0dfc0df:dc004a9e:620cffc5
>        Checksum : 242ff277 correct
>     MPB Sectors : 1
>           Disks : 2
>    RAID Devices : 1
>=20
>   Disk00 Serial : Z2AFVZJZ
>           State : active
>              Id : 00020000
>     Usable Size : 625137928 (298.09 GiB 320.07 GB)
>=20
> [Volume0]:
>            UUID : 83543199:fdb1493f:0f2af5ef:e2287504
>      RAID Level : 1
>         Members : 2
>           Slots : [UU]
>     Failed disk : none
>       This Slot : 0
>      Array Size : 625137664 (298.09 GiB 320.07 GB)
>    Per Dev Size : 625137928 (298.09 GiB 320.07 GB)
>   Sector Offset : 0
>     Num Stripes : 2441944
>      Chunk Size : 64 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : normal
>     Dirty State : clean
>=20
>   Disk01 Serial : Z2AFVZN8
>           State : active
>              Id : 00030000
>     Usable Size : 625137928 (298.09 GiB 320.07 GB)
>=20
> -bash-3.1# mdadm --assemble --scan
> mdadm main: failed to get exclusive lock on mapfile
> mdadm: No arrays found in config file or automatically
>=20
> -bash-3.1# mdadm --create /dev/md/imsm -e imsm -n 2 /dev/sda /dev/sdb
> mdadm: /dev/sda is not attached to Intel(R) RAID controller.
> mdadm: /dev/sda is not suitable for this array.
> mdadm: /dev/sdb is not attached to Intel(R) RAID controller.
> mdadm: /dev/sdb is not suitable for this array.

IMSM raid should work without udev.  It definitely does require sysfs thoug=
h.

However it seems that mdadm doesn't think you have an Intel RAID controller,
so it isn't going to work for you.
You can over-ride that check using
  export IMSM_NO_PLATFORM=3D1

However it may be that it says  that because you don't have /sys mounted.
If you really don't (and I imagine many things would fail without /sys)
then you really need to get it mounted.

NeilBrown


--Sig_/A/O=ZHhEiE/IhvlfanX.5_R
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUA9K0znsnt1WYoG5AQKH5Q//XP2fg7RvjR9lCvPy64m/BtXwQ7CSGMlw
hsbCgwNAWqiyUZba4ijj5VU/cbg/NIpJYWoS8N8T21LRt9H4a8LEXmHaXQZ+ac16
fEcb0UNi1Lesman4VW3+/mvAoe9jJ4/QD/wgHYUqDp5oL0j/p6fhYmxP34TxpBxO
ZrGZ//1LqwMmwiiXae53I9U9NJnBKGaoFi3meq29iEUwbgd10ahEea44Kkm6LanF
2uERgTlh5kw7Lj4hjpAzEIGS/Z6FYHzLMbbDBawGzrY4GKrW/Dhghxw1va/eix0g
uF5zxuPCI4zz5MV8y10sQasYCdTfPubzMKUsIe5j5d8iwgHioPWKHwspO2YrkpNk
2quVrr0vwOG7kiTbfGnlkEd2Ciytsd7DF4I6EExkkHbJO3/CegUpmnA5pVcecTnl
zJDoibEdSeioK3MBvtlhMlGmyCGwLUBlyFOgPh0ms4jeol7+/nN9YBfTQOGSMtu0
tmLEjz7Qbwl1HpDKdi98dWKAIV4UB0g7u9cUt8PAhLBqvw9dEMNOFRdcjnxmgnmw
uI141trkNpYa27/pkj1kO8uSkfnzb/NqgRrrpx7YbORwfgRciGSskwbRd6aT9ja4
Hz88mkLcpys9p/vEB+g4CScojcPxXQ4CIPk1rUTGaLva3lLs6UdRLvUi1tliMDl1
OoC4CFhQJ98=
=9/6Q
-----END PGP SIGNATURE-----

--Sig_/A/O=ZHhEiE/IhvlfanX.5_R--
