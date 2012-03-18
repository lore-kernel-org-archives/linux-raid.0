From: Jim Kukunas <james.t.kukunas@linux.intel.com>
Subject: Re: [PATCH 2/3] lib/raid6: update test program recovery functions
Date: Sat, 17 Mar 2012 17:29:41 -0700
Message-ID: <20120318002941.GA12405@jtkukuna_gentoo_sb.jf.intel.com>
References: <1331939167-10787-1-git-send-email-james.t.kukunas@linux.intel.com>
 <1331939167-10787-3-git-send-email-james.t.kukunas@linux.intel.com>
 <1331974344.3602.4.camel@mattotaupa>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1331974344.3602.4.camel@mattotaupa>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Menzel <pm.debian@googlemail.com>
Cc: linux-raid@vger.kernel.org, hpa@zytor.com
List-Id: linux-raid.ids

On Sat, Mar 17, 2012 at 09:52:24AM +0100, Paul Menzel wrote:
> Dear Jim,

Hi Paul, 

> 
> 
> Am Freitag, den 16.03.2012, 16:06 -0700 schrieb Jim Kukunas:
> > Test each combination of recovery and syndrome generation
> > functions.
> > 
> > Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
> > ---
> >  lib/raid6/algos.c     |    2 +-
> >  lib/raid6/test/test.c |   32 +++++++++++++++++++++-----------
> >  lib/raid6/x86.h       |   13 ++++++++-----
> >  3 files changed, 30 insertions(+), 17 deletions(-)
> > 
> > diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> > index a3ac58a..82cdd01 100644
> > --- a/lib/raid6/algos.c
> > +++ b/lib/raid6/algos.c
> > @@ -17,12 +17,12 @@
> >   */
> >  
> >  #include <linux/raid/pq.h>
> > -#include <linux/module.h>
> >  #include "x86.h"
> >  #ifndef __KERNEL__
> >  #include <sys/mman.h>
> >  #include <stdio.h>
> >  #else
> > +#include <linux/module.h>
> 
> that change is not mentioned in the commit message as far as I can see.
> 

The reason for this change is that <linux/module.h> drags in headers which
are not visible to userspace, thus breaking the build for the test program.

You are correct, it should be mentioned in the commit message.

Thanks, 

<snip>

-- 
Jim Kukunas
Intel Open Source Technology Center
