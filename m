From: Nagilum <nagilum@nagilum.org>
Subject: Re: raid5 reshape/resync
Date: Sun, 25 Nov 2007 20:04:31 +0100
Message-ID: <20071125200431.2wbk051yoso4owsk@cakebox.homeunix.net>
References: <20071124120209.0t70rfkfswkcww0g@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_1gxz6ybkypus";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071124120209.0t70rfkfswkcww0g@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_1gxz6ybkypus
Content-Type: text/plain;
	charset=ISO-8859-2;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from nagilum@nagilum.org ---------
     Date: Sat, 24 Nov 2007 12:02:09 +0100
     From: Nagilum <nagilum@nagilum.org>
Reply-To: Nagilum <nagilum@nagilum.org>
  Subject: raid5 reshape/resync
       To: linux-raid@vger.kernel.org

> Hi,
> I'm running 2.6.23.8 x86_64 using mdadm v2.6.4.
> I was adding a disk (/dev/sdf) to an existing raid5 (/dev/sd[a-e] -> md0)
> During that reshape (at around 4%) /dev/sdd reported read errors and
> went offline.
> I replaced /dev/sdd with a new drive and tried to reassemble the array
> (/dev/sdd was shown as removed and now as spare).
> Assembly worked but it would not run unless I use --force.
> Since I'm always reluctant to use force I put the bad disk back in,
> this time as /dev/sdg . I re-added the drive and could run the array.
> The array started to resync (since the disk can be read until 4%) and
> then I marked the disk as failed. Now the array is "active, degraded,
> recovering":
>
> nas:~# mdadm -Q --detail /dev/md0
> /dev/md0:
>         Version : 00.91.03
>   Creation Time : Sat Sep 15 21:11:41 2007
>      Raid Level : raid5
>      Array Size : 1953234688 (1862.75 GiB 2000.11 GB)
>   Used Dev Size : 488308672 (465.69 GiB 500.03 GB)
>    Raid Devices : 6
>   Total Devices : 7
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>
>     Update Time : Sat Nov 24 10:10:46 2007
>           State : active, degraded, recovering
>  Active Devices : 5
> Working Devices : 6
>  Failed Devices : 1
>   Spare Devices : 1
>
>          Layout : left-symmetric
>      Chunk Size : 16K
>
>  Reshape Status : 19% complete
>   Delta Devices : 1, (5->6)
>
>            UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
>          Events : 0.726347
>
>     Number   Major   Minor   RaidDevice State
>        0       8        0        0      active sync   /dev/sda
>        1       8       16        1      active sync   /dev/sdb
>        2       8       32        2      active sync   /dev/sdc
>        6       8       96        3      faulty spare rebuilding   /dev/sdg
>        4       8       64        4      active sync   /dev/sde
>        5       8       80        5      active sync   /dev/sdf
>
>        7       8       48        -      spare   /dev/sdd
>
> iostat:
> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
> sda             129.48      1498.01      1201.59       7520       6032
> sdb             134.86      1498.01      1201.59       7520       6032
> sdc             127.69      1498.01      1201.59       7520       6032
> sdd               0.40         0.00         3.19          0         16
> sde             111.55      1498.01      1201.59       7520       6032
> sdf             117.73         0.00      1201.59          0       6032
> sdg               0.00         0.00         0.00          0          0
>
> What I find somewhat confusing/disturbing is that does not appear to
> utilize /dev/sdd. What I see here could be explained by md doing a
> RAID5 resync from the 4 drives sd[a-c,e] to sd[a-c,e,f] but I would
> have expected it to use the new spare sdd for that. Also the speed is
> unusually low which seems to indicate a lot of seeking as if two
> operations are happening at the same time.
> Also when I look at the data rates it looks more like the reshape is
> continuing even though one drive is missing (possible but risky).
> Can someone relief my doubts as to whether md does the right thing here?
> Thanks,
>
----- End message from nagilum@nagilum.org -----

Ok, so the reshape tried to continue without the failed drive and =20
after that resynced to the new spare.
Unfortunately the result is a mess. On top of the Raid5 I have =20
dm-crypt and LVM.
Although dmcrypt and LVM dont appear to have a problem the filesystems =20
on top are a mess now.
I still have the failed drive, I can read the superblock from that =20
drive and up to 4% from the beginning and probably backwards from the =20
end towards that point.
So in theory it could be possible to reorder the stripe blocks which =20
appears to have been messed up.(?)
Unfortunately I'm not sure what exactly went wrong or what I did =20
wrong. Can someone please give me hint?
Thanks,
Alex.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..


--=_1gxz6ybkypus
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHScc+AKWN2UY+sLwRAreuAJ0T1Xw27EUWTriOs60gND/i917+9wCeISw+
wSBNs9/PWzxGUShxODuor10=
=3VZ1
-----END PGP SIGNATURE-----

--=_1gxz6ybkypus--
