From: Phil Turmel <philip@turmel.org>
Subject: Re: dm-crypt over raid6 unreadable after crash
Date: Thu, 07 Jul 2011 08:41:36 -0400
Message-ID: <4E15A980.3060508@turmel.org>
References: <20110706161228.GA1491@apartia.fr> <4E1494BB.9060101@turmel.org> <20110707090540.GA7288@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110707090540.GA7288@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Louis-David Mitterrand <vindex+lists-linux-kernel@apartia.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/07/2011 05:05 AM, Louis-David Mitterrand wrote:
> On Wed, Jul 06, 2011 at 01:00:43PM -0400, Phil Turmel wrote:
>>> After a hardware crash I can no longer open a dm-crypt partition lo=
cated
>>> directly over a md-raid6 partition. I get this error:
>>>
>>> 	root@grml ~ # cryptsetup isLuks /dev/md1=20
>>> 	Device /dev/md1 is not a valid LUKS device
>>>
>>> It seems the LUKS header has been shifted a few bytes forward, but =
looks
>>> otherwise fine to specialists on the dm-crypt mailing list. Normall=
y the
>>> "LUKS" signature should be at 0x00000000
>>>
>>> Is there some way that the md layer could have shifted its contents=
?
>>>
>>> Here is a hexdum of /dev/md1 done with "hd /dev/md1 | head -n 40"
>>>
>>> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |......=
=2E.........|
>>> *
>>> 00100000  4c 55 4b 53 ba be 00 01  61 65 73 00 00 00 00 00  |LUKS..=
=2E.aes.....|
>>> 00100010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |......=
=2E.........|
>>> 00100020  00 00 00 00 00 00 00 00  63 62 63 2d 65 73 73 69  |......=
=2E.cbc-essi|
>>> 00100030  76 3a 73 68 61 32 35 36  00 00 00 00 00 00 00 00  |v:sha2=
56........|
>=20
> Hi Phil,
>=20
>> The offset is precisely 1MB.  This is the default data offset for
>> metadata types 1.1 and 1.2 (nowadays).  Metadata types 0.90 and 1.0
>> have a zero offset (the metadata is at the end.)
>>
>> You don't say what your recovery efforts were, but I'd guess you did=
 a
>> "mdadm --create" somewhere in there, and didn't match the original
>> parameters.  Or you used an older version of mdadm than was used
>> originally, and therefore got different defaults.
>=20
> No I did a mdadm-startall with a grml livecd.

Very interesting.

>> Another possibility is that the original array was set up on a 1MB
>> aligned partition, and the array is now using the whole device.  Thi=
s
>> can happen with v0.90 metadata.  If so, the original partition table
>> is obviously zeroed out now.
>>
>> Please share more information about what you've done so far.  Also
>=20
> Nothing appart from assembling the array and failing to decrypt it wi=
th
> cryptsetup.

OK.  And it's a v1.2 superblock, so mdadm very likely got it right.

>> show us the output of "mdadm -D /dev/md1"=20
>=20
> /dev/md1:
>         Version : 1.2
>   Creation Time : Wed Oct 20 21:40:40 2010
>      Raid Level : raid6
>      Array Size : 841863168 (802.86 GiB 862.07 GB)
>   Used Dev Size : 140310528 (133.81 GiB 143.68 GB)
>    Raid Devices : 8
>   Total Devices : 8
>     Persistence : Superblock is persistent
>=20
>   Intent Bitmap : Internal
>=20
>     Update Time : Thu Jul  7 09:44:49 2011
>           State : active
>  Active Devices : 8
> Working Devices : 8
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>            Name : grml:1  (local to host grml)
>            UUID : 1434a46a:f2b751cd:8604803c:b545de8c
>          Events : 8292
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8      130        0      active sync   /dev/sdi2
>        1       8       50        1      active sync   /dev/sdd2
>        2       8       34        2      active sync   /dev/sdc2
>        3       8       82        3      active sync   /dev/sdf2
>        4       8       66        4      active sync   /dev/sde2
>        5       8      146        5      active sync   /dev/sdj2
>        8       8      114        6      active sync   /dev/sdh2
>        7       8       98        7      active sync   /dev/sdg2
>=20
>> and then "mdadm -E /dev/xxx" for each of its components.
>=20
>=20
> /dev/sdc2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 1434a46a:f2b751cd:8604803c:b545de8c
>            Name : grml:1  (local to host grml)
>   Creation Time : Wed Oct 20 21:40:40 2010
>      Raid Level : raid6
>    Raid Devices : 8
>=20
>  Avail Dev Size : 280621372 (133.81 GiB 143.68 GB)
>      Array Size : 1683726336 (802.86 GiB 862.07 GB)
>   Used Dev Size : 280621056 (133.81 GiB 143.68 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 0a10d6c3:8a6f1948:f1a546a4:32f10094
>=20
> Internal Bitmap : 2 sectors from superblock
>     Update Time : Thu Jul  7 11:00:42 2011
>        Checksum : 16c1099b - correct
>          Events : 8292
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 2
>    Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)

[...]

No oddities in the above.  Both of my speculations are wrong.

