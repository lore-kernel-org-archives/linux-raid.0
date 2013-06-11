From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: RAID-10 keeps aborting
Date: Tue, 11 Jun 2013 17:50:38 -0400
Message-ID: <20130611175038.57b4a7b3@jlaw-desktop.mno.stratus.com>
References: <51AC1440.7020505@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51AC1440.7020505@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
List-Id: linux-raid.ids

I'll away from the office the rest of the week for the Red Hat Summit,
but a few things tested today:

*** Test 1 (repeated for both RAID1 and RAID10)

Setup: RAID1/10, a single disk fails WRITE SAME with
       [sense_key,asc,ascq]: [0x05,0x20,0x00]

Result: the RAID md_personality error_handler was invoked for the disk
        that kicked back Illegal Request.  That disk was marked
	faulty and write intent bitmaps started tracking chunks.  WRITE
	SAME to the other disks succeeded so MD didn't fail the parent
	bio and therefore blkdev_issue_write_same was considered
	successful.  

        When the failed component disk is re-added to the RAID, the
        write_same_max_bytes are recalculated and set to 0.  Resync with
        write intent bitmap properly mirrored the disk.

This behavior seems reasonable, though one could argue that
write_same_max_bytes should be set to 0 for the MD device once any WRITE
SAME fails.  Better yet, the block layer could fall back to plain WRITEs
without dropping the disk.


*** Test 2

Setup: RAID1, all member disks fail WRITE SAME with
       [sense_key,asc,ascq]: [0x05,0x20,0x00].

Result: the first disk is kicked out of the RAID, but the second remains
	active.  The block layer detected an error from
	blkdev_issue_write_same, emits "mdXXX: WRITE SAME failed.
	Manually zeroing" messages, but never prevents future WRITE
        SAMEs from hitting this MD device.


*** Test 3

Setup: RAID10, all member disks fail WRITE SAME with
       [sense_key,asc,ascq]: [0x05,0x20,0x00].

Result: all component disks are marked as faulty and lost page writes
	occur on MD device!  blkdev_issue_write_same fails and "mdXXX:
	WRITE SAME failed.  Manually zeroing" appear, but it's too late,
	there aren't any disks left standing in the RAID.


I think the results of Tests 2 and 3 confirm that RAID10 definitely
needs to be fixed...  Disabling WRITE SAME for RAID10 for now (3.10 +
stable) would be safest thing to do until this is sorted out properly.

-- Joe
