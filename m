From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: scsiformat and badblocks (was: Re: repeatable crash during ra
	id5 rebuild on 2.4.19-smp)
Date: Fri, 11 Oct 2002 06:33:10 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D29B@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Louis-David Mitterrand' <vindex@apartia.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Scsiformat does remapping of bad blocks.  You can see the bad blocks in the
disks Grown Defect List afterward (if you have a tool to read the GDL).
Your disk is good, some bad blocks can be expected during the useful life of
the disk.  The key is to evaluate when "some" is too many (rate of
increase), but 4 isn't too many.

Andy

-----Original Message-----
From: Louis-David Mitterrand [mailto:vindex@apartia.org] 
Sent: Thursday, October 10, 2002 6:29 AM
To: linux-raid@vger.kernel.org
Subject: scsiformat and badblocks (was: Re: repeatable crash during raid5
rebuild on 2.4.19-smp)

On Sun, Oct 06, 2002 at 12:16:37PM +0200, Louis-David Mitterrand wrote:
> 	- "mdadm /dev/md1 --add /dev/sda2" starts OK, says 15 minutes to go,
> 	  when at 25% rebuild suddenly it stops with "md_do_sync() caught
> 	  signal, exiting"

Following up to myself.

Could bad blocks on one of the raid5 partition disk have caused this
problem? 

I just found out that /dev/sdb has 4 four badblocks, the following
messages appearing in the syslog during the "badblocks /dev/sdb"
command:

	Oct 10 08:51:12 uruk kernel: scsi0: ERROR on channel 0, id 1, lun 0,
CDB: Read ( 10) 00 01 20 ba 30 00 00 c4 00 
	Oct 10 08:51:12 uruk kernel: Info fld=0x120ba48, Current sd08:10:
sense key Medium Error
	Oct 10 08:51:12 uruk kernel: Additional sense indicates Read retries
exhausted
	Oct 10 08:51:12 uruk kernel:  I/O error: dev 08:10, sector 18922056

So I tried a "scsiformat /dev/sdb" and now the disks seems to have no
more bad blocks.

Can a low-level format fix badblocks on a scsi disk (Fujitsu MAM3376)?
Should I trust that disk or send it back?

Cheers,
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
