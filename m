From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: high mismatch count after scrub
Date: Tue, 6 Mar 2007 07:51:30 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0703060751160.29188@p34.internal.lan>
References: <200703060306.46082.Dexter.Filmore@gmx.de>
 <17900.60288.751357.807885@notabene.brown> <200703061345.03675.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200703061345.03675.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 6 Mar 2007, Dexter Filmore wrote:

>>> xerxes:/sys/block/md0/md# cat mismatch_cnt
>>> 147248
>>> Need to worry?
>>
>> If you have a swap file on this array, then that could explain it, so
>> don't worry.
>
> Nope, swap is not on the array.
> Couple of loops tho.
>
>>
>> If not... maybe worry?
>>
>> I assume you did a 'check' or 'repair' before looking at this file?
>
> Correct, "check".
>
>> If not and it is a newly created array, then it is just telling that
>> the drives didn't have the same content when you started....
>
> Array has been in use for quite a while.
>
> -- 
> -----BEGIN GEEK CODE BLOCK-----
> Version: 3.12
> GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
> w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@
> b++(+++) DI+++ D- G++ e* h>++ r* y?
> ------END GEEK CODE BLOCK------
>
> http://www.stop1984.com
> http://www.againsttcpa.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Neil,

So in his case, is there anyway to determine which files are potentially 
corrupted?

Justin.
