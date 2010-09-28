From: Nagilum <nagilum@nagilum.org>
Subject: Re: Accidental grow before add
Date: Tue, 28 Sep 2010 17:14:51 +0200
Message-ID: <20100928171451.27293d0o1kotcfi8@cakebox.homeunix.net>
References: <AANLkTi=PydpqTR1x=KTfW16en3U3+KxoLV85iWpWtRC9@mail.gmail.com>
 <193703.58642.qm@web51305.mail.re2.yahoo.com>
 <AANLkTimWyuvf1_9H8QhLXQ5gYRya1ux6WFGS4EPWP5_U@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-2;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimWyuvf1_9H8QhLXQ5gYRya1ux6WFGS4EPWP5_U@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hartman <mike@hartmanipulation.com>
Cc: Jon@ehardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Message from mike@hartmanipulation.com ---------

>> I am more interested to know why it kicked off a reshape that would  
>> leave the array in a degraded state without a warning and
>> needing a '--force' are you sure there wasn't capacity to 'grow' anyway?
>
> Positive. I had no spare of any kind and mdstat was showing all disks
> were in use.

Yep, a warning/safety net would be good. At the moment mdadm assumes  
you know what you're doing.

> Now I've got the new drive in there as a spare, but it
> was added after the reshape started and mdadm doesn't seem to be
> trying to use it yet. I'm thinking it's going through the original
> reshape I kicked off (transforming it from an intact 7 disk RAID 6 to
> a degraded 8 disk RAID 6) and then when it gets to the end it will run
> another reshape to pick up the new spare.

Yes, that's what's going to happen.

>> Also, when i first ran my reshape it was incredibly slow from  
>> Raid5~6 tho.. it literally took days.
> I did a RAID 5 -> RAID 6 conversion the other week and it was also
> slower than a normal resizing, but only 2-2.5 times as slow. Adding a
> new disk usually takes a bit less than 2 days on this array and that
> conversion took closer to 4. However, at the slowest rate I reported
> above it would have taken something 11 months - definitely a whole
> different ballpark.

Yeah that was due to the disk errors.
I find "iostat -d 2 -kx" helpful to understand what's going on.

> At any rate, apparently one of my other drives in the array was
> throwing some read errors. Eventually it did something unrecoverable
> and was dropped from the array. Once that happened the speed returned
> to a more normal level, but I stopped the arrays to run a complete
> read test on every drive before continuing. With an already degraded
> array, losing that drive killed any failure buffer I had left. I want
> to make quite sure all the other drives will finish the reshape
> properly before risking it. Then I guess it's just a matter of waiting
> 3 or 4 days for both reshapes to complete.

Yep, I once got bitten by a linux kernel bug that caused the RAID5 to  
corrupt when a drive failed during reshape. I managed to recover though.
Since then I always do a raid-check before starting any changes.
Good luck and thanks for the story so far.
Alex.

========================================================================
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
========================================================================


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..
