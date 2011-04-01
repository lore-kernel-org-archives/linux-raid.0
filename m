From: hank peng <pengxihan@gmail.com>
Subject: Re: strange problem with my raid5
Date: Fri, 1 Apr 2011 08:19:25 +0800
Message-ID: <AANLkTineJSt77ZNhUR61BTp65WMvDUDo4QGZdwpYgjBp@mail.gmail.com>
References: <AANLkTinEcLaQAdoFgbV6+UGkPYKTgBass8J8pUBQ3h_X@mail.gmail.com>
	<4D94AAB4.2050900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D94AAB4.2050900@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: simonmcnair@gmail.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

thanks for reply, I have other information to  add.
I created 3 raid5 array, then I created 6 iscsi LUN on them, each
raid5 had two LUNs. And then I exported them to Windows side. On
Windows side, I format them using NTFS filesystem.
On Linux side, there are some information as follows:

#fdisk -l
Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1      243199  1953495903+   7  HPFS/NTFS

Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1      243199  1953495903+   7  HPFS/NTFS

Disk /dev/sdc: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

Disk /dev/sdc doesn't contain a valid partition table

Disk /dev/sdd: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

Disk /dev/sdd doesn't contain a valid partition table

Disk /dev/sdf: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdf1               1      243199  1953495903+   7  HPFS/NTFS

Disk /dev/sdg: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdg1               1      243199  1953495903+   7  HPFS/NTFS

Disk /dev/sde: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

Disk /dev/sde doesn't contain a valid partition table

Disk /dev/sdj: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

Disk /dev/sdj doesn't contain a valid partition table

Disk /dev/sdi: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

Disk /dev/sdi doesn't contain a valid partition table

Disk /dev/sdk: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

Disk /dev/sdk doesn't contain a valid partition table

Disk /dev/sdh: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

Disk /dev/sdh doesn't contain a valid partition table

Disk /dev/sdl: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdl1               1      243199  1953495903+   7  HPFS/NTFS

Disk /dev/sdm: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdm1               1      243199  1953495903+   7  HPFS/NTFS

Disk /dev/sdn: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

Disk /dev/sdn doesn't contain a valid partition table

Disk /dev/sdo: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

Disk /dev/sdo doesn't contain a valid partition table

Disk /dev/sdp: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4]
unused devices: <none>
root@Dahua_Storage:~# cat /etc/mdadm.conf
DEVICE /dev/sd*
ARRAY /dev/md3 level=3Draid5 num-devices=3D5
UUID=3D2d3ac8ef:2dbe2469:b31e3c87:77c5769c
   devices=3D/dev/sdg1,/dev/sdg,/dev/sdf1,/dev/sdf,/dev/sde,/dev/sdd,/d=
ev/sdc
ARRAY /dev/md1 level=3Draid5 num-devices=3D5
UUID=3D9462a7df:31fca040:023819d9:dbf71832
   devices=3D/dev/sdm1,/dev/sdm,/dev/sdl1,/dev/sdl,/dev/sdk,/dev/sdj,/d=
ev/sdi
ARRAY /dev/md2 level=3Draid5 num-devices=3D5
UUID=3D5dbc2bdc:9173d426:21a1b5c2:f8b2768a
   devices=3D/dev/sdp,/dev/sdo,/dev/sdn,/dev/sdb1,/dev/sdb,/dev/sda1,/d=
ev/sda



There are two strange points:
1. As you see, there are "sdg1" "sdf1" "sdm1" "sdl1" "sdb1" "sda1".
These partitions should not exist.
2. The content of /etc/mdadm.conf is abnormal, "sdg1" "sdf1" "sdm1"
"sdl1" "sdb1" "sda1" should not be scanned and included.







2011/4/1 Simon McNair <simonmcnair@gmail.com>:
> I think the normal thing to try in this situation is:
>
> =C2=A0mdadm --assemble --scan
>
> and if that doesn't work, people normally ask for:
> =C2=A0mdadm -E /dev/sd?? for each appropriate drive which should be i=
n the array
>
> have a look at dmesg too ?
>
> I don't know much about md, I just lurk so apologies if you already k=
now
> this.
>
> cheers
> Simon
>
> On 30/03/2011 13:34, hank peng wrote:
>>
>> Hi,all:
>> I created a raid5 array which consists of 15 disks, before recoverin=
g
>> is done, a power failure event occured. After power is recovered, th=
e
>> machine box started successfully but "cat /proc/mdstat" gave no
>> message, previously created raid5 was gone. I check kernel messages,
>> it is as follows:
>>
>> <snip>
>> bonding: bond0: enslaving eth1 as a backup interface with a down lin=
k.
>> svc: failed to register lockdv1 RPC service (errno 97).
>> rpc.nfsd used greatest stack depth: 5440 bytes left
>> md: md1 stopped.
>> iSCSI Enterprise Target Software - version 1.4.1
>> </snip>
>>
>> In normal case, md1 should bind its disks after printing "md: md1
>> stopped", then what happened in this cituation?
>> BTW, my kernel version is 2.6.31.6.
>>
>>
>



--=20
The simplest is not all best but the best is surely the simplest!
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
