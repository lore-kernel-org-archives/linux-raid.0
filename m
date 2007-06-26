From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: stripe_cache_size and performance
Date: Tue, 26 Jun 2007 10:37:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706261036560.3561@p34.internal.lan>
References: <Pine.LNX.4.64.0706211312480.5806@gheavc.wnzcbav.cig>
 <5d96567b0706211242p7f03bd1cw9102ae3e44d67cee@mail.gmail.com>
 <Pine.LNX.4.64.0706211808140.5806@gheavc.wnzcbav.cig>
 <Pine.LNX.4.64.0706251705040.5806@gheavc.wnzcbav.cig>
 <Pine.LNX.4.64.0706251820310.27372@p34.internal.lan>
 <Pine.LNX.4.64.0706260853582.5806@gheavc.wnzcbav.cig>
 <Pine.LNX.4.64.0706261000100.3561@p34.internal.lan>
 <Pine.LNX.4.64.0706260916070.5806@gheavc.wnzcbav.cig>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706260916070.5806@gheavc.wnzcbav.cig>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Tue, 26 Jun 2007, Jon Nelson wrote:

> On Tue, 26 Jun 2007, Justin Piszcz wrote:
>
>>
>>
>> On Tue, 26 Jun 2007, Jon Nelson wrote:
>>
>>> On Mon, 25 Jun 2007, Justin Piszcz wrote:
>>>
>>>> Neil has a patch for the bad speed.
>>>
>>> What does the patch do?
>>>
>>>> In the mean time, do this (or better to set it to 30, for instance):
>>>>
>>>> # Set minimum and maximum raid rebuild speed to 60MB/s.
>>>> echo "Setting minimum and maximum resync speed to 60 MiB/s..."
>>>> echo 60000 > /sys/block/md0/md/sync_speed_min
>>>> echo 60000 > /sys/block/md0/md/sync_speed_max
>>>
>>> sync_speed_max defaults to 200000 on this box already.
>>> I tried a binary search of values between the default (1000)
>>> and 60000 which resulted in some pretty weird behavior:
>>>
>>> at values below 26000 the rate (also confirmed via dstat output) stayed
>>> low.  2-3MB/s.  At 26000 and up, the value jumped more or less instantly
>>> to 70-74MB/s. What makes 26000 special? If I set the value to 20000 why
>>> do I still get 2-3MB/s actual?
>
>
>> You want to use sync_speed_min.
>
> I forgot to say I changed the values of sync_speed_min.
>
>
> --
> Jon Nelson <jnelson-linux-raid@jamponi.net>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Sounds quite strange, what chunk size are you using for your RAID?
