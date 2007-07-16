From: Al Boldi <a1426z@gawab.com>
Subject: Re: [Advocacy] Re: 3ware 9650 tips
Date: Mon, 16 Jul 2007 20:40:00 +0300
Message-ID: <200707162040.00062.a1426z@gawab.com>
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu> <alpine.LRH.0.999.0707161142440.25773@chaos.egr.duke.edu> <1184606132.4551.11.camel@portatux64.mobile.smithconcepts.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1184606132.4551.11.camel@portatux64.mobile.smithconcepts.com>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Bryan J. Smith" <b.j.smith@ieee.org>, Joshua Baker-LePain <jlb17@duke.edu>
Cc: David Chinner <dgc@sgi.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, Jon Collette <jon@etelos.com>, linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

Bryan J. Smith wrote:
> Off-topic, advocacy-level response ...
>
> On Mon, 2007-07-16 at 11:43 -0400, Joshua Baker-LePain wrote:
> > I do so wish that RedHat shared this view...
>
> I've been trying to convince them since Red Hat Linux 7 (and, later, 9)
> that they need to realize the limits of Ext3 at the enterprise end of
> the scalability spectrum -- you know, that whole market they are
> seemingly saying they are the king of and a replacement for Sun?  ;->
>
> The problem with Red Hat is that when anyone brings up an alternative to
> Ext3, Red Hat falls back to arguments against other filesystems, which
> is rather easy given the various compatibility issues with JFS (ported
> from OS/2, requiring a lot of inode compatibility hacks -- don't get me
> started with my experiences) and ReiserFS (utter lack of inode
> compatibility in structures, requiring kernel-level emulation, etc...
> that never seems to work, regardless of what the advocates say, let
> alone the almsota always "out-of-sync" off-line repair tools).
>
> But when you bring up XFS and its history of a stable, but advanced
> inode structure, quota support from day 1, POSIX ACLs from nearly day 1,
> and all the SGI team put into 2.5.3+ that is now stock kernel, they
> still try to dance.  One thing I always get is "oh, its extents don't
> perform well for /tmp or /var" or countless other arguments, of which I
> merely respond, "all the more reason to use Ext3 for those few
> filesystems, and XFS when Ext3 doesn't scale -- like for
> large /home, /export, etc... filesystems."  No matter how many times I
> put forth the argument that XFS complements Ext3, they seem to treat it
> as yet another JFS/ReiserFS argument.
>
> Hopeless?
>
> -- Bryan "one of the reasons I still deploy Solaris instead of RHEL for
> fileservers, even though RHL7+XFS and RHL9+XFS rocked (and are still
> rocking!)" Smith

XFS surely rocks, but it's missing one critical component: data=ordered
And that's one component that's just too critical to overlook for an 
enterprise environment that is built on data-integrity over performance.

So that's the secret why people still use ext3, and XFS' reliance on external 
hardware to ensure integrity is really misplaced.

Now, maybe when we get the data=ordered onto the VFS level, then maybe XFS 
may become viable for the enterprise, and ext3 may cease to be KING.


Thanks!

--
Al

