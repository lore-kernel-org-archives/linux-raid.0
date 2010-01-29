From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm PATCH] Kill: fix when zeroing busy devices.
Date: Fri, 29 Jan 2010 21:02:02 +1100
Message-ID: <20100129210202.35b20639@notabene>
References: <20100128154844.31790.44309.stgit@awojcik-linux>
	<20100128163157.GT7517@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100128163157.GT7517@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Artur Wojcik <artur.wojcik@intel.com>, linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, 28 Jan 2010 17:31:57 +0100
Andre Noll <maan@systemlinux.org> wrote:

> On 16:48, Artur Wojcik wrote:
> > mdadm should not wait indefinitely when it trys to reset
> > superblock on device which is busy (cannot be opened).

Thanks.

> > 
> > Signed-off-by: Artur Wojcik <artur.wojcik@intel.com>
> > ---
> >  Kill.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/Kill.c b/Kill.c
> > index 63442a6..a65b865 100644
> > --- a/Kill.c
> > +++ b/Kill.c
> > @@ -46,7 +46,7 @@ int Kill(char *dev, struct supertype *st, int force, int quiet, int noexcl)
> >  			fprintf(stderr, Name ": Couldn't open %s for write - not zeroing\n",
> >  				dev);
> >  		close(fd);
> > -		return 1;
> > +		return 2;
> >  	}
> >  	if (st == NULL)
> >  		st = guess_super(fd);
> 
> Jup.
> 
> 	Acked-by: Andre Noll <maan@systemlinux.org>
> 
> BTW: Mind to kill the close(fd) as well (as fd is negative) while
> we're at it? A comment that explains the meaning of the return value
> would also be nice.

Done and done.

I really don't know why the loop in mdadm.c cared about the different
possible return values - I cannot see any justification for it.

Thanks,
NeilBrown