>> The output of "lsdrv"[1] would also be useful for visualizing your s=
etup.
>=20
> PCI [ata_piix] 00:1f.2 IDE interface: Intel Corporation 82801IB (ICH9=
) 2 port SATA IDE Controller (rev 02)
>  =C3=A2=E2=80=9D=C5=93=C3=A2=E2=80=9D=E2=82=ACscsi 0:0:0:0 HL-DT-ST D=
VD+-RW GH50N {K1LA7D41849}
>  =C3=A2=E2=80=9D=E2=80=9A  =C3=A2=E2=80=9D=E2=80=9D=C3=A2=E2=80=9D=E2=
=82=ACsr0: [11:0] Partitioned (dos) 224.00m 'grml64-medium_2011.05'
>  =C3=A2=E2=80=9D=E2=80=9A     =C3=A2=E2=80=9D=E2=80=9D=C3=A2=E2=80=9D=
=E2=82=ACMounted as /dev/sr0 @ /live/image
>  =C3=A2=E2=80=9D=E2=80=9D=C3=A2=E2=80=9D=E2=82=ACscsi 1:x:x:x [Empty]
> PCI [mpt2sas] 02:00.0 Serial Attached SCSI controller: LSI Logic / Sy=
mbios Logic SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 02)
>  =C3=A2=E2=80=9D=C5=93=C3=A2=E2=80=9D=E2=82=ACscsi 2:0:0:0 ATA WDC WD=
1002FAEX-0 {WD-WCATR1851552}
>  =C3=A2=E2=80=9D=E2=80=9A  =C3=A2=E2=80=9D=E2=80=9D=C3=A2=E2=80=9D=E2=
=82=ACsdc: [8:32] Partitioned (dos) 931.51g
>  =C3=A2=E2=80=9D=E2=80=9A     =C3=A2=E2=80=9D=C5=93=C3=A2=E2=80=9D=E2=
=82=ACsdc1: [8:33] MD raid1 (2/8) 250.98m md0 clean in_sync {2871f814-c=
eb7-6a88-d8b7-8f6599226e41}
>  =C3=A2=E2=80=9D=E2=80=9A     =C3=A2=E2=80=9D=E2=80=9A  =C3=A2=E2=80=9D=
=E2=80=9D=C3=A2=E2=80=9D=E2=82=ACmd0: [9:0] Partitioned (dos) 250.88m {=
d1d876e9-6905-4940-bf55-7cdb4b64484f}
>  =C3=A2=E2=80=9D=E2=80=9A     =C3=A2=E2=80=9D=C5=93=C3=A2=E2=80=9D=E2=
=82=ACsdc2: [8:34] MD raid6 (2/8) 133.81g md1 clean in_sync 'grml:1' {1=
434a46a-f2b7-51cd-8604-803cb545de8c}
>  =C3=A2=E2=80=9D=E2=80=9A     =C3=A2=E2=80=9D=E2=80=9A  =C3=A2=E2=80=9D=
=E2=80=9D=C3=A2=E2=80=9D=E2=82=ACmd1: [9:1] Empty/Unknown 802.86g
>  =C3=A2=E2=80=9D=E2=80=9A     =C3=A2=E2=80=9D=E2=80=9D=C3=A2=E2=80=9D=
=E2=82=ACsdc3: [8:35] MD raid6 (0/8) 797.36g md2 clean in_sync 'zenon:2=
' {5c037ba3-ca4b-f7b9-eb8f-b01608e1fd3b}
>  =C3=A2=E2=80=9D=E2=80=9A        =C3=A2=E2=80=9D=E2=80=9D=C3=A2=E2=80=
=9D=E2=82=ACmd2: [9:2] (crypto_LUKS) 4.67t {1d30a244-9d40-48e8-925a-1d6=
c93a45474}
>  =C3=A2=E2=80=9D=E2=80=9A           =C3=A2=E2=80=9D=E2=80=9D=C3=A2=E2=
=80=9D=E2=82=ACdm-0: [253:0] (xfs) 4.67t {3cad63a0-a586-43e0-bf89-5be90=
66c884f}
>  =C3=A2=E2=80=9D=E2=80=9A              =C3=A2=E2=80=9D=E2=80=9D=C3=A2=
=E2=80=9D=E2=82=ACMounted as /dev/mapper/cmd2 @ /backup

So, cryptsetup saw and properly handled /dev/md2.

[...]

Well.  /dev/md1 is assembled correctly as far as I can tell.  That make=
 me wonder what else might be in play.  First, it would be good to know=
 if the luks data is truly intact at the 1MB offset.  As a test, please=
 add a linear device mapper layer that skips the 1MB.  Like so:

echo 0 1683724288 linear /dev/md1 2048 | dmsetup create mdtest

Depending on grml's udev setup, this may prompt you to unlock /dev/mapp=
er/mdtest.  Otherwise, use cryptsetup to test it, and then unlock it.  =
Do *NOT* mount yet.  Run "fsck -n" to see if it is intact.

I also wonder if the md device itself was partitioned, maybe with EFI G=
PT, and the grml liveCD doesn't support it?  (Long shot.)  Please show =
"zcat /proc/config.gz |grep PART"

I'm running out of ideas.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
