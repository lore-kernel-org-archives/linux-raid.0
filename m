From: Clive Messer <clive@vacuumtube.org.uk>
Subject: Moving a raid5 array
Date: Tue, 12 Sep 2006 17:14:58 +0100
Message-ID: <200609121714.58541.clive@vacuumtube.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I currently have a 4 disk raid5 array which I wish to move to another machine. 
In the current machine it is comprised of sda1/sdb1/sdc1/sdd1. When I move it 
to the new machine the disks will all shift up by 2. ie. the partitions will 
now be sdc1/sdd1/sde1/sdf1. If I 'mdadm --assemble' the array on the new 
machine with the new partition names will md figure it all out or am I going 
to trash my data?

For reference my current mdadm.conf ......

DEVICE /dev/sd*[0-9]
ARRAY /dev/md0 level=raid5 num-devices=4 
UUID=f1949e2c:bec621e4:de55ae15:4f336899

Regards

Clive
-- 
Clive Messer <clive@vacuumtube.org.uk>
