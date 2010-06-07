From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: It is possible to put write cache on ssd?
Date: Mon, 07 Jun 2010 15:14:04 -0400
Message-ID: <4C0D44FC.8020908@tmr.com>
References: <loom.20100604T102522-67@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20100604T102522-67@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario <mgiammarco@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario wrote:
> Hello,
> I have seen that the only hardware raid controllers that can go faster than
> linux md raid are the controllers with BBU unit.
>
> Infact thanks to the battery the controllers can have a more aggressive write
> caching without the risk of losing data.
>
> Obviously in a standard pc there is not BBU to use with linux software raid.
>
> Now I see that latest hardware raid controllers exchange battery AND ram with a
> little flash disk.
>
> So I ask: if I add a fast (with little size) ssd to a linux server is there a
> way for linux md raid to use it as a cache to have safer writes and faster raid?
>
> Thanks in advance for interest.
>
>   
Actually playing with that now. I got an Intel SATA 40GB SSD, and I am 
trying various combinations of things to put on it. One thing which I 
hoped would benefit was to put a f/s journal on SSD and then use the 
option to push all through the journal (data=journal) in hopes that it 
would then free the RAM needed for cache and thus speed operation.

Since none of that has generated the performance I hoped, I'm now 
looking at a kernel patch to overflow the cache in RAM into the SSD, 
stealing code from the mmap to make some address space on the SSD. At 
the moment that works poorly (ok, doesn't work) and I'm going to have to 
rethink the way I do things and probably write a whole bunch of code to 
do it. Not sure if I want to do that, it's unlikely to be a candidate 
for mainline unless I put a ton of time into learning the corner cases.

I also played with mirroring and write mostly, etc. Does provide a 
general solution, at least in my tests.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

