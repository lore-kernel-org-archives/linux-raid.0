From: Wols Lists <antlists@youngman.org.uk>
Subject: Unable to convert raid1 to raid5
Date: Fri, 5 Aug 2016 21:16:54 +0100
Message-ID: <57A4F436.9080402@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

In my testing of xosview, I've been mucking about with a vm and raid.
xosview is looking quite promising (I've got a few comments about it,
but never mind).

BUT. In mucking about with raid 1, I increased my raid devices to three.
I now just can NOT convert the array to raid 5! I've been mucking around
with all sorts of things trying to get it to work, but finally two error
messages make things clear.

# mdadm /dev/md/testarray --grow --level=5 --backup-file=raidbackup
mdadm: Can only convert a 2-device array to RAID5
#

Okay. That shound't be a problem. BUT

# mdadm /dev/md/testarray --grow -n2
mdadm: failed to set raid disks
#

and I get that error even when I've failed and removed the third device.
Any ideas? Oh yes - I *have* downloaded the latest mdadm from Neil's git
repository :-)

I'm running SuSE leap 42.1, and I've disabled AppArmor (yes, I remember
SELinux mucking things up - I didn't want AppArmor doing the same ...)

Cheers,
Wol
