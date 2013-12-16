From: Tommy Apel <tommyapeldk@gmail.com>
Subject: =?UTF-8?B?UmU6IOetlOWkje+8muetlOWkje+8mnR3byByYWlkNSBwZXJmb3JtYW5jZQ==?=
Date: Mon, 16 Dec 2013 15:02:47 +0100
Message-ID: <CAGA4a+HPazewdo64v_L7wMUeqXTd_4O8-cHXLYUhDL1bmJusvg@mail.gmail.com>
References: <386c52f5-dd36-4697-b76a-d24038bbded3@aliyun.com>
	<fc24d5bd-da62-4c2d-8c51-c9b76a3f9dd7@aliyun.com>
	<3600622.49q3PtzSug@eseries.newtech.fi>
	<17f1f2ef-bac0-4857-b72b-ed5b9667426b@aliyun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17f1f2ef-bac0-4857-b72b-ed5b9667426b@aliyun.com>
Sender: linux-raid-owner@vger.kernel.org
To: lilofile <lilofile@aliyun.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46irst off you chunksizes are different on the two volumes and secondl=
y
if you're looking for throughput performance move them up to like 512K
or maybe more

2013/12/16 lilofile <lilofile@aliyun.com>:
> the result of mdadm -D is as follows:
>
> root@host0:~# mdadm  -D /dev/md126
> /dev/md126:
>         Version : 1.2
>   Creation Time : Sat Dec  7 16:26:04 2013
>      Raid Level : raid5
>      Array Size : 1171499840 (1117.23 GiB 1199.62 GB)
>   Used Dev Size : 234299968 (223.45 GiB 239.92 GB)
>    Raid Devices : 6
>   Total Devices : 6
>     Persistence : Superblock is persistent
>
>   Intent Bitmap : Internal
>
>     Update Time : Fri Dec 13 22:51:04 2013
>           State : active
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>            Name : host0:md126
>            UUID : aaa3075d:f25e3bd0:9dd347c5:fb58192f
>          Events : 158
>
>     Number   Major   Minor   RaidDevice State
>        0      65      112        0      active sync   /dev/sdx
>        1      65       96        1      active sync   /dev/sdw
>        2      65       80        2      active sync   /dev/sdv
>        3      65       64        3      active sync   /dev/sdu
>        4      65       48        4      active sync   /dev/sdt
>        6      65       32        5      active sync   /dev/sds
> root@host0:~#
>
>
> root@host0:~# mdadm  -D /dev/md129
> /dev/md129:
>         Version : 1.2
>   Creation Time : Sun Dec  8 15:59:11 2013
>      Raid Level : raid5
>      Array Size : 1171498880 (1117.23 GiB 1199.61 GB)
>   Used Dev Size : 234299776 (223.45 GiB 239.92 GB)
>    Raid Devices : 6
>   Total Devices : 6
>     Persistence : Superblock is persistent
>
>     Update Time : Mon Dec 16 21:50:45 2013
>           State : clean
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 128K
>
>            Name : host0:md129  (local to host sc0)
>            UUID : b80616a9:49540979:90b20aa6:1b22f67b
>          Events : 31
>
>     Number   Major   Minor   RaidDevice State
>        0      65       16        0      active sync   /dev/sdr
>        1      65        0        1      active sync   /dev/sdq
>        2       8      224        2      active sync   /dev/sdo
>        3       8      240        3      active sync   /dev/sdp
>        4       8      208        4      active sync   /dev/sdn
>        5       8      192        5      active sync   /dev/sdm
> root@host0:~#
>
>
> ------------------------------------------------------------------
> =E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9ATommy Apel <tommyapeldk@gmail.com=
>
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4=EF=BC=9A2013=E5=B9=B412=E6=9C=88=
16=E6=97=A5(=E6=98=9F=E6=9C=9F=E4=B8=80) 21:32
> =E6=94=B6=E4=BB=B6=E4=BA=BA=EF=BC=9Alilofile <lilofile@aliyun.com>
> =E6=8A=84=E3=80=80=E9=80=81=EF=BC=9Alinux-raid <linux-raid@vger.kerne=
l.org>
> =E4=B8=BB=E3=80=80=E9=A2=98=EF=BC=9ARe: =E7=AD=94=E5=A4=8D=EF=BC=9Atw=
o raid5 performance
>
> Please give us the output of mdadm -D for each array aswell, and just
> in case, also the model of the SSD's in use
>
> 2013/12/16 Dag Nygren <dag@newtech.fi>:
>> On Monday 16 December 2013 15:57:42 lilofile wrote:
>>> the disks involved in the array is sTEC ssd disk,they are connected=
 by mpt2sas 6Gb/s
>>
>> I/O bus to the card?
>>
>> Best
>> Dag
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
>
> /Tommy



--=20

/Tommy
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
