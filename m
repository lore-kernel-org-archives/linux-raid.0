From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: mdadm: ioctl(GET_DISK_INFO) question
Date: Fri, 27 Apr 2012 17:14:28 +0300
Message-ID: <CAGRgLy4p0aiZD92dJsV3tdcZyPaJ=8Nc6CKWVcQU20QtMb6MBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

what is the reason that in some places (like Detail()), the code tests
for all desc_nrs possible (value read from superblock or MaxDisks
macro):
for (d = 0; d < max_disks; d++) {
    disc.number = d;
    ioctl(fd, GET_DISK_INFO, &disk)

and in other places (like Monitor()), the loop goes only up to :
array.raid_disks + array.nr_disks.

After all, disk.number (which is rdev->desc_nr in kernel) is merely a
position of the disk entry in the dev_roles[] array in the superblock,
and has no relation to the raid slot of the disk. Shouldn't the code
always check max_disks possible?

Thanks,
  Alex.
