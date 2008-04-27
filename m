From: Keith Roberts <keith@karsites.net>
Subject: Re: Question: how to identify failing disk in a RAID1
Date: Sun, 27 Apr 2008 18:03:19 +0100 (BST)
Message-ID: <alpine.LFD.1.10.0804271758360.18247@www.karsites.net>
References: <48025B8D.2030803@harddata.com>
	<alpine.DEB.1.10.0804131529300.11311@p34.internal.lan>
	<4802AFEB.9020006@tmr.com> <480F7105.9030405@harddata.com>
	<alpine.DEB.1.10.0804231453390.4441@p34.internal.lan>
	<480F8830.6020207@harddata.com>
	<alpine.DEB.1.10.0804231525140.4441@p34.internal.lan>
Reply-To: Keith Roberts <keith@karsites.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0804231525140.4441@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 23 Apr 2008, Justin Piszcz wrote:

> To: Maurice Hilarius <maurice@harddata.com>
> From: Justin Piszcz <jpiszcz@lucidpixels.com>
> Subject: Re: Question: how to identify failing disk in a RAID1
> 
>
>
> On Wed, 23 Apr 2008, Maurice Hilarius wrote:
>
>> Justin Piszcz wrote:
>>> 
>>> 
>>> On Wed, 23 Apr 2008, Maurice Hilarius wrote:
>>> 
>>>> Hi all.
>>>> 
>>>> With much appreciated help from Bell Davidsen and Justin Piszcz I 
>>>> recently dealt with a problem with a RAID1 set, caused by a failing 
>>>> hard disk.
>>>> 
>>>> At the end, there is one question remaining, which I think is quite 
>>>> important:
>>>> When one has a RAID5 or RAID6, and a disk starts "acting up" mdadm 
>>>> rapidly kicks out the offending device.
>>>> Some might say "too easily" but that is another thread.
>>>> 
>>>> On a RAID1 set, until the failing disk completely "packs it in" it 
>>>> remains part of the RAID.
>>>> 
>>>> Why??
>>>> 
>>>> Some more background:
>>>> Since the issue was reported and explored I have recreated this on a 
>>>> test machine.
>>>> Installed RAID1 with one known good and one know error prone drive.
>>>> Easy to do as the error drive has a thermal issue.
>>>> Keep it cold, no problems, but after 30 minutes use in a +25C room it 
>>>> start to generate data errors.
>>>> I reproduced exactly the problem I saw before:
>>>> Data errors occur, the other drive in the RAID1 set gets "infected" 
>>>> with the bad data, and the file system will get corrupted.
>>>> On BOTH drives.
>>>> 
>>>> This is highly reproducible.
>>>> 
>>>> In summary:
>>>> 1) RAID1 lacks significant protection from the effects of a data 
>>>> error condition on a failing drive
>>>> 2) I recommend anyone using madadm refrain from using RAID1 until 
>>>> this issue is addressed and resolved.
>>>> 
>>>> Thanks again.
>>> I can confirm this, until you actually REBOOT the host with RAID1 only 
>>> then will it kick it out.  Whereas with RAID5, I experienced the same 
>>> thing, it kicks it out right away, would need to wait for the 
>>> linux-raid/developers to answer this one.
>>> 
>>> Justin.
>>> 
>> Actually reboot does not help me.
>> mdadm seems to NEVER "kick out" the bad disk.
>> Even when it is horribly erroring.
>> 
>> I think this is a CRITICAL problem, as, if one is using RAID1 thinking 
>> it will enhance their data reliability,
>> they stand a very good chance of getting a nasty surprise.
> Yikes, what kernel+mobo+chipset+drives are in use (the developers will 
> want to know) also are you using drives on different channels?  Or e.g., 
> two drives on one ide cable?  (To summarize for the developers)
>
> Justin.

I'm now looking at using smartmontools to monitor my hard 
drive's status, maybe instead of using RAID1 arrays.

http://en.wikipedia.org/wiki/S.M.A.R.T.

http://smartmontools.sourceforge.net/

It appears that smartmontools will not work with the linux 
software RAID layer. So I guess I need to make a choice of 
which one to use - smartmontools or RAID1 mirrors?

Obviously I don't want to be mirroring corrupted drive data.

It would be nice to be able to use smartmontools to monitor 
the health of the drives in a RAID1 array. Get the best of 
both worlds then.

Is there any way that the smartmontools code can be included 
in the md driver code, to allow mdadm access to the SMART 
data on a RAID1 set of disks please?

Kind Regards

Keith Roberts

-----------------------------------------------------------------
Websites:
http://www.php-debuggers.net
http://www.karsites.net
http://www.raised-from-the-dead.org.uk

All email addresses are challenge-response protected with
TMDA [http://tmda.net]
-----------------------------------------------------------------


