From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: RE: Spread Spectrum (SSC) Enable or Disable?
Date: Mon, 22 Dec 2008 11:25:25 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812221122490.7231@p34.internal.lan>
References: <alpine.DEB.1.10.0812220857410.27615@p34.internal.lan> <A20315AE59B5C34585629E258D76A97C031B1D1F@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C031B1D1F@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: linux-raid@vger.kernel.org, smartmontools-support@lists.sourceforge.net
List-Id: linux-raid.ids



On Mon, 22 Dec 2008, David Lethe wrote:

>
>
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of Justin Piszcz
>> Sent: Monday, December 22, 2008 7:59 AM
>> To: linux-raid@vger.kernel.org
>> Cc: smartmontools-support@lists.sourceforge.net
>> Subject: Spread Spectrum (SSC) Enable or Disable?
>>
>> Besides the power supply/surge/etc with a lot of drives-- I have read:
>>
>> http://www.wrightthisway.com/Articles/cat_reviews.html
>> "As I mentioned earlier, the enclosure will definitely handle drives
>> using Spread Spectrum Clocking (SSC), an increasingly common feature
>> that helps reduce electromagnetic interference, especially between
>> drives in close proximity with each others, such as you might have in
> a
>> RAID setup, so that is a definite plus here."
>>
>> With 16-24 disks-- if they are close together, it sounds like a good
>> idea to use Spread Spectrum Clocking?
>> Does anyone here with a large-ish raid array use this?
>>
>> Any enterprise-insiders care to comment?
>>
>> Justin.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> I know for a fact that Xyratex supports SSC on SOME of their enclosures.
> However,
> there is a caveat to be aware of ... some RAID
> controllers/firmware/enclosure combinations
> have problems "seeing" disks that have SSC enabled.  Don't just turn
> this on unless you
> verify with the enclosure manufacturer that they support SSC for your
> desired combination.
>
> David

Dave, thanks for the reply, in my case (and most people on this list) use 
their arrays in a regular ATX/case.

The question I had was:

"especially between drives in close proximity with each others, such as 
you might have in a RAID setup, so that is a definite plus here"

Besides the staggered spin-up functionality (which is enabled, at 
least with WD drives when you enable SSC, which is good for the PSU) is 
there any other 'benefit' to using SSC in relation to the comment of 
drives being close to one another?

e.g., have studies been done looking at several raid arrays with ssc 
enabled vs. disabled and what / if any correlation can be made within 
respect to failure rates?

Justin.
