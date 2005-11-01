From: Ming Zhang <mingz@ele.uri.edu>
Subject: raid0 fail to detect drive failure
Date: Tue, 01 Nov 2005 11:02:54 -0500
Message-ID: <1130860974.9447.19.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi folks

I have a raid0 on top of 2 sata disk sda and sdb. after i hot unplug
sda, the raid0 still shows online and active. run dd to write to it will
fail and dmesg shows scsi io error. but /proc/mdstat shows everything is
ok.

checked 2.4.27 and 2.6.11.2, both show same problem.

mdadm is 1.8

any hint?

Ming


