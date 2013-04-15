From: Ben Bucksch <linux.news@bucksch.org>
Subject: Re: md RAID5: Disk wrongly marked "spare", need to force re-add it
Date: Mon, 15 Apr 2013 03:34:04 +0200
Message-ID: <516B590C.5060807@bucksch.org>
References: <516869D2.9030506@bucksch.org> <516B3077.9020507@schinagl.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516B3077.9020507@schinagl.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey Oliver,

first off: thanks for trying to help me.

Oliver Schinagl wrote, On 15.04.2013 00:40:
> Firstly, have you written anything TOO the array while resyncing? If 
> not, chances are your array is in a reasonable shape still.

I did write to the array (in fact, I did a bonnie++, which in 
retrospective is very stupid, and I'm upset I did it, but hindsight is 
20/20 - I assumed the array was fine at that time), BUT if you look at 
the "event count" of each drive, the sdl marked "spare" has an event 
count just 2 lower then all the others, so they are very close.

> Now check the event count for all your drivers and compare. If the 
> 'broken' drive is only a few off (1 or 2 I think i spotted below, try 
> the following) 

Exactly.

> The 'spare' drive, I don't know what its status is.

According to SMART, it's just fine. Its event status is very close to 
the others.

> Theoretically, I would assume that the resync the data written to the 
> disk is exactly the same as it was before, so keep that in mind as a 
> last resort.

Yes, that's my plan. My question is: HOW can I tell mdadm to use it?

> mdadm --run --force -A /dev/md0 /dev/sd...

I've tried that, and it tells me the array can't be started, because I 
have RAID 5 with 8 drives (in normal situation), 6 good drives, and 2 
spares (1 working fine, 1 with hardware failure). So, after this 
command, I end up in "inactive" operation mode.

> Now the broken drive. Check your cables!! and run smartctl on it to 
> give smart a chance to 'fix' the drive somewhat and check its 
> status/health. ...
> If it fails again (at 80% because of hardware failure) you can't 
> re-use the broken disk. It really is broken :p

It failed twice during resync, at around the same point, and smartctl 
tells me it's broken, so I assume it's gone for good. (Also, the failed 
drive is also marked as "spare" currently.)

> your very last hope, is to not use the broken drive, and 'force' the 
> above using the earlier marked spare.

How? I haven't managed to do that, that's my whole question.

