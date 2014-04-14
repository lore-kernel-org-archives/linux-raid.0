From: Francis Moreau <francis.moro@gmail.com>
Subject: Force mdadm to not prompt the user
Date: Mon, 14 Apr 2014 17:33:12 +0200
Message-ID: <534BFFB8.2030203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I'm using mdadm in script which setup a system automtically.

When creating a RAID array, I'd like mdadm to not prompt the user.

Currently I get:

# mdadm --create array1 --force --metadata=1.0 --level=raid1
--raid-devices=3 /dev/vdb1 /dev/vdc1 /dev/vdd1
mdadm: /dev/vdb1 appears to be part of a raid array:
       level=raid0 devices=0 ctime=Thu Jan  1 01:00:00 1970
mdadm: metadata will over-write last partition on /dev/vdb1.
Continue creating array?

I thought that using --force would do the trick, but it didn't.

I'm using mdadm - v3.3 - 3rd September 2013

Is there any other way to achieve that ?

Thanks
