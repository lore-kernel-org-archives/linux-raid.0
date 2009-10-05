From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: ANNOUNCE: mdadm 3.0.1 - A tool for managing Soft RAID under Linux
Date: Mon, 05 Oct 2009 13:47:12 +0400
Message-ID: <4AC9C0A0.8070709@msgid.tls.msk.ru>
References: <19132.27836.474548.540600@notabene.brown> <alpine.LNX.2.01.0910041514180.11684@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.0910041514180.11684@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mr. James W. Laferriere wrote:
>     Hello Neil (& All) ,  Am I missing something here ?  I've not had 
> much if any difficulties compiling mdadm ,  from -very- old distro. 
> tooled boxen to very new ,  But ...
[]
> monitor.c: In function `signal_manager':
> monitor.c:139: error: `SYS_tgkill' undeclared (first use in this function)
> monitor.c:139: error: (Each undeclared identifier is reported only once
> monitor.c:139: error: for each function it appears in.)
> make: *** [monitor.o] Error 1
> 
> # uname -a
> Linux ns3 2.6.30.6 #1 SMP Wed Sep 9 05:50:45 UTC 2009 i686 pentium3 i386 
> GNU/Linux

If you use that new kernel, how about updating kernel-headers
to match your kernel?  SYS_tgkill comes from linux headers.

> # /usr/src/linux/scripts/ver_linux

that's all fine except it does not show
version of kernel headers installed on
your system.  Or the "counterpart" from
the glibc.

/mjt
