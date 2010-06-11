From: Dave W <dave+gmane@wuertele.com>
Subject: Re: How does kernel decide that a drive is &quot;spare&quot;?
Date: Fri, 11 Jun 2010 06:51:00 +0000 (UTC)
Message-ID: <loom.20100611T083659-954@post.gmane.org>
References: <loom.20100611T070945-23@post.gmane.org> <C2.E9.26996.922D11C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Leslie Rhorer <lrhorer <at> satx.rr.com> writes:

> 	Any failed drives are moved to spare status.  Issue the `mdadm -D
> /dev/mdX` command, and it will probably show 3 failed drives.

You are correct.

> > Why are three drives assumed to be spares?
> 
> 	It's not assumed.  If was almost surely forced by md / mdadm.

Is there any way to get md or mdadm to tell me how it is making this decision? 
If I run "mdadm -Afv /dev/md0 /dev/sd[bcdef]1" I see this in messages:

Jun 11 07:22:10 fileserver kernel: md: md0 stopped.
Jun 11 07:22:10 fileserver kernel: md: unbind<sdd1>
Jun 11 07:22:10 fileserver kernel: md: export_rdev(sdd1)
Jun 11 07:22:10 fileserver kernel: md: unbind<sdb1>
Jun 11 07:22:10 fileserver kernel: md: export_rdev(sdb1)
Jun 11 07:22:10 fileserver kernel: md: unbind<sdc1>
Jun 11 07:22:10 fileserver kernel: md: export_rdev(sdc1)
Jun 11 07:22:10 fileserver kernel: md: unbind<sdf1>
Jun 11 07:22:10 fileserver kernel: md: export_rdev(sdf1)
Jun 11 07:22:10 fileserver kernel: md: unbind<sde1>
Jun 11 07:22:10 fileserver kernel: md: export_rdev(sde1)
Jun 11 07:22:27 fileserver kernel: md: md0 stopped.
Jun 11 07:22:27 fileserver kernel: md: bind<sde1>
Jun 11 07:22:27 fileserver kernel: md: bind<sdf1>
Jun 11 07:22:27 fileserver kernel: md: bind<sdc1>
Jun 11 07:22:27 fileserver kernel: md: bind<sdb1>
Jun 11 07:22:27 fileserver kernel: md: bind<sdd1>

All the ATA and SCSI messages in the log appear normal -- there are no warnings
or errors that I can see.

> No doubt at least one of the drives probably has enough
> info on hand to be able to recover most if not all of the information.  You
> should be able to force assemble (-A -f) the array using at least 4 drives,
> or perhaps all six.

I tried all combinations of three out of the five drives, but at most two
drives ever get used:

# mdadm -Af /dev/md0 /dev/sd[de]1
mdadm: /dev/md0 assembled from 2 drives - not enough to start the array.
# mdadm -Af /dev/md0 /dev/sd[bcd]1
mdadm: /dev/md0 assembled from 1 drive and 2 spares - not enough to start the \
array.
# mdadm -Af /dev/md0 /dev/sd[bce]1
mdadm: /dev/md0 assembled from 1 drive and 2 spares - not enough to start the \
array.
# mdadm -Af /dev/md0 /dev/sd[bcf]1
mdadm: No suitable drives found for /dev/md0
# mdadm -Af /dev/md0 /dev/sd[cde]1
mdadm: /dev/md0 assembled from 2 drives and 1 spare - not enough to start the \
array.
# mdadm -Af /dev/md0 /dev/sd[cdf]1
mdadm: /dev/md0 assembled from 1 drive and 2 spares - not enough to start the \
array.
# mdadm -Af /dev/md0 /dev/sd[def]1
mdadm: /dev/md0 assembled from 2 drives and 1 spare - not enough to start the \
array.


Thanks for the advice,
Dave


