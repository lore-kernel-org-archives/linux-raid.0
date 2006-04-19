From: "James Sutherland" <J.A.Sutherland@dundee.ac.uk>
Subject: Rebuilding RAID6 after wrongly marked "faulty" drives
Date: Wed, 19 Apr 2006 09:22:24 +0100
Message-ID: <s4460159.071@gw-out.dundee.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks to the IOMMU bug (run out of memory? Send everything to /dev/null
and return errors which make RAID think the drives are all faulty...)
I've lost a RAID6 array: 2 of the 7 drives were (wrongly) marked
'faulty' because of this bug.

After enlarging my I/O aperture to stop the problem recurring, I
managed to get the array started with 5 of the 7 drives - only to have
one of them apparently develop a genuine fault:

***
end_request: I/O error, dev sde, sector 4057289
Buffer I/O error on device sde2, logical block 962111
ATA: abnormal status 0xD8 on port 0xFFFFC20000010287
ATA: abnormal status 0xD8 on port 0xFFFFC20000010287
ATA: abnormal status 0xD8 on port 0xFFFFC20000010287
ata7: command 0x25 timeout, stat 0xd8 host_stat 0x1
ata7: translated ATA stat/err 0xd8/00 to SCSI SK/ASC/ASCQ 0xb/47/00
ata7: status=0xd8 { Busy }
sd 6:0:0:0: SCSI error: return code = 0x8000002
sde: Current: sense key=0xb
    ASC=0x47 ASCQ=0x0
***

Assuming this is a genuine drive failure, is there any way I can
reconstruct using the other 6 drives, despite two of them wrongly being
marked "failed"? I tried --assemble /dev/md2 --force (names), but was
told I had "4 drives and 2 spares" - not enough to start the array :-(
There's a log entry about "ejecting non-fresh /dev/... from array",
although the event counts all match.

Disturbingly, Seagate's diagnostic had reached 87% last night without
reporting any problems, leaving me in some doubt as to whether the drive
really had failed.

I'm also getting appalling rebuild speeds on the RAID1 system partition
(2-3Mbyte/sec, without any other load; bumping up speed_min in /proc did
nothing.)

As someone else has suggested, disabling libata's automatic retries
would be a *huge* improvement in rebuild speed, but also improve
reliability (if a block can be read on the 4th attempt, it really isn't
very OK - but AFAICS, this is masked at present). Copying the working
bits of a dying drive directly to the hot spare, then just using parity
to fill in the gaps, would seem nice...


James.

