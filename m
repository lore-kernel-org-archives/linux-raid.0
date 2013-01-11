From: Chris Murphy <lists@colorremedies.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Fri, 11 Jan 2013 10:46:53 -0700
Message-ID: <3EE4457C-A185-4223-A84D-5BFBB204A94C@colorremedies.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301100349.46794.thomas@fjellstrom.ca> <6FD79D70-01A4-4DC9-9494-157773CD0F11@colorremedies.com> <201301110520.07128.thomas@fjellstrom.ca> <5C8F4DE0-5C1E-476F-BBA8-17A7D695E599@colorremedies.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5C8F4DE0-5C1E-476F-BBA8-17A7D695E599@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 11, 2013, at 10:39 AM, Chris Murphy <lists@colorremedies.com> wrote:
> 
> They probably have a high ERC time out as all consumer disks do so you should also check /sys/block/sdX/device/timeout and make sure it's not significantly less than the drive. It may be possible for smartctl or hdparm to figure out what the drive ERC timeout is.
> 
> http://cgi.csc.liv.ac.uk/~greg/projects/erc/

Actually what I wrote is misleading to the point it's wrong. You want the linux device time out to be greater than the device timeout. The device needs to be allowed to give up, and report back a read error to linux/md, so that md knows it should reconstruct the missing data from parity, and overwrite the (obviously) bad blocks causing the read error.

If the linux device time out is even a little bit less than the drive's timeout, md never gets the sector read error, doesn't repair it, since linux boots the whole drive. Now instead of repairing a few sectors, you have a degraded array on your hands. Usual consumer drive time outs are quite high, they can be up to a couple minutes long. Linux device time out is 30 seconds.


Chris Murphy