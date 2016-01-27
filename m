From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Uneven wear on raid1 devices
Date: Wed, 27 Jan 2016 11:05:31 +1100
Message-ID: <56A809CB.8070207@websitemanagers.com.au>
References: <56A5B29E.3020708@websitemanagers.com.au>
 <20160125104027.597041a3@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160125104027.597041a3@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 25/01/16 16:40, Roman Mamedov wrote:
> On Mon, 25 Jan 2016 16:29:02 +1100
> Adam Goryachev <adam@websitemanagers.com.au> wrote:
>
>>     9 Power_On_Hours          -O--CK   098   098   000    -    6435
>>     9 Power_On_Hours          -O--CK   095   095   000    -    23178
> 2nd drive has almost 4x as much power-on time than the first one. My guess
> would be that it accumulated all that write usage back before you put it into
> this RAID1.
>
> If you want to ensure the RAID1 usage is even, record the SMART data you have
> now, and compare to the readings you will have a month later.

Hmmm, oops, I should have looked at that. Now of course, I realise one 
drive was replaced under warranty when it failed around 6 months ago 
(well, the value says just under 9 months actually), and that would 
explain the difference in wear and power on hours (aside from the 
initial full sync when the new device was first installed).

So, 2.5 years old, and 74% life remaining, and 9 months with 93% life 
remaining.

Sounds good to me, I should expect these to last at least the 5 years I 
was hoping for, and probably before that happens I will want to upgrade 
them to increase capacity anyway.

Thanks for your help

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
