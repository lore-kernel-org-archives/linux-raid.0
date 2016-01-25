From: Phil Turmel <philip@turmel.org>
Subject: Re: Uneven wear on raid1 devices
Date: Mon, 25 Jan 2016 13:00:03 -0500
Message-ID: <56A662A3.6000402@turmel.org>
References: <56A5B29E.3020708@websitemanagers.com.au>
 <20160125104027.597041a3@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160125104027.597041a3@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>, Adam Goryachev <adam@websitemanagers.com.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/25/2016 12:40 AM, Roman Mamedov wrote:
> On Mon, 25 Jan 2016 16:29:02 +1100
> Adam Goryachev <adam@websitemanagers.com.au> wrote:
> 
>>    9 Power_On_Hours          -O--CK   098   098   000    -    6435
> 
>>    9 Power_On_Hours          -O--CK   095   095   000    -    23178
> 
> 2nd drive has almost 4x as much power-on time than the first one. My guess
> would be that it accumulated all that write usage back before you put it into
> this RAID1.

Or you are doing "repair" scrubs when you should be doing "check"
scrubs.  Any operation that requires resynchronization will read from
the first mirror and write to the others.

> If you want to ensure the RAID1 usage is even, record the SMART data you have
> now, and compare to the readings you will have a month later.

By the way, your devices show scterc disabled.  That's bad.  You should
definitely use boot scripts or udev rules to enable it.

Has sdd been getting bumped out of the array lately, and resyncing when
you put it back?

Phil

