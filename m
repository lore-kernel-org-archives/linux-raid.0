From: "kyle" <kylewong@southa.com>
Subject: Re: change strip_cache_size freeze the whole raid
Date: Mon, 22 Jan 2007 21:09:58 +0800
Message-ID: <005501c73e33$7d9046d0$28df0f3d@kylecea1512a3f>
References: <001801c73e14$c3177170$28df0f3d@kylecea1512a3f> <Pine.LNX.4.64.0701220717200.30260@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

>
> On Mon, 22 Jan 2007, kyle wrote:
>
>> Hi,
>>
>> Yesterday I tried to increase the value of strip_cache_size to see if I 
>> can
>> get better performance or not. I increase the value from 2048 to 
>> something
>> like 16384. After I did that, the raid5 freeze. Any proccess read / write 
>> to
>> it stucked at D state. I tried to change it back to 2048, read
>> strip_cache_active, cat /proc/mdstat, mdadm stop, etc. All didn't return 
>> back.
>> I even cannot shutdown the machine. Finally I need to press the reset 
>> button
>> in order to get back my control.

> Yes, I noticed this bug too, if you change it too many times or change it
> at the 'wrong' time, it hangs up when you echo numbr >
> /proc/stripe_cache_size.
>
> Basically don't run it more than once and don't run it at the 'wrong' time
> and it works.  Not sure where the bug lies, but yeah I've seen that on 3
> different machines!
>
> Justin.
>
>

I just change it once, then it freeze. It's hard to get the 'right time'

Actually I tried it several times before. As I remember there was once it 
freezed for around 1 or 2 minutes , then back to normal operation. This is 
the first time it completely freezed and I waited after around 10 minutes it 
still didn't wake up.

Kyle

