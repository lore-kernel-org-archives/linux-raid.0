From: Richard Michael <rmichael-raid@edgeofthenet.org>
Subject: Auto rebuild of Firewire/USB drive in 3-way RAID1
Date: Tue, 19 Jun 2007 15:40:41 -0400
Message-ID: <20070619194041.GM6050@server>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I'm looking for comments on a setup I'm working on..

I'm building three-way mirror with (at least) one removable drive.  My
intention is solve the offsite backup problem by allowing my users to
simply unplug the removable drive, take it away, and replug it (or a
replacement later) without having to think about anything.  It's
three-way so I have redundancy when the removable is gone.

I'm experimenting with mdadm to figure out various solutions to build
the setup.  My approach is to use the PROGRAM feature of mdadm to run a
script when the removable device "fails", the script will briefly sleep
to let subsystems settle down, then call mdadm to remove to failed
device.  On reconnect of the device, I can use udev to tell me which
socket the drive was connected (to determine if it's RAID related even I
care about), briefly sleep again, then call mdadm to add the device back
to the array.

I could write a udev rule to make the dev names permanent, i.e.
corresponding to the socket so I don't have to deal with incremental or
varying sda, sdb, sdc, style names.  But it might not be worth it..

I'll just be using "mdadm <MD> --remove detached", and "mdadm <MD> --add
<NEW_DEV_PATH>".

I'm just wondering if I understand things correctly.  Should I be
looking at writing the array config into mdadm.conf and doing something
mdadm --assemble?  I think not because the array will already be active
(and therefore assembled), just degraded.

Thoughts?

Ultimately, I'd like to do this ontop of an EVMS BBR (bad block
relocation) segment manager to buy me time when bad blocks are
encountered on array drives.  (As opposed to have the entire drive
offlined immediately.)


Thanks,
Richard
