From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm expanded 8 disk raid 6 fails in new server, 5 original
 devices show no md superblock
Date: Mon, 13 Jan 2014 13:42:07 -0500
Message-ID: <52D4337F.4050307@turmel.org>
References: <1389422546.11328.15.camel@achilles.aeskuladis.de>	 <52D183B5.3060006@turmel.org> <1389632980.11328.104.camel@achilles.aeskuladis.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1389632980.11328.104.camel@achilles.aeskuladis.de>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?Ikdyb8Ofa3JldXR6LCBKdWxpYW4i?= <Julian.Grosskreutz@med.uni-jena.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "neilb@suse.de" <neilb@suse.de>
List-Id: linux-raid.ids

Hi Julian,

[Note, your reply didn't make it to linux-raid due to size.  I believe
the limit is 150k ~ 200k.]

On 01/13/2014 12:09 PM, Gro=C3=9Fkreutz, Julian wrote:
> Hi Phil,
>=20
> thanks for getting back so quickly
>=20
>>> Model: ATA ST3000DM001-9YN1 (scsi)

Aside: This model looks familiar.  I'm pretty sure these drives are
desktop models that lack scterc support.  Meaning they are *not*
generally suitable for raid duty.  Search the archives for combinations
of "timeout mismatch", "scterc", "URE", and "scrub" for a full
explanation.  If I've guessed correctly, you *must* use the driver
timeout work-around before proceeding.

[trim /]

> I noticed one difference: part 1 is one sector longer than
> on /dev/[abcde], but part 2 starts at the same sector in all 8 drives
> and has the same length in all 8 drives. I usually leave 800-1000
> sectors unallocated at the end. As previously mentioned the first 5
> drives are older, the last three newer (the drive with the oldest
> firmware is sdb which has (incidence?) gone missing acc to sd[fgh]).

Some versions of parted/fdisk will get you that extra sector, wasting a
megabyte or more between partitions.  Not relevant here, I don't think.
 The partitions we need are all consistent.

[trim /]

>> Ok.  Your evidence below has some evidence suggesting you created th=
e
>> larger array from scratch instead of using --grow.  Do you remember?
>>
> I seem to recall that building the initial 5 disk raid 6 was difficul=
t,
> and I think I needed a custom compiled mdadm version (now residing on
> the inaccessible raid) which allowed me to align the offsets and
> optimize performance which was otherwise abysmal. I may have chosen 1=
=2E0
> superblock. Extending the raid was difficult as well, but I don't rec=
all
> recreating it from scratch. Maybe I tried once using standard setting=
s,
> didn't work, and then used the "custom" mdadm with offsets on the new
> drives as well. Sadly I can't remember. The existing superblock 1.2
> on /dev/sd[fgh] seems standard in data offset and superblock offset.

I don't think you can run an array with mixed superblock locations, so
I'm now concerned that the partitions on /dev/sd[a-e] aren't correct.
Instead of attempting to find the superblock signature, I think we
should first try to find the LVM2 signature.

>> Note this creation time...  would have been 2012 if you had used --g=
row.
>>
> Dont pin me down on 2012, but surely the original set of five was not
> created July 2013, my third child was born on the 8th. By then this r=
aid
> was up and served as an extra mirror archive.

But you could have backed up and re-created from scratch *after*.  It
does say July 31.

>> This used dev size is very odd.  The unused space after the data are=
a is
>> 1155584 sectors (>500MiB).
>=20
> Possibly the result of my fiddling with a custom mdadm and offsets to
> begin with? I presume I could not have set this manually.

No, I don't think so.

[trim /]

>> I would suggest hexdumping entire devices looking for the MD superbl=
ock
>> magic value, which will always be at the start of a 4k-aligned block=
=2E
>>
>> Show (will take a long time, even with the big block size):
>>
>> for x in /dev/sd[a-e]2 ; echo -e "\nDevice $x" ; dd if=3D$x bs=3D1M =
|hexdump
>> -C |grep "000  fc 4e 2b a9" ; done
>>
>=20
> I started it, but this old dual Xeon puts 1.2 MB/s through the hexdum=
p
> thread if data is not zero -> it will take app. 20 days !
>=20
> For now: the last 2.8 GB of all 8 drives did not show the signature:
>=20
> [root@livecd ~]# for x in /dev/sd[a-h]; do echo -e "\nDevice $x"; dd =
if=3D$x skip=3D5855000000 count=3D100000000 |hexdump -C |grep "000  fc =
4e 2b a9"; done

