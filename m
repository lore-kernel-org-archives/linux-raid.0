From: David Wuertele <dave-gnus@bfnet.com>
Subject: Please help!  How to reconstitute array (drive order problem)?
Date: Wed, 27 Oct 2004 03:51:58 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <m3vfcw3035.fsf@bfnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My 1.5TB SW RAID5 array is hosed because my motherboard stopped
recognizing drives on two of its controllers.  I have moved drives
around so that they are all recognized now, but the drive names have
all changed, and even though I've tried all combinations nothing seems
to work.  I have run out of troubleshooting tools.  Please help!

Here's what I had before the crash:

Motherboard IDE Controller bus 0:  One 250GB drive
Motherboard IDE Controller bus 1:  One 250GB drive
SIS IDE Controller 1 bus 0:        One 250GB drive
SIS IDE Controller 1 bus 1:        One 250GB drive
SIS IDE Controller 2 bus 0:        One 250GB drive
SIS IDE Controller 2 bus 1:        One 250GB drive
SIS IDE Controller 3 bus 0:        One 250GB drive
SIS IDE Controller 3 bus 1:        nothing

These drives came up something like hda, hdi, hdh, hdk, hdm, hdn, hdp,
but I don't know which physical drive got which name.  I had one 240GB
partition from each drive mapped to the RAID5 array md0 in
/etc/raidtab.

When the machine hanged, I found that the bios was not recognizing
both the SIS IDE Controller 1 drives and the SIS IDE Controller 3
drive.  These drives were hda, hdi, and hdk (I only know this because
they were inaccessible after linux booted).

So I moved the drives that were on SIS Controller 1 and 3 onto SIS
Controller 2 and the Motherboard controller.  I know that having two
drives on the same bus is a huge performance hit, but I just want my
data back!!!  On boot, all drives were recognized, but now their names
are different, so I figured all I need to do is edit /etc/raidtab to
reflect the new drive names.  Is that right?

Anyway, using fdisk I discovered that the drives' new names were hde,
hdg, and hdo.  Since I didn't know what physical drive had what
logical name before or after the switch, I tried all six combinations.
For example, the first thing I tried was to do the following in
/etc/raditab:

s/hda/hdo/
s/hdi/hde/
s/hdk/hdg/

I saved raidtab, and rebooted, but the array was not recognized by the
kernel and so I repeated the swap with all six possible combinations.
None of them worked.

Now I'm out of ideas.  How can I reconstruct my raid array?  This data
is very important to me, so any help you might have would be highly
appreciated.

Thanks!
Dave

