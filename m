From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: starting an array on Linux, advise needed
Date: Sat, 17 Jan 2004 03:34:32 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40088318.6000002@tls.msk.ru>
References: <200401170004.i0H04mi15707@dns1.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200401170004.i0H04mi15707@dns1.watkins-home.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:
> I found this old message, it may help.
> ======================================
> http://www.corpit.ru/mjt/mdctl.c - a very small utility similar to raidtools

Note it will not work correctly in the situation described.
Or at least it may not work.  For the same reason as original
code does not work: "renamed" devices in 2.4 vs 2.6.

With raidstart (and this utility follows it logic), it is the
kernel who is reading the raid superblock, opening devices
and assembles the array.  Most important part is the superblock:
kernel will pick up any devices found there (by major/minor
number).  When booting 2.4 and 2.6, or when your devices are
using dynamically-assigned numbers, that numbers may be different
on next reboot, so kernel will not be able to find all required
devices.

While mdadm tries to examine all superblocks and find all
devices in between the ones listed on command line, in the
superblock or ones that are really present on your system
at any given time (--scan; depends on your mdadm.conf also).

So when you expect your device names/numbers to be instable
between reboots, it's best to use mdadm together with --scan
and proper mdadm.conf or with all possible devices listed in
command line.  Mdassemble by Luca Berra will be useful here
too.

/mjt

P.S.  Please trim original message somehow when replying.

