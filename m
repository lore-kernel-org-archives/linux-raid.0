From: Joshua Thomas <thatguy@pacer1.usca.sc.edu>
Subject: Starting a raid5 when devices have changed and having replaced a failed disk
Date: Sat, 18 Jan 2003 14:14:22 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030118191422.GA28241@pacer1.usca.sc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This may be a repeat to that same post a few days ago, but I had a raid5 currently running in degraded mode on /dev/hdb1,/dev/hdc1,/dev/hdd1,/dev/hde1,/dev/hdf1.  hdb went bad, had been running in degraded mode.  I replaced the disk, but all of my device names have changed because i moved to one disk per ide bus.  I have been trying to use mdadm.

Should I be trying to build a new array?  As in, mdadm --build /dev/md0 --raid-devices=5 /dev/hde1 /dev/hdg1 /dev/hdi1 /dev/hdk1 /dev/hdm1?  The disk hde is the one I replaced.  Thanks


