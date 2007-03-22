From: Adrian Bunk <bunk@stusta.de>
Subject: Re: BLK_DEV_MD with CONFIG_NET
Date: Thu, 22 Mar 2007 12:15:31 +0100
Message-ID: <20070322111531.GT752@stusta.de>
References: <20070320200538.5270d636.randy.dunlap@oracle.com> <20070320.202621.74740974.davem@davemloft.net> <20070321120246.GB18195@uranus.ravnborg.org> <200703212330.24502.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200703212330.24502.arnd@arndb.de>
Sender: linux-raid-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>, randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 21, 2007 at 11:30:24PM +0100, Arnd Bergmann wrote:
> On Wednesday 21 March 2007 13:02:46 Sam Ravnborg wrote:
> > > Anything which is every exported to modules, which ought to
> > > be the situation in this case, should be obj-y not lib-y
> > > right?
> >
> > That is also my understanding of lib-y - I should update makefiles.txt
> > to reflect this..
> 
> Strictly speaking, it could well be obj-m instead of obj-y if it
> is _only_ used by modules. OTOH, it makes the Makefile a lot simpler
> to not optimize for this case.

No, it is only used by modules only if CONFIG_BLK_DEV_MD=m and CONFIG_NET=n...

And except for some legacy drivers, there shouldn't be any module-only 
code in the kernel.

The solution is either obj-y or obj-$(CONFIG_CSUM_PARIAL).

> 	Arnd

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

