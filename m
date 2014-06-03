From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: Recovering RAID set after OS disk failed
Date: Tue, 03 Jun 2014 16:05:32 +1000
Message-ID: <538D65AC.1090706@eyal.emu.id.au>
References: <7C19F7E4-7354-4C2C-A53E-DA546B569201@sbcglobal.net> <000801cf7e5f$53ffce20$fbff6a60$@kovari.priv.hu> <A2FAF98E-1CEC-41C5-8AA4-9CE707A477F6@sbcglobal.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A2FAF98E-1CEC-41C5-8AA4-9CE707A477F6@sbcglobal.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Davide,

Do you expect a partition table or do you use the whole disk as the fs =
(or whatever
higher layers you have)?

What does your /etc/fstab entry say?

Did you try a simple
	sudo mount /dev/md0

You do not say if you rebooted (to let initrd) do its thing.

Eyal

On 06/03/14 15:49, Davide Guarisco wrote:
> Peter, thanks for your help. Below are the answers.
>
>
> On Jun 2, 2014, at 05:36, K=C5=91v=C3=A1ri P=C3=A9ter <peter@kovari.p=
riv.hu> wrote:
>
>> Hi Davide,
>>
>> Open / ssh a console on your NAS box, and issue the following comman=
d and send us the results:
>> $ cat /proc/mdstat
>
>
> Personalities :
> unused devices: <none>
>
>
>
>>
>> Please also issue the following commands
>>
>> mdadm --examine /dev/sdX[Y]
>
> $ mdadm =E2=80=94examine /dev/sdb
> mdadm: cannot open /dev/sdb: Permission denied
>
>
> $ sudo mdadm =E2=80=94examine /dev/sdb
> /dev/sdb:
> 	MBR Magic : aa55
> Partition[0] : 1953520002 sectors at       63 (type fd)
>
>
> $ sudo mdadm =E2=80=94examine /dev/sdb1
> /dev/sdb1:
>            Magic : a92b4efc
>          Version : 0.90.00
>             UUID : f8a943c7:2ffa13d0:9770de34:eca2e81c (local to host=
 gecko)
>    Creation Time : Tue Mar  3 23:27:50 2009
>       Raid Level : raid5
>    Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>       Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
>     Raid Devices : 4
>    Total Devices : 4
> Preferred Minor : 0
>
>      Update Time : Wed May 28 21:52:54 2014
>            State : clean
>   Active Devices : 4
> Working Devices : 4
>   Failed Devices : 0
>    Spare Devices : 0
>         Checksum : 2d5185d8 - correct
>           Events : 46
>
>           Layout : left-symmetric
>       Chunk Size : 128K
>
>        Number   Major   Minor   RaidDevice State
> this     0       8       17        0      active sync   /dev/sdb1
>
>     0     0       8       17        0      active sync   /dev/sdb1
>     1     1       8       33        1      active sync   /dev/sdc1
>     2     2       8       49        2      active sync   /dev/sdd1
>     3     3       8       65        3      active sync   /dev/sde1
>
>
>> mdadm --examine /dev/sdc1
>
> /dev/sdc1:
>            Magic : a92b4efc
>          Version : 0.90.00
>             UUID : f8a943c7:2ffa13d0:9770de34:eca2e81c (local to host=
 gecko)
>    Creation Time : Tue Mar  3 23:27:50 2009
>       Raid Level : raid5
>    Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>       Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
>     Raid Devices : 4
>    Total Devices : 4
> Preferred Minor : 0
>
>      Update Time : Wed May 28 21:52:54 2014
>            State : clean
>   Active Devices : 4
> Working Devices : 4
>   Failed Devices : 0
>    Spare Devices : 0
>         Checksum : 2d5185ea - correct
>           Events : 46
>
>           Layout : left-symmetric
>       Chunk Size : 128K
>
>        Number   Major   Minor   RaidDevice State
> this     1       8       33        1      active sync   /dev/sdc1
>
>     0     0       8       17        0      active sync   /dev/sdb1
>     1     1       8       33        1      active sync   /dev/sdc1
>     2     2       8       49        2      active sync   /dev/sdd1
>     3     3       8       65        3      active sync   /dev/sde1
>
>
> =E2=80=A6etc. So it seems to me that we are OK, with the RAID 5 set s=
etup on /dev/sdb1, /dev/sdc1, /dev/sdd1, /dev/sde1.
>
>>
>> Where X is one of the raid drive's name and Y is the partition numbe=
r, if you created the raid set on partitions. (If not, then leave the n=
umber.) So, for example (assuming that your OS drive is /dev/sda, so yo=
ur raid drives are /dev/sdb, /dev/sdc and so on) issue the following co=
mmands:
>>
>> $ mdadm --examine /dev/sdb
>> or
>> $ mdadm --examine /dev/sdb1
>>
>> and so on for all 4 drives. And send back the results.
>>
>> p.s.
>> Before everything else,  you might try  auto assembling th eset by:
>> $ mdadm -v --assemble =E2=80=94scan
>
> Trying this holding my breath=E2=80=A6.
>
>> mdadm -v --assemble --scan
>
> mdadm: looking for devices for /dev/md0
> mdadm: no recogniseable superblock on /dev/dm-1
> mdadm: no recogniseable superblock on /dev/dm-0
> mdadm: no RAID superblock on /dev/sde
> mdadm: no RAID superblock on /dev/sdd
> mdadm: no RAID superblock on /dev/sdb
> mdadm: no RAID superblock on /dev/sdc
> mdadm: no RAID superblock on /dev/sda5
> mdadm: no RAID superblock on /dev/sda2
> mdadm: no RAID superblock on /dev/sda1
> mdadm: no RAID superblock on /dev/sda
> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 1.
> mdadm: added /dev/sdc1 to /dev/md0 as 1
> mdadm: added /dev/sdd1 to /dev/md0 as 2
> mdadm: added /dev/sde1 to /dev/md0 as 3
> mdadm: added /dev/sdb1 to /dev/md0 as 0
> mdadm: /dev/md0 has been started with 4 drives.
>
>
> OK, this seems successful as well. My RAID is /dev/md0.
>
>
>
>
>>
>> It might assemble your raid set for you successfully out of the box.=
  (If not, send here the output.)
>> If this assembles your set successfully, then you just need to save =
your config in /etc/mdam/mdadm.conf, do an initramfs update and you are=
 good to go.
>> So to save the config issue:
>> $ mdadm --examine --scan >> /etc/mdadm/mdadm.conf
>
>> cat /etc/mdadm/mdadm.conf
>
> ARRAY /dev/md0 UUID=3Df8a943c7:2ffa13d0:9770de34:eca2e81c
>
>
>
>>
>> then update initramfs so th eset will auto assmble on next boot:
>> $ update-initramfs -k all -u
>
>> update-initramfs -k all -u
>
> update-initramfs: Generating /boot/initrd.img-3.13.0-24-generic
>
>
>
> But now:
>
>> sudo fdisk -l
>
> Disk /dev/md0: 3000.6 GB, 3000606523392 bytes
> 2 heads, 4 sectors/track, 732569952 cylinders, total 5860559616 secto=
rs
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 131072 bytes / 393216 bytes
> Disk identifier: 0x00000000
>
> Disk /dev/md0 doesn=E2=80=99t contain a valid partition table
>
>
>
> How do I fix this and how to I gain access to /dev/md0?
>
> Thanks,
> 	Davide
>
>
>
>
>
>

--=20
Eyal Lebedinsky (eyal@eyal.emu.id.au)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
