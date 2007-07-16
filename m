From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Advocacy] Re: 3ware 9650 tips
Date: Mon, 16 Jul 2007 11:48:01 -0600
Message-ID: <20070716174801.GM13826@parisc-linux.org>
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu> <alpine.LRH.0.999.0707161142440.25773@chaos.egr.duke.edu> <1184606132.4551.11.camel@portatux64.mobile.smithconcepts.com> <200707162040.00062.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200707162040.00062.a1426z@gawab.com>
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: "Bryan J. Smith" <b.j.smith@ieee.org>, Joshua Baker-LePain <jlb17@duke.edu>, David Chinner <dgc@sgi.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, Jon Collette <jon@etelos.com>, linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 16, 2007 at 08:40:00PM +0300, Al Boldi wrote:
> XFS surely rocks, but it's missing one critical component: data=ordered
> And that's one component that's just too critical to overlook for an 
> enterprise environment that is built on data-integrity over performance.
> 
> So that's the secret why people still use ext3, and XFS' reliance on external 
> hardware to ensure integrity is really misplaced.
> 
> Now, maybe when we get the data=ordered onto the VFS level, then maybe XFS 
> may become viable for the enterprise, and ext3 may cease to be KING.

Wow, thanks for bringing an advocacy thread onto linux-fsdevel.  Just what
we wanted.  Do you have any insight into how to "get the data=ordered
onto the VFS level"?  Because to me, that sounds like pure nonsense.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
