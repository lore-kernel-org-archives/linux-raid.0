From: Neil Brown <neilb@suse.de>
Subject: Re: softraid and multiple distros
Date: Tue, 16 May 2006 21:32:47 +1000
Message-ID: <17513.47199.99460.746601@cse.unsw.edu.au>
References: <Pine.LNX.4.44.0605141048330.7486-100000@coffee.psychology.mcmaster.ca>
	<200605151454.27974.Dexter.Filmore@gmx.de>
	<17512.64468.813293.673836@cse.unsw.edu.au>
	<200605161216.00477.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dexter Filmore on Tuesday May 16
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 16, Dexter.Filmore@gmx.de wrote:
> 
> Right now all that's in mdadm.conf is:
> 
> DEVICE /dev/sd[abcd]1
> ARRAY /dev/md0 devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1
> MAILADDR root@localhost
> 
> Something important missing..?

If these are the only SCSI drives (or USB or anything else that looks
like a SCSI drive) that you have or will ever have, then it is
probably safe.
If you plug another device in and reboot, that other device could
conceivably become sda, and your current devices will be b,c,d,e.
If this happened, then mdadm could have trouble assembly your array.
At best it would be degraded as sde would not get included.

So in the very simple one-array situation, this is probably safe.
But it doesn't generalise.  If you have two array of distinct devices,
then something like 

 ARRAY /dev/md0 devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1
 ARRAY /dev/md1 devices=/dev/sde1,/dev/sdf1,/dev/sdg1,/dev/sdh1

is not safe.  If /dev/sda1 fails, you pull it out and reboot, then md1
won't be assembled properly as everything will get renamed.
In general it is safer to use UUIDs

  DEVICE /dev/sd[a-z][0-9]
  ARRAY /dev/md0 uuid=whatever
  ARRAY /dev/md1 uuid=whatever:else

Hope that makes it reasonably clear.

NeilBrown
