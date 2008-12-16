From: "Max Waterman" <davidmaxwaterman@fastmail.co.uk>
Subject: Re: upgrade advice
Date: Tue, 16 Dec 2008 15:04:43 +0200
Message-ID: <d5fe39840812160504q1b7f9a64k24eb9d19a3c8f4fd@mail.gmail.com>
References: <d5fe39840812160310t45e822c1geb633f805cf5388e@mail.gmail.com>
	 <alpine.DEB.1.10.0812160641130.725@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812160641130.725@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2008/12/16 Justin Piszcz <jpiszcz@lucidpixels.com>:
>
>
> On Tue, 16 Dec 2008, Max Waterman wrote:
>
>> Hi,
>>
>> I have a 8x200GB RAID5 array - 4 SATA and 4 EIDE. It has 2 spare, so
>> that's only 6 drives actually in the array, making 1TB of space (I
>> think that's right).
>>
>> The drives are quite old now, and people are asking what I want for
>> Christmas...so I'm wondering how to upgrade this setup. Clearly I
>> don't want to retire my existing drives prematurely, since they've
>> shown no sign of problem.
>>
>> My initial thought was to make a RAID1 out of a new 1TB disk and my
>> existing RAID5 array, but perhaps that doesn't make much sense...
>>
>> Perhaps I could get a 400GB drive (or more likely 500GB) and make a
>> RAID1 with a couple of the existing 200GBs?
>>
>> ...but I'm just guessing and the purpose of this email is to get advice.
>>
>> What do you guys think?
>>
>> Max.
>
> Tough call, depends on what you want to accomplish?  Availability or mass
> storage space?  You could continue running like you are now and use a 1TiB
> disk as your "scratch" area and rsync the important data off to your RAID-5
> nightly for example.

I think I want 'availability'. I would be really sick to lose the
contents, but it wouldn't be the end of the world...I have nowhere big
enough for a backup.

A 1TiB disk might be a good thing to do a backup while I convert from
RAID5 to RAID6, and be useful later in some way.

>
> Another option (probably not a good one) take two of your 200s and make a
> RAID1, leave your RAID-5 as-is, buy another 200GiB as a spare

I'm not sure what I'm ending up with here - 6x200/RAID5 + 2x200/RAID1
+ 200SPARE.

Seems a little messy to me...

> and then with
> the rest of the $ buy something else, there are no good alternatives, those
> are pretty old disks you got there, but I agree if its been running fine, no
> reason to replace it.

I guess my main reason is the fear that one will fail at some time
(soon); and while it rebuilds another will fail.

Seems like I should head for RAID6. I'm not sure I can even do that
making and restoring from a backup - can I?

Max.
