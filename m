From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: BLK_DEV_MD with CONFIG_NET
Date: Wed, 21 Mar 2007 15:59:25 -0700
Message-ID: <20070321155925.172944e5.randy.dunlap@oracle.com>
References: <20070320200538.5270d636.randy.dunlap@oracle.com>
	<20070320.202621.74740974.davem@davemloft.net>
	<20070321120246.GB18195@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070321120246.GB18195@uranus.ravnborg.org>
Sender: linux-raid-owner@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 21 Mar 2007 13:02:46 +0100 Sam Ravnborg wrote:

> On Tue, Mar 20, 2007 at 08:26:21PM -0700, David Miller wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > Date: Tue, 20 Mar 2007 20:05:38 -0700
> > 
> > > Build a kernel with CONFIG_NET-n and CONFIG_BLK_DEV_MD=m.
> > > Unless csum_partial() is built and kept by some arch Makefile,
> > > the result is:
> > > ERROR: "csum_partial" [drivers/md/md-mod.ko] undefined!
> > > make[1]: *** [__modpost] Error 1
> > > make: *** [modules] Error 2
> > > 
> > > 
> > > Any suggested solutions?
> > 
> > Anything which is every exported to modules, which ought to
> > be the situation in this case, should be obj-y not lib-y
> > right?
> That is also my understanding of lib-y - I should update makefiles.txt
> to reflect this..

I concur, but there seems to be quite a bit of change needed in
Makefile*s for this.  I'll begin with csum_partial() and trying
to use Arnd's suggestion as well.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
