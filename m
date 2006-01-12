From: Matt Darcy <kernel-lists@projecthugo.co.uk>
Subject: Re: [git patch] 2.6.x libata fix
Date: Thu, 12 Jan 2006 10:01:34 +0000
Message-ID: <43C628FE.9020303@projecthugo.co.uk>
References: <20060109171104.GA25793@havoc.gtf.org> <43C4DB86.7030603@projecthugo.co.uk>
Reply-To: kernel-lists@projecthugo.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43C4DB86.7030603@projecthugo.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matt Darcy wrote:

> Jeff Garzik wrote:
>
>> Please pull from 'upstream-linus' branch of
>> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
>>
>> to receive the following updates:
>>
>> drivers/scsi/sata_nv.c |   30 ++++++++++++++++++++++++------
>> 1 files changed, 24 insertions(+), 6 deletions(-)
>>
>> Andrew Chew:
>>      sata_nv, spurious interrupts at system startup with MAXTOR 
>> 6H500F0 drive
>>
>> diff --git a/drivers/scsi/sata_nv.c b/drivers/scsi/sata_nv.c
>> index c0cf52c..bbbb55e 100644
>> --- a/drivers/scsi/sata_nv.c
>> +++ b/drivers/scsi/sata_nv.c
>>
>> <snip reset of patch>
>>  
>>
> Hi Jeff, et all
>
> I pulled this down last night from 
> git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
> as I don't have an account on master.kernel.org, I assume these are 
> the same physical tree.
>
> This built fine and seemed aware of all the SATA disks on my 
> controller (as did previous git branches).
>
> Again using my raid5 (7 disks 1.4tb) example, I am unable to build an 
> array without the machine hanging.
>
> I am able to access the individual disks for a short period of time 
> before the box hangs totally which I assume is why the raid array will 
> not build as the access for the disks hangs, not the actual building 
> of the array.
>
> I havn't got any output yet on the errors (if there are any) as I left 
> the array building overnight (300+ minutes) and when I woke up this 
> morning the box had hung, but power saver had come on the screen so I 
> couldn't see the messages.
>
> I'll do another test this afternoon and try to get some output for 
> you, but I just thought I'd let you know this was coming.
>
> Aslo FYI: I'm using maxtor SATA disks, so your patch was of particular 
> interesting to me.
>
> Many thanks,
>
> Matt


I can now provide further updates for this, although this are not really 
super useful.

I've copied the linux-raid list in as well, as after a little more 
testing on my part I'd appriciate some input from the raid guys also.

First of all, please ignore the comments above, there was a problem with 
grub and it actually "failed back" and booted into the older git 
release, so my initial test was actually done running the wrong kenel 
which I didn't notice. Appologies to all for this.

Last nights tests where done using the correct kernel (I fixed the grub 
typo) 2.6.15-g5367f2d6

The details I have are as follows.

I can run the machine accessing the 7 maxtor SATA disks as individual 
disks for around 12 hours now, without any hangs or errors or any real 
problems. I've not hit them very hard, but initial performance seems 
fine and more than usable.

The actual problems occurr when including these disks in a raid group.

root@berger:~# fdisk -l /dev/sdc

Disk /dev/sdc: 251.0 GB, 251000193024 bytes
255 heads, 63 sectors/track, 30515 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       30515   245111706   fd  Linux raid 
autodetect

root@berger:~# fdisk -l /dev/sde

Disk /dev/sde: 251.0 GB, 251000193024 bytes
255 heads, 63 sectors/track, 30515 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1               1       30515   245111706   fd  Linux raid 
autodetect


As you can see from my two random disks examples, they are partitioned 
and makred as raid auto detect.

I issue the mdadm command to build the raid 5 array

 mdadm -C /dev/md6 -l5 -n6 -x1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 
/dev/sdg1 /dev/sdh1 /dev/sdi1

and the array starts to build.......

md6 : active raid5 sdh1[7] sdi1[6](S) sdg1[4] sdf1[3] sde1[2] sdd1[1] 
sdc1[0]
      1225558080 blocks level 5, 64k chunk, algorithm 2 [6/5] [UUUUU_]
      [>....................]  recovery =  0.1% (374272/245111616) 
finish=337.8min speed=12073K/sec


however at around %25 - %40 completion the box will simpley just hang - 
I'm getting no on screen messages and the sylog is not reporting anything.

SysRQ is unusable.

I'm open to options on how to resolve this and move the driver forward 
(assuming it is the drivers interfaction with the raid sub system)
or
how to get some meaningful debug out to report back to the appropriate 
development groups.

thanks.

Matt.










