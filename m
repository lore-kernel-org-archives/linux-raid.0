From: "Leandro Tracchia" <ltracchia@gmail.com>
Subject: Re: metadata format 00.90 unknown, ignored
Date: Thu, 6 Nov 2008 14:13:57 -0500
Message-ID: <837a927a0811061113t45d06a43m7a877d116fae735d@mail.gmail.com>
References: <837a927a0811061051heb9081fr51217068eede302e@mail.gmail.com>
	 <49133ED8.4010409@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49133ED8.4010409@rabbit.us>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i know but when i created the fd partitions on /dev/sda and /dev/sdc
those are on /dev/sda1 /dev/sdc1

fdisk -l show this:

Disk /dev/sda: 750.1 GB, 750156374016 bytes
255 heads, 63 sectors/track, 91201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x04bcb930

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1       91201   732572001   fd  Linux raid autodetect

Disk /dev/sdb: 160.0 GB, 160041885696 bytes
255 heads, 63 sectors/track, 19457 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xe6433e3f

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *           1         122      979933+  83  Linux
/dev/sdb2             123       18845   150392497+  83  Linux
/dev/sdb3           18846       19457     4915890   82  Linux swap / Solaris

Disk /dev/sdc: 750.1 GB, 750156374016 bytes
255 heads, 63 sectors/track, 91201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xafcd80c2

-------
so why does mdadm tell me:

mdadm: Cannot open /dev/sda1: No such file or directory
mdadm: Cannot open /dev/sdc1: No such file or directory

when i try to create the array???

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       91201   732572001   fd  Linux raid autodetect

On Thu, Nov 6, 2008 at 2:00 PM, Peter Rabbitson <rabbit@rabbit.us> wrote:
> Leandro Tracchia wrote:
>> i'm not sure exactly what i did wrong and i wouldn't mind starting
>> over only i'm not sure how.
>>
>> i created a raid level 1 array using 2 disks.
>>
>> mdadm --create /dev/md0 --level=1 --raid-devices=2   /dev/sda   /dev/sdc
>>
>> ...
>>
>>
>> mdadm --assemble /dev/md0 /dev/sda1 /dev/sdc1
>>
>
> /dev/sda1 != /dev/sda
>
> Cheers :)
>
