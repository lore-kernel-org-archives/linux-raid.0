From: Mirko <mirko76@arcor.de>
Subject: Re: Need help with my raid5
Date: Fri, 22 Mar 2013 15:28:54 +0000 (UTC)
Message-ID: <loom.20130322T162821-835@post.gmane.org>
References: <loom.20130322T084406-543@post.gmane.org> <CAAMCDed0Pvs_+c6o5BvpVNi5ATZeu1abR1xeW=ikR8O9W5HJ1Q@mail.gmail.com> <loom.20130322T134448-923@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mdadm --assemble --auto=yes --force --verbose /dev/md0 /dev/sda1 /dev/sdb1
/dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdh1 
mdadm: looking for devices for /dev/md0
mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot -1.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot -1.
mdadm: clearing FAULTY flag for device 6 in /dev/md0 for /dev/sdh1
mdadm: Marking array /dev/md0 as 'clean'
mdadm:/dev/md0 has an active reshape - checking if critical section needs to be
restored
mdadm: added /dev/sda1 to /dev/md0 as 1
mdadm: added /dev/sdf1 to /dev/md0 as 2
mdadm: no uptodate device for slot 3 of /dev/md0
mdadm: added /dev/sde1 to /dev/md0 as 4
mdadm: added /dev/sdb1 to /dev/md0 as 5
mdadm: no uptodate device for slot 6 of /dev/md0
mdadm: added /dev/sdc1 to /dev/md0 as -1
mdadm: added /dev/sdh1 to /dev/md0 as -1
mdadm: added /dev/sdd1 to /dev/md0 as 0
mdadm: /dev/md0 assembled from 5 drives and 2 spares - not enough to start the
array.


