From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: NVRAM support
Date: Tue, 14 Feb 2006 11:17:31 +0100
Message-ID: <20060214101730.GJ3209@harddisk-recovery.com>
References: <43EC5655.1060504@web.de> <20060210124204.GC28676@harddisk-recovery.com> <43ECB4A4.6010005@tmr.com> <Pine.LNX.4.64.0602101700540.30925@twinlark.arctic.org> <20060213092204.GB3209@harddisk-recovery.nl> <20060213115444.GY32687@strugglers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060213115444.GY32687@strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 13, 2006 at 11:54:44AM +0000, Andy Smith wrote:
> On Mon, Feb 13, 2006 at 10:22:04AM +0100, Erik Mouw wrote:
> > On Fri, Feb 10, 2006 at 05:02:02PM -0800, dean gaudet wrote:
> > > it doesn't seem to make any sense at all to use a non-volatile external 
> > > memory for swap... swap has no purpose past a power outage.
> > 
> > No, but it is a very fast swap device. Much faster than a hard drive.
> 
> Wouldn't the same amount of money be better spent on RAM then?

Sure, but when you happen to have such a device lying idle, this is a
way to use it.

(note that you can also use unused memory on your video adapter as a
fast swap device).


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
