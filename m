From: Michael-John Turner <mj@mjturner.net>
Subject: Re: Help - power failure during RAID6 grow
Date: Fri, 26 Aug 2011 17:17:46 +0100
Message-ID: <20110826161746.GB7595@majestic.pimp.org.za>
References: <20110826151803.GA7595@majestic.pimp.org.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110826151803.GA7595@majestic.pimp.org.za>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Aug 26, 2011 at 04:18:03PM +0100, Michael-John Turner wrote:
[...]
> I tried stopping and re-assembling by hand, but get the following:
> # mdadm --assemble /dev/md20 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1
> mdadm: /dev/md20 assembled from 5 drives and 1 spare - not enough to start the array.
[...]

A bit more info. If I try an assemble with -vv, I get the following:
mdadm: /dev/sdh1 is identified as a member of /dev/md20, slot 4.
mdadm: /dev/sdf1 is identified as a member of /dev/md20, slot 2.
mdadm: /dev/sdg1 is identified as a member of /dev/md20, slot 3.
mdadm: /dev/sde1 is identified as a member of /dev/md20, slot 1.
mdadm: /dev/sdd1 is identified as a member of /dev/md20, slot 0.
mdadm: /dev/sdb1 is identified as a member of /dev/md20, slot 6.
mdadm: /dev/sdc1 is identified as a member of /dev/md20, slot 5.
mdadm: /dev/sda1 is identified as a member of /dev/md20, slot -1.
mdadm:/dev/md20 has an active reshape - checking if critical section needs to be restored
mdadm: too-old timestamp on backup-metadata on device-5
mdadm: too-old timestamp on backup-metadata on device-6
mdadm: too-old timestamp on backup-metadata on device-8
mdadm: added /dev/sde1 to /dev/md20 as 1
mdadm: added /dev/sdf1 to /dev/md20 as 2
mdadm: added /dev/sdg1 to /dev/md20 as 3
mdadm: added /dev/sdh1 to /dev/md20 as 4
mdadm: added /dev/sdc1 to /dev/md20 as 5
mdadm: added /dev/sdb1 to /dev/md20 as 6
mdadm: no uptodate device for slot 7 of /dev/md20
mdadm: added /dev/sda1 to /dev/md20 as -1
mdadm: added /dev/sdd1 to /dev/md20 as 0
mdadm: /dev/md20 assembled from 5 drives and 1 spare - not enough to start the array.

Taking the contents of my previous mail into account (with the details
of each array member), is it safe to do an assemble with 
MDADM_GROW_ALLOW_OLD=1?

-mj
-- 
 Michael-John Turner
 mj@mjturner.net      <>     http://mjturner.net/
