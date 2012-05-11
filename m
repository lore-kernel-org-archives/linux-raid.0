From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: thanks md raid
Date: Thu, 10 May 2012 21:09:44 -0500
Message-ID: <4FAC74E8.7040108@hardwarefreak.com>
References: <4FAC0ED2.2000201@pocock.com.au> <4FAC37D9.6040403@hardwarefreak.com> <4FAC387E.1010006@pocock.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FAC387E.1010006@pocock.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/10/2012 4:51 PM, Daniel Pocock wrote:
> 
> 
> On 10/05/12 21:49, Stan Hoeppner wrote:
>> On 5/10/2012 1:54 PM, Daniel Pocock wrote:
>>>
>>> I'm glad my RAID1 worked as expected... just hoping I don't encounter
>>> any read timeouts on the non-TLER drive before my rebuild finishes:
>>
>> You have an inverse understanding of ERC.  Drives without ERC will retry
>> forever, or until an upper layer puts a stop to its efforts.  Drives
>> with a 7 second ERC will return a hard error after 7 seconds.
>>
>> So the only way you'll get a timeout with your rebuild is if the healthy
>> drive spends 30 seconds retying a sector read.
>>
> 
> I was thinking about the more obscure case - that some other URE
> followed by an attempt at write access on the good drive fails and it
> becomes degraded

If drives were that damn fragile modern computing wouldn't exist.  The
odds of your UPS taking a dump during a rebuild are greater than the
scenario you just described.  You need to put more thought into UPS
failure scenarios than ERC.

I mention this specifically because my "desktop" APC Backups XS 900 did
the unthinkable the other day.  Apparently it decided the batteries were
bad at the very moment it ran its hard scheduled self test.  Class, what
happens with all APC UPSes when the scheduled self test runs and the
batteries have been flagged bad?  Answer:  it drops the load and causes
your system to reboot.

One would think APC would be smart enough to have the firmware skip the
self test until after the batteries have been replaced, specifically to
prevent an unplanned power event, the whole purpose of a UPS.  I guess
one of their actuaries figured they'd get more battery sales if they
keep downing your system until you replace them...

-- 
Stan
