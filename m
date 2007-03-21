From: David Miller <davem@davemloft.net>
Subject: Re: BLK_DEV_MD with CONFIG_NET
Date: Tue, 20 Mar 2007 20:26:21 -0700 (PDT)
Message-ID: <20070320.202621.74740974.davem@davemloft.net>
References: <20070320200538.5270d636.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070320200538.5270d636.randy.dunlap@oracle.com>
Sender: linux-raid-owner@vger.kernel.org
To: randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 20 Mar 2007 20:05:38 -0700

> Build a kernel with CONFIG_NET-n and CONFIG_BLK_DEV_MD=m.
> Unless csum_partial() is built and kept by some arch Makefile,
> the result is:
> ERROR: "csum_partial" [drivers/md/md-mod.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> 
> Any suggested solutions?

Anything which is every exported to modules, which ought to
be the situation in this case, should be obj-y not lib-y
right?
