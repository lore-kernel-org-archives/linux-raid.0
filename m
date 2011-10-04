From: "Marcin M. Jessa" <lists@yazzy.org>
Subject: Re: How to stress test an RAID 6 array?
Date: Tue, 04 Oct 2011 10:37:43 +0200
Message-ID: <4E8AC5D7.8070405@yazzy.org>
References: <4E89B81D.5000800@yazzy.org> <CADNH=7E9n-uj-xNPq-DuYgfJ+Js9b4bWn_QyeDJ8O+ka4GjLiQ@mail.gmail.com> <4E89BF73.8020604@yazzy.org> <4E8A83FD.3060805@hardwarefreak.com>
Reply-To: lists@yazzy.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E8A83FD.3060805@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/4/11 5:56 AM, Stan Hoeppner wrote:
> On 10/3/2011 8:58 AM, Marcin M. Jessa wrote:
>
>>   exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
>
> This line is not important ^^^
>
>>   ata9.00: failed command: FLUSH CACHE EXT
>
> THIS one is:^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
>> That "exception Emask" part pointed me to misc threads where people
>> mentioned bugs in the Linux kernel.
>
> According to your dmesg output the kernel believes the drives are not
> completing the ATA6 (and later) FLUSH_CACHE_EXT command.  hdparm will
> confirm your drives drives do support it.  FLUSH_CACHE_EXT is sent to a
> drive to force data in the cache to hit the platters.  This is done for
> data consistency and to prevent filesystem corruption due to power
> outages, system crashes, and the like.
>
> What you need to figure out is why the apparent flush command faliures
> are occurring.  The cause will likely be a kernel/driver issue, a
> motherboard/sata controller issue, a PSU issue, or a drive issue.

I was testing the ARRAY again yesterday running multiple I/O intensive 
processes:
- installing two KVM guests at the same time
- running iozone -a -Rb output.xls
- 3 simultaneous dd processes writing to an LV on top of the array with 
various block sizes, i.e: dd if=/dev/zero of=file2 bs=8k count=1024000
- fio tests as suggested by Joseph Landman in a different post in the 
thread.

It never failed.
I updated the BIOS to the latest version before running new tests and 
replace the SATA cables. It may have helped.
I also noticed the CPU was slightly overclocked from 3.0GHz to 3.2GHz.
Do you think it could affect the RAID on heavy CPU loads?

> The few instances of this FLUSH_CACHE_EXT error I located seemed to
> center somewhere around kernel 2.6.34.  IIRC those experiencing this
> issue on FC and Ubuntu instantly fixed it with a distro upgrade.
>
> Thus, upgrade your kernel to 2.6.38.8 or later.

My kernel is pretty new:
# uname -a
Linux odin 3.0.0-1-amd64 #1 SMP Sat Aug 27 16:21:11 UTC 2011 x86_64
GNU/Linux

>If that doesn't fix it,
> disable the write caches on your array member drives (a very good idea
> with non BBU RAID anyway).  The proper/preferred way to do this may vary
> amongst distros.  Adding a boot script containing something like the
> following to the appropriate /etc/rc.x directory should do the trick on
> all distros:
>
> #!/bin/sh
> hdparm -W0 /dev/sda
> hdparm -W0 /dev/sdb
> hdparm -W0 /dev/sdc
> hdparm -W0 /dev/sdd
> hdparm -W0 /dev/sde

Thanks. The problem is device names change across reboots. The RAID 
members can start at /dev/sdg or /dev/sda, you never know.
I should probably replace that with UUIDs.
BTW, would it be recommended to disable write caches for devices which 
are members of RAID 1 or not members of any RAID ?


> Reboot.  Confirm the write caches are disabled with something like this:
>
> #!/bin/bash
> for i in {a..e}
> do
>      echo -n "sd$i:  "
>      hdparm -i /dev/sd$i|grep -i writecache|awk '{ print $2 }'
> done
>
> If neither of these suggestions fixes the problem then you may need to
> start replacing or adding hardware.  At that point I'd recommend
> dropping an LSI SAS 9211-8i into your free PCIe x16 slot.

Thanks a lot for your help Stan.


-- 

Marcin M. Jessa
