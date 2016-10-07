From: Phil Turmel <philip@turmel.org>
Subject: Re: Why not just return an error?
Date: Fri, 7 Oct 2016 12:52:06 -0400
Message-ID: <94b1a4f4-adec-90b7-e804-2d8d2c94a7af@turmel.org>
References: <57F6DF18.40703@yandex.ru> <20161007112151.GA4405@metamorpher.de>
 <e887908f-ba51-0f88-f891-f60e8bac50bd@turmel.org>
 <57F7CC10.3050607@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57F7CC10.3050607@yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Dark Penguin <darkpenguin@yandex.ru>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, keld@keldix.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi DP,

{It's good that you are trimming replies, but don't cut the ID of who
wrote what. }

On 10/07/2016 12:23 PM, Dark Penguin wrote:
>> Likewise, when the first disk fails, one could mark it as kind of in
>> an error state,
>> and keep it running, and if one gets a read error, then you could get
>> the data from the good disks.
> 
> Yes!! If a drive is "faulty", it means "you should replace it because it
> is failing"; there is no need to actually stop using it and degrade the
> whole RAID operation! What's more, it would be extremely useful at
> rebuilding without any performance loss: let the array work in degraded
> mode, while the faulty drive is being copied to the new one, with only
> read errors reconstructed from the rest of the drives! But that's a
> different issue, and not a very good idea for other reasons.

MD raid already does as much of this as it can, as I described.

>> One big reason is human behaviour. And it is human behaviour that in the
>> end causes all the collapsed raids.
> 
> "Human behaviour", that's what I'm talking about. If the only reason to
> do it is to force people to do what is necessary, that approach is
> called "Windows". :) And I do not suggest that it should be the default
> behaviour; instead, we should have an option "--idiotmode
> --yes-i-know-what-i-am-doing" at RAID creation for those who
> specifically want to take the risks.
> 
> And of course, no broken files will appear if we suffer from read
> *errors*. We do not suffer from *incorrect reads*, right?..

You want to push the failure condition from being "broken raid with
likely salvageable data, except for one sector" to "repeated errors to
the upper layers with unknowable corruption as side effects".

>> You make it sound like it solves all problems, but it does not.
>> Errors are just not part of the concept anywhere really.
> 
> It does not "solve all problems", but it lets me solve my problems my
> way, and not "the only correct and intended way" - which is what Linux
> is good at. :)

Then patch your kernel with your desired behavior.  "Free software"
doesn't mean someone writes what you want for free.  And I disagree with
you, so would object to it being put in the mainline kernel.

>>> > I believe this is the dream of everyone who had ever dealt with RAIDs.
>>
>> My dream is different. I don't want errors. I want it to work. ;)
>> And it does, as long as you make sure your disks are healthy.
> 
> I do not suggest that we do it my way and not yours - we have an option
> to do it your way, but we do not have one to do it my way, that's the
> problem. :)

Write the code to add the option you want.

> Anyway, if I had a collapsed RAID-5, I would want to at least have an
> easy option to start it in a read-only mode in the last-known working
> state, while the faulty drives are still not out of sync, and recover
> data easily (to my single backup drive), or continue using the array for
> a while, manually deleting one "bad" file if necessary; this is of
> course not a "good thing" to do, but this way, RAID would be at least
> not worse than single drives with faulty sectors, which are capable of
> that, while RAIDs are not! I would be fine with that in my archive - as
> I'm fine with some less importand parts of the archive being on faulty
> single drives. It's just that I don't want to lose the whole drive due
> to a hardware failure - and RAID adds more causes other than that,
> instead of offering more protection against that.

MD raid has no idea what is at any given sector.  And with a
near-infinite variety of layering choices, there's no way it's going to.
 That's why *you* have to do this.  You trimmed my description of the
only "easy option" actually trustable.

> It's just that everyone has their own opinion on where to draw the line,
> and the "intended" one should of course be preached, but not forced!

The "line" I was referring to is the decision of when to throw away a
drive vs. recondition it.  That's already in your hands.

Phil
