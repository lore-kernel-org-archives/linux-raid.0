From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Which (physical) disk is broken?
Date: Wed, 22 Dec 2004 19:52:47 -0500
Message-ID: <200412230052.iBN0qs913210@www.watkins-home.com>
References: <16841.65275.437988.190177@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16841.65275.437988.190177@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: michael@insulin-pumpers.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have never seen a disk system without per disk lights.  You may need to
open a door or something.

If you don't have per disk labels, how would you ever know what disk to
remove?  At least the manual should give details.  I have seen this issue, I
then add my own labels.

This seems like a large enough system that you should add custom labels so
you know which disk is which, and which array uses each disk.  Which SCSI
tray connects to which SCSI host, ...

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Neil Brown
Sent: Wednesday, December 22, 2004 6:11 PM
To: michael@insulin-pumpers.org
Cc: linux-raid@vger.kernel.org
Subject: RE: Which (physical) disk is broken?

On Wednesday December 22, michael@insulin-pumpers.org wrote:
> <snip>
> > Use a command like this to cause your disks to have activity, then look
for
> > the blinking lights:
> > dd if=/dev/md/1 of=/dev/null bs=64k
> > 
> 
> Oh swell!.... I have one blinking light for ALL the disks on all 12 of 
> our raid systems. There has to be a better way.


There are really only two ways:

 1/ make lights blinks.
 2/ have labels on the front of each bay saying what SCSI (or
    whatever) ID the device has.

If your storage array does not have per-device lights, or per-device
labels, you should speak sternly to your hardware provider.

NeilBrown
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

