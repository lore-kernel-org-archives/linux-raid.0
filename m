From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Raid5 Construction Question
Date: Thu, 19 Aug 2004 13:30:39 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408191730.i7JHUd313659@watkins-home.com>
References: <4124E24E.7070802@psc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4124E24E.7070802@psc.edu>
To: 'PAulN' <pauln@psc.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In short... Issue this command:
echo 100000 > /proc/sys/dev/raid/speed_limit_max

If it does not help issue this command and send the results:
cat /proc/mdstat

Details below.

These are related to throttling:
/proc/sys/dev/raid/speed_limit_max
/proc/sys/dev/raid/speed_limit_min

Do "man md" for more info.

The speed limits are per device, not per array.
Make sure the max is large enough the permit your disks to go as fast as
they can.  I use 100000 (100,000K bytes/second).  My disks are not that
fast, and having too large of a number does not hurt.
At least as a test, set the min to the same value as max.

I use these commands when I want to change by hand:
cat /proc/sys/dev/raid/speed_limit_max
cat /proc/sys/dev/raid/speed_limit_min

echo 100000 > /proc/sys/dev/raid/speed_limit_max
echo 1000 > /proc/sys/dev/raid/speed_limit_min

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of PAulN
Sent: Thursday, August 19, 2004 1:25 PM
To: linux-raid@vger.kernel.org
Subject: Raid5 Construction Question

Hi,
So I have a raid 5 which is around ~1TB and the problem I've been having 
is that
the resync rate is really bad.  This is understandable given that the 
raid5 has not
been initialized.  Does anyone know a way for me to initialize my raid5 
before I use it so
that the resync process doesn't run for 3 days?
thanks
paul


Config:
-------------------------------------------------
raiddev             /dev/md0
raid-level                  5
nr-raid-disks               7
nr-spare-disks              1
chunk-size                  64k
persistent-superblock       1
parity-algorithm        left-symmetric
    device          /dev/sda1
    raid-disk     0
    device          /dev/sdb1
    raid-disk     1
    device          /dev/sdc1
    raid-disk     2
    device          /dev/sdd1
    raid-disk     3
    device          /dev/sde1
    raid-disk     4
    device          /dev/sdg1
    raid-disk     5
    device          /dev/sdf1
    raid-disk    6
    device          /dev/sdh1
    spare-disk     0
----------------------------------------

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

