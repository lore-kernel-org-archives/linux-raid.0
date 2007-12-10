From: Tejun Heo <htejun@gmail.com>
Subject: Re: Kernel 2.6.23.9 / P35 Chipset + WD 750GB Drives (reset port)
Date: Mon, 10 Dec 2007 17:14:54 +0900
Message-ID: <475CF57E.7060406@gmail.com>
References: <Pine.LNX.4.64.0712010619150.25643@p34.internal.lan> <Pine.LNX.4.64.0712011310410.30316@fbirervta.pbzchgretzou.qr> <4751AB91.2000207@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4751AB91.2000207@tmr.com>
Sender: linux-ide-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids

Bill Davidsen wrote:
> Jan Engelhardt wrote:
>> On Dec 1 2007 06:26, Justin Piszcz wrote:
>>> I ran the following:
>>>
>>> dd if=/dev/zero of=/dev/sdc
>>> dd if=/dev/zero of=/dev/sdd
>>> dd if=/dev/zero of=/dev/sde
>>>
>>> (as it is always a very good idea to do this with any new disk)
>>
>> Why would you care about what's on the disk? fdisk, mkfs and
>> the day-to-day operation will overwrite it _anyway_.
>>
>> (If you think the disk is not empty, you should look at it
>> and copy off all usable warez beforehand :-)
>>
> Do you not test your drive for minimum functionality before using them?

I personally don't.

> Also, if you have the tools to check for relocated sectors before and
> after doing this, that's a good idea as well. S.M.A.R.T is your friend.
> And when writing /dev/zero to a drive, if it craps out you have less
> emotional attachment to the data.

Writing all zero isn't too useful tho.  Drive failing reallocation on
write is catastrophic failure.  It means that the drive wanna relocate
but can't because it used up all its extra space which usually indicates
something else is seriously wrong with the drive.  The drive will have
to go to the trash can.  This is all serious and bad but the catch is
that in such cases the problem usually stands like a sore thumb so
either vendor doesn't ship such drive or you'll find the failure very
early.  I personally haven't seen any such failure yet.  Maybe I'm lucky.

Most data loss occurs when the drive fails to read what it thought it
wrote successfully and the opposite - reading and dumping the whole disk
to /dev/null periodically is probably much better than writing zeros as
it allows the drive to find out deteriorating sector early while it's
still readable and relocate.  But then again I think it's an overkill.

Writing zeros to sectors is more useful as cure rather than prevention.
 If your drive fails to read a sector, write whatever value to the
sector.  The drive will forget about the data on the damaged sector and
reallocate and write new data to it.  Of course, you lose data which was
originally on the sector.

I personally think it's enough to just throw in an extra disk and make
it RAID0 or 5 and rebuild the array if read fails on one of the disks.
If write fails or read fail continues, replace the disk.  Of course, if
you wanna be extra cautious, good for you.  :-)

-- 
tejun
