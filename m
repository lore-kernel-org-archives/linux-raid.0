From: Fabian Knorr <knorrfab@fim.uni-passau.de>
Subject: Re: Recovering an Array with inconsistent Superblocks
Date: Sun, 05 Jan 2014 10:07:50 +0100
Message-ID: <1388912870.3591.4.camel@vessel>
References: <1388829881.16265.20.camel@vessel> <52C835C9.3050707@turmel.org>
	 <1388873143.7641.20.camel@vessel> <52C8C433.5030403@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ZLZjAOA1OWFoH2YG5RJq"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C8C433.5030403@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-ZLZjAOA1OWFoH2YG5RJq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

> Try this:
> 
> mdadm --stop /dev/md0
> 
> mdadm -Afv /dev/md0 /dev/sd[bcefghi]1
> 
> It leaves out /dev/sda, which appears to have been the spare in the
> original setup.
> 
> If MD is happy after that, use fsck -n on your logical volumes to verify
> your FS integrity, and/or see the extent of the damage (little or none,
> I think).

This had the same result as simply trying --assemble --scan, see
"assemble.log". I tried using sda1 instead of sdb1 as well as the both
seem to have ID 4 ("assemble2.log"), same thing again.

Do you have any idea why mdadm seems to ignore --force and does not add
the outdated disks? (Or am I misinterpreting --force?)

Thanks.

Fabian

--=-ZLZjAOA1OWFoH2YG5RJq
Content-Disposition: attachment; filename="assemble.log"
Content-Type: text/x-log; name="assemble.log"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

mdadm: looking for devices for /dev/md0
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 6.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdi1 is identified as a member of /dev/md0, slot 3.
mdadm: added /dev/sdg1 to /dev/md0 as 1
mdadm: added /dev/sdh1 to /dev/md0 as 2
mdadm: added /dev/sdi1 to /dev/md0 as 3
mdadm: added /dev/sdb1 to /dev/md0 as 4 (possibly out of date)
mdadm: added /dev/sdc1 to /dev/md0 as 5 (possibly out of date)
mdadm: added /dev/sde1 to /dev/md0 as 6 (possibly out of date)
mdadm: added /dev/sdf1 to /dev/md0 as 0
mdadm: /dev/md0 assembled from 4 drives - not enough to start the array.

--=-ZLZjAOA1OWFoH2YG5RJq
Content-Disposition: attachment; filename="assemble2.log"
Content-Type: text/x-log; name="assemble2.log"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

mdadm: looking for devices for /dev/md0
mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 6.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdi1 is identified as a member of /dev/md0, slot 3.
mdadm: added /dev/sdg1 to /dev/md0 as 1
mdadm: added /dev/sdh1 to /dev/md0 as 2
mdadm: added /dev/sdi1 to /dev/md0 as 3
mdadm: added /dev/sda1 to /dev/md0 as 4 (possibly out of date)
mdadm: added /dev/sdc1 to /dev/md0 as 5 (possibly out of date)
mdadm: added /dev/sde1 to /dev/md0 as 6 (possibly out of date)
mdadm: added /dev/sdf1 to /dev/md0 as 0
mdadm: /dev/md0 assembled from 4 drives - not enough to start the array.

--=-ZLZjAOA1OWFoH2YG5RJq--

