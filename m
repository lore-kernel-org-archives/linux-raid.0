From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Bug#737951: mdadm: udev rules files ignores raid=noautodetect
 kernel parameter
Date: Fri, 07 Feb 2014 11:36:46 +0400
Message-ID: <52F48D0E.80905@msgid.tls.msk.ru>
References: <2014-02-07T08-14-24@devnull.michael-prokop.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2014-02-07T08-14-24@devnull.michael-prokop.at>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Prokop <mika@debian.org>, 737951@bugs.debian.org
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Control: tag -1 + moreinfo
Control: severity -1 wishlist

07.02.2014 11:21, Michael Prokop wrote:
> Package: mdadm
> Version: 3.3-2
> Severity: normal
> 
> Quoting from kernel's Documentation/md.txt:
> 
> ,---- [ https://www.kernel.org/doc/Documentation/md.txt ]
> | Boot time autodetection of RAID arrays
> | --------------------------------------
> |
> | When md is compiled into the kernel (not as module), partitions of
> | type 0xfd are scanned and automatically assembled into RAID arrays.
> | This autodetection may be suppressed with the kernel parameter
> | "raid=noautodetect".  As of kernel 2.6.9, only drives with a type 0
> | superblock can be autodetected and run at boot time.
> `----
> 
> The udev rules file /lib/udev/rules.d/64-md-raid-assembly.rules
> shipped by mdadm ignores that kernel parameter and tries to assemble
> mdadm RAIDs without honoring the raid=noautodetect setting.
> 
> It would be nice if there would be some way (maybe just checking for
> raid=noautodetect in /proc/cmdline?) to disable auto assembly
> without having to manually delete/override the udev file.

I don't think that using raid=noautodetect is a good way of doing
this.  It is for the really obsolete in-kernel array assembly, and
it is described as such in the documentation you quoted above.

In debian we have another parameter in initrd, --

  mdassemble=all|none|list

which is copied from a debconf question.  Maybe this one is better
suited for this need, at least it is more flexible.  It is sort
of trivial to get this parameter from kernel command line in the
initrd script.

But.

It is all about early-boot environment.

None of these parameters, at my point of view, should be considered
after pre-boot is done and we're in the main system.  If you're
talking about main udev rules of mdadm, I disagree, there should
be entirely separate option, if at all.

What is your usage case?  What are you trying to achieve?

Note that we're moving (very slow) towards assembling everything
using those rules, including your boot arrays, so if you disable
those, your system wont boot anymore.

Adding linux-raid list to Cc.  Please describe your situation
in more detail, and maybe together we will be able to come to
some solution.

Marking your bugreport as a wishlist for now in debian.

Thanks,

/mjt
