From: Tim Small <tim@buttersideup.com>
Subject: Write and verify correct data to read-failed sectors before degrading
 array?
Date: Thu, 16 Sep 2004 11:50:55 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4149700F.6060509@buttersideup.com>
References: <41420D07.4060001@steeleye.com> <16709.12517.514905.627708@cse.unsw.edu.au> <41487D18.1050000@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41487D18.1050000@steeleye.com>
To: Paul Clements <paul.clements@steeleye.com>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements wrote:

> Neil Brown wrote:
>
>> On Friday September 10, paul.clements@steeleye.com wrote:
>>
>>> Neil,
>>>
>>> unless you've already done so, I believe there is a little fix 
>>> needed in the raid1 read reschedule code. As the code currently 
>>> works, a read that is retried will continue to fail and cause raid1 
>>> to go into an infinite retry loop:
>>
>>
>>
>> Thanks.  I must have noticed this when writing the raid10 module
>> because it gets it right.  Obviously I didn't "back-port" it to raid1.
>>
>> A few other fields need to be reset for safety.
>
>
> Well, it turns out that even that is not enough. Even with your patch, 
> we're still seeing ext3-fs errors, which means we're getting bogus 
> data on the read retry (the filesystem is re-created every test run, 
> so there's no chance of lingering filesystem corruption causing the 
> errors).
>
> Rather than getting down in the guts of the bio and trying to reset 
> all the fields that potentially could have been touched, I think it's 
> probably safer to simply discard the bio that had the failed I/O 
> attempted against it and clone a new bio, setting it up just as we did 
> for the original read attempt. This seems to work better and will also 
> protect us against any future changes in the bio code (or bio handling 
> in any driver sitting below raid1), which could break read retry 
> again. Patch attached.
>

Just thinking out loud here, but I wonder if the following change is 
possible or worth making to this code?  For a failed read, where the 
block is then successfully read from another drive, then attempt to 
write the correct data for this block to the device with the read 
failure (to try to see if the drive firmware thinks this sector is still 
usable, and if not then maybe it will reallocate the failed sector).  If 
this write succeeds, and can be verified, then don't mark the sector bad 
(maybe just complain with a printk)..

This would get around a lot of mirror failures that I see in 
operation..  In the past, I've had mirrors go bad with individual failed 
sectors in different locations on both drives, the array is then 
unusable (and the database server is dead, in my experience) unless you 
manually try to knit it back together with dd.

