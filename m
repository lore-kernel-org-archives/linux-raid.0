From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: Recovering RAID set after OS disk failed
Date: Wed, 04 Jun 2014 15:20:16 +1000
Message-ID: <538EAC90.9030201@eyal.emu.id.au>
References: <7C19F7E4-7354-4C2C-A53E-DA546B569201@sbcglobal.net> <000801cf7e5f$53ffce20$fbff6a60$@kovari.priv.hu> <A2FAF98E-1CEC-41C5-8AA4-9CE707A477F6@sbcglobal.net> <538D65AC.1090706@eyal.emu.id.au> <A5637DAF-91A1-4313-9314-13058D65F0C0@sbcglobal.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A5637DAF-91A1-4313-9314-13058D65F0C0@sbcglobal.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 06/04/14 15:00, Davide Guarisco wrote:
>
> On Jun 2, 2014, at 23:05, Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote=
:
>
>> Davide,
>>
>> Do you expect a partition table or do you use the whole disk as the =
fs (or whatever
>> higher layers you have)?
>
>
> I do not remember. It=E2=80=99s possible I originally setup two parti=
tions, one for Time Machine and one as shared storage.
>
>
>>
>> What does your /etc/fstab entry say?
>
>
> fstab is all new, so it says:
>
> davide@gecko:/etc$ cat fstab
> # /etc/fstab: static file system information.
> #
> # Use 'blkid' to print the universally unique identifier for a
> # device; this may be used with UUID=3D as a more robust way to name =
devices
> # that works even if disks are added and removed. See fstab(5).
> #
> # <file system> <mount point>   <type>  <options>       <dump>  <pass=
>
> /dev/mapper/gecko--vg-root /               ext4    errors=3Dremount-r=
o 0       1
> # /boot was on /dev/sda1 during installation
> UUID=3D89a63dd3-93fb-4a37-acd5-34f6790ef3e7 /boot           ext2    d=
efaults        0       2
> /dev/mapper/gecko--vg-swap_1 none            swap    sw              =
0       0
>
>
>
>
>>
>> Did you try a simple
>> 	sudo mount /dev/md0
>>
>> You do not say if you rebooted (to let initrd) do its thing.
>>
>> Eyal
>
>
> All right, I will reboot now=E2=80=A6
>
> After reboot:
>
> davide@gecko:~$ sudo fdisk -l
> [sudo] password for davide:
> no talloc stackframe at ../source3/param/loadparm.c:4864, leaking mem=
ory
>
> Disk /dev/sda: 31.9 GB, 31937527808 bytes
> 255 heads, 63 sectors/track, 3882 cylinders, total 62377984 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x000384c2
>
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sda1   *        2048      499711      248832   83  Linux
> /dev/sda2          501758    62375935    30937089    5  Extended
> /dev/sda5          501760    62375935    30937088   8e  Linux LVM
>
> Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 secto=
rs
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0xe3494e66
>
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1              63  1953520064   976760001   fd  Linux raid au=
todetect
>
> Disk /dev/sdc: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 secto=
rs
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x6b47e429
>
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1              63  1953520064   976760001   fd  Linux raid au=
todetect
>
> Disk /dev/sde: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 secto=
rs
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0xfdfcb365
>
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sde1              63  1953520064   976760001   fd  Linux raid au=
todetect
>
> Disk /dev/sdd: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 secto=
rs
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x6303429f
>
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sdd1              63  1953520064   976760001   fd  Linux raid au=
todetect
>
> Disk /dev/md0: 3000.6 GB, 3000606523392 bytes
> 2 heads, 4 sectors/track, 732569952 cylinders, total 5860559616 secto=
rs
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 131072 bytes / 393216 bytes
> Disk identifier: 0x00000000
>
> Disk /dev/md0 doesn't contain a valid partition table
>
> Disk /dev/mapper/gecko--vg-root: 29.5 GB, 29536288768 bytes
> 255 heads, 63 sectors/track, 3590 cylinders, total 57688064 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
>
> Disk /dev/mapper/gecko--vg-root doesn't contain a valid partition tab=
le
>
> Disk /dev/mapper/gecko--vg-swap_1: 2139 MB, 2139095040 bytes
> 255 heads, 63 sectors/track, 260 cylinders, total 4177920 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
>
> Disk /dev/mapper/gecko--vg-swap_1 doesn't contain a valid partition t=
able
>
>
>
> Now trying to mount md0:
>
> davide@gecko:~$ sudo mount /dev/md0
> mount: can't find /dev/md0 in /etc/fstab or /etc/mtab
>
>
> OK, I am lost now.
>
> Davide

