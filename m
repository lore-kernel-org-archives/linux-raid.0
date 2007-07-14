From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: how to deal with continuously getting more errors?
Date: Sat, 14 Jul 2007 17:03:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0707141702130.17019@p34.internal.lan>
References: <98d279bf0707141115m14308e64s50f6517b2e1aef5c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <98d279bf0707141115m14308e64s50f6517b2e1aef5c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jeff stern <jas.61803+lr@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 14 Jul 2007, jeff stern wrote:

> hi, everyone..  i have a problem.
>
> SUMMARY
>
> i've got a linux software RAID1 setup, with 2 SATA drives (/dev/sdf1,
> /dev/sdg1) set up to be /dev/md0. these 2 drives together hold my
> /home directories. the / and / partitions are on another drive, a
> standard parallel IDE (/dev/hda). (I can provide more hardware
> information if someone needs it).
>
> the problem is that new errors (mismatch_cnt discrepancies) between
> the two disks keep coming up. weekly. even daily, and i dont know what
> to do, or how to handle it.
>
> How many mismatch_cnts between two almost-new drives running in a
> healthy RAID1 array should one expect in a year? in a month? a day?
>
> And more importantly, What do i do now?
>
> EXTENDED DESCRIPTION OF PROBLEM
>
> i first noticed this problem when i downloaded the fedora core 7 .iso,
> and did a checksum on it, and it didn't match. with a little more
> investigating, i found that i could make a copy of any large file on
> disk, and its copy would sometimes match, sometimes not.
>
> here is a typical session:
> ------------------------------------------------------------------------------------------
> $ cp F-7-i386-DVD.iso F.iso
> $ cmp F-7-i386-DVD.iso F.iso
> F-7-i386-DVD.iso F.iso differ: byte 1033827385, line 3789612
> $ cmp F-7-i386-DVD.iso F.iso
> $ cmp F-7-i386-DVD.iso F.iso
> F-7-i386-DVD.iso F.iso differ: byte 1033827385, line 3789612
> $ cmp F-7-i386-DVD.iso F.iso
> F-7-i386-DVD.iso F.iso differ: byte 8870221, line 37265
> $ cmp F-7-i386-DVD.iso F.iso
> F-7-i386-DVD.iso F.iso differ: byte 8870221, line 37265
> $ _
> ------------------------------------------------------------------------------------------


Something sounds very strange here, I have a script that runs the 'check' 
once a week for my RAID1 partitions and it is generally 0 every time, 
except for the swap parition (occasionally)- which Neil has mentioned-- is 
normal.  You bringup a lot of good points though; however, I am not sure 
why you are experiencing so many mismatches.....

Justin.
