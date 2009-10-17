From: "Majed B." <majedb@gmail.com>
Subject: Re: best practice when using removable drives and USB enclosure?
Date: Sat, 17 Oct 2009 12:42:34 +0300
Message-ID: <70ed7c3e0910170242j3d5d010dh63795c147a747faf@mail.gmail.com>
References: <2267211f0910162234s60f52e0pbf29b93bf7141da1@mail.gmail.com>
	<alpine.DEB.2.00.0910170432210.20160@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0910170432210.20160@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Bostrom <tbostrom@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I don't think it's necessary to update the mdadm config file each time
they change names, since mdadm reads the superblock on each disk to
determine the array's information, then construct the array itself.

You should be aware that using external disks through USB means that
SMART tools can't monitor your disks for bad sectors and read errors,
thus if any occur you won't know till you start getting I/O errors --
it would be almost too late by then.

On Sat, Oct 17, 2009 at 11:34 AM, Justin Piszcz <jpiszcz@lucidpixels.co=
m> wrote:
>
>
> On Fri, 16 Oct 2009, Tim Bostrom wrote:
>
>> I have a four drive USB enclosure that is populated with two drives
>> currently in RAID1 (md1). =C2=A0[pay no attention to md0]
>>
>> mdadm.conf
>> DEVICE =C2=A0/dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdg1 /dev/=
sdh1
>> ARRAY =C2=A0 /dev/md0 level=3Draid5 num-devices=3D4
>> UUID=3Dcdaba8bd:80943c6a:ab2fedca:3ef56cfb
>> devices=3D/dev/sdb1,/dev/sdc1,/dev/sdd1,/dev/sde1
>> ARRAY =C2=A0 /dev/md1 level=3Draid1 num-devices=3D2
>> UUID=3D649526d8:828a57b4:ab2fedca:3ef56cfb devices=3D/dev/sdg1,/dev/=
sdh1
>>
>> fstab
>> /dev/md0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/mnt=
/teradata =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext3 =C2=A0 =C2=A0defaults=
 =C2=A0 =C2=A0 =C2=A0 1 2
>> /dev/md1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/mnt=
/mirror =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext3 =C2=A0 =C2=A0def=
aults =C2=A0 =C2=A0 =C2=A0 =C2=A01
>> 2
>>
>>
>> [Fri Oct 16-22:34:15] [tbostrom@teraserver ~]$ sudo mdadm --detail
>> --scan /dev/md1
>> /dev/md1:
>> =C2=A0 =C2=A0 =C2=A0 Version : 0.90
>> =C2=A0Creation Time : Wed Oct 14 09:38:10 2009
>> =C2=A0 =C2=A0Raid Level : raid1
>> =C2=A0 =C2=A0Array Size : 1465135936 (1397.26 GiB 1500.30 GB)
>> =C2=A0Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>> =C2=A0Raid Devices : 2
>> =C2=A0Total Devices : 2
>> Preferred Minor : 1
>> =C2=A0 Persistence : Superblock is persistent
>>
>> =C2=A0 Update Time : Fri Oct 16 08:11:05 2009
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
>> Active Devices : 2
>> Working Devices : 2
>> Failed Devices : 0
>> =C2=A0Spare Devices : 0
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UUID : 649526d8:828a57b4:ab2fedca:=
3ef56cfb (local to host
>> teraserver.teambostrom.com)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 0.36
>>
>> =C2=A0 Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice State
>> =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 97=
 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdg1
>> =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0113=
 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdh1
>>
>>
>> When I created the array, I had another a third drive in the enclosu=
re
>> I was using for other work and the drive letters for the two RAID1
>> drives were /dev/sdh1 and /dev/sdi1. =C2=A0After I removed the disks=
 and
>> rebooted, the array drives changed to /dev/sdg1 and /dev/sdh1. =C2=A0=
I then
>> fixed my mdadm.conf and fstab to list the correct partitions.
>>
>> SO..... I don't anticipate changing drives in and out of the last tw=
o
>> open slots of my USB enclosure, but what would be the best practice
>> for making sure md1 comes up at boot all the time without having to
>> manually go into mdadm.conf and modify it back to /dev/sdh1 and
>> /dev/sdi1 when I put a drive in the open drive slots?
>>
>> I'm sure I'm missing some newbie Linux feature and this may not have
>> to do with RAID. =C2=A0Any ideas?
>>
>> Thank you.
>>
>> --
>> -Tim
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
> Hi,
>
> mdadm --examine --scan > /etc/mdadm/mdadm.conf
>
> Make sure this is started up at boot via mdadm (/etc/init.d/mdadm-rai=
d
> start) in Debian, this will/should put the UUID of the arrays in the =
file
> and then it should not matter what the disks are named.
>
> If you are plugging them in randomly you will need to setup an event =
based
> script to do something similar for you.
>
> Justin.
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