So you do not have an fstab entry, no problem. File systems usually mou=
nt just fine
with automatic detection (replace mountPoint with the directory where i=
t usually mounts).
	sudo mount -o ro /dev/md0 /mountPoint
[if it looks good then you can remove the readonly option '-o ro']

Or you can check the array directly:
	sudo file -s /dev/md0

=46or me I get:

$ sudo file -s /dev/md0
/dev/md0: Linux rev 1.0 ext4 filesystem data, UUID=3D1db56f55-de4f-435e=
-80ed-e525f07d30df, volume name "data1" (needs journal recovery) (exten=
ts) (64bit) (large files) (huge files)

If there is no fs showing then you probably did have some partitions. O=
r it did
not assemble correctly (hope not).

cheers

>>
>> On 06/03/14 15:49, Davide Guarisco wrote:
>>> Peter, thanks for your help. Below are the answers.
>>>
>>>
>>> On Jun 2, 2014, at 05:36, K=C5=91v=C3=A1ri P=C3=A9ter <peter@kovari=
=2Epriv.hu> wrote:
>>>
>>>> Hi Davide,
>>>>
>>>> Open / ssh a console on your NAS box, and issue the following comm=
and and send us the results:
>>>> $ cat /proc/mdstat
>>>
>>>
>>> Personalities :
>>> unused devices: <none>
>>>
>>>
>>>
>>>>
>>>> Please also issue the following commands
>>>>
>>>> mdadm --examine /dev/sdX[Y]
>>>
>>> $ mdadm =E2=80=94examine /dev/sdb
>>> mdadm: cannot open /dev/sdb: Permission denied
>>>
>>>
>>> $ sudo mdadm =E2=80=94examine /dev/sdb
>>> /dev/sdb:
>>> 	MBR Magic : aa55
>>> Partition[0] : 1953520002 sectors at       63 (type fd)
>>>
>>>
>>> $ sudo mdadm =E2=80=94examine /dev/sdb1
>>> /dev/sdb1:
>>>            Magic : a92b4efc
>>>          Version : 0.90.00
>>>             UUID : f8a943c7:2ffa13d0:9770de34:eca2e81c (local to ho=
st gecko)
>>>    Creation Time : Tue Mar  3 23:27:50 2009
>>>       Raid Level : raid5
>>>    Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>>>       Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
>>>     Raid Devices : 4
>>>    Total Devices : 4
>>> Preferred Minor : 0
>>>
>>>      Update Time : Wed May 28 21:52:54 2014
>>>            State : clean
>>>   Active Devices : 4
>>> Working Devices : 4
>>>   Failed Devices : 0
>>>    Spare Devices : 0
>>>         Checksum : 2d5185d8 - correct
>>>           Events : 46
>>>
>>>           Layout : left-symmetric
>>>       Chunk Size : 128K
>>>
>>>        Number   Major   Minor   RaidDevice State
>>> this     0       8       17        0      active sync   /dev/sdb1
>>>
>>>     0     0       8       17        0      active sync   /dev/sdb1
>>>     1     1       8       33        1      active sync   /dev/sdc1
>>>     2     2       8       49        2      active sync   /dev/sdd1
>>>     3     3       8       65        3      active sync   /dev/sde1
>>>
>>>
>>>> mdadm --examine /dev/sdc1
>>>
>>> /dev/sdc1:
>>>            Magic : a92b4efc
>>>          Version : 0.90.00
>>>             UUID : f8a943c7:2ffa13d0:9770de34:eca2e81c (local to ho=
st gecko)
>>>    Creation Time : Tue Mar  3 23:27:50 2009
>>>       Raid Level : raid5
>>>    Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>>>       Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
>>>     Raid Devices : 4
>>>    Total Devices : 4
>>> Preferred Minor : 0
>>>
>>>      Update Time : Wed May 28 21:52:54 2014
>>>            State : clean
>>>   Active Devices : 4
>>> Working Devices : 4
>>>   Failed Devices : 0
>>>    Spare Devices : 0
>>>         Checksum : 2d5185ea - correct
>>>           Events : 46
>>>
>>>           Layout : left-symmetric
>>>       Chunk Size : 128K
>>>
>>>        Number   Major   Minor   RaidDevice State
>>> this     1       8       33        1      active sync   /dev/sdc1
>>>
>>>     0     0       8       17        0      active sync   /dev/sdb1
>>>     1     1       8       33        1      active sync   /dev/sdc1
>>>     2     2       8       49        2      active sync   /dev/sdd1
>>>     3     3       8       65        3      active sync   /dev/sde1
>>>
>>>
>>> =E2=80=A6etc. So it seems to me that we are OK, with the RAID 5 set=
 setup on /dev/sdb1, /dev/sdc1, /dev/sdd1, /dev/sde1.
