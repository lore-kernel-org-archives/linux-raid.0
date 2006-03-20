From: Sander <sander@humilis.net>
Subject: RAID5 grow success  (was: Re: 2.6.16-rc6-mm2)
Date: Mon, 20 Mar 2006 14:02:32 +0100
Message-ID: <20060320130232.GA32762@favonius>
References: <20060318044056.350a2931.akpm@osdl.org>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060318044056.350a2931.akpm@osdl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Morton wrote (ao):
> - Lots of MD and DM updates

I would like to report that growing an online raid5 device works like a
charm:

mdadm --version
mdadm - v2.4-pre1 - Not For Production Use - 20 March 2006

mdadm -C -l5 -n3 /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1

While performing:
for i in `seq 4`
do dd if=/dev/zero of=bigfile.$i bs=1024k count=10000
done
md5sum bigfile.*

I do:
mdadm /dev/md0 -a /dev/sdd1

mdadm --grow /dev/md0 --raid-disks=4

When the dd and md5sum finishes, I umount and:

e2fsck -f /dev/md0
resize2fs -p /dev/md0

After mounting again the disk indeed is bigger, and the md5sum still
matches.


FWIW, I now try to add four more spares at once, and grow the raid5
again. It seems to work:


# mdadm /dev/md0 -a /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1
mdadm: added /dev/sde1
mdadm: added /dev/sdf1
mdadm: added /dev/sdg1
mdadm: added /dev/sdh1
# mdadm --grow /dev/md0 --raid-disks=8
mdadm: Need to backup 448K of critical section..
mdadm: ... critical section passed.
#

It is still reshapeing ATM.

Thanks!

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
