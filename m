From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: Raid 6 - TLER/CCTL/ERC
Date: Fri, 08 Oct 2010 07:47:25 +0200
Message-ID: <4CAEB06D.4040007@stud.tu-ilmenau.de>
References: <3870309.421286406668656.JavaMail.SYSTEM@ninja>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3870309.421286406668656.JavaMail.SYSTEM@ninja>
Sender: linux-raid-owner@vger.kernel.org
To: Lemur Kryptering <gottail@lemurdude.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, philip@turmel.org
List-Id: linux-raid.ids

Am 07.10.2010 01:11, schrieb Lemur Kryptering:
> 
> [...]
> 
> That sounds exactly like what I'm seeing in the logs -- the sector initially reported as bad is indeed unreadable via dd. All of the subsequent problems reported in other sectors aren't actually problems when I check on them at a later point. Couldn't this be worked around by exposing whatever timeouts there are in mdraid to something that could be adjusted in /sys?
> 
>>
>> There's nothing you can do about this viscious circle except either
>> enabling ERC or using Raid-Edition disk (which have ERC enabled by
>> default).

I must say yesterday we had our first Hitachi UltraStar Drives - which
are supposed to be Raid-Edition.  They didn't have ERC enabled.  I'll
inquire Hitachi about that today.
>>
> 
> I tried connecting the drives directly to my motherboard (my controller didn't seem to want to let me pass the smart commands ERC commands to the drives). The ERC commands took, in so far as I was able to read them back with what I set them to. This didn't seem to help much with the issues I was having, however.

Which wouldn't work, as the SCT ERC settings are volatile.  I.e.:
they're gone after a power cycle.

> 
> Lesson-learned on the non-raid edition disks. I would have spent the extra to avoid all this headache, but am now stuck with these things. I realize that not fixing the problem at the core (the drives themselves), essentially puts the burden on mdraid (which would be forced to block for a ridiculous amount of time waiting for the drive instead of just kicking it), however, in my particular case, this sort of delay would not be a cause for concern.
> 
> Would someone be able to nudge me in the right direction as far as where the logic that handles this is located?
> 
>> [...]
>>> #!/bin/bash
>>> #
>>> for x in /sys/block/md*/md/sync_action ; do
>>>         echo repair >$x
>>> done
>>>[...]

That is probably the only thing you can try.  As this does indeed try to
reconstruct the sector from the redundancy.  But I'd try it with ERC
enabled.  Maybe you find a way where this works.  (i.e. move the whole
Raid to the other computer...)

Stefan
