From: Nikhil Kshirsagar <nkshirsa@redhat.com>
Subject: mdadm - raid6 best practices ?
Date: Fri, 22 Sep 2017 09:25:33 +0530
Message-ID: <CAMNNMLHLA8mEEKpX8UAXgZPYXyL+mhSBC74K_azC25z=+VAc7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello linux-raid,

A customer has some questions about raid6 best practices. They are
using a 84-disk MD1280 Expansion Shelf (seagate disks). They want to
use mdadm to setup a s/w raid, using raid6.

The questions are

a) recommended number of disks included in RAID array set?
b) Is it possible to include all 84 disks in one array and leave 2 of
them as host spare?
c) Is there a raid6 best practices document to refer to ?

Can anyone point me to me any internal docs or articles to construct a
reply to the customer?

Thanks,
Nikhil.
