From: NeilBrown <neilb@suse.de>
Subject: Re: Failed RAID6
Date: Sat, 25 Feb 2012 07:52:26 +1100
Message-ID: <20120225075226.54c42fb2@notabene.brown>
References: <1788692158.60895.1330105517283.JavaMail.root@zimbra.cis.uab.edu>
	<1217710129.60911.1330106199149.JavaMail.root@zimbra.cis.uab.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Yg/b2OtIc+VvAXzOk4.cJN."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1217710129.60911.1330106199149.JavaMail.root@zimbra.cis.uab.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Larry Owen <larryowen@cis.uab.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Yg/b2OtIc+VvAXzOk4.cJN.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Feb 2012 11:56:39 -0600 (CST) Larry Owen <larryowen@cis.uab.edu>
wrote:

> We have a raid6 array with 3 "failed" discs.  However, smart=20
> status for all drives is ok.  I'm also not seeing any io errors
> in my logs (except when the discs were initially dropped). I=20
> also tried reading raw data from one of the failed drives,=20
> using dd.  I was able to get data, still no io errors.
>=20
> We're thinking about trying to re-add or assemble --force,
> in hopes of getting it up to recover some data (did I mention
> the users put important data on here knowing it was not backed
> up).
>=20
> Our main concern is that we add the discs and the system start=20
> rebuilding.  Any suggestions on how we should proceed?

Use assemble --force - this situation is exactly what it is for.

mdadm -S /dev/md0
mdadm -A --force /dev/md0

You might need to list all the component devices, depending on what is in
your mdadm.conf

NeilBrown


>=20
> Thanks,
> Larry Owen
>=20
> ################### MDADM OUTPUT ##############################
>=20
> mdadm --detail /dev/md0=20
> /dev/md0:
>         Version : 1.2
>   Creation Time : Tue Feb  1 16:25:03 2011
>      Raid Level : raid6
>   Used Dev Size : 1953512960 (1863.02 GiB 2000.40 GB)
>    Raid Devices : 22
>   Total Devices : 21
>     Persistence : Superblock is persistent
>=20
>     Update Time : Wed Feb 22 23:42:11 2012
>           State : active, FAILED, Not Started
>  Active Devices : 19
> Working Devices : 21
>  Failed Devices : 0
>   Spare Devices : 2
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>            Name : kddm-nas:0  (local to host kddm-nas)
>            UUID : 9fc31e38:7723974a:1f37af62:5a75ec91
>          Events : 5412
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       16        0      active sync   /dev/sdb
>        1       8       32        1      active sync   /dev/sdc
>        2       8       48        2      active sync   /dev/sdd
>        3       8       64        3      active sync   /dev/sde
>        4       8       80        4      active sync   /dev/sdf
>        5       8       96        5      active sync   /dev/sdg
>        6       8      112        6      active sync   /dev/sdh
>        7       0        0        7      removed
>        8       8      144        8      active sync   /dev/sdj
>        9       8      160        9      active sync   /dev/sdk
>       10       8      176       10      active sync   /dev/sdl
>       11       0        0       11      removed
>       12       8      208       12      active sync   /dev/sdn
>       13       8      224       13      active sync   /dev/sdo
>       14       8      240       14      active sync   /dev/sdp
>       15       0        0       15      removed
>       16      65       16       16      active sync   /dev/sdr
>       17      65       32       17      active sync   /dev/sds
>       18      65       48       18      active sync   /dev/sdt
>       19      65       64       19      active sync   /dev/sdu
>       20      65       80       20      active sync   /dev/sdv
>       21      65       96       21      active sync   /dev/sdw
>=20
>       22      65      112        -      spare   /dev/sdx
>       23      65      128        -      spare   /dev/sdy
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/Yg/b2OtIc+VvAXzOk4.cJN.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0f4ijnsnt1WYoG5AQLYXRAAkeSpO9F7ET1XilJx0oNmfTWA6BoDhj1x
cI93KTyMDbBtEfj8zdmi0uGiseU+h/XxoqoSAtWmxA/5E5UPWc13Kmv4/H38mBeC
i6VsEB0uj4evTYraQnLbau+z2ha4HMXxlTfG30Y1IIODUbInbZdvSm3fwx/B2Iuc
dztz2t15qwFzwM7ESH/eHksT8IgW8aOYCb23hW98QEoUfBJsffi+Rp7/j+dwtMhr
NT7RcULtc2yJNZjfDsAQv6XrlBzjvltQxqtCs5w9Z+R3n7mDkVl/v+xWFzMpLdmN
t+Dr/+ww+c7P8sNm5OrxYdB8k9oo4vip/LZoA9I/dvCWwoo4pcxPjwMAsC/+1Spn
AGnA9qHlNI0RWqaqFRevIcgoW0qimRSUSaInLUf/+0u7WP8XeS7+KsknKNcjsV/A
MqLi+9XtShAIPhqRaHu46/DGFKOTRxCgqGWb+TOzV/PSG4jcmzw02ygENwFgqQwu
T3fB6e0GHh8TyQmq7GrpSYv7+JIbLDPN7O2XM4a+jK+EigumqkCbnjIsuKfLYXL3
dCH8ryApmVElewaSULdH7mZE0ShaH3vgKM4edyOrhLBeN4E/U8xByO8G0I+ioDlJ
JRnKs07Ao0I4w2kHAdUdI4VNUkDl11OdmrvYZzPLnNxLKAsPTOfWwsagvsiTOc0i
Ne9QAWHvOVU=
=R7dc
-----END PGP SIGNATURE-----

--Sig_/Yg/b2OtIc+VvAXzOk4.cJN.--
