From: linuxraid@valli.org
Subject: Re: hostRAID, AIC-7901, disable?
Date: Tue, 21 Dec 2004 21:41:35 +0100 (CET)
Message-ID: <32897.194.153.181.92.1103661695.squirrel@mail.valli.org>
References: <cpkem3$70s$1@sea.gmane.org>
     <bbfa52890412131309234b2d09@mail.gmail.com>  
     <cpl0tm$4sp$1@sea.gmane.org>
     <1103132961.3629.41.camel@compaq-rhel4.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1103132961.3629.41.camel@compaq-rhel4.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: m.evans@rdg.ac.uk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
> We have recently aquired a new Dell Precision 670 workstation, on which
> we intended to install linux, (Suse 9.1).
> In the install, is reports it can not find any hard drives.
> We think we have tracked this problem down to the AIC-7901 hostRAID
> SCSI controller.

We had the same problem with the adaptec 39320 in a Dell Server.
The proper driver for the adaptec U320 scsi should be aic79xx
and it really is.
The aic79xx driver of the Kernel 2.4.28 didn't recognise
our scsi adapter. So we downloaded one from adaptec which
was labeled as *minimally tested*, but this one works:
http://download.adaptec.com/scsi/linux/aic7Yxx-2.0.12-6.3.9-linux-2.4.tar.bz2
or for kernel 2.6 series
http://download.adaptec.com/scsi/linux/aic7Yxx-2.0.12-6.3.9-linux-2.6.tar.bz2

This tarballs contain the source for following drivers:
aic79xx (version 2.0.12)
aic7xxx (version 6.3.9)
They are more recent than the original ones in the kernel.

If you don't like kernel-compiling there's a chance to find
a precompiled one on sites like
http://www.adaptec.com/worldwide/support/drivers_by_product.jsp?sess=no&language=English+US&prodkey=ASC-39320D-R&cat=%2fProduct%2fASC-39320D-R

> From what I we can gather, linux no longer has
> drivers for hostRAID hardware. We don't care about having RAID, just
> a working system, so we would be content to simply disable the
> hostRAID. the problem is, the setup tool does not have any option
> to disable hostRAID.
> Has anyone come across a solution? Is there a driver I don't know of?
> Is there a way of disabling hostRAID?
>
> *PS: From the SuSe install, when we try to add the appropriate SCSI
> module for the AIC-7901, it fails.