Don't bother with this now.

> So attached You will find hexdumps of 64k of /sda/sd[a-h]2 at sector =
0
> and 262144 which shows the superblock 1.2 on sd[fgh]2, not on sd[a-e]=
2,
> but may help to identify data_offset; I suspect it is 2048 on sd[a-e]=
2
> and 262144 on sd[fgh]2.
>

Jackpot!  LVM2 embedded backup data at the correct location for mdadm
data offset =3D=3D 262144.  And on /dev/sda2, which is the only device =
that
should have it (first device in the raid).

=46rom /dev/sda2 @ 262144:

> 00001200  76 67 5f 6e 65 64 69 67  73 30 32 20 5d 0a 69 64  |vg_nedig=
s02 ].id|
> 00001210  20 3d 20 22 32 4c 62 48  71 64 2d 72 67 42 9f 6e  | =3D "2L=
bHqd-rgB.n|
> 00001220  45 4a 75 31 2d 32 52 36  31 2d 41 35 f5 75 2d 6e  |EJu1-2R6=
1-A5.u-n|
> 00001230  49 58 53 2d 66 79 4f 36  33 73 22 0a 73 65 3a 01  |IXS-fyO6=
3s".se:.|
> 00001240  6f 20 3d 20 33 36 0a 66  6f 72 6d 61 ca 24 3d 20  |o =3D 36=
=2Eforma.$=3D |
> 00001250  22 6c 76 6d 32 22 20 23  20 69 6e 66 6f 72 6b ac  |"lvm2" #=
 infork.|
