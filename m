From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: BLK_DEV_MD with CONFIG_NET
Date: Wed, 21 Mar 2007 23:30:24 +0100
Message-ID: <200703212330.24502.arnd@arndb.de>
References: <20070320200538.5270d636.randy.dunlap@oracle.com> <20070320.202621.74740974.davem@davemloft.net> <20070321120246.GB18195@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070321120246.GB18195@uranus.ravnborg.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Miller <davem@davemloft.net>, randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 21 March 2007 13:02:46 Sam Ravnborg wrote:
> > Anything which is every exported to modules, which ought to
> > be the situation in this case, should be obj-y not lib-y
> > right?
>
> That is also my understanding of lib-y - I should update makefiles.txt
> to reflect this..

Strictly speaking, it could well be obj-m instead of obj-y if it
is _only_ used by modules. OTOH, it makes the Makefile a lot simpler
to not optimize for this case.

	Arnd <><
