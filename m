From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: RAID1 robust read and read/write correct and EVMS-BBR
Date: Wed, 23 Feb 2005 15:52:31 -0500
Message-ID: <200502232052.j1NKqb927350@www.watkins-home.com>
References: <CAC3BCBB443DEC439198F230B4BCC7E9092C45CC@exna6-ftsaa.mis.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <CAC3BCBB443DEC439198F230B4BCC7E9092C45CC@exna6-ftsaa.mis.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'Nagpure, Dinesh'" <Dinesh.Nagpure@stratus.com>, evms-devel@lists.sourceforge.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is very good!  But most of my disk space is RAID5.  Any chance you have
similar plans for RAID5?

Thanks,
Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Nagpure, Dinesh
Sent: Wednesday, February 23, 2005 2:56 PM
To: 'evms-devel@lists.sourceforge.net'
Cc: 'linux-raid@vger.kernel.org'
Subject: RAID1 robust read and read/write correct and EVMS-BBR

Hi,

I noticed the discussion about robust read on the RAID list and similar one
on the EVMS list so I am sending this mail to both the lists. Latent media
faults which prevent data from being read from portions of a disk has always
been a concern for us. Such faults will go undetected till the time that
block is read. RAID 1 depends on error free mirrors for proper operation and
undiscovered bad blocks would only give pseudo illusion of duplexity when in
reality the array should be degraded. Over long run all the mirrors might
develop latent media faults and none can be replaced with a new disk. Also
it is a disaster if the same block goes bad on all the mirrors in a RAID 1
volume. With this concern we developed what we call "disk-scrubber". The
approach was to proactively seek for bad spots on the disk and when one is
discovered, read the correct data from the other mirror and use it to repair
the disk by way of a write. SCSI disks automatically repair bad spots on
write by internally mapping the bad spots to spare sectors (Being SCSI
centric might be one limitation of this solution).
The implementation comprised of a thread that looks for bad spots by way of
slow repeated continuous scan through all disks. The RAID error management
was extended to attempt a repair on read error from a RAID 1 array to permit
fixing of user discovered bad spots as well as those discovered by the
scrubber. The work is lk2.4.26 based as of now.

I can go back and put together a patch over the weekend if anyone is
interested in using it. 

-dinesh
dinesh.nagpure@stratus.com
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

