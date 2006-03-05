From: Gordon Henderson <gordon@drogon.net>
Subject: Re: 4 disks: RAID-6 or RAID-10 ..
Date: Sun, 5 Mar 2006 20:59:49 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0603052014340.11005@lion.drogon.net>
References: <Pine.LNX.4.56.0602171100420.22063@lion.drogon.net>
 <43F5B707.3030005@panix.com>  <Pine.LNX.4.56.0602171153090.22063@lion.drogon.net>
 <fd8d0180602170407ib160644v@mail.gmail.com> <Pine.LNX.4.56.0602171445280.22063@lion.drogon.net>
 <440B2CA5.8010307@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <440B2CA5.8010307@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 5 Mar 2006, Bill Davidsen wrote:

> >Still scratching my head, trying to work out if raid-10 can withstand
> >(any) 2 disks of failure though, although after reading md(4) a few times
> >now, I'm begining to think it can't (unless you are lucky!) So maybe I'll
> >just stick with Raid-6 as I know that!
> >
>
> With only four drives you can just do the possible failure cases, there
> are only six... when any one drive fails you can only survive the
> failure of two of the three remaining drives, not what you wanted. How
> reliable do you NEED here is the real question.

Well this was a few weeks ago and after working things out, then things
changed a little, and I decided to make a change to the server - it's now
a 5-disk RAID-6 system, and it's working just fine.

> It isn't too hard to make the drives more reliable than the case they're
> in, how many fans and power supplies can you survive losing?

This is true, but my experience of PCs over the past 10 years has been
that drives fail on average more than anything else - especially when you
have more hard drives in a box than anything else! (but I've no hard
statistical data to back this up - it's just my overvations!)

Anyway, just in-case, I do like to test things as much as I can before
taking them to the datacentre - and it appears to work with all 3 case
fans unplugged without overheating.  There's a redundant PSU, and it even
works with the processor fan turned off - slowly, but workable. I run
lm-sensors and hddtemp (although hddtemp is lying to me - it's reading 20C
too high for the drives I have in it )-: it's remotely monitored, (nagios)
and I get called & TXTd by the monitoring server should anything go wrong.

All its working set data is backed up on another server in the same place,
(rsync, overnight) and it's acting as a backup for a dozen other servers
(in the same place) so should the mobo blow up then I can recover and the
other server can assume IP addresses, etc. It's not quite "high
avalability" in that it requires human intervention to bring the backup
server online, but it's good enough for my purposes, (and my clients!),
and you have to draw the line somewhere!

(And how many single CPU, single drive RAQs out there just humming away in
datacentres all over the world.. Hmm, maybe they're onto something ;-)

Cheers,

Gordon
