From: David Brown <david.brown@hesbynett.no>
Subject: Re: LVM striping RAID volumes
Date: Wed, 25 Jan 2012 11:04:09 +0100
Message-ID: <jfok2p$6vg$1@dough.gmane.org>
References: <1327467050.3474.303.camel@slacker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1327467050.3474.303.camel@slacker>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/01/12 05:50, Douglas Siebert wrote:
> I recently bought two Intel 320 80GB SSDs and plan to use them on a
> Fedora 16 system for boot/root, home and other frequently used data.  I
> planned to mirror them together using md raid/Linux software RAID for
> reliability, and use LVM to partition.  I did some investigation on
> insuring data alignment for best performance, etc. along with
> verification that my criteria for setting them up could be met:
>
> 1) must be mirrored since SSDs are similar to hard drives in their
> reliability (i.e. lack of)

SSD's are typically better than HD's, but certainly not failproof.  I 
get the impression that there is a bigger spread of reliabilities and 
failures with SSD's than with HD's.

>
> 2) must support passing TRIM commands through the RAID layer (e.g. ext4-
>> LVM->RAID->SSD) to avoid write amplification that reduces SSD lifetime
> and performance

That's not really necessary with modern SSD's - TRIM is overrated. 
Garbage collection on current generations is so much better than on 
earlier models that you generally don't have to worry about TRIM.

Dropping TRIM makes your life /much/ easier with SSD's, especially when 
you want raid.  According to some benchmarks I've seen, it also makes 
the disk measurably faster.

>
> 3) ideally should maximize performance by splitting reads between both
> SSDs
>

Sounds like Linux raid10 to me.

> Unfortunately, my investigation determined that while both md raid and
> dmraid/fakeraid can of course accomplish #1, only dmraid does #2 and
> only md raid does #3!  At first it looked like I had to give up #3, but
> I think I have a way around this dilemma, at the cost of a bit of
> additional complexity which I'm totally comfortable with.
>

Drop #2, and you are done.

> My plan is to use dmraid/ICH10R to create two equal sized RAID-1
> volumes, with the primary mirror of the first volume as sda and the
> primary mirror of the second volume as sdb, then create all my LVM
> volumes by striping extents from the two dmraid devices.
>
> Am I correct that this will meet my criteria?  Does anyone see another
> method that avoids dmraid?  If md raid handled TRIM it would be my
> preference since I've used it before and have no need to dual boot with
> Windows, but I guess its not ready yet.  Any gotchas to my solution I
> need to worry about which I may be overlooking?  Thanks for any tips or
> suggestions!
>
>
> PS - its too bad you can't set the 'strip size' parameter for RAID 1 in
> dmraid and have it swap its idea of "primary mirror" on each stripe.
> Not sure if the Intel metadata format would allow storing that value for
> a RAID 1 volume, but if it does this would be a way to avoid having all
> reads directed at one drive.  While there may be some good reasons to
> avoid indiscriminately splitting reads between hard drives, with SSDs
> the algorithm doesn't need much intelligence to see a major performance
> boost...
>


