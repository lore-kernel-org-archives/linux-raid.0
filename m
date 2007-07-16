From: "Bryan J. Smith" <b.j.smith@ieee.org>
Subject: [Advocacy] Re: 3ware 9650 tips
Date: Mon, 16 Jul 2007 13:15:32 -0400
Message-ID: <1184606132.4551.11.camel@portatux64.mobile.smithconcepts.com>
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu>
	 <Pine.LNX.4.64.0707131434470.31742@p34.internal.lan>
	 <4697CA4D.6020304@etelos.com>
	 <Pine.LNX.4.64.0707131535270.2064@p34.internal.lan>
	 <20070716024115.GJ12413810@sgi.com>
	 <alpine.LRH.0.999.0707161142440.25773@chaos.egr.duke.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.0.999.0707161142440.25773@chaos.egr.duke.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Joshua Baker-LePain <jlb17@duke.edu>
Cc: David Chinner <dgc@sgi.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, Jon Collette <jon@etelos.com>, linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

Off-topic, advocacy-level response ...  

On Mon, 2007-07-16 at 11:43 -0400, Joshua Baker-LePain wrote:
> I do so wish that RedHat shared this view...

I've been trying to convince them since Red Hat Linux 7 (and, later, 9)
that they need to realize the limits of Ext3 at the enterprise end of
the scalability spectrum -- you know, that whole market they are
seemingly saying they are the king of and a replacement for Sun?  ;->

The problem with Red Hat is that when anyone brings up an alternative to
Ext3, Red Hat falls back to arguments against other filesystems, which
is rather easy given the various compatibility issues with JFS (ported
from OS/2, requiring a lot of inode compatibility hacks -- don't get me
started with my experiences) and ReiserFS (utter lack of inode
compatibility in structures, requiring kernel-level emulation, etc...
that never seems to work, regardless of what the advocates say, let
alone the almsota always "out-of-sync" off-line repair tools).

But when you bring up XFS and its history of a stable, but advanced
inode structure, quota support from day 1, POSIX ACLs from nearly day 1,
and all the SGI team put into 2.5.3+ that is now stock kernel, they
still try to dance.  One thing I always get is "oh, its extents don't
perform well for /tmp or /var" or countless other arguments, of which I
merely respond, "all the more reason to use Ext3 for those few
filesystems, and XFS when Ext3 doesn't scale -- like for
large /home, /export, etc... filesystems."  No matter how many times I
put forth the argument that XFS complements Ext3, they seem to treat it
as yet another JFS/ReiserFS argument.

Hopeless?

-- Bryan "one of the reasons I still deploy Solaris instead of RHEL for
fileservers, even though RHL7+XFS and RHL9+XFS rocked (and are still
rocking!)" Smith


-- 
Bryan J. Smith         Professional, Technical Annoyance
mailto:b.j.smith@ieee.org   http://thebs413.blogspot.com
--------------------------------------------------------
        Fission Power:  An Inconvenient Solution

