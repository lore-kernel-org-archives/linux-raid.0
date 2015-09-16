From: Alex <mysqlstudent@gmail.com>
Subject: Re: Recommendations for RAID setup needed
Date: Wed, 16 Sep 2015 11:53:31 -0400
Message-ID: <CAB1R3siXjNdihbJhzSWL7bbLGuj0SD7a9iA2wKs-C2dKAO6u0Q@mail.gmail.com>
References: <CAB1R3sjKb-aXJV+4E5t6OsWid4QB+r6aCteZt+F+57=cWLhHWw@mail.gmail.com>
	<55F85E9F.1070100@youngman.org.uk>
	<CAB1R3sj3fA3rJA+hQRJcTvL6HmNium+T2RRfdvF9YhpLA=q2Vg@mail.gmail.com>
	<55F8D01C.5040106@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55F8D01C.5040106@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

>>> What disks are you using? Are they proper raid disks? A 12TB array can
>>> have a soft read error every complete pass, and still be within the
>>> disk-manufacturer's specs. If your disks are not raid-compliant, this
>>> will stop your array from rebuilding, ever!
>>
>> All four are WD30EFRX-68EUZN0. They're not the cheapest WD disks, but
>> they're also not the ones with the 5yr warranty. The last array I
>> built using disks with 5yr warranty exceeded their capacity before the
>> warranty expired.
>
> Umm, 1st google result showed this:
> http://community.wd.com/t5/Desktop-Mobile-Drives/New-WD30EFRX-Red-Drive-Idle3-Timer-Set-to-8-Seconds-High-LCC-in/td-p/648821/page/5

I was really just looking for general input on RAID5 vs RAID6, but
that is good information. I knew the drives weren't basic desktop
drives and would be generally suitable for building a software RAID
array.

Are you familiar with the idle3 time? It appears the idle3-tools can
be used to disable the idle3 timer entirely, which would disable
parking the head at all, correct?

> You might want to verify that setting before using in production, and
> probably a quick search/read on any other issues.

Perhaps I should have posted here prior to ordering the drives. Do you
have any recommendations for 3TB SATA disks I should have used?

> That depends on your requirements. What are the implications (for you) if
> all the data is lost because two drives failed close to the same time? Is
> that resulting cost more or less than getting a fourth drive and using
> RAID6?

I was hoping for some kind of emphatic NO, that it's a really bad
idea. I'll consider it further, but probably choose RAID6 then anyway.

> Take a look at BackupPC (on sourceforge). It is a "perl script" that uses
> rsync plus hardlinks, but also does a whole lot more. It has worked very
> well for me for a number of years.

Okay, great.

> Personally, I'm also still waiting for a more "stable" version of btrfs or
> equivalent which can do block level de-dupe.

Awesome, thanks.
Alex
