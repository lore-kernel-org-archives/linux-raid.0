From: Greg KH <greg@kroah.com>
Subject: Re: [cgl_discussion] Re: ANNOUNCE: User-space System Device Enumation (uSDE)
Date: Wed, 29 Oct 2003 16:57:05 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031030005704.GA2143@kroah.com>
References: <3ACA40606221794F80A5670F0AF15F840215DC2F@pdsmsx403.ccr.corp.intel.com> <20031029190421.GA4173@kroah.com> <20031030003720.GA6000@penguin.co.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20031030003720.GA6000@penguin.co.intel.com>
To: Rusty Lynch <rusty@linux.co.intel.com>
Cc: "Guo, Min" <min.guo@intel.com>, linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, Lars Marowsky-Bree <lmb@suse.de>, "Ling, Xiaofeng" <xiaofeng.ling@intel.com>, Mark Bellon <mbellon@mvista.com>, linux-kernel@vger.kernel.org, cgl_discussion@osdl.org, Steven Dake <sdake@mvista.com>
List-Id: linux-raid.ids

On Wed, Oct 29, 2003 at 04:37:20PM -0800, Rusty Lynch wrote:
> 
> In the past we experimented with udev, and even did a little work on
> sysfsutils (which I though udev was using, but looking at udev-005 I still
> see the libsysfs directory.)

Yes, udev uses libsysfs, and your (Intel's) help on libsysfs is greatly
appreciated.

> I see the the TODO list in udev-005.  Are all these items wide open, or have
> people already spoken for some parts?  Maybe you have a couple of items you 
> consider higher priority?

Hm, some of those things on the TODO list are already done (latest
libsysfs, man page, and a few others.)  But no, they are all pretty much
wide open, feel free to jump in with whatever you feel like helping out
with.

thanks,

greg k-h
