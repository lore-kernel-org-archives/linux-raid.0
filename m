From: David Brown <david@westcontrol.com>
Subject: Re: RAID 5 - One drive dropped while replacing another
Date: Wed, 02 Feb 2011 17:24:35 +0100
Message-ID: <iic0k1$950$1@dough.gmane.org>
References: <AANLkTinXTYds442gPrs9a9vKtWTo4OcDHDEzvO0njvyv@mail.gmail.com> <AANLkTikSjLhoUM5f2ibqCUmo8XF-tsrhxZ7oieg08dtD@mail.gmail.com> <20110202043605.593f0c5c@natsu> <AANLkTimJC_e8=BmGj7Th_LLc=wnoNj8tRovAgTR=mmQ7@mail.gmail.com> <20110202144726.GB18517@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110202144726.GB18517@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/02/2011 15:47, Robin Hill wrote:
> On Wed Feb 02, 2011 at 09:21:20PM +0700, hansbkk@gmail.com wrote:
>
>> On Wed, Feb 2, 2011 at 6:36 AM, Roman Mamedov<rm@romanrm.ru>  wrote:
>>>
>>>> I have a RAID5 setup with 15 drives.
>>>
>>> Looks like you got the problem you were so desperately asking for, with this
>>> crazy setup. :(
>>
>> Please give some more details as to what's so crazy about this.
>>
> Just the number of drives in a single RAID5 array I think.  I'd be
> looking at RAID6 well before I got to 10 drives.
>
>> I would think RAID6 would have made more sense, possibly with an
>> additional spare if these are large drives (over a few hundred GB?)
>>
> With 15, RAID6 + spare would probably be what I'd go with (depending on
> drive size of course, and whether you have cold spares handy).  For very
> large drives, multiple arrays would be safer.
>
>> Or is there an upper limit as to the number of drives that's advisable
>> for any array?
>>
> I'm sure there's advice out there on this one - probably a recommended
> minimum percentage of capacity used for redundancy.  I've not looked
> though - I tend to go with gut feeling&  err on the side of caution.
>
>> If so, then what do people reckon a reasonable limit should be for a
>> RAID6 made up of 2TB drives?
>>
> As the drive capacities go up, you need to be thinking more carefully
> about redundancy - with a 2TB drive, your rebuild time is probably over
> a day.  Rebuild also tends to put more load on drives than normal, so is
> more likely to cause a secondary (or even tertiary) failure.  I'd be
> looking at RAID6 regardless, and throwing in a hot spare if there's more
> than 5 data drives.  If there's more than 10 then I'd be going with
> multiple arrays.
>

If the load due to rebuild is a problem, it can make sense to split the 
raid into parts.  If you've got the money, you can start with a set of 
raid1 pairs and then build raid5 (or even raid6) on top of that.  With 
raid 1 + 5, you can survive any 3 drive failures, and generally more 
than that unless you are very unlucky in the combinations.  However, 
rebuilds are very fast - they are just a direct copy from one disk to 
its neighbour, and thus are less of a load on the rest of the system.

Of course, there is a cost - if you have 15 2TB drives, with one being a 
warm spare shared amongst the raid1 pairs, you have only 6 x 2TB storage.



