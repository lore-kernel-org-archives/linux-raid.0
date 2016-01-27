From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Uneven wear on raid1 devices
Date: Wed, 27 Jan 2016 11:18:44 +1100
Message-ID: <56A80CE4.1090603@websitemanagers.com.au>
References: <56A5B29E.3020708@websitemanagers.com.au>
 <20160125104027.597041a3@natsu> <56A662A3.6000402@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56A662A3.6000402@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Roman Mamedov <rm@romanrm.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/01/16 05:00, Phil Turmel wrote:
> On 01/25/2016 12:40 AM, Roman Mamedov wrote:
>> On Mon, 25 Jan 2016 16:29:02 +1100
>> Adam Goryachev <adam@websitemanagers.com.au> wrote:
>>
>>>     9 Power_On_Hours          -O--CK   098   098   000    -    6435
>>>     9 Power_On_Hours          -O--CK   095   095   000    -    23178
>> 2nd drive has almost 4x as much power-on time than the first one. My guess
>> would be that it accumulated all that write usage back before you put it into
>> this RAID1.
> Or you are doing "repair" scrubs when you should be doing "check"
> scrubs.  Any operation that requires resynchronization will read from
> the first mirror and write to the others.

No, definitely not doing a repair scrub, so sounds like the issue was 
just the power on hours problem.

>> If you want to ensure the RAID1 usage is even, record the SMART data you have
>> now, and compare to the readings you will have a month later.
> By the way, your devices show scterc disabled.  That's bad.  You should
> definitely use boot scripts or udev rules to enable it.

Ooops, thank you for catching this, well understood how bad it is, I 
just assumed (badly) that I was using decent drives (I always used the 
WD enterprise black), and clearly forgot to check for this on an SSD. 
I've enabled it now from /etc/rc.local, as well as fixing the scheduler 
to noop on the SSD instead of cfq.

> Has sdd been getting bumped out of the array lately, and resyncing when
> you put it back?
No, but I wonder if this might have explained the drop from around 9 
months ago, when I re-plugged it and it tested fine, but I asked them to 
replace it anyway (which they did). So, I can't complain about it too much.

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
