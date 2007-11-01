From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Requesting migrate device options for raid5/6
Date: Thu, 01 Nov 2007 10:51:55 -0400
Message-ID: <4729E80B.5010707@tmr.com>
References: <87hck9c2qg.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87hck9c2qg.fsf@informatik.uni-tuebingen.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> Hi,
>
> I would welcome if someone could work on a new feature for raid5/6
> that would allow replacing a disk in a raid5/6 with a new one without
> having to degrade the array.
>
> Consider the following situation:
>
> raid5 md0 : sda sdb sdc
>
> Now sda gives a "SMART - failure iminent" warning and you want to
> repalce it with sdd.
>
> % mdadm --fail /dev/md0 /dev/sda
> % mdadm --remove /dev/md0 /dev/sda
> % mdadm --add /dev/md0 /dev/sdd
>
> Further consider that drive sdb will give an I/O error during resync
> of the array or fail completly. The array is in degraded mode so you
> experience data loss.
>
>   
That's a two drive failure, so you will lose data.
> But that is completly avoidable and some hardware raids support disk
> migration too. Loosly speaking the kernel should do the following:
>
>   
No, it's not "completly avoidable" because have described sda is ready 
to fail and sdb as "will give an I/O error" so if both happen at once 
you will lose data because you have no valid copy. That said, some of 
what you describe below is possible to *reduce* the probability of 
failure. But if sdb is going to have i/o errors, you really need to 
replace two drive :-(
See below for some thoughts.
> raid5 md0 : sda sdb sdc
> -> create internal raid1 or dm-mirror
> raid1 mdT : sda
> raid5 md0 : mdT sdb sdc
> -> hot add sdd to mdT
> raid1 mdT : sda sdd
> raid5 md0 : mdT sdb sdc
> -> resync and then drop sda
> raid1 mdT : sdd
> raid5 md0 : mdT sdb sdc
> -> remove internal mirror
> raid5 md0 : sdd sdb sdc 
>
>
> Thoughts?
>   

If there were a "migrate" option, it might work something like this:
Given a migrate from sda to sdd, as you noted and raid1 between sda and 
sdd needs to be created, and obviously all chunks of sdd need to be 
marked as needing rebuild, but in addition sda needs to be made 
read-only, to minimize the i/o and to prevent any errors which might 
come from a failed write, like failed sector relocates, etc. Also, if 
valid data for a chunk is on sdd, no read would be done to sda. I think 
there's relevant code in the "write-mostly" bits to implement keep i/o 
to sda to a minimum, no writes and only mandatory reads when no valid 
chunk is on sdd yet. This is similar to recovery to a spare, save that 
most data will be valid on the failing drive and doesn't need to be 
recreated, only unreadable data must be done the slow way.

Care is needed for sda as well, so that if sdd fails during migrate, a 
last chance attempt to bring sda back to useful content can be made, I'm 
paranoid that way.

Assuming the migrate works correctly, sda is removed from the array, and 
the superblock should be marked to reflect that. Now sdd is a part of 
the array, and assemble, at least using UUID, should work.

I personally think that a migrate capability would be vastly useful, 
both for handling failing drives and just moving data to a better place. 
As you point out, the user commands are not *quite* as robust as an 
internal implementation could be, and are complex enough to invite user 
error. I certainly always write down steps before doing migrate, and if 
possible do it with the system booted from a rescue media.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

