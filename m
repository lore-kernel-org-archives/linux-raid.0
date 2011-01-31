From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 09:41:43 +0000
Message-ID: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

RAID10 is (could be) setup in this way, correct?

2 devices in a RAID1
2 devices in another RAID1

Then you run RAID0 on top of them. If you're lucky you can lose 2
devices at most (1 in each RAID1).

If you have, say 6 HDDs, would you create 3 RAID1 volumes? Then create
a RAID0 on top of them?

How would one go about expanding a 4 HDD RAID10 into a 6 HDD RAID10?
Is it "just" a matter of creating a new RAID1 array of the 2 new HDDs,
then adding them to the RAID0, then expanding whatever is on that
(lvm, xfs, ext4)?

Are there any design tips, or caveats? For example, how many disks
would you use at most, in a RAID10 setup?

Kind regards,
// Mathias
