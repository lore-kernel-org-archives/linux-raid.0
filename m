From: maarten van den Berg <maarten@vbvb.nl>
Subject: Re: new problem has developed
Date: Thu, 30 Oct 2003 14:14:45 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310301414.45160.maarten@vbvb.nl>
References: <Pine.LNX.4.44.0310290050190.10948-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0310290050190.10948-100000@coffee.psychology.mcmaster.ca>
To: Mark Hahn <hahn@physics.mcmaster.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 29 October 2003 06:52, Mark Hahn wrote:
> > For various reasons I decided to decommission the old hardware (AMD K6)
> > and I built a newer (and 100% known-good) board in it earlier today. That
> > makes a BIG difference in initial speed, I now get 14000K/sec instead of
> > the dead slow AMD K6 did. However, at 5.2% the speed drops significantly.
> > We're now back at 5.3% and speed has dropped from 13000K to 170K and
> > continues to drop.
>
> this sort of thing *can* actually occur because of sick disks.

Thanks for replying.  Yes, it was a bad disk and I solved it eventually.

> > I investigated already on the old machine with several tools, of course
> > mdadm, but also iostat and keeping an eye on /var/log/messages.  All
> > seems proper.
>
> smartctl on the disks?

If only my BIOS would support that... :-( 
I don't know if it's the main BIOS or the promise cards that must support it, 
but 'ide-smart' just gives no output at all.

I did a 'badblocks' on one disk that was part of the array but already got 
kicked twice from it.  Lo and behold, starting at about 4GB it developed a 
problem (slow reads due to endless retries).  As I desperately NEEDED this 
drive (my array was already degraded!) I decided to use 'dd_rescue' to clone 
it to a good disk and re-assemble the array from there. The dd_rescue 
operation took more than 30 hours(!) and showed that there was a problem 
around the 4GB and also around 71 GB markers. Several MB could not be 
recovered (which is close to nothing, percentage-wise).
Mdadm then reassembled the array with the fresh drive, and subsequent 
hot-adding went as fast as it should. One day later I added a new hot-spare. 
All is well now. I will surely find corrupted data at some point due to the 
missing MB's.  But I see no way to avoid this anyhow...
I just hope it is a file, not reiserfs meta-data, that got killed.

Taking into account that dd_rescue took 30 hours it stands to reason that 
maybe the resync would have worked after all, if only I would have let it run 
longer.  The problem is partly that the resync just seems to grind to a halt, 
whereas dd_rescue is much more verbose in what it does.  If I could 
distinguish between a 'crash' and a slow process (that still works -albeit 
slow) this probably wouldn't have happened. Well, now we know...

> > I'm unsure if this could be due to a disk hardware fault but then it
> > would surely show up in syslog, right ?
>
> no.  there's no syslog-over-ata/scsi afaikt ;)
>
> > Could disk corruption be the culprit ? My
>
> I'd guess vibration.  I've experienced several kinds of recent disks that
> under bad conditions (vibration, near-death) just get amazingly slow,
> but continue to work.  this is, of course, really, really good...

They vibrate, yeah.  That's just what happens if you put eight disks together 
in a cabinet and put two 120mm papst fans right in front of them...  ;-)
(But at least they stay quite cool, really quite cool...)

Maarten

-- 
Yes of course I'm sure it's the red cable. I guarante[^%!/+)F#0c|'NO CARRIER
