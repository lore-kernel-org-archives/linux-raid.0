From: Michael Stumpf <mjstumpf@pobox.com>
Subject: Re: 2 drive dropout (and raid 5), simultaneous, after 3 years
Date: Thu, 09 Dec 2004 11:22:26 -0600
Message-ID: <41B889D2.2070808@pobox.com>
References: <200412091642.iB9Ggv918601@www.watkins-home.com>
Reply-To: mjstumpf@pobox.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412091642.iB9Ggv918601@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ahhhhhhh.. You're on to something here.  In all my years of ghetto raid 
one of the weakest things I've seen is the Y-molex-power-splitters.  Do 
you know where more solid ones can be found?  I'm to the point where I'd 
pay $10 or more for the bloody things if they didnt blink the power 
connection when moved a little bit.

I'll bet good money this is what happened.  Maybe I need to break out 
the soldering iron, but that's kind of an ugly, proprietary, and slow 
solution.



Guy wrote:

>Since they both went off line at the same time, check the power cables.  Do
>they share a common power cable, or doe each have a unique cable directly
>from the power supply.
>
>Switch power connections with another drive to see if the problem stays with
>the power connection.
>
>Guy
>
>-----Original Message-----
>From: linux-raid-owner@vger.kernel.org
>[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Michael Stumpf
>Sent: Thursday, December 09, 2004 9:45 AM
>To: Guy; linux-raid@vger.kernel.org
>Subject: Re: 2 drive dropout (and raid 5), simultaneous, after 3 years
>
>All I see is this:
>
>Apr 14 22:03:56 drown kernel: scsi: device set offline - not ready or 
>command retry failed after host reset: host 1 channel 0 id 2 lun 0
>Apr 14 22:03:56 drown kernel: scsi: device set offline - not ready or 
>command retry failed after host reset: host 1 channel 0 id 3 lun 0
>Apr 14 22:03:56 drown kernel: md: updating md1 RAID superblock on device
>Apr 14 22:03:56 drown kernel: md: (skipping faulty sdj1 )
>Apr 14 22:03:56 drown kernel: md: (skipping faulty sdi1 )
>Apr 14 22:03:56 drown kernel: md: sdh1 [events: 000000b5]<6>(write) 
>sdh1's sb offset: 117186944
>Apr 14 22:03:56 drown kernel: md: sdg1 [events: 000000b5]<6>(write) 
>sdg1's sb offset: 117186944
>Apr 14 22:03:56 drown kernel: md: recovery thread got woken up ...
>Apr 14 22:03:56 drown kernel: md: recovery thread finished ...
>
>What the heck could that be?  Can that possibly be related to the fact 
>that there weren't proper block device nodes sitting in the filesystem?!
>
>I already ran WD's wonky tool to fix their "DMA timeout" problem, and 
>one of the drives is a maxtor.  They're on separate ATA cables, and I've 
>got about 5 drives per power supply.  I checked heat, and it wasn't very 
>high.
>
>Any other sources of information I could tap?  Maybe an "MD debug" 
>setting in the kernel with a recompile?
>
>Guy wrote:
>
>  
>
>>You should have some sort of md error in your logs.  Try this command:
>>grep "md:" /var/log/messages*|more
>>
>>Yes, they don't play well together, so separate them!  :)
>>
>>Guy
>>
>>-----Original Message-----
>>From: linux-raid-owner@vger.kernel.org
>>[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Michael Stumpf
>>Sent: Wednesday, December 08, 2004 11:46 PM
>>To: linux-raid@vger.kernel.org
>>Subject: Re: 2 drive dropout (and raid 5), simultaneous, after 3 years
>>
>>No idea what failure is occuring.  Your dd test, run from begin to end 
>>of each drive, completed fine.  Smartd had no info to report.
>>
>>The fdisk weirdness was operator error; the /dev/sd* block nodes were 
>>missing (forgotten detail on age old upgrade).  Fixed with mknod.
>>
>>So, I forced mdadm to assemble and it is reconstructing now.  
>>Troublesome, though, that 2 drives fail at once like this.  I think I 
>>should separate them to different raid-5s, just incase.
>>
>>
>>
>>Guy wrote:
>>
>> 
>>
>>    
>>
>>>What failure are you getting?  I assume a read error.  md will fail a
>>>      
>>>
>drive
>  
>
>>>when it gets a read error from the drive.  It is "normal" to have a read
>>>error once in a while, but more than 1 a year may indicate a drive going
>>>bad.
>>>
>>>I test my drives with this command:
>>>dd if=/dev/hdi of=/dev/null bs=64k
>>>
>>>You may look into using "smartd".  It monitors and tests disks for
>>>   
>>>
>>>      
>>>
>>problems.
>> 
>>
>>    
>>
>>>However, my dd test finds them first.  smartd has never told me anything
>>>useful, but my drives are old, and are not smart enough for smartd.
>>>
>>>Guy
>>>
>>>-----Original Message-----
>>>From: linux-raid-owner@vger.kernel.org
>>>[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Michael Stumpf
>>>Sent: Wednesday, December 08, 2004 4:03 PM
>>>To: linux-raid@vger.kernel.org
>>>Subject: 2 drive dropout (and raid 5), simultaneous, after 3 years
>>>
>>>
>>>I've got a an LVM cobbled together of 2 RAID-5 md's.  For the longest 
>>>time I was running with 3 promise cards and surviving everything 
>>>including the occasional drive failure, then suddenly I had double drive 
>>>dropouts and the array would go into a degraded state.
>>>
>>>10 drives in the system, Linux 2.4.22, Slackware 9, mdadm v1.2.0 (13 mar 
>>>2003)
>>>
>>>I started to diagnose; fdisk -l /dev/hdi  returned nothing for the two 
>>>failed drives, but "dmesg" reports that the drives are happy, and that 
>>>the md would have been automounted if not for a mismatch on the event 
>>>counters (of the 2 failed drives).
>>>
>>>I assumed that this had something to do with my semi-nonstandard 
>>>application of a zillion (3) promise cards in 1 system, but I never had 
>>>this problem before.  I ripped out the promise cards and stuck in 3ware 
>>>5700s, cleaning it up a bit and also putting a single drive per ATA 
>>>channel.  Two weeks later, the same problem crops up again.
>>>
>>>The "problematic" drives are even mixed; 1 is WD, 1 is Maxtor (both
>>>   
>>>
>>>      
>>>
>>120gig).
>> 
>>
>>    
>>
>>>Is this a known bug in 2.4.22 or mdadm 1.2.0?  Suggestions?
>>>
>>>
>>>--------------------------------------------
>>>My mailbox is spam-free with ChoiceMail, the leader in personal and
>>>corporate anti-spam solutions. Download your free copy of ChoiceMail from
>>>www.choicemailfree.com
>>>
>>>-
>>>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>the body of a message to majordomo@vger.kernel.org
>>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>-
>>>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>the body of a message to majordomo@vger.kernel.org
>>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>>
>>>   
>>>
>>>      
>>>
>>--------------------------------------------
>>My mailbox is spam-free with ChoiceMail, the leader in personal and
>>corporate anti-spam solutions. Download your free copy of ChoiceMail from
>>www.choicemailfree.com
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>> 
>>
>>    
>>
>
>
>--------------------------------------------
>My mailbox is spam-free with ChoiceMail, the leader in personal and
>corporate anti-spam solutions. Download your free copy of ChoiceMail from
>www.choicemailfree.com
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>  
>


--------------------------------------------
My mailbox is spam-free with ChoiceMail, the leader in personal and corporate anti-spam solutions. Download your free copy of ChoiceMail from www.choicemailfree.com

