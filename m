From: Ninti Systems <office@ninti.com.au>
Subject: Add device doesn't stick
Date: 31 Mar 2004 17:56:45 +0930
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1080721605.10119.57.camel@localhost>
Reply-To: office@ninti.com.au
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Back again ... :-)

So far so good with building RAID1 arrays using the 'missing' device
method on an already installed Slackware 9.1 system.

I've set up the RAID devices, they are autodetected on boot, everything
looks good. 

I hotadd the 'missing' device and the two devices sync.

I run 'mdadm --detail /dev/md5' and yep, the full array is now running
with both disks. I can 'ls' the contents etc.

I reboot and ... back to degraded mode with one failed device. The
hotadded device doesn't stick to the RAID device.

I'm sure there is a simple explanation. One system complaint is that the
expected superblock info couldn't be found (something like "expecting
a2hgf64jdk found 00000000").

I'm not sure how to rectify this?

Thanks
Mick


