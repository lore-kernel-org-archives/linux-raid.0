From: Nix <nix@esperi.org.uk>
Subject: Re: disks becoming slow but not explicitly failing anyone?
Date: Mon, 24 Apr 2006 20:20:22 +0100
Message-ID: <874q0irdah.fsf@hades.wkstn.nix>
References: <Pine.LNX.4.44.0604231344470.18611-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0604231344470.18611-100000@coffee.psychology.mcmaster.ca> (Mark Hahn's message of "23 Apr 2006 19:04:34 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23 Apr 2006, Mark Hahn stipulated:
>> I've seen a lot of cheap disks say (generally deep in the data sheet
>> that's only available online after much searching and that nobody ever
>> reads) that they are only reliable if used for a maximum of twelve hours
>> a day, or 90 hours a week, or something of that nature. Even server
> 
> I haven't, and I read lots of specs.  they _will_ sometimes say that 
> non-enterprise drives are "intended" or "designed" for a 8x5 desktop-like
> usage pattern.

That's the phrasing, yes: foolish me assumed that meant `if you leave it
on for much longer than that, things will go wrong'.

>                 to the normal way of thinking about reliability, this would 
> simply mean a factor of 4.2x lower reliability - say from 1M to 250K hours
> MTBF.  that's still many times lower rate of failure than power supplies or 
> fans.

Ah, right, it's not a drastic change.

>> It still stuns me that anyone would ever voluntarily buy drives that
>> can't be left switched on (which is perhaps why the manufacturers hide
> 
> I've definitely never seen any spec that stated that the drive had to be 
> switched off.  the issue is really just "what is the designed duty-cycle?"

I see. So it's just `we didn't try to push the MTBF up as far as we would
on other sorts of disks'.

> I run a number of servers which are used as compute clusters.  load is
> definitely 24x7, since my users always keep the queues full.  but the servers
> are not maxed out 24x7, and do work quite nicely with desktop drives
> for years at a time.  it's certainly also significant that these are in a 
> decent machineroom environment.

Yeah; i.e., cooled. I don't have a cleanroom in my house so the RAID
array I run there is necessarily uncooled, and the alleged aircon in the
room housing work's array is permanently on the verge of total collapse
(I think it lowers the temperature, but not by much).

> it's unfortunate that disk vendors aren't more forthcoming with their drive
> stats.  for instance, it's obvious that "wear" in MTBF terms would depend 
> nonlinearly on the duty cycle.  it's important for a customer to know where 
> that curve bends, and to try to stay in the low-wear zone.  similarly, disk

Agreed! I tend to assume that non-laptop disks hate being turned on and
hate temperature changes, so just keep them running 24x7. This seems to be OK,
with the only disks this has ever killed being Hitachi server-class disks in
a very expensive Sun server which was itself meant for 24x7 operation; the
cheaper disks in my home systems were quite happy. (Go figure...)

> specs often just give a max operating temperature (often 60C!), which is 
> almost disingenuous, since temperature has a superlinear effect on reliability.

I'll say. I'm somewhat twitchy about the uncooled 37C disks in one of my
machines: but one of the other disks ran at well above 60C for *years*
without incident: it was an old one with no onboard temperature sensing,
and it was perhaps five years after startup that I opened that machine
for the first time in years and noticed that the disk housing nearly
burned me when I touched it. The guy who installed it said that yes, it
had always run that hot, and was that important? *gah*

I got a cooler for that disk in short order.

> a system designer needs to evaluate the expected duty cycle when choosing
> disks, as well as many other factors which are probably more important.
> for instance, an earlier thread concerned a vast amount of read traffic 
> to disks resulting from atime updates.

Oddly, I see a steady pulse of write traffic, ~100Kb/s, to one dm device
(translating into read+write on the underlying disks) even when the
system is quiescient, all daemons killed, and all fsen mounted with
noatime. One of these days I must fish out blktrace and see what's
causing it (but that machine is hard to quiesce like that: it's in heavy
use).

> simply using more disks also decreases the load per disk, though this is 
> clearly only a win if it's the difference in staying out of the disks 
> "duty-cycle danger zone" (since more disks divide system MTBF).

Well, yes, but if you have enough more you can make some of them spares
and push up the MTBF again (and the cooling requirements, and the power
consumption: I wish there was a way to spin down spares until they were
needed, but non-laptop controllers don't often seem to provide a way to
spin anything down at all that I know of).

-- 
`On a scale of 1-10, X's "brokenness rating" is 1.1, but that's only
 because bringing Windows into the picture rescaled "brokenness" by
 a factor of 10.' --- Peter da Silva