> 00001260  74 69 6f 6e 61 6c 0a 73  74 61 74 75 ee 22 3d 20  |tional.s=
tatu."=3D |
> 00001270  5b 22 52 45 53 49 5a 45  41 42 4c 45 22 2c 3e c0  |["RESIZE=
ABLE",>.|
> 00001280  52 45 41 44 22 2c 20 22  57 52 49 54 d0 27 5d 0a  |READ", "=
WRIT.'].|
> 00001290  66 6c 61 67 73 20 3d 20  5b 5d 0a 65 78 74 4b df  |flags =3D=
 [].extK.|
> 000012a0  74 5f 73 69 7a 65 20 3d  20 38 31 39 3e 08 6d 61  |t_size =3D=
 819>.ma|
> 000012b0  78 5f 6c 76 20 3d 20 30  0a 6d 61 78 5f 70 14 13  |x_lv =3D=
 0.max_p..|
> 000012c0  3d 20 30 0a 6d 65 74 61  64 61 74 61 b3 63 6f 70  |=3D 0.me=
tadata.cop|
> 000012d0  69 65 73 20 3d 20 30 0a  0a 70 68 79 73 69 97 c4  |ies =3D =
0..physi..|
> 000012e0  6c 5f 76 6f 6c 75 6d 65  73 20 7b 0a 2e 78 76 30  |l_volume=
s {..xv0|
> 000012f0  20 7b 0a 69 64 20 3d 20  22 50 4a 48 4c 67 bf 14  | {.id =3D=
 "PJHLg..|
> 00001300  53 70 56 70 2d 47 55 71  34 2d 6b 4a 57 7f 2d 39  |SpVp-GUq=
4-kJW.-9|
> 00001310  6d 74 4b 2d 31 6c 65 4a  2d 73 36 64 39 6a d8 1b  |mtK-1leJ=
-s6d9j..|
> 00001320  0a 64 65 76 69 63 65 20  3d 20 22 2f 79 6c 76 2f  |.device =
=3D "/ylv/|
> 00001330  73 64 66 32 22 0a 0a 73  74 61 74 75 73 20 7d 18  |sdf2"..s=
tatus }.|
> 00001340  5b 22 41 4c 4c 4f 43 41  54 41 42 4c df 25 5d 0a  |["ALLOCA=
TABL.%].|
> 00001350  66 6c 61 67 73 20 3d 20  5b 5d 0a 64 65 76 e3 b5  |flags =3D=
 [].dev..|
> 00001360  69 7a 65 20 3d 20 31 30  32 34 30 30 ce 33 30 0a  |ize =3D =
102400.30.|
> 00001370  70 65 5f 73 74 61 72 74  20 3d 20 32 30 34 99 22  |pe_start=
 =3D 204."|
> 00001380  70 65 5f 63 6f 75 6e 74  20 3d 20 31 cd 33 39 39  |pe_count=
 =3D 1.399|
> 00001390  0a 7d 0a 0a 70 76 31 20  7b 0a 69 64 20 3d 92 37  |.}..pv1 =
{.id =3D.7|
> 000013a0  44 39 7a 75 70 37 2d 6a  76 79 46 2d 6b 32 73 42  |D9zup7-j=
vyF-k2sB|
> 000013b0  2d 42 75 59 30 2d 39 74  73 61 2d 41 78 68 11 86  |-BuY0-9t=
sa-Axh..|
> 000013c0  34 45 51 48 4e 71 22 0a  64 65 76 69 c0 61 20 3d  |4EQHNq".=
devi.a =3D|
> 000013d0  20 22 2f 64 65 76 2f 6d  64 31 22 0a 0a 73 e4 c6  | "/dev/m=
d1"..s..|
> 000013e0  74 75 73 20 3d 20 5b 22  41 4c 4c 4f db 41 54 41  |tus =3D =
["ALLO.ATA|
> 000013f0  42 4c 45 22 5d 0a 66 6c  61 67 73 20 3d 20 f4 12  |BLE"].fl=
ags =3D ..|
> 00001400  0a 64 65 76 5f 73 69 7a  65 20 3d 20 14 39 32 38  |.dev_siz=
e =3D .928|
> 00001410  35 37 39 33 32 38 30 0a  70 65 5f 73 74 61 99 37  |5793280.=
pe_sta.7|
> 00001420  20 3d 20 35 31 32 0a 70  65 5f 63 6f 4d 6d 74 20  | =3D 512=
=2Epe_coMmt |
> 00001430  3d 20 33 35 37 34 39 32  35 0a 7d 0a 7d 0a 77 f1  |=3D 3574=
925.}.}.w.|
> 00001440  6f 67 69 63 61 6c 5f 76  6f 6c 75 6d 9c 7d 20 7b  |ogical_v=
olum.} {|
> 00001450  0a 0a 6c 76 5f 76 61 72  20 7b 0a 69 64 20 b9 ee  |..lv_var=
 {.id ..|
> 00001460  22 5a 4a 47 56 55 4d 2d  4d 70 76 50 a8 7a 6f 49  |"ZJGVUM-=
MpvP.zoI|
> 00001470  39 2d 68 31 39 47 2d 57  70 75 6d 2d 4e 4b ee d5  |9-h19G-W=
pum-NK..|
> 00001480  2d 4a 77 34 32 31 59 22  0a 73 74 61 f4 70 73 20  |-Jw421Y"=
=2Esta.ps |
> 00001490  3d 20 5b 22 52 45 41 44  22 2c 20 22 57 52 73 ed  |=3D ["RE=
AD", "WRs.|
> 000014a0  45 22 2c 20 22 56 49 53  49 42 4c 45 86 5a 0a 66  |E", "VIS=
IBLE.Z.f|
> 000014b0  6c 61 67 73 20 3d 20 5b  5d 0a 73 65 67 6d b4 4c  |lags =3D=
 [].segm.L|
> 000014c0  74 5f 63 6f 75 6e 74 20  3d 20 31 0a d1 76 65 67  |t_count =
=3D 1..veg|
> 000014d0  6d 65 6e 74 31 20 7b 0a  73 74 61 72 74 5f 3c f6  |ment1 {.=
start_<.|
> 000014e0  74 65 6e 74 20 3d 20 30  0a 65 78 74 9a 68 74 5f  |tent =3D=
 0.ext.ht_|
> 000014f0  63 6f 75 6e 74 20 3d 20  31 32 35 30 0a 0a 97 fc  |count =3D=
 1250....|
> 00001500  70 65 20 3d 20 22 73 74  72 69 70 65 a4 23 0a 73  |pe =3D "=
stripe.#.s|
> 00001510  74 72 69 70 65 5f 63 6f  75 6e 74 20 3d 20 5c a5  |tripe_co=
unt =3D \.|
> 00001520  23 20 6c 69 6e 65 61 72  0a 0a 73 74 75 69 70 65  |# linear=
=2E.stuipe|
> 00001530  73 20 3d 20 5b 0a 22 70  76 30 22 2c 20 34 88 4c  |s =3D [.=
"pv0", 4.L|
> 00001540  39 0a 5d 0a 7d 0a 7d 0a  0a 6c 76 5f b5 6e 6f 74  |9.].}.}.=
=2Elv_.not|
> 00001550  20 7b 0a 69 64 20 3d 20  22 4c 48 58 57 4f 97 f4  | {.id =3D=
 "LHXWO..|
> 00001560  47 30 6f 63 2d 62 4a 54  31 2d 49 6e 5d 36 2d 36  |G0oc-bJT=
1-In]6-6|
> 00001570  46 39 58 2d 7a 76 4b 50  2d 53 68 73 74 66 b7 69  |F9X-zvKP=
-Shstf.i|
> 00001580  0a 73 74 61 74 75 73 20  3d 20 5b 22 0b 42 41 44  |.status =
=3D [".BAD|
> 00001590  22 2c 20 22 57 52 49 54  45 22 2c 20 22 56 39 ed  |", "WRIT=
E", "V9.|
> 000015a0  49 42 4c 45 22 5d 0a 66  6c 61 67 73 ef 3d 20 5b  |IBLE"].f=
lags.=3D [|
> 000015b0  5d 0a 73 65 67 6d 65 6e  74 5f 63 6f 75 6e 7b 0b  |].segmen=
t_coun{.|
> 000015c0  3d 20 31 0a 0a 73 65 67  6d 65 6e 74 4c 27 7b 0a  |=3D 1..s=
egmentL'{.|
> 000015d0  73 74 61 72 74 5f 65 78  74 65 6e 74 20 3d 1a 75  |start_ex=
tent =3D.u|
> 000015e0  0a 65 78 74 65 6e 74 5f  63 6f 75 6e ae 22 3d 20  |.extent_=
coun."=3D |
> 000015f0  32 35 30 30 0a 0a 74 79  70 65 20 3d 20 22 c9 37  |2500..ty=
pe =3D ".7|
> 00001600  72 69 70 65 64 22 0a 73  74 72 69 70 77 50 63 6f  |riped".s=
tripwPco|
> 00001610  75 6e 74 20 3d 20 31 09  23 20 6c 69 6e 65 f1 fc  |unt =3D =
1.# line..|
> 00001620  0a 0a 73 74 72 69 70 65  73 20 3d 20 24 0b 22 70  |..stripe=
s =3D $."p|
> 00001630  76 30 22 2c 20 32 34 39  39 0a 5d 0a 7d 0a 05 56  |v0", 249=
9.].}..V|
> 00001640  0a 6c 76 5f 68 6f 6d 65  20 7b 0a 69 26 22 3d 20  |.lv_home=
 {.i&"=3D |
> 00001650  22 76 48 4a 37 4d 34 2d  74 74 77 4f 2d 46 71 7d  |"vHJ7M4-=
ttwO-Fq}|
> 00001660  6e 2d 72 35 67 71 2d 74  44 48 74 2d 38 49 64 37  |n-r5gq-t=
DHt-8Id7|
> 00001670  2d 54 56 74 52 6f 36 22  0a 73 74 61 74 75 ff 91  |-TVtRo6"=
=2Estatu..|
> 00001680  3d 20 5b 22 52 45 41 44  22 2c 20 22 9a 54 49 54  |=3D ["RE=
AD", ".TIT|
> 00001690  45 22 2c 20 22 56 49 53  49 42 4c 45 22 5d 47 54  |E", "VIS=
IBLE"]GT|
> 000016a0  6c 61 67 73 20 3d 20 5b  5d 0a 73 65 e6 6b 65 6e  |lags =3D=
 [].se.ken|
> 000016b0  74 5f 63 6f 75 6e 74 20  3d 20 31 0a 0a 73 fe d2  |t_count =
=3D 1..s..|
> 000016c0  6d 65 6e 74 31 20 7b 0a  73 74 61 72 3e 50 65 78  |ment1 {.=
star>Pex|
> 000016d0  74 65 6e 74 20 3d 20 30  0a 65 78 74 65 6e 77 a2  |tent =3D=
 0.extenw.|
> 000016e0  63 6f 75 6e 74 20 3d 20  32 35 30 30 13 0a 74 79  |count =3D=
 2500..ty|
> 000016f0  70 65 20 3d 20 22 73 74  72 69 70 65 64 22 dd 28  |pe =3D "=
striped".(|
> 00001700  74 72 69 70 65 5f 63 6f  75 6e 74 20 1e 22 31 09  |tripe_co=
unt ."1.|
> 00001710  23 20 6c 69 6e 65 61 72  0a 0a 73 74 72 69 2a 8b  |# linear=
=2E.stri*.|
> 00001720  73 20 3d 20 5b 0a 22 70  76 30 22 2c 1c 35 32 34  |s =3D [.=
"pv0",.524|
> 00001730  39 0a 5d 0a 7d 0a 7d 0a  0a 6c 76 5f 73 77 5d dc  |9.].}.}.=
=2Elv_sw].|
> 00001740  20 7b 0a 69 64 20 3d 20  22 58 6f 36 e6 7a 36 2d  | {.id =3D=
 "Xo6.z6-|
> 00001750  39 62 61 38 2d 49 54 53  73 2d 57 63 61 78 ba 6f  |9ba8-ITS=
s-Wcax.o|
> 00001760  73 42 52 2d 6e 48 65 61  2d 65 44 45 63 61 33 22  |sBR-nHea=
-eDEca3"|
> 00001770  0a 73 74 61 74 75 73 20  3d 20 5b 22 52 45 08 4f  |.status =
=3D ["RE.O|
> 00001780  22 2c 20 22 57 52 49 54  45 22 2c 20 ec 50 49 53  |", "WRIT=
E", .PIS|
> 00001790  49 42 4c 45 22 5d 0a 66  6c 61 67 73 20 3d 9d 2d  |IBLE"].f=
lags =3D.-|
> 000017a0  5d 0a 73 65 67 6d 65 6e  74 5f 63 6f 04 6a 74 20  |].segmen=
t_co.jt |
> 000017b0  3d 20 31 0a 0a 73 65 67  6d 65 6e 74 31 20 72 ec  |=3D 1..s=
egment1 r.|
> 000017c0  73 74 61 72 74 5f 65 78  74 65 6e 74 7b 3d 20 30  |start_ex=
tent{=3D 0|
> 000017d0  0a 65 78 74 65 6e 74 5f  63 6f 75 6e 74 20 5e 17  |.extent_=
count ^.|
> 000017e0  32 34 39 39 0a 0a 74 79  70 65 20 3d f7 21 73 74  |2499..ty=
pe =3D.!st|
> 000017f0  72 69 70 65 64 22 0a 73  74 72 69 70 65 5f 1a 13  |riped".s=
tripe_..|
> 00001800  75 6e 74 20 3d 20 31 09  23 20 6c 69 51 65 61 72  |unt =3D =
1.# liQear|
> 00001810  0a 0a 73 74 72 69 70 65  73 20 3d 20 5b 0a 1e 68  |..stripe=
s =3D [..h|
> 00001820  76 30 22 2c 20 30 0a 5d  0a 7d 0a 7d 0a 0a 6c 76  |v0", 0.]=
=2E}.}..lv|
> 00001830  5f 74 6d 70 20 7b 0a 69  64 20 3d 20 22 6b 66 55  |_tmp {.i=
d =3D "kfU|
> 00001840  76 49 50 2d 55 4f 56 50  2d 53 67 61 24 2a 55 71  |vIP-UOVP=
-Sga$*Uq|
> 00001850  49 4f 2d 56 36 32 6f 2d  33 56 58 47 2d 52 7e 09  |IO-V62o-=
3VXG-R~.|
> 00001860  67 6b 75 22 0a 73 74 61  74 75 73 20 c2 27 5b 22  |gku".sta=
tus .'["|
> 00001870  52 45 41 44 22 2c 20 22  57 52 49 54 45 22 9e 35  |READ", "=
WRITE".5|
> 00001880  22 56 49 53 49 42 4c 45  22 5d 0a 66 37 61 67 73  |"VISIBLE=
"].f7ags|
> 00001890  20 3d 20 5b 5d 0a 73 65  67 6d 65 6e 74 5f 00 58  | =3D [].=
segment_.X|
> 000018a0  75 6e 74 20 3d 20 31 0a  0a 73 65 67 80 61 6e 74  |unt =3D =
1..seg.ant|
> 000018b0  31 20 7b 0a 73 74 61 72  74 5f 65 78 74 65 89 ec  |1 {.star=
t_exte..|
> 000018c0  20 3d 20 30 0a 65 78 74  65 6e 74 5f 2a 6c 75 6e  | =3D 0.e=
xtent_*lun|
> 000018d0  74 20 3d 20 32 35 30 30  0a 0a 74 79 70 65 16 87  |t =3D 25=
00..type..|
> 000018e0  20 22 73 74 72 69 70 65  64 22 0a 73 40 77 69 70  | "stripe=
d".s@wip|
> 000018f0  65 5f 63 6f 75 6e 74 20  3d 20 31 09 23 20 31 06  |e_count =
=3D 1.# 1.|
> 00001900  6e 65 61 72 0a 0a 73 74  72 69 70 65 cc 25 3d 20  |near..st=
ripe.%=3D |
> 00001910  5b 0a 22 70 76 30 22 2c  20 38 37 34 39 0a 5b ab  |[."pv0",=
 8749.[.|
> 00001920  7d 0a 7d 0a 7d 0a 7d 0a  23 20 47 65 b1 66 72 61  |}.}.}.}.=
# Ge.fra|
> 00001930  74 65 64 20 62 79 20 4c  56 4d 32 20 76 65 89 6d  |ted by L=
VM2 ve.m|
> 00001940  69 6f 6e 20 32 2e 30 32  2e 39 38 28 ff 2f 2d 52  |ion 2.02=
=2E98(./-R|
> 00001950  48 45 4c 36 20 28 32 30  31 32 2d 31 30 2d 7c 07  |HEL6 (20=
12-10-|.|
> 00001960  29 3a 20 57 65 64 20 4a  75 6c 20 33 14 22 31 38  |): Wed J=
ul 3."18|
> 00001970  3a 32 36 3a 31 39 20 32  30 31 33 0a 0a 63 d5 09  |:26:19 2=
013..c..|
> 00001980  74 65 6e 74 73 20 3d 20  22 54 65 78 69 21 46 6f  |tents =3D=
 "Texi!Fo|
> 00001990  72 6d 61 74 20 56 6f 6c  75 6d 65 20 47 72 a8 8f  |rmat Vol=
ume Gr..|
> 000019a0  70 22 0a 76 65 72 73 69  6f 6e 20 3d 20 31 0a 0a  |p".versi=
on =3D 1..|
> 000019b0  64 65 73 63 72 69 70 74  69 6f 6e 20 3d 20 22 22  |descript=
ion =3D ""|
> 000019c0  0a 0a 63 72 65 61 74 69  6f 6e 5f 68 f7 73 74 20  |..creati=
on_h.st |
> 000019d0  3d 20 22 6e 65 64 69 67  73 33 30 2e 6e 65 cb 26  |=3D "ned=
igs30.ne.&|
> 000019e0  67 2e 61 65 73 6b 75 6c  61 64 69 73 2e 6c 6f 63  |g.aeskul=
adis.loc|
> 000019f0  61 6c 22 09 23 20 4c 69  6e 75 78 20 6e 65 64 69  |al".# Li=
nux nedi|
> 00001a00  67 73 33 30 2e 6e 65 64  69 67 2e 61 65 73 6b 75  |gs30.ned=
ig.aesku|
> 00001a10  6c 61 64 69 73 2e 6c 6f  63 61 6c 20 32 2e 36 2e  |ladis.lo=
cal 2.6.|
> 00001a20  33 32 2d 33 35 38 2e 36  2e 31 2e 65 93 35 2e 78  |32-358.6=
=2E1.e.5.x|
> 00001a30  38 36 5f 36 34 20 23 31  20 53 4d 50 20 54 85 b1  |86_64 #1=
 SMP T..|
> 00001a40  20 41 70 72 20 32 33 20  31 39 3a 32 76 3a 30 30  | Apr 23 =
19:2v:00|
> 00001a50  20 55 54 43 20 32 30 31  33 20 78 38 36 5f 10 f7  | UTC 201=
3 x86_..|
> 00001a60  0a 63 72 65 61 74 69 6f  6e 5f 74 69 71 61 20 3d  |.creatio=
n_tiqa =3D|
> 00001a70  20 31 33 37 35 32 38 37  39 37 39 09 23 20 d2 32  | 1375287=
979.# .2|
> 00001a80  64 20 4a 75 6c 20 33 31  20 31 38 3a af 37 3a 31  |d Jul 31=
 18:.7:1|
> 00001a90  39 20 32 30 31 33 0a 0a  00 00 00 00 00 00 ee 12  |9 2013..=
=2E.......|

Note the creation date/time at the end (with a corrupted byte):

Jul 31 18:?7:19 2013

There are other corrupted bytes scattered around.  I'd be worried about
the RAM in this machine.  Since you are using non-enterprise drives, I'=
m
going to go out on a limb here and guess that the server doesn't have
ECC ram...

Part of the signature that should have showed up at 00001000 is missing=
,
too.

Consider performing an extended memcheck run to see what's going on.
Maybe move the entire stack of disks to another server.

>>> 00001200  76 67 5f 6e 65 64 69 67  73 30 32 20 7b 0a 69 64  |vg_ned=
igs02
>>> {.id|
>>> 00001210  20 3d 20 22 32 4c 62 48  71 64 2d 72 67 42 74 2d  | =3D
>>> "2LbHqd-rgBt-|
>>> 00001220  45 4a 75 31 2d 32 52 36  31 2d 41 35 7a 74 2d 6e  |
>>> EJu1-2R61-A5zt-n|
>>> 00001230  49 58 53 2d 66 79 4f 36  33 73 22 0a 73 65 71 6e  |
>>> IXS-fyO63s".seqn|
>>> 00001240  6f 20 3d 20 37 0a 66 6f  72 6d 61 74 20 3d 20 22  |o =3D
>>> 7.format =3D "|
>>> 00001250  6c 76 6d 32 22 20 23 20  69 6e 66 6f 72 6d 61 74  |lvm2" =
#
>>> informat|
>>> (cont'd)
>>
>> This implies that /dev/sda2 is the first device in a raid5/6 that us=
es
>> metadata 0.9 or 1.0.  You've found the LVM PV signature, which start=
s at
>> 4k into a PV.  Theoretically, this could be a stray, abandoned signa=
ture
>> from the original array, with the real LVM signature at the 262144
>> offset.  Show:

This certainly was a stray LVM2 signature from a version 1.0 metadata
array.  It matches the new location, if you allow for the scattered
corrupted bytes.  Even the same UUID, suggesting you did a vgcfgbackup
and vgcfgrestore sequence.

[trim /]

>> No, but with parity raid scattering data amongst the participating
>> devices, the report on /dev/sdb2 is expected.
>>
>>> As for the last state: one drive was set faulty, apparently, but th=
e
>>> spare had not been integrated. I may have gotten caught in a bug
>>> described by Neil Brown, where on shutdown disk were wrongly report=
ed,
>>> and subsequently superblock information was overwritten.
>>
>> Possible.  If so, you may not find any superblocks with the grep abo=
ve.

With memory corruption, all kinds of weird behavior is possible.

> In all, I think I lost all superblock information on sd[a-e]2, possib=
ly
> when I extended the raid set; superblock 1.2 could not be written to
> 262144 on sd[a-e]2 because data started at 2048, so no place to put t=
he
> superblocks.
>=20
> I would proceed to try a non-destructive assembly of the raid (i.e.
> read-only through a loop device for each drive) with the freshly
> compiled mdadm_offset with /dev/sd[a-e]2:2048 and /dev/sd[f-h]2:26214=
4.
> Make sense ?

Based on the signature discovered above, we should be able to --create
--assume-clean with the modern default data offset.  We know the
following device roles:

/dev/sda2 =3D=3D 0
/dev/sdf2 =3D=3D 5
/dev/sdg2 =3D=3D 6
/dev/sdh2 =3D=3D spare

So /dev/sdh2 should be left out until the array is working.

Please re-execute the "mdadm -E" reports for /dev/sd[fgh]2 and show the=
m
uncut.  (Use the lasted mdadm.)  That should fill in the likely device
order of the remaining drives.

Also, it is important that you document which drive serial numbers are
currently occupying the different device names.  An excerpt from "ls -l
/dev/disk/by-id/" would do.

I have to admit that I'm very concerned about your corrupted LVM
signature at offset 262144.  LVM probably won't recognize your PV once
the array is assembled correctly, making it difficult to
non-destructively test the filesystems on your logical volumes.  You ma=
y
have to duplicate your disks onto new ones so that an LVM restore can b=
e
safely attempted.

Do *not* buy desktop drives!  You need raid-capable drives like the WD
Red at the least.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
