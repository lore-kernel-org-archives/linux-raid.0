From: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: Re: Help, array corrupted after clean shutdown.
Date: Sat, 06 Apr 2013 14:04:42 +0200
Message-ID: <51600F5A.3010607@schinagl.nl>
References: <5160060B.8020603@schinagl.nl> <alpine.DEB.2.00.1304061354170.23668@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1304061354170.23668@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/06/13 13:58, Mikael Abrahamsson wrote:
> On Sat, 6 Apr 2013, Oliver Schinagl wrote:
>
>> All that said when I did the assemble with the 'guessed' 3 correct
>> drives. Did of course increase the events count. sdc1 of course didn't
>> partake in this. Assuming that it is in sync with the rest, what is
>> the worst that can happen? And does the --read-only flag protect
>> against it?
>
>> /dev/sdc1:
>>    Update Time : Sat Mar 16 20:20:47 2013
>>       Checksum : a7686a57 - correct
>>         Events : 180132
>
> As you probably already know, using sdc1 will mean you'll be playing
> with part of the array that is out of date by 3 weeks (this update time
> indicates that sdc1 fell out on Mar 16).
>
> So I would definitely stay away from sdc1. It seems you have made a lot
> of changes lately (your create time is in 2010 and on Mar 16 2013 you
> were up to 180k events, and then now three weeks later the rest of the
> drives are at 513k events, that seems like a of writes has been done to
> the array the past tree weeks?).
>
> So sdc1 is definitely not in sync according to this information. Using
> it is risky, but as a last resort, sure.
>
While I agree with your findings, I seriously doubt that it did actually 
fall out of the array. Logs do not indicate this fact and I'm not so 
sure there was a huge difference in activity since mar 16th.

Though I will admit I have been cloing, checkout/in a lot of git repo's 
so that could increase this of course, but 3x more then its entire lifetime?

Anyway, last resort sounds where this will be heading, I'm scare of 
running fsck on the array, fixing things and then still have something 
unusable, and even the last resort method not working. So is this all 
doable, in read-only mode. And what are the chances of accessing certain 
data even when doing so?