>>>
>>>>
>>>> Where X is one of the raid drive's name and Y is the partition num=
ber, if you created the raid set on partitions. (If not, then leave the=
 number.) So, for example (assuming that your OS drive is /dev/sda, so =
your raid drives are /dev/sdb, /dev/sdc and so on) issue the following =
commands:
>>>>
>>>> $ mdadm --examine /dev/sdb
>>>> or
>>>> $ mdadm --examine /dev/sdb1
>>>>
>>>> and so on for all 4 drives. And send back the results.
>>>>
>>>> p.s.
>>>> Before everything else,  you might try  auto assembling th eset by=
:
>>>> $ mdadm -v --assemble =E2=80=94scan
>>>
>>> Trying this holding my breath=E2=80=A6.
>>>
>>>> mdadm -v --assemble --scan
>>>
>>> mdadm: looking for devices for /dev/md0
>>> mdadm: no recogniseable superblock on /dev/dm-1
>>> mdadm: no recogniseable superblock on /dev/dm-0
>>> mdadm: no RAID superblock on /dev/sde
>>> mdadm: no RAID superblock on /dev/sdd
>>> mdadm: no RAID superblock on /dev/sdb
>>> mdadm: no RAID superblock on /dev/sdc
>>> mdadm: no RAID superblock on /dev/sda5
>>> mdadm: no RAID superblock on /dev/sda2
>>> mdadm: no RAID superblock on /dev/sda1
>>> mdadm: no RAID superblock on /dev/sda
>>> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
>>> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
>>> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 0.
>>> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 1.
>>> mdadm: added /dev/sdc1 to /dev/md0 as 1
>>> mdadm: added /dev/sdd1 to /dev/md0 as 2
>>> mdadm: added /dev/sde1 to /dev/md0 as 3
>>> mdadm: added /dev/sdb1 to /dev/md0 as 0
>>> mdadm: /dev/md0 has been started with 4 drives.
>>>
>>>
>>> OK, this seems successful as well. My RAID is /dev/md0.
>>>
>>>
>>>
>>>
>>>>
>>>> It might assemble your raid set for you successfully out of the bo=
x.  (If not, send here the output.)
>>>> If this assembles your set successfully, then you just need to sav=
e your config in /etc/mdam/mdadm.conf, do an initramfs update and you a=
re good to go.
>>>> So to save the config issue:
>>>> $ mdadm --examine --scan >> /etc/mdadm/mdadm.conf
>>>
>>>> cat /etc/mdadm/mdadm.conf
>>>
>>> ARRAY /dev/md0 UUID=3Df8a943c7:2ffa13d0:9770de34:eca2e81c
>>>
>>>
>>>
>>>>
>>>> then update initramfs so th eset will auto assmble on next boot:
>>>> $ update-initramfs -k all -u
>>>
>>>> update-initramfs -k all -u
>>>
>>> update-initramfs: Generating /boot/initrd.img-3.13.0-24-generic
>>>
>>>
>>>
>>> But now:
>>>
>>>> sudo fdisk -l
>>>
>>> Disk /dev/md0: 3000.6 GB, 3000606523392 bytes
>>> 2 heads, 4 sectors/track, 732569952 cylinders, total 5860559616 sec=
tors
>>> Units =3D sectors of 1 * 512 =3D 512 bytes
>>> Sector size (logical/physical): 512 bytes / 512 bytes
>>> I/O size (minimum/optimal): 131072 bytes / 393216 bytes
>>> Disk identifier: 0x00000000
>>>
>>> Disk /dev/md0 doesn=E2=80=99t contain a valid partition table
>>>
>>>
>>>
>>> How do I fix this and how to I gain access to /dev/md0?
>>>
>>> Thanks,
>>> 	Davide
>>
>> --
>> Eyal Lebedinsky (eyal@eyal.emu.id.au)


--=20
Eyal Lebedinsky (eyal@eyal.emu.id.au)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
