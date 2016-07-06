From: o1bigtenor <o1bigtenor@gmail.com>
Subject: Request for assistance
Date: Tue, 5 Jul 2016 19:13:23 -0500
Message-ID: <CAPpdf58z4JagWmP=xiUj9qOU-bdyN7W=EvcM9evjCT4ZWp+VxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Greetings

Running a Raid 10 array with 4 - 3 TB drives. Have a UPS but this area
gets significant lightning and also brownout (rural power) events.

Found the array was read only this morning. Thought that rebooting the
system might correct things - - - it did not as the array did not
load.

commands used followed by system response

mdadm --detail /dev/md0
   mdadm:  md device /dev/md0 does not appear to be active.

cat /proc/mdstat
   md0  : inactive sdc1[5](S) sdf1[8](S) sde1[7](S) sdb1[4](S)

mdadm -E /dev/sdb1
                       sdc1
                       sde1
                       sdf1

everything is the same except for 2 items

sde and sdf have uptime listed from July 04 05:50:46
                          events 64841
                          array state of AAAA

sdb and sdc have uptime listed from July 05 01:57:38
                           events 64844
                           array state of AAA.



Do I just re-create the array?

TIA

Dee
