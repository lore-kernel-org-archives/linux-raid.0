From: Bostjan Skufca <bostjan@a2o.si>
Subject: Boot option raid=parttitionable and autodetection
Date: Thu, 11 Sep 2014 01:31:13 +0200
Message-ID: <CAEp_DRBuccHOzkrJe8UKP1bKLdk_GM1TB8rqB_7_9w-fgdUZ0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

does kernel boot time parameter raid=partitionable ofer any additional
feature over not using it at all?

Besides changing autodetected device names from /dev/mdX to /dev/md_dX
I currently can not see any other difference, save lilo being unable
to work with them.

Normal raid devices can be partitioned without hassle, unfortunately
in-kernel autodetection of nested raid arrays does not work (talking
about raid0 over raid1 here, not raid10), but that is more or less
understandable.


Another quick question:
What is the status of in-kernel autodetection vs initramfs based one?
As I could gather from various sites it seems initramfs is preferable,
but what does that mean for in-kernel detection? Is it slowly being
phased out?

Tnx for info,
b.
