From: berk walker <berk.walker@verizon.net>
Subject: Re: Fwd: RAID5 on different sized disks on low-end machine
Date: Fri, 14 Jan 2005 18:20:12 -0500
Message-ID: <41E853AC.4050007@verizon.net>
References: <eaa6dfe050111104772af6240@mail.gmail.com>	 <eaa6dfe050111111465c7e5b1@mail.gmail.com>	 <cs1qqb$98l$1@sea.gmane.org>	 <eaa6dfe05011206366059173a@mail.gmail.com>	 <41E78C6C.2080701@chemie.uni-erlangen.de> <cs85j1$uuf$2@sea.gmane.org>	 <eaa6dfe05011411048ad3d4@mail.gmail.com> <eaa6dfe050114110518a963f1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eaa6dfe050114110518a963f1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Derek Piper <derek.piper@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you have an AGP slot, dump the pci vga, eh?
b-

Derek Piper wrote:

>Hi all,
>
>Yes, I did notice that I would be doing the master/slave thing and
>went and read to the FAQ about it (omg! he reads?!). I actually set up
>(well, am in the process of setting up) the machine to use it's older
>ATA33 ports of hda and hdc. I was going to post my revision of idea to
>the list but forgot. Thanks for responding to it though! :)
>
>I would get another promise card, but since I need two NICs in this
>machine (Dual PPro W6LI board) and the VGA card (PCI), all PCI slots
>are used.
>
>I went with this layout in the end:
>
>/dev/hde,/dev/hdg,/dev/hdc = 60000MB
>/dev/hda = 80000MB
>Pair1 = /dev/hde, /dev/hdg on the Promise Ultra TX2 (bootable, ATA100,
>boots to large drives)
>Pair2 = /dev/hda, /dev/hdc on the motherboard IDE controllers (ATA33
>and BIOS cannot boot to large drives)
>
>/dev/hd*1       32      RAID1   0.03    /boot   /dev/md1        32    
> 0.03    Pair1
>/dev/hd*2       768     RAID1   0.75    Swap    /dev/md0        768   
> 0.75    Pair1
>/dev/hd*5       1760    RAID1   1.72    /       /dev/md2        1760  
> 1.72    Pair1
>
>/dev/hd*5       2560    RAID1   2.5     /usr    /dev/md3        2560  
> 2.5     Pair2
>
>/dev/hd*6       57462   RAID5   56.12   /mnt/array      /dev/md4      
> 172386  168.35  (all)
>/dev/hda7       20663   (non-raid)      20.18
>
>One thing though, since I'm posting to the list...
>
>I have the machine able to boot from RAID, and the filesystem is
>copied to the above assigned md devices. I added the initial
>installation drive (happened to be /dev/hde) and to the md4 array to
>complete the RAID5. All RAID5 component partitions are the exact same
>block size according to fdisk -l , so at least partitioning the larger
>disk was okay.
>
>The problem is now that during the course of the re-sync (it added hde
>in as 'spare', is that normal?) it tells me that /dev/hdc has 'failed'
>and decides to kick it out. That's a bit worrysome, since what happens
>if there was data on that array? Does that tend to happen? Is RAID5
>REALLY that unreliable? Jokes about p0rn and replacable data aside,
>should we really be trusting valuable data to it? What are the
>opinions out there?
>
>I'm wondering about just saying 'screw it' to RAID5 and doing two
>RAID1 mirrors with the partitions instead since it's data I really do
>not want to lose that would be going on there. I've never had any
>problems with any of the HDs, even hdc, so it's quite surprising it
>would barf like that. The kernel didn't give any messages and I've
>since rebooted. I was tinkering with it from work during my lunch
>break, getting the RAID arrays created and booting from RAID, but now
>after rebooting it's not come back so that I can log into it again. I
>guess I'll see what it's complaining about this evening :>
>
>Derek
>
>On Fri, 14 Jan 2005 10:07:03 +0000, Robin Bowes
><robin-lists@robinbowes.com> wrote:
>  
>
>>Norman Schmidt wrote:
>>    
>>
>>>Hi Derek!
>>>
>>>What worries me a little bit about your setup is that you seem to want
>>>to put the drives as master and slave on each of the two busses of the
>>>ata controller.
>>>      
>>>
>>Ah, I missed that. Yes, that's definitely not a good idea. Get yourself
>>another controller card and stick to one disk per ATA channel.
>>
>>R.
>>--
>>http://robinbowes.com
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>    
>>
>
>  
>

