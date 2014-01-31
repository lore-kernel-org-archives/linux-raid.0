From: Francis Moreau <francis.moro@gmail.com>
Subject: Soft RAID and EFI systems
Date: Fri, 31 Jan 2014 18:02:11 +0100
Message-ID: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

On EFI systems I'd like to RAID mirror /boot partition.

For HW RAID there's no issue since access to the disk or any
partitions should be totally transparent to the bios.

For Fake RAID, I'm not sure but I would say that the bios is able to
read the RAID metadata as well.

For (md) Soft RAID, I don't know. I would say that the bios is
unlikely to understand the md metadata stored in the /boot partition
so it won't work.
Is that correct ?
If so does that mean I can't mirror /boot partition on EFI systems ?
Maybe creating a RAID device using the whole disk (not the partition
device) would work ?

Thanks for your enlightments.
-- 
Francis
