From: Bob Glamm <glamm@a-s-i.com>
Subject: device-mapper library
Date: Thu, 26 Aug 2004 12:48:30 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040826174830.GA27929@romulus.a-s-i.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I apologize if this is the wrong place to ask this; kindly direct
me to the appropriate place if so.

Is there an issue building device-mapper.1.00.1[89] against
2.6 kernels?  struct dm_target_msg does not appear in the
kernel headers for 2.6.5 or 2.6.7 (include/linux/dm-ioctl.h)
but does appear in kernel/ioctl/dm-ioctl.h in the device-mapper
sources.  Is there a set of 2.6.x patches somewhere I missed?

Thanks!

-Bob
