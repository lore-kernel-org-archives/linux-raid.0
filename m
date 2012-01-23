From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Raid 6--best practices
Date: Mon, 23 Jan 2012 00:26:23 -0600
Message-ID: <4F1CFD8F.7080608@hardwarefreak.com>
References: <4F173D3D.6070902@npr.org>,<CF17461882827E43AD7DF6E471FFA903834EFD7853@EXCHANGE.ads.npr.org> <CF17461882827E43AD7DF6E471FFA903834EFD7858@EXCHANGE.ads.npr.org> <jfbfk6$gqk$1@dough.gmane.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <jfbfk6$gqk$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/20/2012 4:24 AM, David Brown wrote:

> I wouldn't bother dedicating a spare to each RAID-6 - I would rather
> have the spares in a pool that can be used by any of the low-level raids.
> 
> Before it is possible to give concrete suggestions, it is vital to know
> the usage of the system.  Are you storing mostly big files, mostly small
> ones, or a mixture?  What are the read/write ratios?  Do you have lots
> of concurrent users, or only a few - and are they accessing wildly
> different files or the same ones?  How important is uptime?  How
> important are fast rebuilds/resyncs?  How important is array speed
> during rebuilds?  What sort of space efficiencies do you need?  What
> redundancies do you really need?  What topologies do you have that
> influence speed, failure risks, and redundancies (such as multiple
> controllers/backplanes/disk racks)?  Are you using hardware raid
> controllers in this mix, or just software raid?  Are you planning to be
> able to expand the system in the future with more disks or bigger disks?
> 
> There are lots of questions here, and no immediate answers.  I certainly
> wouldn't fixate on a concatenation of RAID-6 arrays before knowing a bit
> more - it's not the only way to tie together 48 disks, and it may not be
> the best balance.

Glad I read your post before typing my response David.  You hit almost
every important point here.  You've identified the OP's one big mistake
which is:

"I have these 48 disks and I'm trying to figure out how best to use them."

What the OP should be asking himself is:

"I have a mix of applications and administration needs.  How best can I
utilize this set of 48 disks to serve both?"

Do you plan to make use of VFS snapshots?  Do you actually need any of
the functionality that LVM provides?  If not consider directly
formatting your RAID devices with XFS.  Also, do NOT use partitions, and
make sure you align XFS to the underlying RAID stripe, or your
performance will drop by a factor of 2 instantly with parity RAID.  If
you need help with mkfs.xfs stripe alignment ask on the XFS list.  If
you don't format the RAID device correctly performance will really suck
(technical term).

NOTE:  You _need_ to have already decided what RAID level and
configuration you plan to use before asking about stripe alignment, as
it is different for every single configuration.  I.e. changing from a 16
disk array to 14, or changing from RAID6 to RAID10, totally changes
filesystem alignment parameters.  You only make the filesystem once, so
the parms must be right, or performance suffers horribly.

-- 
Stan
