From: Gene Heskett <gene.heskett@verizon.net>
Subject: Fwd: Re: md questions [forwarded from already sent mail]
Date: Sat, 24 Jan 2004 11:47:56 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401241147.56120.gene.heskett@verizon.net>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org, Jim Hines <jhines@wdtv.com>
List-Id: linux-raid.ids


Date: Saturday 24 January 2004 08:20
From: Maarten van den Berg <maarten@ultratux.net>
To: linux-raid@vger.kernel.org

>On Saturday 24 January 2004 11:31, you wrote:
>> On Saturday 24 January 2004 06:58, Maarten van den Berg wrote:
>> >On Saturday 24 January 2004 01:31, Gene Heskett wrote:
>> >> On Thursday 22 January 2004 19:28, Gene Heskett wrote:
>> >
>> >All of the above ;-) No seriously, it sounds like a problem with
>> > the hardware somewhere along the line. Can you test the array on
>> > the OLD motherboard, by just plugging everything in ?  Also, if
>> > you're using persistent superblocks and type=0xFD, messing with
>> > the order in which the drives are attached / recognized should
>> > not matter. It is confusing, but the array should nonetheless
>> > assemble itself perfectly. At least in my experience.
>>
>> How do we make sure the persistent superblocks are in use?  And the
>> 0xFD is I assume what fdisk would show us as the disk type?

>It's all in the manual. Yes, the partition type in fdisk.

>> Jim has been beating his head on this thing for a week.  Trying the
>> old mobo might be a possibility, but its boot drive would need
>> formatted and 7.2 re-installed and recompiled so md is builtin to
>> dup what we had before, or at least make a reasonable copy of it. 
>> What I'm trying to say is that we probably cannot recreate it
>> exactly. It was the boot drive, not the raid, that got trashed on
>> the other, older mobo.  I'm now confused as to whether the 4
>> 160Gb's in the raid array are new, or the same ones from 2 years
>> ago when we built the first one which had a 400mhz K6-II on it
>> IIRC, with 256 megs of dimms.  This one has a bit more horsepower
>> than that.

>No, no, NO.  I don't mean recreate the old setup with the old
> software. I mean use the exact same bootdrive as you're using now
> and the exact same setup ! It's linux, you know, not windows. You
> can, in most all cases, just change hardware without any changes.
> The exception being if you have a kernel that is optimized for a
> certain cpu. But even then, a new kernel is compiled easily, seen as
> you have already done that anyway.
>So the question is: what happens if you ONLY swap the motherboard but
> leave all else in place (controllers, disks and linux bootdrive)

I think Jim can do that Monday, if he hasn't already tried it.  I've 
not been personally present for much of this, its 30 miles up the 
interstate from the Peacefull Valley Rest Home, aka the Heskett 
Ranchette.

Jim, please send a subscribe linux-raid message to 
Majordomo@vger.kernel.org so this can become a bit less like heresay 
and more first person.

>P.S. I'd appreciate it if you reply to the list instead of to me
> directly.

>Maarten

For some reason a reply all isn't doing that and I have to change it 
manually which I've done here.  Hummm, no mention of the ml in the 
headers that I see here.  I see the quoting seems to be broken too so 
I'll fix that too, (kmail 1.6.0, kde-3.23-rc2, not quite ready for 
prime time... :)

-
To unsubscribe from this list: send the line "unsubscribe linux-raid"
 in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

Odd, this is here, but the header says its from you personally.
Maybe this will reset the headers?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty: soap,
ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
99.22% setiathome rank, not too shabby for a WV hillbilly
Yahoo.com attornies please note, additions to this message
by Gene Heskett are:
Copyright 2004 by Maurice Eugene Heskett, all rights reserved.
