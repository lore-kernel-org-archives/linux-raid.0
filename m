From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Removing a failing drive from multiple arrays
Date: Thu, 26 Apr 2012 08:36:07 +0100
Message-ID: <20120426073607.GA11590@nsrc.org>
References: <4F905F66.6070803@tmr.com>
 <20369.29756.761374.308057@quad.stoffel.home>
 <4F918F5C.2000607@anonymous.org.uk>
 <CAK2H+efwgznsS4==Rrtm6UE=uOb25-Q0Qm84i8yAJEJJ2JLdgg@mail.gmail.com>
 <4F9450D1.40305@anonymous.org.uk> <4F98B4FE.5010101@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F98B4FE.5010101@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Apr 25, 2012 at 10:37:50PM -0400, Bill Davidsen wrote:
> I have put MBR and boot partition on a USB thumb drive because the
> failure rate of a R/O flash is lower than rotating devices (in my
> experience). Use ext2 for boot, no journal so the drive works really
> read-only. Hopefully grub2 mounts the boot noatime.

Another option, although I've not done this for a long time, is PXE boot. 
You need a DHCP server giving out the correct parameters and a TFTP server
for the kernel (and ramdisk?)

Regards,

Brian.
