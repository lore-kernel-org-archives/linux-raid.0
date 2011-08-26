From: NeilBrown <neilb@suse.de>
Subject: Re: Help - power failure during RAID6 grow
Date: Sat, 27 Aug 2011 06:51:51 +1000
Message-ID: <20110827065151.03b2d930@notabene.brown>
References: <20110826151803.GA7595@majestic.pimp.org.za>
	<20110826161746.GB7595@majestic.pimp.org.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110826161746.GB7595@majestic.pimp.org.za>
Sender: linux-raid-owner@vger.kernel.org
To: Michael-John Turner <mj@mjturner.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 26 Aug 2011 17:17:46 +0100 Michael-John Turner <mj@mjturner.net>
wrote:

> On Fri, Aug 26, 2011 at 04:18:03PM +0100, Michael-John Turner wrote:
> [...]
> > I tried stopping and re-assembling by hand, but get the following:
> > # mdadm --assemble /dev/md20 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1
> > mdadm: /dev/md20 assembled from 5 drives and 1 spare - not enough to start the array.
> [...]
> 
> A bit more info. If I try an assemble with -vv, I get the following:
> mdadm: /dev/sdh1 is identified as a member of /dev/md20, slot 4.
> mdadm: /dev/sdf1 is identified as a member of /dev/md20, slot 2.
> mdadm: /dev/sdg1 is identified as a member of /dev/md20, slot 3.
> mdadm: /dev/sde1 is identified as a member of /dev/md20, slot 1.
> mdadm: /dev/sdd1 is identified as a member of /dev/md20, slot 0.
> mdadm: /dev/sdb1 is identified as a member of /dev/md20, slot 6.
> mdadm: /dev/sdc1 is identified as a member of /dev/md20, slot 5.
> mdadm: /dev/sda1 is identified as a member of /dev/md20, slot -1.
> mdadm:/dev/md20 has an active reshape - checking if critical section needs to be restored
> mdadm: too-old timestamp on backup-metadata on device-5
> mdadm: too-old timestamp on backup-metadata on device-6
> mdadm: too-old timestamp on backup-metadata on device-8
> mdadm: added /dev/sde1 to /dev/md20 as 1
> mdadm: added /dev/sdf1 to /dev/md20 as 2
> mdadm: added /dev/sdg1 to /dev/md20 as 3
> mdadm: added /dev/sdh1 to /dev/md20 as 4
> mdadm: added /dev/sdc1 to /dev/md20 as 5
> mdadm: added /dev/sdb1 to /dev/md20 as 6
> mdadm: no uptodate device for slot 7 of /dev/md20
> mdadm: added /dev/sda1 to /dev/md20 as -1
> mdadm: added /dev/sdd1 to /dev/md20 as 0
> mdadm: /dev/md20 assembled from 5 drives and 1 spare - not enough to start the array.
> 
> Taking the contents of my previous mail into account (with the details
> of each array member), is it safe to do an assemble with 
> MDADM_GROW_ALLOW_OLD=1?
> 
> -mj

Leave sda1 out of the list - it looks too much like a spare.  Sometime must
have reset the metadata on it.  You can live without it so do so for now.

Assemble the array with the rest of the devices and give the "--force" flag
so it will update the event counts to all be in sync.
And do this with MDADM_GROW_ALLOW_OLD=1 set.

This should finish the reshape and give you a singly degraded 8 device RAID6.

Then add sda1 back in and it will recover and the array will be optimal.

NeilBrown
