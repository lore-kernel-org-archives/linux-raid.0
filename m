From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm -A /dev/md3 fails
Date: Mon, 9 Sep 2002 21:07:03 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15740.32983.311512.759757@notabene.cse.unsw.edu.au>
References: <20020909054800.GV3806@merlins.org>
	<15740.15774.911597.853392@notabene.cse.unsw.edu.au>
	<20020909075559.GE3806@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Marc MERLIN on Monday September 9
To: Marc MERLIN <marc_news@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday September 9, marc_news@merlins.org wrote:
> On Mon, Sep 09, 2002 at 04:20:14PM +1000, Neil Brown wrote:
> > That is part of the reason that I wrote mdadm.  It can do the right
> > thing for you.
> 
> Apparently it can, but I'm having issues with it:
> 
> My conf file says:
> DEVICE /dev/scsi/host*/bus*/target*/lun*/part*
> ARRAY /dev/md3 level=raid5 num-devices=7 UUID=7f69d69c:2d523219:4f3d1ea7:9b7f4057 devices=/dev/scsi/host3/bus0/target8/lun0/part1,/dev/scsi/host3/bus0/target9/lun0/part1,/dev/scsi/host3/bus0/target10/lun0/part1,/dev/scsi/host3/bus0/target11/lun0/part1,/dev/scsi/host3/bus0/target12/lun0/part1,/dev/scsi/host3/bus0/target13/lun0/part1,/dev/scsi/host3/bus0/target14/lun0/part1
> 
> gargamel:/etc/mdadm# mdadm -A  -v /dev/md3
> mdadm: No identity information available for /dev/md3 - cannot assemble.
> 
> Any idea why 
> mdadm -A -v /dev/md3 doesn't work?

As Derek says, add "--scan" to tell it that it is allowed to look in
the config file.
Also, get rid of the "devices=...." part of the ARRAY line or it will
fail if any of the devices change address.

> 
> Am I supposed to actually start the device with
> mdadm -A  -v /dev/md3 /dev/scsi/host3/bus0/target*/lun0/part1 ?

That would probably work..

> or
> mdadm -A  -v -u 7f69d69c:2d523219:4f3d1ea7:9b7f4057 /dev/md3 ?

That wouldn't.  Would would need to to mdadm where the devices are:

mdadm -A  -v -u 7f69d69c:2d523219:4f3d1ea7:9b7f4057 /dev/md3 /dev/disk/*/part*

would work.

> 
> (I thought mdadm would get that data from the config file)

Only when you tell it to.  If that isn't clear from a second reading
of the man page, I would appreciate suggestions on how to make it more
clear.


NeilBrown
