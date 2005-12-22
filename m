From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: First RAID Setup
Date: Thu, 22 Dec 2005 09:20:22 -0500
Message-ID: <43AAB626.3060708@tmr.com>
References: <0481A62A3E95A044AC20A1A45899645C06B02F4B@glc-mail-1.tessco.com> <43A1D642.2010301@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43A1D642.2010301@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: "Callahan, Tom" <CallahanT@tessco.com>, 'Andargor The Wise' <andargor@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brad Campbell wrote:

> Callahan, Tom wrote:
>
>> It is always wise to build in a spare however, that being said about all
>> raid levels. In your configuration, if a disk fails in your RAID5, your
>> array will go down. RAID5 is usually 3+ disks, with a mirror. So you 
>> should
>> have 3 disks at minimum, and then a 4th as a spare.
>>
>
> /me wonders in the days of reliable RAID-6 why we use RAID-5 + spare?
>
> RAID-6 has saved me twice now from dual drive failures on a 15 disk 
> array.
> It's schweeeeeeeeeett 


It's also a lot more overhead... RAID-5 needs to update just one parity 
block beyond the data written. As I understand the Q sum in RAID-6, and 
watching disk access rates, each write requires the entire stripe to be 
read, then P and Q calculated, then written. You can do the P with a 
read+write, but since you have to read the entire stripe for Q, you save 
a read by recalculating the P from data.

Did I say that right, Neil?

If you are seeing dual drive failures, I suspect your hardware has 
problems. We run multiple 3 and 6 TB databases, and over a dozen 1 TB 
data caching servers, all using a lot of small fast disk, and I haven't 
seen a real dual drive failure in  about 8 years.

We did see some cases which looked like dual failures, it turned out to 
be a firmware limitation, controller not waiting for the bus to settle 
after a real failure, and thinking the next i/o had failed (or similar, 
in any case a false fail on the transaction after the real fail). If you 
run two PATA drives on the same cable in master/slave, it's at least 
possible that this could happen with consumer grade hardware as well. 
Just a thought, dual failures are VERY unlikely unless one triggers the 
other in some way, like failing the bus or cabinet power supply.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

