From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: RAID5 reshape problems
Date: Wed, 25 Mar 2009 23:43:47 +0100
Message-ID: <49CAB3A3.7020807@xunil.at>
References: <49CA787C.2090100@xunil.at> <18890.44146.95223.103114@notabene.brown>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18890.44146.95223.103114@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown schrieb:

>> "mdadm -D" doesn't give me answers.
> 
> Must be some sort of deadlock....

Yes ...

your suggested ps-command showed numerous instances of hanging
smbd-processes, cronjobs etc.

I feel a bit ashamed to not have taken more daemons offline for doing
that ... but I couldn't foresee the fact that the hotplug-tray would be
full of dust and that the owner of the box wouldn't see that ...

It is very likely that the disk is OK itself, just the connection might
have been too dirty!

>>           State : active
>>  Active Devices : 5
>> Working Devices : 5
>>  Failed Devices : 1
>>   Spare Devices : 0
>>        Checksum : 65f12171 - correct
>>          Events : 0.8247
>>
>>          Layout : left-symmetric
>>      Chunk Size : 64K
>>
>>       Number   Major   Minor   RaidDevice State
>> this     0       8        4        0      active sync   /dev/sda4
>>
>>    0     0       8        4        0      active sync   /dev/sda4
>>    1     1       8       20        1      active sync   /dev/sdb4
>>    2     2       8       36        2      active sync   /dev/sdc4
>>    3     3       8       52        3      active sync   /dev/sdd4
>>    4     4       0        0        4      faulty removed
>>    5     5       8       68        5      active sync   /dev/sde4
>>
> 
> This looks good.  The devices knows that it is in the middle of a
> reshape, and knows how far along it is.  After a reboot it should just
> pick up where it left off.

Sounds gooood ...

> The raid is OK.  It is, of course, degraded now and if another device
> fails you will lose data.  Reboot should be perfectly safe.  However
> you might need to re-assemble the array using the "--force" flag.
> This is safe.
> The reshape didn't finish.  It is only up to 
>>   Reshape pos'n : 61125760 (58.29 GiB 62.59 GB)

ok ... thanks for your feedback, thanks a lot.

Sorry that I called it a "problematic RAID5" ... your code seems not to
be the problem here :-)

I try a remote reboot, I am more than 100 kms away from that server.

It seems to take forever now to reboot, I can still ping it while ssh
doesn't work anymore.

Might take till tomorrow when the owner comes to office again that he
will be able to reboot the box via console.

At least I am somehow more confident now that we won't lose data.

I avoid thinking of having to re-add that /dev/sdf again, and the
pvresize is also still ahead of me.

*sigh*

;-)

Thanks again, Stefan

