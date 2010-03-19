From: jin zhencheng <zhenchengjin@gmail.com>
Subject: BUG:write data to degrade raid5
Date: Fri, 19 Mar 2010 18:29:28 +0800
Message-ID: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

hi;

i use kernel is 2.6.26.2

what i do as follow:

1, I create a raid5:
mdadm -C /dev/md5 -l 5 -n 4 /dev/sda /dev/sdb /dev/sdc  /dev/sdd
--metadata=1.0 --assume-clean

2, dd if=/dev/zero of=/dev/md5 bs=1M &

write data to this raid5

3, mdadm --manage /dev/md5 -f /dev/sda

4 mdadm --manage  /dev/md5 -f /dev/sdb

if i faild 2 disks ,then the OS kernel display OOP error and kernel down


do somebody know why ?

Is MD/RAID5 bug ?
