From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Checking if RAID does work?
Date: Wed, 19 Jan 2005 15:59:37 -0500
Message-ID: <200501192101.j0JL1k908633@www.watkins-home.com>
References: <20050119195154.23514.qmail@web60405.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050119195154.23514.qmail@web60405.mail.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: poonamsbox@yahoo.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You need to go to RAID school!  :)
No problem, so did everyone else at one time.

RAID0 does not create a backup copy of your data.  It just uses 2 or more
disks, giving you 2 or more times the space of a single disk.  If any 1 disk
were to fail in a RAID0 array, your data would be virtually gone.  RAID0
tends to also improve read and write performance.

RAID1 makes copies of your data on each disk.  Normally 2 disks are used,
both would have a full copy of your data.  The usable space would be the
same as a single disk regardless of the number of disks used.  But each
would have a full copy.  RAID1 tends to also improve read performance in a
multi tasking environment.  But write performance stays about the same,
unless you have a data bottleneck somewhere.

With RAID0, mounting a single disk is useless.  Don't waste your time.

With RAID1, you should not attempt to mount a disk directly, unless you are
recovering from an abnormal failure.  Doing so could cause your array to be
out of sync, and md would not know it has occurred.  A normal failure would
allow you to have normal access to your data, just using 1 less disk,
without user intervention.

I hope this helps!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Poonam Dalya
Sent: Wednesday, January 19, 2005 2:52 PM
To: linux-raid@vger.kernel.org
Subject: Checking if RAID does work?


Respected Sir,
              Sir, I would like to check if my data is
actually being written on the RAID disks of RAID0
array. I tried to check by doing the following
steps...
I mounted my /dev/md1 on /mnt/raid. and then wrote a
file on it. Then I tried to mount the raid disks
/dev/hda10 on some other mount point and checked that
mount point. But there was nothing in that mount
point. Please could you please help me with this.
       Sir I tried the same steps with a RAID1 array
and showed the files which I wrote on the md mount
point.
        Hoping for your reply.Thanking you in
anticipation.

Regards,
Poonam



__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

