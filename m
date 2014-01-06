From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Why 4k native drives haven't arrived
Date: Mon, 06 Jan 2014 18:35:41 -0500
Message-ID: <yq1mwj8y982.fsf@sermon.lab.mkp.net>
References: <52C61807.6050906@hardwarefreak.com>
	<yq1d2k8zsie.fsf@sermon.lab.mkp.net>
	<52C85580.2080303@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C85580.2080303@hardwarefreak.com> (Stan Hoeppner's message of
	"Sat, 04 Jan 2014 12:40:00 -0600")
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Stan" == Stan Hoeppner <stan@hardwarefreak.com> writes:

Stan> I'm sure they would but is this a high priority?  RMW handling was
Stan> a small price to pay for the increased platter density they were
Stan> after.  And now that most modern OS partitioning tools align to
Stan> 1MB this isn't a performance issue for the user.  Does the RMW
Stan> code occupy a huge amount of the firmware space on the drive, or
Stan> continual sink of engineering dollars with each new drive model?

It certainly takes up resources and puts constraints on the inner
workings of the drive firmware. They really don't want to be in the RMW
business but I doubt that's going to change.

SMR drives are closer to tape and a big departure from decades of
harddrive behavior. The current plan is to have cheap drive models that
are essentially glorified tapes and where the OS and filesystem have to
explicitly manage the zones. Misaligned or I/Os requiring RMW will
simply be rejected.

More expensive and backwards-compatible SMR drives will be doing the RMW
transparently in firmware. However, this comes at a much higher cost
than for 512e. SMR zones are 256MB - 1GB. That's a big chunk of stuff to
RMW!

My hunch is that in reality we'll land somewhere in-between the two
approaches like we did for 512e. In Linux we essentially treat 512e
drives as 4Kn in the I/O stack. And we are careful to get alignment
right. But legacy applications that rely on 512-byte accesses (using
direct I/O for instance) still work.

I think we'll see something similar with SMR. We'll query the drive
topology, and filesystems that are conductive to the SMR approach like
btrfs will properly align to the zones and only append to them. Whereas
legacy filesystems will resort to letting the drive deal with the
horrors.

Stan> This is why I said there is little motivation on the part of the
Stan> drive vendors to continue pushing 4Kn drives.

They are pushing pretty hard, actually, but there is a lot of inertia
and legacy hardware/software out there. The industry 4Kn transition was
originally supposed to be completed around late 2006!

Stan> Windows 7 doesn't support 4Kn drives either.  Up to now I thought
Stan> it was limited to XP.  Since these two versions of Windows make up
Stan> ~80% of the installed MS Windows base, putting 4Kn USB drives on
Stan> the market *is* suicide.

I believe Windows treats USB and SATA/SCSI differently. But I have no
personal experience in the Windows department.

Off-the-shelf 4TB USB drive:

# lsscsi | grep sdc
[10:0:0:0]   disk    Seagate  Backup+ Desk     050B  /dev/sdc
# sg_readcap -l /dev/sdc | grep length
   Logical block length=4096 bytes

(I'm guessing it's actually a 512e drive and that it's the SATA-USB
bridge that makes it look like 4Kn to the host. But who knows?).

Stan> Interesting read.  Are the suggested IDENTIFY DEVICE responses
Stan> simply a reprint of the ATA/SCSI standards, or are these return
Stan> values Linux specific, as the paper seems to suggest?  

The document describes the drive parameters I key off of in sd and
libata. We only use a small subset of what T10/T13 allows in Linux. The
document is what we share with drive vendors to make sure they implement
the knobs Linux needs correctly.

-- 
Martin K. Petersen	Oracle Linux Engineering
