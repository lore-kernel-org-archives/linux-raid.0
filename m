From: Du Jun <dujun@perabytes.com>
Subject: raid related kernel hang in 2.6.36
Date: Wed, 24 Nov 2010 21:48:20 +0800
Message-ID: <4CED17A4.7050604@perabytes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
We just quick tested the raid stability under the vanilla 2.6.36 kernel
and got an unstable result.

first, we create a raid5 array using 16 sata disks:

mdadm -C /dev/md10 -l 5 -n 16 /dev/sd[b-q]

then use dd to stress the io:

dd if=/dev/zero of=/dev/md10 bs=1M

After a while, usually several minutes, the system hangs. It looks like
some kind of kernel deadlock. ping to this machine could get timely
response, however, any other process just hangs.

It is easily reproducible and everytime the test result is a system hang.

Johnson

