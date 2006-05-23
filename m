From: Adam Talbot <talbotx@comcast.net>
Subject: Re: Does software RAID take advantage of SMP, or 64 bit CPU(s)?
Date: Tue, 23 May 2006 07:44:59 -0700
Message-ID: <44731FEB.6020602@comcast.net>
References: <4472A9FF.9060501@comcast.net> <17522.43808.68998.902497@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17522.43808.68998.902497@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-Neil
I was not looking for any direct advantage.  It is more a money VS
performance thing.  I have a old dual proc Opteron motherboard.  I am
going with 64-bit, but it is much cheaper if I just go buy a nice single
proc board instead of buying two Opterons for my dual proc board.  If I
could get a 1.5~2X performance improvement with SMP I would pay the
extra money.  If there is no major performance difference, I will take
the cheap road.

Thank you for the good input.
-Adam

P.S.  Here is my current plan.
RAID 6, 6X 400GB SATA 2.0 HDD's, Athlon FX 53, 1GB DDR 400, Nvidia based
motherboard, Gb Ethernet.  Storing 15,000+ MP3's, 500+ movies.

Neil Brown wrote:
> On Monday May 22, talbotx@comcast.net wrote:
>   
>> A few simple questions about the 2.6.16+ kernel and software RAID.
>> Does software RAID in the 2.6.16 kernel take advantage of SMP?
>>     
>
> Not exactly.  RAID5/6 tends to use just one cpu for parity
> calculations, but that frees up other cpus for doing other important
> work.
>
>   
>> Does software RAID take advantage of 64-bit CPU(s)?
>>     
>
> No more or less that other code in the kernel.  Sometimes using a 64-bit
> CPU is a cost because more data is shuffled around...
>
> Was there some particular sort of 'advantage' that you were thinking
> of?
>
> NeilBrown
>
>
>   
>> If there are any good web sites that cover this information, a link
>> would be GREAT!
>>
>> -Adam Talbot
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>     
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   

