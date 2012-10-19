From: Marcus Sorensen <shadowsor@gmail.com>
Subject: raid device gone underneath array
Date: Thu, 18 Oct 2012 18:01:34 -0600
Message-ID: <CALFpzo4gLGzGWLRdVK7bZnYr3hbR7xOgn402UTP2_7UpRE8j6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've been using software raid to mirror two devices, and recently one
of the drives went AWOL.

md1 : active raid1 sdm[0] sdc[1](F)
      12884900728 blocks super 1.2 [2/1] [U_]
      bitmap: 1/96 pages [4KB], 65536KB chunk

However, md1 froze, and in looking at the logs I saw this:

Oct 18 17:47:48 sys kernel: md: cannot remove active disk sdc from md1 ...
Oct 18 17:47:48 sys kernel: md: cannot remove active disk sdc from md1 ...

[root(marcus)@sanmirror3-01 ~]# mdadm --manage /dev/md1 --remove /dev/sdc
mdadm: cannot find /dev/sdc: No such file or directory

/dev/sdc was already gone! The /sys/block was already removed, no
reference to it in /proc/scsi/scsi. So md1 was destined to sit there
forever. So I rebooted and started up the degraded array.

Using kernel 3.6.2 from kernel.org
