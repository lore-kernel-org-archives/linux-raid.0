From: Tony Coffman <tony@emitony.com>
Subject: Device naming and raid1
Date: Tue, 26 Aug 2008 11:32:54 -0400
Message-ID: <48B42226.3020702@emitony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've have a Centos5 box running a software raid-1 set on a pair of SATA
drives.

The SATA controller or driver has a flaw.
Every 150 days or so, one of the two drives will experience errors and fail.

Subsequent tests always show the drive and cable to be ok.  We bought a
couple of replacement drives before we figured that out :-(

On the last event this weekend, I went searching for a way to get the
raid back online with no host downtime.  I found the technique that
deletes the drive and then brings it back online with a bus scan using
the /sys filesystem delete and rescan entities.

I didn't realize that you could also perform a rescan on a single LUN. 
I'll have to use that next time.

My question - since I've done a delete/rescan bus operation, my device
name and major,minor numbers have changed.

Original
[0:0:0:0]    disk    ATA      ST3250410AS      3.AA  /dev/sdc

Current
[0:0:0:0]    disk    ATA      ST3250410AS      3.AA  /dev/sdc

If I re-add the device to the raid set using the new device name, will
it cause any problems on the next boot?

The drive appears to be fine.  I can read all blocks with no errors. 
Partition table looks ok, etc..

In the future if I rescan just the single LUN, I'm pretty sure I won't
run into again this but I'd like to avoid an outage on this event if
possible.

Thanks and regards,
--Tony

