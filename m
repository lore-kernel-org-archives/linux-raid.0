From: Louis-David Mitterrand <vindex@apartia.org>
Subject: scsiformat and badblocks (was: Re: repeatable crash during raid5 rebuild on 2.4.19-smp)
Date: Thu, 10 Oct 2002 12:29:20 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021010102920.GA11053@apartia.org>
References: <20021006101636.GA29381@apartia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021006101636.GA29381@apartia.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

	Oct 10 08:51:12 uruk kernel: scsi0: ERROR on channel 0, id 1, lun 0, CDB: Read ( 10) 00 01 20 ba 30 00 00 c4 00 
	Oct 10 08:51:12 uruk kernel: Info fld=0x120ba48, Current sd08:10: sense key Medium Error
	Oct 10 08:51:12 uruk kernel: Additional sense indicates Read retries exhausted
	Oct 10 08:51:12 uruk kernel:  I/O error: dev 08:10, sector 18922056

So I tried a "scsiformat /dev/sdb" and now the disks seems to have no
more bad blocks.

Can a low-level format fix badblocks on a scsi disk (Fujitsu MAM3376)?
Should I trust that disk or send it back?

Cheers,
