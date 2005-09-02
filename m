From: Jim Faulkner <james.faulkner@yale.edu>
Subject: RE: question regarding multipath & Linux 2.6
Date: Fri, 2 Sep 2005 09:40:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0509020937390.24193-100000@netra.cs.yale.edu>
References: <0481A62A3E95A044AC20A1A45899645C06B02EE0@glc-mail-1.tessco.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0481A62A3E95A044AC20A1A45899645C06B02EE0@glc-mail-1.tessco.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Callahan, Tom" <CallahanT@tessco.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Yes, a copy of the whitepaper would be most useful.  If you could e-mail 
it to me or make it available on a website for download, that would be 
great.

thanks,
Jim Faulkner

On Fri, 2 Sep 2005, Callahan, Tom wrote:

> Your running into the problem of the "active/passive" link as you stated. If
> you are using Qlogic FibreChannel cards, qlogic offers drivers on their
> website for this.
> 
> I have a whitepaper I've written on this topic, please contact me if you
> would like a copy. We currently have many 2.6 Kernel Linux machines running
> exclusively off the SAN, with true failover support.
> 
> Thanks,
> Tom Callahan 
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> To: linux-raid@vger.kernel.org
> Sent: 9/2/2005 2:38 AM
> Subject: Re: question regarding multipath & Linux 2.6
> 
> On Thu, Sep 01, 2005 at 02:51:44PM -0400, Jim Faulkner wrote:
> >
> >Hello,
> >
> >Recently my department had a SAN installed, and I am in the process of 
> >setting up one of the first Linux machines connected to it.  The
> machine 
> >is running Red Hat Enterprise AS4 (x86_64), which uses Linux kernel 
> >version 2.6.9-11.ELsmp.
> giving more info about the infamous SAN would help :)
> >
> >The SAN shows up twice in the kernel, as /dev/sdb and /dev/sdc.
> /dev/sdb 
> >is inaccessible (I get a bunch of "Buffer I/O error on device sdb"
> kernel 
> >errors), but /dev/sdc works fine.  According to the administrator of
> the 
> it probably is a cheapo storage with an Active/Passive storage
> controller, you cannot use md to handle those.
> 
> >He told me to use PowerPath, but I'd rather not have to reinstall or 
> it is a long time i don't see powerpath on linux, but i am in favour of
> ditching proprietary multipath solutions in favour of free ones.
> >
> what you want is multipath-tools http://christophe.varoqui.free.fr/
> RH4 should already include a multipath-tools rpm.
> 
> Regards,
> Luca
> 
> 

