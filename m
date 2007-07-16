From: Al Boldi <a1426z@gawab.com>
Subject: [RFC] VFS: data=ordered  (was: [Advocacy] Re: 3ware 9650 tips)
Date: Mon, 16 Jul 2007 21:28:08 +0300
Message-ID: <200707162128.08397.a1426z@gawab.com>
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu> <200707162040.00062.a1426z@gawab.com> <20070716174801.GM13826@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070716174801.GM13826@parisc-linux.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Bryan J. Smith" <b.j.smith@ieee.org>, Joshua Baker-LePain <jlb17@duke.edu>, David Chinner <dgc@sgi.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, Jon Collette <jon@etelos.com>, linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

Matthew Wilcox wrote:
> On Mon, Jul 16, 2007 at 08:40:00PM +0300, Al Boldi wrote:
> > XFS surely rocks, but it's missing one critical component: data=ordered
> > And that's one component that's just too critical to overlook for an
> > enterprise environment that is built on data-integrity over performance.
> >
> > So that's the secret why people still use ext3, and XFS' reliance on
> > external hardware to ensure integrity is really misplaced.
> >
> > Now, maybe when we get the data=ordered onto the VFS level, then maybe
> > XFS may become viable for the enterprise, and ext3 may cease to be KING.
>
> Wow, thanks for bringing an advocacy thread onto linux-fsdevel.  Just what
> we wanted.  Do you have any insight into how to "get the data=ordered
> onto the VFS level"?  Because to me, that sounds like pure nonsense.

Well, conceptually it sounds like a piece of cake, technically your guess is 
as good as mine.  IIRC, akpm once mentioned something like this.

But seriously, can you think of a technical reason why it shouldn't be 
possible to abstract data=ordered mode out into the VFS?


Thanks!

--
Al

