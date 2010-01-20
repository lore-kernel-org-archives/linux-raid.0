From: "Majed B." <majedb@gmail.com>
Subject: Re: Can't re-assemble successfully after creation, initial sync and
	reboot
Date: Wed, 20 Jan 2010 16:32:11 +0300
Message-ID: <70ed7c3e1001200532l4d01ff52o251d898632735458@mail.gmail.com>
References: <959332b61001180933n638b9255k5aa540be024f2e6f@mail.gmail.com>
	<959332b61001200524j7a879f15u5281e03b1da2cd43@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <959332b61001200524j7a879f15u5281e03b1da2cd43@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stephan Stachurski <ses1984@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Have you ran SMART tests using smartctl (part of smartmontools) on
each disk to verify that they're all sane and have no bad sectors or
any sort of damage?

Which version are you using exactly? mdadm --version

If the array is fresh, you don't need to resync. zero all disks then
create the array and use the assumeclean flag.
To zero them, use dd: dd if=3D/dev/zero of=3D/dev/sdx of=3D/dev/sdz of=3D=
/dev/sdy bs=3D50M

Also provide the output of mdadm -E /dev/sdx for each disk (paste it
in the email itself)

On Wed, Jan 20, 2010 at 4:24 PM, Stephan Stachurski <ses1984@gmail.com>=
 wrote:
> Ok, I tried a couple of things, so far with no success.
>
> I re-created the array, let it synchronize, then rebooted. When I
> first created the array, the components devices looked like this:
>
> md0 : active raid5 sda[0] sdb[1] sdc[2] sdd[3]
>
> When I rebooted, it suddenly comes up like this, skipping component d=
evice 3:
>
> md0 : active raid5 sda[0] sdd[4] sdb[1] sdc[2]
>
> and it was automatically resyncing, destroying the last 6 hours I was
> waiting for it to initially sync, and it changed my chunk size! Why d=
o
> I keep getting these problems?
>
> On Mon, Jan 18, 2010 at 12:33 PM, Stephan Stachurski <ses1984@gmail.c=
om> wrote:
>> I'm having problems with an array that I just created. It's a raid
>> level 5 with 4 devices using all of the default settings. I'm using
>> the version of mdadm that's included in ubuntu 9.10 repositories.
>>
>> When I reboot the machine, /proc/mdstat shows this:
>> md_d0 : inactive sdc[2](S)
>>
>> I can stop the device, and attempt the --assemble the array correctl=
y,
>> but something still is wrong:
>>
>> $ sudo mdadm --stop /dev/md_d0
>> mdadm: stopped /dev/md_d0
>> $ sudo mdadm --assemble /dev/md0 -fv /dev/sda /dev/sdb /dev/sdc /dev=
/sdd
>> mdadm: looking for devices for /dev/md0
>> mdadm: /dev/sda is identified as a member of /dev/md0, slot 0.
>> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 1.
>> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 2.
>> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 3.
>> mdadm: added /dev/sdb to /dev/md0 as 1
>> mdadm: added /dev/sdc to /dev/md0 as 2
>> mdadm: added /dev/sdd to /dev/md0 as 3
>> mdadm: added /dev/sda to /dev/md0 as 0
>> mdadm: /dev/md0 has been started with 3 drives (out of 4).
>> $ sudo cat /proc/mdstat
>> md0: active raid5 sda[0] sdc[2] sdb[1]
>> 2930287488 blocks level 5, 128k chunk, algorithm 2 [4/3] [UUU_]
>>
>> md_d0: inactive sdd[3](S)
>> 976762496 blocks
>>
>> Why, if it correctly identifies the devices that are members of
>> /dev/md0, and then adds them to /dev/md0, do I not get the complete
>> array?
>> --
>> Stephan E Stachurski
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
