From: Wakko Warner <wakko@animx.eu.org>
Subject: Script to save array info
Date: Wed, 20 Jun 2012 19:21:49 -0400
Message-ID: <20120620232149.GA7767@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After reading some of the stories about lost metadata, I was wondering if
anyone had a script that would output the member info for each device with
the device's physical serial number.

For a crude one I did this while in /sys/block:
for x in sd*;do
	echo /dev/$x
	/lib/udev/scsi_id --export --page=0x80 --whitelisted /dev/$x
	mdadm -E /dev/$x
done

And saved the output.  It works for me because all but 3 of my raid members
are full disks.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 21
 million bugs.
