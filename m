From: Louis-David Mitterrand <vindex@apartia.org>
Subject: booting from a Promise Sata tx4
Date: Thu, 1 Jul 2004 09:51:57 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040701075157.GA20952@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,

I am planning to boot from a raid array of drives connected through a
Promise Sata tx4.

Even though the drive (only one for testing) is bootable (lilo ran
correctly) and the tx4 has been selected in the bios (Dell Dimension
4100) as the first boot device, the boot process goes right through to
the next bootable device on its list.

I went into the tx4 bios configuration and was offered the option of
configuring that single drive as "1+0 stripe". That process wiped the
data of course. After rebooting from a knoppix I fdisk'd and
mkreiserfs'd and copied another system partition. The next boot attempt
was successful but I wonder what that "1+0 stripe" mode means.

I only need my four disks configured as JBOD as I want to only rely on
the kernel's raid5, and not on some (possibly buggy) card firmware for
raid operation.

Has someone already configured a tx4 as JBOD?

Thanks in advance,

-- 
A meeting is an event at which the minutes are kept and the hours are
lost.
