From: Gordon Henderson <gordon@drogon.net>
Subject: Re: resync (what is it doing when making a new array?)
Date: Sun, 8 Aug 2004 08:24:20 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0408080821010.805@lion.drogon.net>
References: <1091924709.209ea25bc637f@www.then7.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1091924709.209ea25bc637f@www.then7.com>
To: Eli Cantu <eli@then7.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 7 Aug 2004, Eli Cantu wrote:

> (watching a raid 5 array, composed of five 250gb disks, resyncing...to
> be completed 16 hours from now...)

One thing to check (if it's IDE drives) is that they are working in DMA
mode - use hdparm /dev/hda, etc. to check and force DMA if necessary
(although you might need to re-compile your kernel to include the correct
drivers for your IDE hardware)

It'll still take a long time with 250GB drives, though.

Other things you can fiddle with are

  /proc/sys/dev/raid/speed_limit_max
  /proc/sys/dev/raid/speed_limit_min

which will affect resync speed versus array accessibility during the
recync.

Gordon

