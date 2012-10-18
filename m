From: Jivko Sabev <jsabev@nicmus.com>
Subject: Cannot auto assemble a raid1 array on boot
Date: Wed, 17 Oct 2012 20:35:27 -0600
Message-ID: <CAG9W8wBsh_i_jtqKFhEVywCk92hef41T0t+6J9saZD3CFT7V9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

I have a RAID1 array setup of the following

/dev/md0 [linear raid array consisting of two 500GB SATA drives]
/dev/md1  [RAID1 array consisting of /dev/md0 and one 1TB SATA drive]

here is my /proc/mdstat

--------

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md1 : active raid1 md0[0] sde1[2]
      976639296 blocks super 1.2 [2/2] [UU]

md0 : active linear sdb1[0] sdc1[1]
      976770537 blocks super 1.2 0k rounding

unused devices: <none>


--------

However, on every reboot, the md1 array is in degraded mode and I get
dumped to a intramfs shell. I can then assemble the said array - i.e.
mdadm --assemble /dev/md1 /dev/md0 /dev/sde1 and everything is fine.
Is it possible to have such an array auto assembled and how?

Many thanks,

Jivko
