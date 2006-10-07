From: Chris Allen <chris@cjx.com>
Subject: Re: raid5 hang on get_active_stripe
Date: Sun, 08 Oct 2006 00:25:46 +0100
Message-ID: <4528377A.2010001@cjx.com>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>	<Pine.LNX.4.64.0605110758100.25283@twinlark.arctic.org>	<Pine.LNX.4.64.0605171137350.29929@twinlark.arctic.org>	<17522.29813.189944.397154@cse.unsw.edu.au>	<Pine.LNX.4.64.0605260903270.7952@twinlark.arctic.org>	<17527.38282.35857.117651@cse.unsw.edu.au>	<Pine.LNX.4.64.0605270834240.30550@twinlark.arctic.org>	<17529.37347.782285.77442@cse.unsw.edu.au>	<Pine.LNX.4.64.0605291354260.30134@twinlark.arctic.org>	<17531.35050.632471.433333@cse.unsw.edu.au>	<Pine.LNX.4.64.0605301713480.11178@twinlark.arctic.org>	<17532.59212.364233.765155@cse.unsw.edu.au>	<Pine.LNX.4.64.0605301758380.21977@twinlark.arctic.org>	<17532.62343.933852.982391@cse.unsw.edu.au>	<Pine.LNX.4.64.0605301844180.21977@twinlark.arctic.org>	<17534.22056.981033.686846@cse.unsw.edu.au>	<Pine.LNX.4.64.0606020009560.10016@twinlark.arctic.org>	<17535.59496.4311
 82.785563@cse.unsw.edu.au>	<448F0994.6050704@tmr.com> <17551.18061.160356.35034@cse.unsw.!
 edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17551.18061.160356.35034@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Neil Brown wrote:
> On Tuesday June 13, davidsen@tmr.com wrote:
>   
>> Will that fix be in 2.6.17?
>>
>>     
>
> Probably not.  We have had the last 'rc' twice and I so I don't think
> it is appropriate to submit the patch at this stage.
> I probably will submit it for an early 2.6.17.x. and for 2.6.16.y.
>
>
>   

What is the status of this?

I've been experiencing exactly the same get_active_stripe lockup
on a FC5 2.6.17-1.2187_FC5smp  stock kernel. Curiously we have ten 
similar heavily loaded
servers but only one of them experiences the problem. The problem 
happens consistently after 24 hours or so
when I hammer the raid5 array over NFS, but I've never managed to 
trigger it with local access. I'd also
say (anecdotally) that it only started happening since I added a bitmap 
to my array.


As with the other poster, the lockup is released by increasing 
stripe_cache_size.





