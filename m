From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Mirror recovery?
Date: Thu, 20 Jun 2002 10:01:12 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020620140112.GA26939@willow.seitz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

	Lost a drive in my box last night - woke up to it locked
completely solid.  So I reset the machine, it started to come back up
and remirror the drives.  I set about trying to figure out why it locked
(the terminal had blanked overnight of course, and wouldn't unblank so
I missed the probable standard failure messages).  Then the box locked
hard again, right as I heard one of my IDE drives make some terrible
noises.

	So I rebooted, and ran the manufacturer's disk test, sure enough
it's headed south.  Once I've got a replacement drive, will I be able to
get the data on my raid partition back?  I don't think I've ever had a
failure happen on a RAID1 array during resync.  Once on RAID5, and that
was a disaster....

Ross Vandegrift
ross@willow.seitz.com
