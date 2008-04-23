From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Question: how to identify failing disk in a RAID1
Date: Wed, 23 Apr 2008 15:26:03 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0804231525140.4441@p34.internal.lan>
References: <48025B8D.2030803@harddata.com> <alpine.DEB.1.10.0804131529300.11311@p34.internal.lan> <4802AFEB.9020006@tmr.com> <480F7105.9030405@harddata.com> <alpine.DEB.1.10.0804231453390.4441@p34.internal.lan> <480F8830.6020207@harddata.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <480F8830.6020207@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 23 Apr 2008, Maurice Hilarius wrote:

> Justin Piszcz wrote:
>> 
>> 
>> On Wed, 23 Apr 2008, Maurice Hilarius wrote:
>> 
>>> Hi all.
>>> 
>>> With much appreciated help from Bell Davidsen and Justin Piszcz I recently 
>>> dealt with a problem with a RAID1 set, caused by a failing hard disk.
>>> 
>>> At the end, there is one question remaining, which I think is quite 
>>> important:
>>> When one has a RAID5 or RAID6, and a disk starts "acting up" mdadm rapidly 
>>> kicks out the offending device.
>>> Some might say "too easily" but that is another thread.
>>> 
>>> On a RAID1 set, until the failing disk completely "packs it in" it remains 
>>> part of the RAID.
>>> 
>>> Why??
>>> 
>>> Some more background:
>>> Since the issue was reported and explored I have recreated this on a test 
>>> machine.
>>> Installed RAID1 with one known good and one know error prone drive.
>>> Easy to do as the error drive has a thermal issue.
>>> Keep it cold, no problems, but after 30 minutes use in a +25C room it 
>>> start to generate data errors.
>>> I reproduced exactly the problem I saw before:
>>> Data errors occur, the other drive in the RAID1 set gets "infected" with 
>>> the bad data, and the file system will get corrupted.
>>> On BOTH drives.
>>> 
>>> This is highly reproducible.
>>> 
>>> In summary:
>>> 1) RAID1 lacks significant protection from the effects of a data error 
>>> condition on a failing drive
>>> 2) I recommend anyone using madadm refrain from using RAID1 until this 
>>> issue is addressed and resolved.
>>> 
>>> Thanks again.
>> I can confirm this, until you actually REBOOT the host with RAID1 only then 
>> will it kick it out.  Whereas with RAID5, I experienced the same thing, it 
>> kicks it out right away, would need to wait for the linux-raid/developers 
>> to answer this one.
>> 
>> Justin.
>> 
> Actually reboot does not help me.
> mdadm seems to NEVER "kick out" the bad disk.
> Even when it is horribly erroring.
>
> I think this is a CRITICAL problem, as, if one is using RAID1 thinking it 
> will enhance their data reliability,
> they stand a very good chance of getting a nasty surprise.
Yikes, what kernel+mobo+chipset+drives are in use (the developers will 
want to know) also are you using drives on different channels?  Or e.g., 
two drives on one ide cable?  (To summarize for the developers)

Justin.
