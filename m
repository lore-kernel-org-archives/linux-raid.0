From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: NVRAM support
Date: Mon, 13 Feb 2006 10:22:04 +0100
Message-ID: <20060213092204.GB3209@harddisk-recovery.nl>
References: <43EC5655.1060504@web.de> <20060210124204.GC28676@harddisk-recovery.com> <43ECB4A4.6010005@tmr.com> <Pine.LNX.4.64.0602101700540.30925@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0602101700540.30925@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Bill Davidsen <davidsen@tmr.com>, Mirko Benz <mirko.benz@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 10, 2006 at 05:02:02PM -0800, dean gaudet wrote:
> On Fri, 10 Feb 2006, Bill Davidsen wrote:
> > Erik Mouw wrote:
> > > You could use it for an external journal, or you could use it as a swap
> > > device.
> > >  
> > 
> > Let me concur, I used external journal on SSD a decade ago with jfs (AIX). If
> > you do a lot of operations which generate journal entries, file create,
> > delete, etc, then it will double your performance in some cases. Otherwise it
> > really doesn't help much, use as a swap device might be more helpful depending
> > on your config.
> 
> it doesn't seem to make any sense at all to use a non-volatile external 
> memory for swap... swap has no purpose past a power outage.

No, but it is a very fast swap device. Much faster than a hard drive.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
| Data lost? Stay calm and contact Harddisk-recovery.com
