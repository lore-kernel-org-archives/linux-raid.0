From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Requesting migrate device options for raid5/6
Date: Mon, 29 Oct 2007 17:19:51 +0100
Message-ID: <87hck9c2qg.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I would welcome if someone could work on a new feature for raid5/6
that would allow replacing a disk in a raid5/6 with a new one without
having to degrade the array.

Consider the following situation:

raid5 md0 : sda sdb sdc

Now sda gives a "SMART - failure iminent" warning and you want to
repalce it with sdd.

% mdadm --fail /dev/md0 /dev/sda
% mdadm --remove /dev/md0 /dev/sda
% mdadm --add /dev/md0 /dev/sdd

Further consider that drive sdb will give an I/O error during resync
of the array or fail completly. The array is in degraded mode so you
experience data loss.


But that is completly avoidable and some hardware raids support disk
migration too. Loosly speaking the kernel should do the following:

raid5 md0 : sda sdb sdc
-> create internal raid1 or dm-mirror
raid1 mdT : sda
raid5 md0 : mdT sdb sdc
-> hot add sdd to mdT
raid1 mdT : sda sdd
raid5 md0 : mdT sdb sdc
-> resync and then drop sda
raid1 mdT : sdd
raid5 md0 : mdT sdb sdc
-> remove internal mirror
raid5 md0 : sdd sdb sdc 


Thoughts?

MfG
        Goswin
