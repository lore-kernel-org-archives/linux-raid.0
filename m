From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: upgrade advice
Date: Wed, 17 Dec 2008 08:37:32 -0600
Message-ID: <cccedfc60812170637j7eab2c4cyac88fc110b51755f@mail.gmail.com>
References: <d5fe39840812160310t45e822c1geb633f805cf5388e@mail.gmail.com>
	 <1229428184.22331.43.camel@localhost>
	 <alpine.DEB.1.10.0812160807200.725@p34.internal.lan>
	 <1229436950.22331.45.camel@localhost>
	 <cccedfc60812160757x2af73afbv4a69eac31d212062@mail.gmail.com>
	 <alpine.DEB.1.10.0812161829490.31132@p34.internal.lan>
	 <cccedfc60812161608y29e6c645n6ff7df5c87292374@mail.gmail.com>
	 <1229497160.22331.73.camel@localhost>
	 <cccedfc60812170526l43c661ddgff95c99ea883f362@mail.gmail.com>
	 <A20315AE59B5C34585629E258D76A97C030D4837@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C030D4837@34093-C3-EVS3.exchange.rackspace.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Redeeman <redeeman@metanurb.dk>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 17, 2008 at 8:28 AM, David Lethe <david@santools.com> wrote:
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of Jon Nelson
>> Sent: Wednesday, December 17, 2008 7:27 AM
>> To: Redeeman
>> Cc: Justin Piszcz; linux-raid@vger.kernel.org
>> Subject: Re: upgrade advice
>>
>> > What sort of volume of disks are you using, and what loads? (24/7
>> with
>> > high load?)
>>
>> It's a home server. It's up 24/7. Load probably 80% of the time is
>> low, the rest of the time it's bursty.
>>

> Read the specs on the disks.  Most consumer class drives are rated for
> only 2400 hours annual duty cycle ... so I guess you turn the computer
> off in April? :)

Yeah. Right. I typically get > 5 years out of the disks. I got almost
9 years once, before bad sectors started showing up. Actually, I've
either gotten less than a week or more than 4 years out of every
single drive I've ever had, except a really bad batch of seagates I
got 8-10 years ago.

The current temp of the drives varies between 28C and 33C (the Hitach
is warmer by +4C than any other drive).

> Other differences include number of ECC correction bits, so you will
> absolutely get more grown bad blocks with cheap drives.

That's good to know.

> drives.   No wonder several fail within days of each other, they all
> have same model, I/O load, and generally same manufacturing batch.

I never have more than 1 of the same manuf. / model in a raid at a
time. I have a 3 drive raid10f2 with 3 different manuf.

> If you are hell-bent on getting cheap drives, then at least factor in
> cost of an additional drive so you can implement RAID6, and automate a
> daemon to check/repair consistency often.

I will likely move to raid6 eventually.
Thanks for the advice.

-- 
Jon
