From: NeilBrown <nfbrown@novell.com>
Subject: Re: mdadm and size differences
Date: Mon, 21 Dec 2015 13:32:40 +1100
Message-ID: <871tag5y5z.fsf@notabene.neil.brown.name>
References: <n31ec1$ebi$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <n31ec1$ebi$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marco De Vitis <starless@spin.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 24 2015, Marco De Vitis wrote:

> Hi,
> I cannot understand a difference in size I can see on an old Debian 5.0=20
> machine, maybe I'm just missing something obvious.
...
>
> You can see that sdd6 is twice the size of sdd7.
> cfdisk reports sizes of around 20 GB and 10 GB:
>      sdd6 -> 19329.41
>      sdd7 -> 10010.17
>
> All partitions in these two identical drives are configured as RAID 1=20
> using mdadm, but the md devices associated to sdd6/sdf6 and sdd7/sdf7=20
> are both reported to be 10 GB in size, as can be seen from the mdadm=20
> output below.
>
> Why?

Probably because the arrays aren't using the whole partition.
e.g. if you have a RAID! comprised of 2 1GB partitions,
then you fail one partition and had a 2GB partition as a spare and let
it rebuild.  Then fail the other 1GB partition and add a 3GB partition
as a spare and let it rebuild.
Then you will have a 1GB RAID made from 2 partitions, a 2GB partition
and a 3GB partition.

If you want to resize the RAID! to use all the available space, then use
the command
  mdadm --grow /dev/md2 --size=3Dmax

You might then need to resize and filesystem you have in that array.

NeilBrown


>
> Thanks for any info.
>
>> #>mdadm -vv --detail /dev/md2
>> /dev/md2:
>>         Version : 00.90
>>   Creation Time : Thu Feb 22 16:18:11 2007
>>      Raid Level : raid1
>>      Array Size : 9767424 (9.31 GiB 10.00 GB)
>>   Used Dev Size : 9767424 (9.31 GiB 10.00 GB)
>>    Raid Devices : 2
>>   Total Devices : 2
>> Preferred Minor : 2
>>     Persistence : Superblock is persistent
>>
>>     Update Time : Mon Nov 23 14:19:23 2015
>>           State : clean
>>  Active Devices : 2
>> Working Devices : 2
>>  Failed Devices : 0
>>   Spare Devices : 0
>>
>>            UUID : 5582dad7:7ac89883:0c2b9e1d:5009dd35
>>          Events : 0.69228
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       8       54        0      active sync   /dev/sdd6
>>        1       8       86        1      active sync   /dev/sdf6
>>
>> #>mdadm -vv --detail /dev/md3
>> /dev/md3:
>>         Version : 00.90
>>   Creation Time : Thu Feb 22 16:18:54 2007
>>      Raid Level : raid1
>>      Array Size : 9767424 (9.31 GiB 10.00 GB)
>>   Used Dev Size : 9767424 (9.31 GiB 10.00 GB)
>>    Raid Devices : 2
>>   Total Devices : 2
>> Preferred Minor : 3
>>     Persistence : Superblock is persistent
>>
>>     Update Time : Mon Nov 23 14:19:27 2015
>>           State : clean
>>  Active Devices : 2
>> Working Devices : 2
>>  Failed Devices : 0
>>   Spare Devices : 0
>>
>>            UUID : e44836cf:6340f7fa:52fb3562:a78d4dbb
>>          Events : 0.187630
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       8       55        0      active sync   /dev/sdd7
>>        1       8       87        1      active sync   /dev/sdf7
>
> --=20
> Ciao,
>    Marco.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWd2TIAAoJEDnsnt1WYoG5d/0P/0/3Wz6fqQFZXBRoEIp7MGze
Tjp4g883bWDkLoEbE4SCzSC/dHaISSaspnQW4Nch0AWRUU9tUjFgIZJibg4u1dce
XUPEG+fXbkMwuzlf8gf6Ce3BYCGM3SqhwS8wZM2JlktF1LFCoPbHQA5bDuL5Cl9C
lxlmq5e29FbD0VaNdx68vhayuVOp4zf284dKMYcATHmhuk5C4fI9mgFgNlTfudl+
9JzAP2uSv9mJGBxCN/Qf4C7XYbpcAIVQwNgGegb5YcgU5KiuVHTVMiXhLKDrYo9a
Z+VSZ7r7TMdO9TbUUWFkNkWK3ZVlnzfDbyYksWD3phZRYETpX0pqkRLao4zVQk/1
SiVWCnOB0Js9FmcEvFveV+4E4Jhadf/+JGafsoe/XF9IV1QdQjwl7EkNIQpQDaug
4i9uwVBhocJT1cQtT0I+JsKh+UW6LWgrQEBiIX+q3BI9duzL4cTsJ3ARFxPa1Zx0
lcdmP/zigxhRirFhqWZffgdbP707HzDACGgt+8AZbrO1aLYeHWPtbT7NbLmULGdc
fHF2SUmm1r0xT47gsxnDe9ANichKF+wsjwU9SZ6ecl/p3nOMESu65lYBB2vORk3R
vbZZ4TnhJPdBJokTSYyPmZwlWJSqvbGCneUCt2/c6VJOBRLi7g2kOyxh1EUPOJDA
bN2mivTT7iqUUdhG1Ex6
=uaH1
-----END PGP SIGNATURE-----
--=-=-=--
