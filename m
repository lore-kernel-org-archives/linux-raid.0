From: Matt Darcy <kernel-lists@projecthugo.co.uk>
Subject: Re: [git patch] 2.6.x libata fix more information (sata_mv problems
 continued)
Date: Fri, 13 Jan 2006 11:26:47 +0000
Message-ID: <43C78E77.4010603@projecthugo.co.uk>
References: <20060109171104.GA25793@havoc.gtf.org> <43C4DB86.7030603@projecthugo.co.uk> <43C628FE.9020303@projecthugo.co.uk> <43C64182.1000702@projecthugo.co.uk>
Reply-To: kernel-lists@projecthugo.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43C64182.1000702@projecthugo.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: kernel-lists@projecthugo.co.uk, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matt Darcy wrote:

>
>>
>>
>> I can now provide further updates for this, although this are not 
>> really super useful.
>>
>> I've copied the linux-raid list in as well, as after a little more 
>> testing on my part I'd appriciate some input from the raid guys also.
>>
>> First of all, please ignore the comments above, there was a problem 
>> with grub and it actually "failed back" and booted into the older git 
>> release, so my initial test was actually done running the wrong kenel 
>> which I didn't notice. Appologies to all for this.
>>
>> Last nights tests where done using the correct kernel (I fixed the 
>> grub typo) 2.6.15-g5367f2d6
>>
>> The details I have are as follows.
>>
>> I can run the machine accessing the 7 maxtor SATA disks as individual 
>> disks for around 12 hours now, without any hangs or errors or any 
>> real problems. I've not hit them very hard, but initial performance 
>> seems fine and more than usable.
>>
>> The actual problems occurr when including these disks in a raid group.
>>
>> root@berger:~# fdisk -l /dev/sdc
>>
>> Disk /dev/sdc: 251.0 GB, 251000193024 bytes
>> 255 heads, 63 sectors/track, 30515 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>>
>>   Device Boot      Start         End      Blocks   Id  System
>> /dev/sdc1               1       30515   245111706   fd  Linux raid 
>> autodetect
>>
>> root@berger:~# fdisk -l /dev/sde
>>
>> Disk /dev/sde: 251.0 GB, 251000193024 bytes
>> 255 heads, 63 sectors/track, 30515 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>>
>>   Device Boot      Start         End      Blocks   Id  System
>> /dev/sde1               1       30515   245111706   fd  Linux raid 
>> autodetect
>>
>>
>> As you can see from my two random disks examples, they are 
>> partitioned and makred as raid auto detect.
>>
>> I issue the mdadm command to build the raid 5 array
>>
>> mdadm -C /dev/md6 -l5 -n6 -x1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 
>> /dev/sdg1 /dev/sdh1 /dev/sdi1
>>
>> and the array starts to build.......
>>
>> md6 : active raid5 sdh1[7] sdi1[6](S) sdg1[4] sdf1[3] sde1[2] sdd1[1] 
>> sdc1[0]
>>      1225558080 blocks level 5, 64k chunk, algorithm 2 [6/5] [UUUUU_]
>>      [>....................]  recovery =  0.1% (374272/245111616) 
>> finish=337.8min speed=12073K/sec
>>
>>
>> however at around %25 - %40 completion the box will simpley just hang 
>> - I'm getting no on screen messages and the sylog is not reporting 
>> anything.
>>
>> SysRQ is unusable.
>>
>> I'm open to options on how to resolve this and move the driver 
>> forward (assuming it is the drivers interfaction with the raid sub 
>> system)
>> or
>> how to get some meaningful debug out to report back to the 
>> appropriate development groups.
>>
>> thanks.
>>
>> Matt.
>>
>>
>>
> Further further information
>
> The speed that the raid array is being built att appears to drop as 
> the array is created
>
> [=====>...............]  recovery = 29.2% (71633360/245111616) 
> finish=235.1min speed=12296K/sec
> [=====>...............]  recovery = 29.3% (71874512/245111616) 
> finish=235.2min speed=12269K/sec
> [=====>...............]  recovery = 29.4% (72115872/245111616) 
> finish=236.0min speed=12209K/sec
> [=====>...............]  recovery = 29.7% (72839648/245111616) 
> finish=237.4min speed=12091K/sec
> [=====>...............]  recovery = 29.8% (73078560/245111616) 
> finish=238.6min speed=12010K/sec
> [=====>...............]  recovery = 29.8% (73139424/245111616) 
> finish=350.5min speed=8176K/sec
> [=====>...............]  recovery = 29.8% (73139424/245111616) 
> finish=499.6min speed=5735K/sec
> [=====>...............]  recovery = 29.8% (73139776/245111616) 
> finish=691.0min speed=4147K/sec
>
> Now the box is hung
>
> I didn't notice this until about %20 through the creation of the array 
> then I started paying attention to this. These snap shots are taken 
> every 30 seconds
>
> So the problem appears to sap bandwidth on the card to the point there 
> the box hangs.
>
> This may have some relevance, or it may not, but worth mentioning at 
> least.
>
> Matt
>
>
>
First - a quick response to John Stoffels comments.

Both disks and controller on the latest Bios/firmware versions (thanks 
for making me point this out)

I created a much smaller array (3 disks 1 spare) today and again around 
%35 through the creation of the array the whole machine hung, no warning 
no errors no logging.
The speed parameter from /proc/mdstat stayed constant to around %30 
(which explained why I perhaps didn't notice this earlier) and like the 
creation of the large raid 5 array took a massive nose dive in speed 
over about 180 seconds to the point where the box hung.

Its almost as if there is an "IO leak" which is the only way I can think 
of to describe it.the card / system performaces quite well as individual 
disks, but as soon as its entered into a raid 5 configuration using the 
any number of disks the creation of the array appears to be fine until 
around %20-%30 through the assembly, the speed of the arrays creations 
plummits and the machine hangs.

I'm not too sure how to take this further as I get no warnings (other 
than the arrays creation time slowing) - I can't use any tools like 
netdump or sysRQ.

I'll try some additional raid tests (such as raid0 or raid1 across more 
disks) to see how that works. But as it stands I'm not sure how to get 
additional information.

thanks,

Matt







