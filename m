From: Kumar Sundararajan <kumar@fb.com>
Subject: Re: [PATCH] raid5: add support for rmw writes in raid6
Date: Mon, 29 Apr 2013 16:11:41 +0000
Message-ID: <BA07AEDCFD3B5B4DAB0FF1D7B35E42DC5544BCFA@PRN-MBX01-4.TheFacebook.com>
References: <517E1CD4.3060903@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <517E1CD4.3060903@hesbynett.no>
Content-Language: en-US
Content-ID: <1D2D960EB1DB09469E9AEFF045C8ACD9@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>, NeilBrown <neilb@suse.de>
Cc: Dan Williams <djbw@fb.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 4/29/13 12:10 AM, "David Brown" <david.brown@hesbynett.no> wrote:

>On 29/04/13 03:29, NeilBrown wrote:
>> On Fri, 26 Apr 2013 14:35:27 -0700 Dan Williams <djbw@fb.com> wrote:
>> 
>>> On Sun, Apr 21, 2013 at 9:22 PM, NeilBrown <neilb@suse.de> wrote:
>>>> On Wed, 17 Apr 2013 17:56:56 -0700 Dan Williams <djbw@fb.com> wrote:
>>>>
>>>>> From: Kumar Sundararajan <kumar@fb.com>
>>>>>
>>>>> Add support for rmw writes in raid6. This improves small write
>>>>>performance for most workloads.
>>>>> Since there may be some configurations and workloads where rcw
>>>>>always outperforms rmw,
>>>>> this feature is disabled by default. It can be enabled via sysfs.
>>>>>For example,
>>>>>
>>>>>       #echo 1 > /sys/block/md0/md/enable_rmw
>>>>>
>>>>> Signed-off-by: Kumar Sundararajan <kumar@fb.com>
>>>>> Signed-off-by: Dan Williams <djbw@fb.com>
>>>>> ---
>>>>> Hi Neil,
>>>>>
>>>>> We decided to leave the enable in for the few cases where forced-rcw
>>>>> outperformed rmw and there may be other cases out there.
>>>>>
>>>>> Thoughts?
>>>>
>>>> - More commentary would help.  The text at the top should explain
>>>>enough so
>>>>   when I read the code I am just verifying the text at the top, not
>>>>trying to
>>>>   figure out how it is supposed to work.
>>>
>>> Ok, along the lines of:
>>>
>>> "raid5 has supported sub-stripe writes by computing:
>>>
>>> P_new = P_old + D0_old + D0_new
>> 
>> The '0' looks out of place.  All 'D's are treated the same, so I would
>>write
>> it
>>    P_new = P_old + D_old + D_new
>> though that is a small point.
>> 
>>>
>>> For raid6 we add the following:
>>>
>>> P_new = P_old + D0_old + D0_new
>
>Correct (though I agree with Neil that "0" should be replaced by "i").
>
>>>
>>> Q_sub = Q_old + syndrome(D0_old)
>
>Wrong - using this terminology, Q_sub = syndrome(D0_old)
>
>>> Q_sub = Q_old + g^0*D0_old
>>> Q_new = Q_old + Q_sub + g^0*D0_new
>> 
>> But here the different Ds are different, so I would be using "Di" or
>>similar.
>> 
>>   P_new = P_old + Di_old + Di_new
>
>Correct.
>
>> 
>> and I assume the two 'Q_sub' lines are meant to mean the same thing, so
>>let's
>> take the second:
>> 
>>   Q_sub = Q_old + g^i * Di_old
>>   Q_new = Q_old + Q_sub + g^i * Di_new
>> 
>
>You've still got one "Q_old" too many, which means your algebra is wrong
>(Q_new reduces here to g^i * Di_new, which is clearly wrong).  But
>you've jumped to almost the right conclusion on the next line, proving
>that two wrongs sometimes do make a right!
>
>> which looks odd as when that expands out, we add Q_old to Q_old and as
>>'+'
>> is 'xor', it disappears.  Maybe you mean:
>> 
>>   Q_new = Q_sub + g^i * Di_new
>> ??
>
>Q_sub = g^i * Di_old
>Q_new = Q_old - Q_sub + g^i * Di_new
>      = Q_old + g^i * Di_old + g^i * Di_new   (since "-" = "+")
>      = Q_old + g^i * (Di_old + Di_new)
>
>I can't say for sure (I know the maths, not the code), but I would
>expect this final version do be the most efficient for the calculations.
> By xor'ing Di_old and Di_new first, then multiplying by g^i, you'll
>half the number of costly g^i multiplications.
>
>

Yes, I did consider this. But this scheme is harder to implement with how
the rest of the code works,
especially with writes covering more than one Di.


Kumar


>

