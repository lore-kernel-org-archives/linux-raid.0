From: Phil Turmel <philip@turmel.org>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Fri, 11 Jan 2013 19:47:51 -0500
Message-ID: <50F0B2B7.1080604@turmel.org>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301100349.46794.thomas@fjellstrom.ca> <6FD79D70-01A4-4DC9-9494-157773CD0F11@colorremedies.com> <201301110520.07128.thomas@fjellstrom.ca> <5C8F4DE0-5C1E-476F-BBA8-17A7D695E599@colorremedies.com> <3EE4457C-A185-4223-A84D-5BFBB204A94C@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EE4457C-A185-4223-A84D-5BFBB204A94C@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/11/2013 12:46 PM, Chris Murphy wrote:
> 
> On Jan 11, 2013, at 10:39 AM, Chris Murphy <lists@colorremedies.com>
> wrote:
>> 
>> They probably have a high ERC time out as all consumer disks do so
>> you should also check /sys/block/sdX/device/timeout and make sure
>> it's not significantly less than the drive. It may be possible for
>> smartctl or hdparm to figure out what the drive ERC timeout is.
>> 
>> http://cgi.csc.liv.ac.uk/~greg/projects/erc/
> 
> Actually what I wrote is misleading to the point it's wrong. You want
> the linux device time out to be greater than the device timeout. The
> device needs to be allowed to give up, and report back a read error
> to linux/md, so that md knows it should reconstruct the missing data
> from parity, and overwrite the (obviously) bad blocks causing the
> read error.
> 
> If the linux device time out is even a little bit less than the
> drive's timeout, md never gets the sector read error, doesn't repair
> it, since linux boots the whole drive. Now instead of repairing a few
> sectors, you have a degraded array on your hands. Usual consumer
> drive time outs are quite high, they can be up to a couple minutes
> long. Linux device time out is 30 seconds.

This isn't quite right.  When the linux driver stack times out, it
passes the error to MD.  MD doesn't care if the drive reported the
error, or if the controller reported the error, it just knows that it
couldn't read that block.  It goes to recovery, which typically
generates the replacement data in a few milliseconds, and tries to write
back to the first disk.  *That* instantly fails, since the controller is
resetting the link and the drive is still in la-la land trying to read
the data.  MD will tolerate several bad reads before it kicks out a
drive, but will immediately kick if a write fails.

By the time you come to investigate, the drive has completed its
timeout, the link has reset, and the otherwise good drive is sitting
idle (failed).

Any array running with mismatched timeouts will kick a drive on every
unrecoverable read error, where it would likely have just fixed it.

Sadly, many hobbyist arrays are built with desktop drives, and the
timeouts are left mismatched.  When that hobbyist later learns s/he
should be scrubbing, the long-overdue scrub is very likely to produce
UREs on multiple drives (BOOM).

Phil
