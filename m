From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Any benefity to write intent bitmaps on Raid1
Date: Thu, 09 Apr 2009 18:51:15 -0400
Message-ID: <49DE7BE3.1000601@tmr.com>
References: <45635.60.234.49.2.1239236645.squirrel@webmail.stevencherie.net> <18909.36541.447308.778177@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18909.36541.447308.778177@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Steven Ellis <steven@openmedia.co.nz>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday April 9, steven@openmedia.co.nz wrote:
>   
>> Given I have a pair of 1TB drives Raid1 I'd prefer to reduce any recovery
>> sync time. Would an internal bitmap help dramatically, and are there any
>> other benefits.
>>     
>
> Bryan answered some of this but...
>
>  - if your machine crashes, then resync will be much faster if you
>    have a bitmap.
>  - If one drive becomes disconnected, and then can be reconnected,
>    recovery will be much faster.
>  - if one drive fails and has to be replaced, a bitmap makes no
>    difference(*).
>  - there might be performance hit - it is very dependant on your
>    workload.
>  - You can add or remove a bitmap at any time, so you can try to
>    measure the impact on your particular workload fairly easily.
>
>
> (*) I've been wondering about adding another bitmap which would record
> which sections of the array have valid data.  Initially nothing would
> be valid and so wouldn't need recovery.  Every time we write to a new
> section we add that section to the 'valid' sections and make sure that
> section is in-sync.
> When a device was replaced, we would only need to recover the parts of
> the array that are known to be invalid.
> As filesystem start using the new "invalidate" command for block
> devices, we could clear bits for sections that the filesystem says are
> not needed any more...
> But currently it is just a vague idea.
>   

It's obvious that this idea would provide a speedup, and might be useful 
in terms of doing some physical dump software which would just save the 
"used" portions of the array. Only you have an idea of how much effort 
this would take, although my thought is "very little" for the stable 
case and "bunches" for the case of an array size change.

I have been trying making a COW copy of an entire drive with qemu-img, 
then booting it under KCM, and besides giving an interesting slant to 
the term "dual boot," I can back up the changes files (a sparse file) 
quickly and into small space with a backup which knows about sparse 
files. There is lots of room to imagine uses for this if we had it.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


