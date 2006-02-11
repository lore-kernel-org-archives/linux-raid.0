From: dean gaudet <dean@arctic.org>
Subject: Re: NVRAM support
Date: Fri, 10 Feb 2006 17:02:02 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0602101700540.30925@twinlark.arctic.org>
References: <43EC5655.1060504@web.de> <20060210124204.GC28676@harddisk-recovery.com>
 <43ECB4A4.6010005@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43ECB4A4.6010005@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Erik Mouw <erik@harddisk-recovery.com>, Mirko Benz <mirko.benz@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 10 Feb 2006, Bill Davidsen wrote:

> Erik Mouw wrote:
> 
> > You could use it for an external journal, or you could use it as a swap
> > device.
> >  
> 
> Let me concur, I used external journal on SSD a decade ago with jfs (AIX). If
> you do a lot of operations which generate journal entries, file create,
> delete, etc, then it will double your performance in some cases. Otherwise it
> really doesn't help much, use as a swap device might be more helpful depending
> on your config.

it doesn't seem to make any sense at all to use a non-volatile external 
memory for swap... swap has no purpose past a power outage.

-dean
