From: NeilBrown <neilb@suse.com>
Subject: Re: MDADM grow /dev/md0 - chunk size
Date: Mon, 23 Jan 2017 09:52:51 +1100
Message-ID: <87lgu2emgs.fsf@notabene.neil.brown.name>
References: <8ef3e9f2d526ebba88b94a0e6f09fdef.webmail@mx1bln1.prossl.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8ef3e9f2d526ebba88b94a0e6f09fdef.webmail@mx1bln1.prossl.de>
Sender: linux-raid-owner@vger.kernel.org
To: "J. Cassidy" <sean@jdcassidy.eu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 15 2017, J. Cassidy wrote:

> Hello all/Neil,
>
>
>
>
> I am trying to change the chunk size on a RAID 0 (two SSD) from 512K to 6=
4K.
>
> I am running Debian Stretch with a 4.10 kernel.
>
> MDADM version is 4.0 (GIT).
>
> This is the command string being issued -
>
> mdadm --grow -c 64 --backup-file=3D/zz/backup.file /dev/md0
>
> or
>
> mdadm --grow -c 64  /dev/md0
>
> both of the abovementioned commands produce this message -
>
>
> "mdadm: /dev/md0: could not set level to raid4"
>
>
> A snippet from dmesg -
> .
> .
> md/raid:md0: cannot takeover raid0 with more than one zone.
> md: md0: raid4 would not accept array

Your two partitions that form the RAID0 array are different sizes.
This causes raid0 to create 2 zones, one which covers all of the smaller
partition and an equal portion of the larger partition, and one which
covers the remainder of the larger partition.

raid4 does not have a similar concept of zones, so it is not possible to
convert the raid0 into a degraded raid4.
raid0 does not support chunk-size changes (or any changes) directly.
These are performed by transforming the RAID0 to RAID4 and having the
raid4 module perform the change.

The consequence of all this is that: sorry, you cannot change the chunk
size of the array.

And... please don't send nag emails so soon - it was barely more than
24hours after the original.  This just comes across as rude and
impatient.  People have other commitments.
My rule of thumb is to wait at least a week before resending - and then
resend the full text of the original.  Your nag email was not only too
soon, but contained no detail and so was useless.

NeilBrown


> .
> .
>
> My MDADM setup -
>
>
> mdadm --detail /dev/md0
> /dev/md0:
>         Version : 1.2
>   Creation Time : Sat Jan 14 16:51:54 2017
>      Raid Level : raid0
>      Array Size : 497783808 (474.72 GiB 509.73 GB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>
>     Update Time : Sat Jan 14 16:51:54 2017
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>      Chunk Size : 512K
>
>            Name : Pezenas:0  (local to host Pezenas)
>            UUID : 77cd6f4e:f98bf2b0:862948df:12da38fa
>          Events : 0
>
>     Number   Major   Minor   RaidDevice State
>        0     259        4        0      active sync   /dev/nvme0n1p2
>        1     259        2        1      active sync   /dev/nvme1n1p1
>
>
> I recall doing something similiar a few years ago and it worked, though n=
ot using
> NVME drives.
>
>
> Any help/pointers much appreciated.
>
>
>
>
> Regards,
>
>
>
> John
>
>
>
>
>
>
> John Cassidy
>
> Obere B=C3=BChlstrasse 21
> 8700 K=C3=BCsnacht (ZH)
> Switzerland / Suisse / Schweiz
>
>
> Mobile:    +49  152 58961601 (Germany)
> Mobile:    +352 621 577 149  (Luxembourg)
> Mobile:    +41  78 769 17 97 (CH)
> Landline:  +41  44 509 1957
> Mobile email: mobile@jdcassidy.eu
>
> http://www.jdcassidy.eu
>
> "Aut viam inveniam aut faciam" - Hannibal.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAliFN8MACgkQOeye3VZi
gbnR0hAAuDz4VoCN1sD7zNttLE9dwVC3OS93UdFnnrcDLLVWVSl/gGCf61WmTFaf
Bu00AVMBDEsrkzy7kJdLTuvkwbiG1fm6UoC1Nxj82HdAT3rVcrux8+msv23p0A5a
bQn2+/tpnbbDKn/6TrGlvdQl4HpZAubgvQtD5kDgfKlf1NlDX5np5pLFgA4ZG07E
2pG2eXkw8KF7fetjgMP+q/qmBM8UaL1ijo02d7tqlQ5h4UFdxfmbTBEttdf4ijgt
lpjcLMupmnuC5G+AJRqVAe83ui7pmtC2wT7udaozMn0+qErGBaJM6i1EZvaG2BXP
UPv1jHqzCMJ9JVaoiTe5lYmzepuVR3LNzN/pVrJhCF3EDEyx3ui4gI9pYM0y7wyY
dw4sdrkM1bPIyssIao77U8pORb1zj76qa102JwuaF5ByvCSk+SvX02iWza0iAm6G
DGi2spODbDFBBZKfAaNTGJpd5/wBTlyL9O+mcOtn2zFKYx7pdk9lLwFn6N/UVvYb
cU3zEBiI6ZGpyErr2U4wl7C2ZKO5S5q2XIQYxboK10ceC8rTdxz1HBcufu5ENS5a
MHNZsrJw/mEDN0fVU21bluwAMsod2hJ6pdIzX+CFURQEofGzY6+ipXpJD8UsgawT
cCHIciNRYUO1NWMC2FmmKAm5WrQ4koa806tkLhmHOoXmMPWDh3w=
=Hsho
-----END PGP SIGNATURE-----
--=-=-=--
