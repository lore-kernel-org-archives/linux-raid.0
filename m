From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Raid6 array crashed-- 4-disk failure...(?)
Date: Tue, 16 Sep 2008 15:06:15 -0400
Message-ID: <48D003A7.4040207@tmr.com>
References: <48CE250C.8000603@ultratux.net> <18638.16613.435533.269946@tree.ty.sabi.co.uk> <48CE9411.4060201@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48CE9411.4060201@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: Maarten <maarten@ultratux.net>
Cc: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Maarten wrote:
> Peter Grandi wrote:
>>> This weekend I promoted my new 6-disk raid6 array to
>>> production use and was busy copying data to it overnight. The
>>> next morning the machine had crashed, and the array is down
>>> with an (apparent?) 4-disk failure, [ ... ]
>>
>> Multiple drive failures are far more common than people expect,
>> and the problem lies in people's expectations, because they don't
>> do common mode analysis (what's what? many will think).
>
> It IS more common indeed. I'm on my seventh or eight raid-5 array now, 
> the first was a 4-disk raid5 40(120) GB array. I've had 4 or 5 
> two-disk failures happen to me over the years, invariably during 
> rebuild, indeed.
> This is why I'm switching over to raid-6, by the way.
>
> I did not, at any point, lose the array with the two-disk failures 
> though. I intelligently cloned bad drives with dd_rescue and 
> reassembled those degraded arrays using the new disks and thus got my 
> data back.
> But still, such events tend to keep me busy for a whole weekend, which 
> is not too pleasant.
>
>> They typically happen all at once at power up, or in short
>> succession (e.g. 2nd drive fails while syncing to recover from
>> 1st failure).
>>
>> The typical RAID has N drives from the same manufacturer, of the
>> same model, with nearly contiguous serial numbers, from the same
>> shipping carton, in an enclosure where they all are started and
>> stopped at the same time, run on the same power circuit, at the
>> same temperature, on much the same load, attached to the same
>> host adapter or N of the same type. Expecting as many do to have
>> uncorrelated failures is rather comical.
>
> This is true. However, since I know this fact I tend to take care to 
> not make it too vulnerable; the system is incredibly well cooled, it 
> has 8 80mm fans that cool the 16(!) disks, I buy disks in batches of 
> 2, from different brands and vendors. It indeed has just one PSU, but 
> I chose a good one, I think it's a Tagan 550 Watt unit.
>
> In fact -this is my home system- since I cannot afford a DLT drive for 
> this much data I practically have no backup, so I really spend a lot 
> of effort making sure the array stays ok. Yes, I know, this not a good 
> idea, but how do I economically backup 3 TB ?
> In practice I have older disks and/or decommisioned arrays with 
> "backups" but this is of course not up to date at all.
Given the low cost of USB connected TB drives, I would say "look there" 
rather than expect to be able to keep any system totally reliable.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


