From: Ian Pilcher <arequipeno@gmail.com>
Subject: Creating volume in IMSM container
Date: Tue, 07 Apr 2015 10:29:02 -0500
Message-ID: <mg0t3u$ol$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am trying to create an IMSM container and volume in a KVM virtual
machine (so that I can create a reproducer for a Fedora problem that
seems to only/mostly affect IMSM RAID).  I've  managed to create a
container with the following command:

   IMSM_NO_PLATFORM=1 mdadm --create --verbose /dev/md/imsm \
       /dev/vd{a,b} --raid-devices 2 --metadata=imsm

/proc/mdstat now contains:

   Personalities: [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] ...
   md127 : inactive vdb[1](S) vda[0](S)
         2210 blocks super external:imsm

I haven't, however, been able to create a volume within the container:

   # IMSM_NO_PLATFORM=1 mdadm --create --verbose /dev/md/vol0 \
        /dev/md/imsm --raid-devices 2 --level 1 --metadata=imsm
   mdmon: not enough devices with space to create array.

   # IMSM_NO_PLATFORM=1 mdadm --create --verbose /dev/md/vol0 \
        /dev/vd{a,b} --raid-devices 2 --level 1 --metadata=imsm
   mdadm: /dev/vda appears to be part of a raid array:
          level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
   mdmon: /dev/vdb is not in the same imsm set
   mdadm: /dev/vdb is not suitable for this array.
   mdadm: create aborted

Am I doing something wrong, or is this simply not possible?

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
-------- "I grew up before Mark Zuckerberg invented friendship" --------
========================================================================

