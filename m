From: Piete Brooks <Piete.Brooks@cl.cam.ac.uk>
Subject: Is there a good reason why I can't "mdadm -Gfn1 /dev/md1" ?
Date: Thu, 09 Jun 2005 06:54:22 +0100
Message-ID: <E1DgFzi-0007K9-00@mta2.cl.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Piete.Brooks@cl.cam.ac.uk
List-Id: linux-raid.ids

I really love having my partitions as RAID1 devices as it allows the actual 
partition major and minor numbers to change, and allows me to "move" 
partitions by adding and removing them from the array.

As such I do this even when there is only one partition. To move it, I can 
make it a two way mirror, add the new partition, then remove the old. However, 
I can't then shrink it back to being a one way mirror. Is there a good reason 
for this, or is it just not something that was considered sane?
[ "really" just runs a command as root ]

bedat-32:~: really mdadm -Gn1 /dev/md1
mdadm: '1' is an unusual number of drives for an array, so it is probably
     a mistake.  If you really mean it you will need to specify --force before
     setting the number of drives.
bedat-32:~: really mdadm -G --force -n1 /dev/md1
mdadm: option f not valid in grow mode
bedat-32:~: really mdadm --force -Gn1 /dev/md1
mdadm: -G would set mode to grow, but it is already manage.
bedat-32:~:  mdadm -V
mdadm - v1.6.0 - 4 June 2004
bedat-32:~: rpm -q mdadm       
mdadm-1.6.0-2
bedat-32:~: 

Any ideas?

