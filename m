From: Twigathy <twigathy@gmail.com>
Subject: Re: Help with Failed array
Date: Sat, 11 Jul 2009 15:35:59 +0100
Message-ID: <1f0f1a960907110735r55b134f6n63f1acd936a9131@mail.gmail.com>
References: <dd404eb00907110001n177f9fabpb394aac706d3e90@mail.gmail.com>
	 <dd404eb00907110046k2bda785fy204c0d23075bda24@mail.gmail.com>
	 <921ca19c0907110729x52b3b61eo24d98e06347119c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <921ca19c0907110729x52b3b61eo24d98e06347119c6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sujit Karataparambil <sjt.kar@gmail.com>
Cc: Thomas Kenyon <zhadnost@googlemail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

That's raid4. Raid5 has distributed parity. :)

T

2009/7/11 Sujit Karataparambil <sjt.kar@gmail.com>:
> I donot think that is how raid5 works. You should not have removed
> the first faulty disk in the first place.
>
> I think how raid5 works is that it tends to have an parity informatio=
n
> stored in an particular drive.
>
> Correct me on this if it is wrong?
>
> On Sat, Jul 11, 2009 at 1:16 PM, Thomas Kenyon<zhadnost@googlemail.co=
m> wrote:
>> My server at home operates a 4 disk software RAID 5 array which is
>> normally mounted at /.
>>
>> At the moment I am using mdadm v2.6.7.2 (I don't know which version
>> built the array).
>>
>> One of the disks appeared to have developed a fault, an I/O error
>> would be produced and the array would rebuild to try and mao round i=
t,
>> and once it had finished there'd be another I/O error and it would
>> start again.
>>
>> I marked the drive as faulty, removed it from the array, replaced it
>> with a nother drive, replicated the partition map and added it to th=
e
>> array.
>>
>> As expected the drive started being built.
>>
>> I'm not sure if it had finished by this point, but another disk
>> produced an I/O error which broke the array.
>>
>> Now I'm trying to recover any data I can from it.
>>
>> The partitions in the array are sd[abcd]1. (SATA controller).
>>
>> sdb is the drive that originally failed and has been replaced. sdc i=
s
>> the drive that took everything down.
>>
>> When I first try to assemble the array, this message appears in kern=
el messages.
>>
>> md: kicking non-fresh sdc1 from array!
>>
>> and this appears in the console.
>>
>> mdadm: /dev/md0 assembled from 2 drives and 1 spare - not enough to
>> start the array.
>>
>> even if I use --force.
>>
>> with this in mdstat
>>
>> Personalities : [raid6] [raid5] [raid4]
>> md0 : inactive sdd1[2](S) sdc1[1](S) sdb1[5](S) sda1[4](S)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1937888128 blocks super 1.0
>>
>> unused devices: <none>
>>
>> (well, all the [S], except the one on sdb1 appearing is new).
>>
>> If I try to fail and remove sdc1 and then reinsert it I get.
>>
>> mdadm /dev/md0 -f /dev/sdc1
>> mdadm: cannot get array info for /dev/md0
>>
>> from examine I get
>>
>> /dev/sda1:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Magic : a92b4=
efc
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 1.0
>> =C2=A0=C2=A0=C2=A0 Feature Map : 0x0
>> =C2=A0=C2=A0=C2=A0=C2=A0 Array UUID : 62f0dee0:e3a81d0c:68df2ad8:1ec=
b435b
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Name : =
'chef':1
>> =C2=A0 Creation Time : Mon Jul 21 15:58:36 2008
>> =C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid5
>> =C2=A0=C2=A0 Raid Devices : 4
>>
>> =C2=A0Avail Dev Size : 968944072 (462.03 GiB 496.10 GB)
>> =C2=A0=C2=A0=C2=A0=C2=A0 Array Size : 2906832000 (1386.09 GiB 1488.3=
0 GB)
>> =C2=A0 Used Dev Size : 968944000 (462.03 GiB 496.10 GB)
>> =C2=A0=C2=A0 Super Offset : 968944328 sectors
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State : clean
>> =C2=A0=C2=A0=C2=A0 Device UUID : 0bf37dbc:000ee685:7bcf601b:ff125af1
>>
>> =C2=A0=C2=A0=C2=A0 Update Time : Fri Jul 10 18:45:04 2009
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Checksum : ef734a25 - correct
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 19518
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Layout : left-symme=
tric
>> =C2=A0=C2=A0=C2=A0=C2=A0 Chunk Size : 64K
>>
>> =C2=A0=C2=A0=C2=A0 Array Slot : 4 (failed, failed, 2, failed, 3)
>> =C2=A0=C2=A0 Array State : __uU 3 failed
>>
>> /dev/sdb1:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Magic : a92b4=
efc
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 1.0
>> =C2=A0=C2=A0=C2=A0 Feature Map : 0x0
>> =C2=A0=C2=A0=C2=A0=C2=A0 Array UUID : 62f0dee0:e3a81d0c:68df2ad8:1ec=
b435b
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Name : =
'chef':1
>> =C2=A0 Creation Time : Mon Jul 21 15:58:36 2008
>> =C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid5
>> =C2=A0=C2=A0 Raid Devices : 4
>>
>> =C2=A0Avail Dev Size : 968944200 (462.03 GiB 496.10 GB)
>> =C2=A0=C2=A0=C2=A0=C2=A0 Array Size : 2906832000 (1386.09 GiB 1488.3=
0 GB)
>> =C2=A0 Used Dev Size : 968944000 (462.03 GiB 496.10 GB)
>> =C2=A0=C2=A0 Super Offset : 968944328 sectors
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State : clean
>> =C2=A0=C2=A0=C2=A0 Device UUID : bb71f618:9d9be6e2:84bd3fdb:02543dfb
>>
>> =C2=A0=C2=A0=C2=A0 Update Time : Fri Jul 10 18:45:04 2009
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Checksum : 72ae8ca8 - correct
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 19518
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Layout : left-symme=
tric
>> =C2=A0=C2=A0=C2=A0=C2=A0 Chunk Size : 64K
>>
>> =C2=A0=C2=A0=C2=A0 Array Slot : 5 (failed, failed, 2, failed, 3)
>> =C2=A0=C2=A0 Array State : __uu 3 failed
>>
>> /dev/sdc1:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Magic : a92b4=
efc
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 1.0
>> =C2=A0=C2=A0=C2=A0 Feature Map : 0x0
>> =C2=A0=C2=A0=C2=A0=C2=A0 Array UUID : 62f0dee0:e3a81d0c:68df2ad8:1ec=
b435b
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Name : =
'chef':1
>> =C2=A0 Creation Time : Mon Jul 21 15:58:36 2008
>> =C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid5
>> =C2=A0=C2=A0 Raid Devices : 4
>>
>> =C2=A0Avail Dev Size : 968944200 (462.03 GiB 496.10 GB)
>> =C2=A0=C2=A0=C2=A0=C2=A0 Array Size : 2906832000 (1386.09 GiB 1488.3=
0 GB)
>> =C2=A0 Used Dev Size : 968944000 (462.03 GiB 496.10 GB)
>> =C2=A0=C2=A0 Super Offset : 968944328 sectors
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State : clean
>> =C2=A0=C2=A0=C2=A0 Device UUID : 0259688e:21902f87:a4da25cd:a5042e6f
>>
>> =C2=A0=C2=A0=C2=A0 Update Time : Fri Jul 10 18:45:04 2009
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Checksum : f2402efa - correct
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 19375
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Layout : left-symme=
tric
>> =C2=A0=C2=A0=C2=A0=C2=A0 Chunk Size : 64K
>>
>> =C2=A0=C2=A0=C2=A0 Array Slot : 1 (failed, failed, 2, failed, 3)
>> =C2=A0=C2=A0 Array State : __uu 3 failed
>>
>> /dev/sdd1:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Magic : a92b4=
efc
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 1.0
>> =C2=A0=C2=A0=C2=A0 Feature Map : 0x0
>> =C2=A0=C2=A0=C2=A0=C2=A0 Array UUID : 62f0dee0:e3a81d0c:68df2ad8:1ec=
b435b
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Name : =
'chef':1
>> =C2=A0 Creation Time : Mon Jul 21 15:58:36 2008
>> =C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid5
>> =C2=A0=C2=A0 Raid Devices : 4
>>
>> =C2=A0Avail Dev Size : 968944072 (462.03 GiB 496.10 GB)
>> =C2=A0=C2=A0=C2=A0=C2=A0 Array Size : 2906832000 (1386.09 GiB 1488.3=
0 GB)
>> =C2=A0 Used Dev Size : 968944000 (462.03 GiB 496.10 GB)
>> =C2=A0=C2=A0 Super Offset : 968944328 sectors
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State : clean
>> =C2=A0=C2=A0=C2=A0 Device UUID : 1f3b1479:3e01d8dd:d8ce565a:cb13e780
>>
>> =C2=A0=C2=A0=C2=A0 Update Time : Fri Jul 10 18:45:04 2009
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Checksum : d27e859e - correct
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 19518
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Layout : left-symme=
tric
>> =C2=A0=C2=A0=C2=A0=C2=A0 Chunk Size : 64K
>>
>> =C2=A0=C2=A0=C2=A0 Array Slot : 2 (failed, failed, 2, failed, 3)
>> =C2=A0=C2=A0 Array State : __Uu 3 failed
>>
>> As you can see sdc1's event count is more than a little out, oddly
>> sdb1 is in State: clean.
>>
>> I've run out of ideas, can somoneone please give me a point in the
>> right direction as to how to recover some of the data from this.
>>
>> TIA for any help received.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
>
> --
> -- Sujit K M
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
