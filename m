From: "kyle" <kylewong@southa.com>
Subject: Re: change strip_cache_size freeze the whole raid
Date: Mon, 22 Jan 2007 23:18:35 +0800
Message-ID: <00c201c73e38$95dcba70$28df0f3d@kylecea1512a3f>
References: <001801c73e14$c3177170$28df0f3d@kylecea1512a3f> <Pine.LNX.4.64.0701220717200.30260@p34.internal.lan> <005501c73e33$7d9046d0$28df0f3d@kylecea1512a3f> <Pine.LNX.4.64.0701220954540.1711@p34.internal.lan>
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

>>
>> > Yes, I noticed this bug too, if you change it too many times or change 
>> > it
>> > at the 'wrong' time, it hangs up when you echo numbr >
>> > /proc/stripe_cache_size.
>> >
>> > Basically don't run it more than once and don't run it at the 'wrong' 
>> > time
>> > and it works.  Not sure where the bug lies, but yeah I've seen that on 
>> > 3
>> > different machines!
>> >
>> > Justin.
>> >
>> >
>>
>> I just change it once, then it freeze. It's hard to get the 'right time'
>>
>> Actually I tried it several times before. As I remember there was once it
>> freezed for around 1 or 2 minutes , then back to normal operation. This 
>> is the
>> first time it completely freezed and I waited after around 10 minutes it 
>> still
>> didn't wake up.
>>
>> Kyle
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> What kernel version are you using?  It normally works the first time for
> me, I put it in my startup scripts, as one of the last items.  However, if
> I change it a few times, it will hang and there is no way to reboot except
> via SYSRQ or pressing the reboot button on the machine.
>
> This seems to be true of 2.6.19.1 and 2.6.19.2, I did not try under
> 2.6.20-rc5 because I am tired of hanging my machine :)
>
> Justin.
>

It was 2.6.17.8. Now it's 2.6.7.13 but I won't touch it now! It's around 
15km from me!

