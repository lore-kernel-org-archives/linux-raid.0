From: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Subject: Re: Replace drive in RAID5 without losing redundancy?
Date: Thu, 8 Mar 2007 15:56:53 +0100
Message-ID: <9D3015E0-6044-4BE3-8DE3-4B53B86CB1B9@bj-ig.de>
References: <37643E71-0FD9-4F8A-AE68-A8565FEB0247@bj-ig.de> <17900.39356.684798.56121@notabene.brown> <45EED6F0.6010107@tmr.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45EED6F0.6010107@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Am 07.03.2007 um 16:14 schrieb Bill Davidsen:
> Neil Brown wrote:
>> On Monday March 5, ralf@bj-ig.de wrote:
>>> Is it possible to mark a disk as "to be replaced by an existing  
>>> spare",
>>> then migrate to the spare disk and kick the old disk _after_  
>>> migration
>>> has been done? Or not even kick - but mark as new spare.
>>
>> No, this is not possible yet.
>
> I was thinking about this, and looked at the code a bit.
> [ ... ]
> What I was thinking is to trigger the code to rebuild on spare, but  
> to only rebuild the data from parity of the drive being replaced  
> were unreadable.

Sounds good to me ...

> That should make the process run much faster. any write would  
> present a different problem, I would say the data would go to the  
> new drive, and if bitmap was enabled the bit would be set for the  
> old drive but no write done.

But then you need to copy the whole block that is covered by a bit in
the bitmap to the new drive on every write that is done to the raid -  
am I
right? For small random writes this could be a real performance hit.

> If the new drive failed during the migrate the old drive could then  
> be resynced. Without a bitmap you DO want to write the old drive if  
> it's good, DON'T if you think it's failing.

Without a bitmap I would suggest to try to write to the old _and_ the  
new drive.
In case of a write error on the old drive it seems best to me to not  
kick
it - as it would be done normally - but ignore the error and hope the  
next time
one tries to write this sector it is still not writable (just in case  
we have to
stop migration for any reason). Or is there any way to mark a sector  
as invalid
on a raid without bitmap?

In case the new drive fails it should be kicked as usual ...

Ok ... for not having any idea what the raid code actually does this was
quite a lot of text ... hopefully it was not only noise.

Ralf
