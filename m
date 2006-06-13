From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid5 hang on get_active_stripe
Date: Tue, 13 Jun 2006 14:53:08 -0400
Message-ID: <448F0994.6050704@tmr.com>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>	<17429.64926.100005.904328@cse.unsw.edu.au>	<Pine.LNX.4.64.0605110758100.25283@twinlark.arctic.org>	<Pine.LNX.4.64.0605171137350.29929@twinlark.arctic.org>	<17522.29813.189944.397154@cse.unsw.edu.au>	<Pine.LNX.4.64.0605260903270.7952@twinlark.arctic.org>	<17527.38282.35857.117651@cse.unsw.edu.au>	<Pine.LNX.4.64.0605270834240.30550@twinlark.arctic.org>	<17529.37347.782285.77442@cse.unsw.edu.au>	<Pine.LNX.4.64.0605291354260.30134@twinlark.arctic.org>	<17531.35050.632471.433333@cse.unsw.edu.au>	<Pine.LNX.4.64.0605301713480.11178@twinlark.arctic.org>	<17532.59212.364233.765155@cse.unsw.edu.au>	<Pine.LNX.4.64.0605301758380.21977@twinlark.arctic.org>	<17532.62343.933852.982391@cse.unsw.edu.au>	<Pine.LNX.4.64.0605301844180.21977@twinlark.arctic.org>	<17534.22056.981033.686846@cse.unsw.edu.au>	<Pine.LNX.4.64.0606020009560.
 10016@twinlark.arctic.org> <17535.59496.431182.785563@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17535.59496.431182.785563@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: dean gaudet <dean@arctic.org>, Patrik Jonsson <patrik@ucolick.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>On Friday June 2, dean@arctic.org wrote:
>  
>
>>On Thu, 1 Jun 2006, Neil Brown wrote:
>>
>>    
>>
>>>I've got one more long-shot I would like to try first.  If you could
>>>backout that change to ll_rw_block, and apply this patch instead.
>>>Then when it hangs, just cat the stripe_cache_active file and see if
>>>that unplugs things or not (cat it a few times).
>>>      
>>>
>>nope that didn't unstick it... i had to raise stripe_cache_size (from 256 
>>to 768... 512 wasn't enough)...
>>
>>-dean
>>    
>>
>
>Ok, thanks.
>I still don't know what is really going on, but I'm 99.9863% sure this
>will fix it, and is a reasonable thing to do.
>(Yes, I lose a ';'.  That is deliberate).
>
>Please let me know what this proves, and thanks again for your
>patience.
>
>NeilBrown
>
[...snip...]

Will that fix be in 2.6.17?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

