From: Gavin Flower <gavinflower@yahoo.com>
Subject: mdadm: recovering from an aborted reshape op - mdadm -Avv /dev/md1 /dev/sd[adbce]2
Date: Mon, 14 Feb 2011 12:47:44 -0800 (PST)
Message-ID: <880269.28578.qm@web65113.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mdadm -Avv /dev/md1 /dev/sd[adbce]2

mdadm: looking for devices for /dev/md1
mdadm: /dev/sda2 is identified as a member of /dev/md1, slot 0.
mdadm: /dev/sdb2 is identified as a member of /dev/md1, slot 1.
mdadm: /dev/sdc2 is identified as a member of /dev/md1, slot 4.
mdadm: /dev/sdd2 is identified as a member of /dev/md1, slot 3.
mdadm: /dev/sde2 is identified as a member of /dev/md1, slot 2.
mdadm:/dev/md1 has an active reshape - checking if critical section needs to be restored
mdadm: added /dev/sdb2 to /dev/md1 as 1
mdadm: added /dev/sde2 to /dev/md1 as 2
mdadm: added /dev/sdd2 to /dev/md1 as 3
mdadm: added /dev/sdc2 to /dev/md1 as 4
mdadm: added /dev/sda2 to /dev/md1 as 0
mdadm: /dev/md1 has been started with 5 drives.
mdadm: restoring critical section
mdadm: restoring critical section


      
