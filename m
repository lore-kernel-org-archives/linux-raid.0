From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: When do you replace old hard drives in a raid6?
Date: Sun, 6 Mar 2016 22:40:03 -0600
Message-ID: <56DD0623.8070106@gmail.com>
References: <56DB465E.9010703@gmail.com> <56DCCB55.1060906@turmel.org>
 <56DCD0E9.8040506@gmail.com>
 <CAFE24U3in=jKonie7i_tG-kP=8xHQufPaJwHdJAR0vYfAzLBXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFE24U3in=jKonie7i_tG-kP=8xHQufPaJwHdJAR0vYfAzLBXg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Weedy <weedy2887@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/06/2016 08:31 PM, Weedy wrote:
> On Sun, Mar 6, 2016 at 7:52 PM, Ram Ramesh <rramesh2400@gmail.com> wrote:
>> On 03/06/2016 06:29 PM, Phil Turmel wrote:
>>> On 03/05/2016 03:49 PM, Ram Ramesh wrote:
>>>> I am curious if people actually replace hard drives periodically because
>>>> they are old or out of warranty. My 5 device raid6 has several older
>>>> drives (3/5 are 3+ years old and out of warranty) They seem fine with
>>>> SMART and raid scrubs. However, it makes me wonder when they will die.
>>>> What is the best policy in such situations? More importantly, do people
>>>> wait for disks to die and then replace or have some ad hoc schedule of
>>>> replacing (like every 6mo replace oldest) to keep things safe?
>>> I replace drives when their relocation count hits double digits.  In my
>>> limited sample, that's typically after 40,000 hours.
>>>
>>> Phil
>>
>> Thanks for the data point. 40K hours means roughly 4.5 years with 24/7. That
>> is very good. You use enterprise drives?
> They don't have to be, cheap crap can last. My case slots the drives
> in vertically with large silicone dampers, I feel like this helps.
>
> Model Family:     Seagate Barracuda 7200.10
> Device Model:     ST3320620AS
>    5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
> Always       -       0
>    9 Power_On_Hours          0x0032   040   040   000    Old_age
> Always       -       52576
>
> Model Family:     Seagate Barracuda 7200.10
> Device Model:     ST3320620AS
>    5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
> Always       -       0
>    9 Power_On_Hours          0x0032   048   048   000    Old_age
> Always       -       46196
>
> Model Family:     Western Digital Caviar Black
> Device Model:     WDC WD1001FALS-00E8B0
>    5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> Always       -       0
>    9 Power_On_Hours          0x0032   039   039   000    Old_age
> Always       -       44551
>
>
> Model Family:     SAMSUNG SpinPoint F1 DT
> Device Model:     SAMSUNG HD103UJ
>    5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail
> Always       -       10
>    9 Power_On_Hours          0x0032   087   087   000    Old_age
> Always       -       67735
>
>
> Model Family:     Western Digital Caviar Black
> Device Model:     WDC WD1001FALS-00E8B0
>    5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> Always       -       0
>    9 Power_On_Hours          0x0032   040   040   000    Old_age
> Always       -       44427
>
> Model Family:     SAMSUNG SpinPoint F1 DT
> Device Model:     SAMSUNG HD103UJ
>    5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail
> Always       -       6
>    9 Power_On_Hours          0x0032   093   093   000    Old_age
> Always       -       36570
>
>
> I would say the biggest thing is how often you get a reallocated
> sector. The Samsungs seem to get 1-3 a year, they will probably keep
> doing that until they die. Past experience with seagate tells me I'm
> going to get 10 in one day and the drive will die in a week. The WD
> will probably throw a few at a time and I'll dump them when they get
> to 10-15 sectors.
I hear you. I have not had any fails myself in my 20+ years. I have 
gotten rid of them because they became too small relative what market 
offered. Until recently, I had a working 8G (yes, 8G!) IBM IDE drive 
from my first computer (20+ years ago) It was a keepsake. They do not 
make them this tough these days. I am almost sure that a new seagate 
desktop 6TB is not going to last this long.

All said and done, I think I feel I have less to worry. Thanks for 
helping me to see that.

I run long selftest once a month and will watch the RAID scrubs and 
SMART values. I should be ok until I see my first reallocated sector 
hit.  After that I will buy my replacements.

Ramesh
