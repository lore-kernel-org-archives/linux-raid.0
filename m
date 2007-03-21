From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: BLK_DEV_MD with CONFIG_NET
Date: Wed, 21 Mar 2007 13:02:46 +0100
Message-ID: <20070321120246.GB18195@uranus.ravnborg.org>
References: <20070320200538.5270d636.randy.dunlap@oracle.com> <20070320.202621.74740974.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752590AbXCUMCO@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070320.202621.74740974.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 20, 2007 at 08:26:21PM -0700, David Miller wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Tue, 20 Mar 2007 20:05:38 -0700
> 
> > Build a kernel with CONFIG_NET-n and CONFIG_BLK_DEV_MD=m.
> > Unless csum_partial() is built and kept by some arch Makefile,
> > the result is:
> > ERROR: "csum_partial" [drivers/md/md-mod.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> > 
> > 
> > Any suggested solutions?
> 
> Anything which is every exported to modules, which ought to
> be the situation in this case, should be obj-y not lib-y
> right?
That is also my understanding of lib-y - I should update makefiles.txt
to reflect this..

	Sam
