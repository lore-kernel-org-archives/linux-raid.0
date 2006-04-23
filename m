From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: disks becoming slow but not explicitly failing anyone?
Date: Sun, 23 Apr 2006 14:04:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0604231344470.18611-100000@coffee.psychology.mcmaster.ca>
References: <87d5f8s982.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d5f8s982.fsf@hades.wkstn.nix>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I've seen a lot of cheap disks say (generally deep in the data sheet
> that's only available online after much searching and that nobody ever
> reads) that they are only reliable if used for a maximum of twelve hours
> a day, or 90 hours a week, or something of that nature. Even server

I haven't, and I read lots of specs.  they _will_ sometimes say that 
non-enterprise drives are "intended" or "designed" for a 8x5 desktop-like
usage pattern.  to the normal way of thinking about reliability, this would 
simply mean a factor of 4.2x lower reliability - say from 1M to 250K hours
MTBF.  that's still many times lower rate of failure than power supplies or 
fans.

> It still stuns me that anyone would ever voluntarily buy drives that
> can't be left switched on (which is perhaps why the manufacturers hide

I've definitely never seen any spec that stated that the drive had to be 
switched off.  the issue is really just "what is the designed duty-cycle?"

I run a number of servers which are used as compute clusters.  load is
definitely 24x7, since my users always keep the queues full.  but the servers
are not maxed out 24x7, and do work quite nicely with desktop drives
for years at a time.  it's certainly also significant that these are in a 
decent machineroom environment.

it's unfortunate that disk vendors aren't more forthcoming with their drive
stats.  for instance, it's obvious that "wear" in MTBF terms would depend 
nonlinearly on the duty cycle.  it's important for a customer to know where 
that curve bends, and to try to stay in the low-wear zone.  similarly, disk
specs often just give a max operating temperature (often 60C!), which is 
almost disingenuous, since temperature has a superlinear effect on reliability.

a system designer needs to evaluate the expected duty cycle when choosing
disks, as well as many other factors which are probably more important.
for instance, an earlier thread concerned a vast amount of read traffic 
to disks resulting from atime updates.  obviously, just mounting noatime 
will improve the system's reliability.  providing a bit more memory on a 
fileserver to cache and eliminate IOs is another great way to help out.
simply using more disks also decreases the load per disk, though this is 
clearly only a win if it's the difference in staying out of the disks 
"duty-cycle danger zone" (since more disks divide system MTBF).

regards, mark hahn.

