From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Why do I need 4 disks for a raid6?
Date: Fri, 20 Mar 2009 11:20:42 +0100
Message-ID: <87r60sv6kl.fsf@frosties.localdomain>
References: <87ljr4hsk9.fsf@frosties.localdomain>
	<18882.54987.332211.49180@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18882.54987.332211.49180@notabene.brown> (Neil Brown's message
	of "Fri, 20 Mar 2009 10:35:39 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> In 2.6.30 and later you wont even need the downtime.  Just
>   echo raid5 > /sys/block/md9/md/level
> in place of the "stop" and "create" steps.

Hurray. It is great to see the raid driver improving all the
time. Great work all of you.
 
>> Now for the raid6 case. With only 1 data disk and 2 parity disks all 3
>> disks should end up with identical data on them. In effect this should
>> be a 3 disk raid1, a cpu intensive one. Take an existing raid1 with 2
>> or 3 disks, stop the raid, create a new raid6 ovver it with
>> --assume-clean, start the raid. After that one can add more disks and
>> --grow -n 4/5/6/.. the raid6 to a sensible size. Again without going
>> into degraded mode.
>> 
>> 
>> So back to my original question: Why does the kernel require 4 disks
>> for a raid6 instead of allowing 3?
>
> I have occasionally wondered that.  But I didn't write that code and
> never saw a need to change it.  As Andre says, it is very likely that
> just relaxing the restriction will allow it to "just work".
>
> Maybe that will happen in 2.6.31...
>
> NeilBrown

Time for try&error. I only checked one raid6 algorithm but that seemed
to be fine with 3 disks.

MfG
        Goswin
