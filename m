From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: RAID5 in sync does not populate slots sequentially, shows array
 as (somewhat) faulty
Date: Tue, 04 Mar 2008 11:25:43 +0100
Message-ID: <47CD23A7.2000904@rabbit.us>
References: <47CBD62E.7040608@rabbit.us> <47CC44C7.1040304@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47CC44C7.1040304@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> Peter Rabbitson wrote:
>> Hello,
>>
>> Noticing the problems Tor Vestb=C3=B8 is having, I remembered that I=
 have=20
>> an array in a similar state, which I never figured out. The array ha=
s=20
>> been working flawlessly for 3 months, the monthly 'check' runs come=20
>> back with everything being clean. However this is how the array look=
s=20
>> through mdadm's eyes:
>=20
> I'm in agreement that something is odd about the disk numbers here, a=
nd=20
> I'm suspicious because I have never seen this with 0.90 superblocks.=20
> That doesn't mean it couldn't happen and I never noticed, it's certai=
nly=20
> odd that four drives wouldn't be numbered 0..3, in raid5 they are all=
=20
> equally out of sync.
>=20

After Tor Arne reported his success I figured I will simply fail/remove=
 sda3,=20
scrape it clean, and will add it back. I zeroed superblocks beforehand =
and=20
also wrote zeros (dd  if=3D/dev/zero) to the drives start and end just =
to make=20
sure everythign is off. After resync I am back at square one - the offs=
et of=20
sda3 is different than everything else and the array has one failed dri=
ve. If=20
someone can shed some light I made snapshots of the superblocks[1] alon=
gside=20
with the current output of mdadm at http://rabbit.us/pool/md5_problem.t=
ar.bz2.

[1] dd if=3D/dev/sdX3 of=3DsdX_sb count=3D<Data Offset> bs=3D512

Here is my system config:

root@Thesaurus:/arx/space/pool# fdisk -l /dev/sd[abcd]

Disk /dev/sda: 400.0 GB, 400088457216 bytes
255 heads, 63 sectors/track, 48641 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1           7       56196   fd  Linux raid auto=
detect
/dev/sda2               8         507     4016250   fd  Linux raid auto=
detect
/dev/sda3             508       36407   288366750   83  Linux
/dev/sda4           36408       48641    98269605   83  Linux

Disk /dev/sdb: 320.0 GB, 320072933376 bytes
255 heads, 63 sectors/track, 38913 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1           7       56196   fd  Linux raid auto=
detect
/dev/sdb2               8         507     4016250   fd  Linux raid auto=
detect
/dev/sdb3             508       36407   288366750   83  Linux
/dev/sdb4           36408       38913    20129445   83  Linux

Disk /dev/sdc: 300.0 GB, 300090728448 bytes
255 heads, 63 sectors/track, 36483 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1           7       56196   fd  Linux raid auto=
detect
/dev/sdc2               8         507     4016250   fd  Linux raid auto=
detect
/dev/sdc3             508       36407   288366750   83  Linux
/dev/sdc4           36408       36483      610470   83  Linux

Disk /dev/sdd: 300.0 GB, 300090728448 bytes
255 heads, 63 sectors/track, 36483 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1           7       56196   fd  Linux raid auto=
detect
/dev/sdd2               8         507     4016250   fd  Linux raid auto=
detect
/dev/sdd3             508       36407   288366750   83  Linux
/dev/sdd4           36408       36483      610470   83  Linux
root@Thesaurus:/arx/space/pool#

root@Thesaurus:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md5 : active raid5 sda3[4] sdd3[3] sdc3[2] sdb3[1]
       865081344 blocks super 1.1 level 5, 2048k chunk, algorithm 2 [4/=
4] [UUUU]

md1 : active raid1 sdd1[3] sdc1[2] sdb1[1] sda1[0]
       56128 blocks [4/4] [UUUU]

md10 : active raid10 sdd2[3] sdc2[2] sdb2[1] sda2[0]
       5353472 blocks 1024K chunks 3 far-copies [4/4] [UUUU]

unused devices: <none>
root@Thesaurus:~#



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
