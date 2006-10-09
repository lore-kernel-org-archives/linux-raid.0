From: Chris Allen <chris@cjx.com>
Subject: Re: raid5 hang on get_active_stripe
Date: Tue, 10 Oct 2006 00:21:42 +0100
Message-ID: <452AD986.1010304@cjx.com>
References: <17532.59212.364233.765155@cse.unsw.edu.au>	<Pine.LNX.4.64.0605301758380.21977@twinlark.arctic.org>	<17532.62343.933852.982391@cse.unsw.edu.au>	<Pine.LNX.4.64.0605301844180.21977@twinlark.arctic.org>	<17534.22056.981033.686846@cse.unsw.edu.au>	<Pine.LNX.4.64.0606020009560.10016@twinlark.arctic.org>	<17535.59496.431182.785563@cse.unsw.edu.au>	<448F0994.6050704@tmr.com>	<17551.18061.160356.35034@cse.unsw.!edu.au>	<4528377A.2010001@cjx.com>	<20061009110344.GA7104@cjx.com> <17706.54775.830279.53938@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17706.54775.830279.53938@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Neil Brown wrote:
> On Monday October 9, chris@cjx.com wrote:
>   
>> Ok, after more testing, this lockup happens consistently when
>> bitmaps are switched on and never when they are switched off.
>>
>>     
> Are you happy to try a kernel.org kernel with a few patches and a
> little shell script running?
> The net result is that it detects when there is a problem, prints out
> some trace information, and then gets array going again.
>
>
>   

Very happy to. Let me know what you'd like me to do.
