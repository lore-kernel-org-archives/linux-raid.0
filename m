From: starlight.2012q4@binnacle.cx
Subject: Re: question: no-bitmap RAID1 with off-site drive
Date: Mon, 12 Nov 2012 15:40:36 -0500
Message-ID: <6.2.5.6.2.20121112153741.039df248@binnacle.cx>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
 <6.2.5.6.2.20121112122534.05dfec78@binnacle.cx>
 <6.2.5.6.2.20121112131017.05df8b18@binnacle.cx>
 <20121113073119.27f1a1db@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121113073119.27f1a1db@notabene.brown>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
 <6.2.5.6.2.20121112122534.05dfec78@binnacle.cx>
 <6.2.5.6.2.20121112131017.05df8b18@binnacle.cx>
 <20121113073119.27f1a1db@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you!  Still working to wrap my brain
around 'md'.  Will stick with the first
approach.

Amusingly I performed it by accident,
was confused and frustrated by result,
then eventually realized it was ideal.




At 07:31 AM 11/13/2012 +1100, NeilBrown wrote:
>On Mon, 12 Nov 2012 13:11:50 -0500 starlight.2012q4@binnacle.cx 
>wrote:
>
>> Probably this is more elegant:
>> 
>>    mdadm --create --level=1 --raid-devices=2 --spare-devices=1 
>/dev/sdd /dev/sde missing
>
>That is fairly meaningless ... I'm not sure it even works.
>
>While it makes sense for raid devices to be missing, it doesn't
>make sense for spares to be missing.  Spares are just
>any devices in the array which aren't active.  If they
>are missing, then they aren't spare.
>
>NeilBrown
>
>
>> 
>> At 12:26 PM 11/12/2012 -0500, starlight.2012q4@binnacle.cx 
>wrote:
>> >After some pondering, think I've figure it out.
>> >
>> >Best way to go is to set it up with
>> >
>> >  --create --level=1 --raid-devices=2
>> >
>> >for the initial pair of drives, then
>> >
>> >  --fail --remove
>> >
>> >the rotate-out drive, then
>> >
>> >  --add
>> >
>> >the alternate drive.  Now there will be
>> >three drive slots with one "removed" and two
>> >"active".
>> 
>> --
>
>

