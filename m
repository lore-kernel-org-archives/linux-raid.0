From: Alfred Isele <Alfred.Isele@fujitsu-siemens.com>
Subject: raid1: resync hanging until reboot
Date: Mon, 07 Apr 2003 15:25:14 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3.0.6.32.20030407152514.00b8ae30@athen>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello!

When we disable a partition from a raid meta device
and try to reattach it again without a reboot in between
the resynch often starts hanging. After a reboot the
resynch does complete. In detail:

We use Linux version 2.4.19-64GB-SMP 

We create a raid1 meta devivce:

    mdadm -Cv /dev/md0 -l1 -n2 /dev/sda1 /dev/sdb1

We disable one piece from the meta device:

    mdadm /dev/md0 -f /dev/sda1 -r /dev/sda1

We reattach it to the meta device:

	mdadm /dev/md0 -a /dev/sda1

And very often but not always the resych hangs with
cat /proc/mdstat showing:

	md0 : active raid1 sda1[2] sdb1[1]
      	80256 blocks [2/1] [_U]
      	[>....................]  recovery =  0.0% (0/80256) finish=26.7min
speed=0K/sec


Does anybody know a solution to this problem?
Thank you very much
Alfred	


