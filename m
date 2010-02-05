From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: If your using large Sata drives in raid 5/6 ....
Date: Fri, 05 Feb 2010 10:38:37 -0500
Message-ID: <4B6C3B7D.2090502@tmr.com>
References: <87f94c371002021440o3b30414bk3a7ccf9d2fa9b8af@mail.gmail.com> <87f94c371002021446y38dce6fds6acca2b4919ad773@mail.gmail.com> <4B698365.1040007@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B698365.1040007@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John Robinson wrote:
> On 02/02/2010 22:46, Greg Freemyer wrote:
>> All,
>>
>> I think the below is accurate, but please cmiiw or misunderstand.
>>
>> ===
>> If your using normal big drives (1TB, etc.) in a raid-5 array, the
>> general consensus of this list is that it is a bad idea.  The reason 
>> being
>> that the sector error rate for a bad sector has not changed with
>> increasing density.
>>
>> So in the days of 1GB drives, the likelihood of a undetected /
>> repaired bad sector was actually pretty low for the drive as whole.
>> But for today's 1TB drives, the odds are 1000x worse.  ie. 1000x more
>> sectors with the same basic failure rate per sector.
>>
>> So a raid-5 composed of 1TB drives is 1000x more likely to be unable
>> to rebuild itself after a drive failure than a raid-5 built from 1 GB
>> drives of yesteryear.  Thus the current recommendation is to use raid
>> 6 with high density drives.
>
> That sounds about right. One might still see RAID-5 as a way of 
> pushing data loss through bad sectors back into a comfortable zone. 
> After all, the likelihood of the same sector going bad on one of the 
> other drives should be relatively small. Unfortunately it's too long 
> since I studied probability for me to work it out properly. Then, to 
> also protect yourself against dead drives, adding another drive a la 
> RAID-6 sounds like the answer. But you can't think of RAID-6 
> protecting you from 2 drive failures any more.
>
> What is more, you need Linux md's implementation of single-sector 
> recovery/rewriting for this to work. You cannot go around failing 
> arrays because occasional single-sector reads fail.
>
>> The good news is that Western Digital is apparently introducing a new
>> series of drives with an error rate "2 orders of magnitude" better
>> than the current generation.
>
> It's not borne out in their figures; WD quote "less than 1 in 10^15 
> bits" which is the same as they quote for their older drives.
>
> What sums I've done, on the basis of a 1 in 10^15 bit unrecoverable 
> error rate, suggest you've a 1 in 63 chance of getting an 
> uncorrectable error while reading the whole surface of their 2TB disc. 
> Read the whole disc 44 times and you've a 50/50 chance of hitting an 
> uncorrectable error.
>
Rethink that, virtually all errors happen during write, reading is 
non-destructive, in terms of what's on the drive. So it's valid after 
write or it isn't, but having been written correctly, other than 
failures in the media (including mechanical parts) or electronics, the 
chances of "going bad" are probably vanishingly small. And since "write 
in the wrong place" errors are proportional to actual writes, long term 
storage of unchanging data is better than active drives with lots of change.

> You could read the whole drive in about 5 hours, according to the spec 
> (at 110MB/s), so if you keep your drive busy you're going to reach 
> this point in about 9 days. If you had a 5-drive array, you're going 
> to get here inside 2 days.
>
> Bear in mind that this is on a drive working perfectly correctly as 
> specified. We have to expect to be recovering from failed reads daily.
>
> </doom> ;-)
>
> Cheers,
>
> John.
>
> PS. Wish I'd written down my working for this.
> PPS. I'm not having a go at WD; other manufacturers' specs are similar.


-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

