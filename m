From: Marc MERLIN <marc_news@merlins.org>
Subject: Re: mdadm -A /dev/md3 fails
Date: Mon, 9 Sep 2002 00:55:59 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020909075559.GE3806@merlins.org>
References: <20020909054800.GV3806@merlins.org> <15740.15774.911597.853392@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15740.15774.911597.853392@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Sep 09, 2002 at 04:20:14PM +1000, Neil Brown wrote:
> That is part of the reason that I wrote mdadm.  It can do the right
> thing for you.

Apparently it can, but I'm having issues with it:

My conf file says:
DEVICE /dev/scsi/host*/bus*/target*/lun*/part*
ARRAY /dev/md3 level=raid5 num-devices=7 UUID=7f69d69c:2d523219:4f3d1ea7:9b7f4057 devices=/dev/scsi/host3/bus0/target8/lun0/part1,/dev/scsi/host3/bus0/target9/lun0/part1,/dev/scsi/host3/bus0/target10/lun0/part1,/dev/scsi/host3/bus0/target11/lun0/part1,/dev/scsi/host3/bus0/target12/lun0/part1,/dev/scsi/host3/bus0/target13/lun0/part1,/dev/scsi/host3/bus0/target14/lun0/part1

gargamel:/etc/mdadm# mdadm -A  -v /dev/md3
mdadm: No identity information available for /dev/md3 - cannot assemble.

Any idea why 
mdadm -A -v /dev/md3 doesn't work?

Am I supposed to actually start the device with
mdadm -A  -v /dev/md3 /dev/scsi/host3/bus0/target*/lun0/part1 ?
or
mdadm -A  -v -u 7f69d69c:2d523219:4f3d1ea7:9b7f4057 /dev/md3 ?

(I thought mdadm would get that data from the config file)

Thanks
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems & security ....
                                      .... what McDonalds is to gourmet cooking 
Home page: http://marc.merlins.org/   |   Finger marc_f@merlins.org for PGP key
