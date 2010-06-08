From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: It is possible to put write cache on ssd?
Date: Tue, 08 Jun 2010 15:28:26 -0400
Message-ID: <4C0E99DA.8010309@tmr.com>
References: <loom.20100604T102522-67@post.gmane.org>	 <4C0D44FC.8020908@tmr.com> <1275972895.4313.51.camel@sibyl.beware.dropbear.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1275972895.4313.51.camel@sibyl.beware.dropbear.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Dall <ian@beware.dropbear.id.au>
Cc: Mario <mgiammarco@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ian Dall wrote:
> On Mon, 2010-06-07 at 15:14 -0400, Bill Davidsen wrote:
>   
>> Mario wrote:
>>     
>>> [...]
>>> So I ask: if I add a fast (with little size) ssd to a linux server is there a
>>> way for linux md raid to use it as a cache to have safer writes and faster raid?
>>>
>>> Thanks in advance for interest.
>>>
>>>       
>> Actually playing with that now. I got an Intel SATA 40GB SSD, and I am 
>> trying various combinations of things to put on it. One thing which I 
>> hoped would benefit was to put a f/s journal on SSD and then use the 
>> option to push all through the journal (data=journal) in hopes that it 
>> would then free the RAM needed for cache and thus speed operation.
>>
>> Since none of that has generated the performance I hoped, 
>>     
>
> Interesting. If its the X25-V that you have, write performance is
> nothing to write home about even compared to a single hard drive, let
> alone a raid. By journaling data as well (as metadata), you just add
> extra write overhead, possibly even a new bottleneck. 
>
>   
There was a claim that if you use journaled data that the memory buffers 
would be released after the journal was written. Looking at the code I 
didn't think so, but the idea was that a burst of less than 10GB or so 
would get out of memory to the SSD and then be pulled back more slowly 
without blowing everything out of memory cache. Always good to actually 
try stuff than look at the code and pontificate about what it will do 
under dynamic conditions.

The best thing I found was some code I was playing with in 2.6.27 or so, 
which limited the cache used by any one fd, so that there was cache for 
other programs. This shortened the initial fast write speed (write were 
going to buffer, not disk) but didn't hurt 10GB write time, and left the 
system working for other programs.
> What happens if you journal only the metadata? The hoped for advantage
> would be to avoid seeks between the areas used for the journal and the
> data.
>
>   
I've tried putting the journal (and bitmap) on other devices, even on a 
ramdisk, it only helps for certain load.
> The characteristics of these SSD devices seems to be that they get
> faster as they get bigger (like the chips are effectively in a kind of
> raid).
>
>   
>> I'm now 
>> looking at a kernel patch to overflow the cache in RAM into the SSD, 
>> stealing code from the mmap to make some address space on the SSD.
>>     
>
> Again, I wonder if write performance is good enough for this to pay off.
> How does that compare with just using the ssd for swap and possibly
> tweaking some parameters to encourage the kernel to use swap more? This
> would effectively free up more ram for buffers.
>
>   
>>  At 
>> the moment that works poorly (ok, doesn't work) and I'm going to have to 
>> rethink the way I do things and probably write a whole bunch of code to 
>> do it. Not sure if I want to do that, it's unlikely to be a candidate 
>> for mainline unless I put a ton of time into learning the corner cases.
>>
>> I also played with mirroring and write mostly, etc. Does provide a 
>> general solution, at least in my tests.
>>     
>
> Do you mean "does NOT"?
>
>
>   


-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

