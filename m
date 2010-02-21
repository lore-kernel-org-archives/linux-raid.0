From: chris <tknchris@gmail.com>
Subject: Weird Issue with raid 5+0
Date: Sat, 20 Feb 2010 23:33:23 -0500
Message-ID: <31e44a111002202033m4a9dfba9yf8aef62b8b39933a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am trying to setup a raid 5+0 on 6 1TB sata disks. I created the
arrays like so:

mdadm --create /dev/md2 --level=5 --raid-devices=2 /dev/sda /dev/sdb /dev/sdc
mdadm --create /dev/md3 --level=5 --raid-devices=2 /dev/sdd /dev/sde /dev/sdf
mdadm --create /dev/md4 --level=0 --raid-devices=2 /dev/md2 /dev/md3

The arrays create and sync fine, then I put lvm on top and create a
volume group and everything seems fine. I created 2 logical volumes
and formatted them with filesystems and initially didn't realize
anything was wrong. After running 2 virtual machines on them for a
while  I noticed the vm's were reporting bad blocks on the volume. I
looked in the dom0 dmesg and found tons of messages such as:

[444905.674655] raid0_make_request bug: can't convert block across
chunks or bigger than 64k 69314431 4

Chunksize for both raid5's and the raid0 is 64k so it would appear the
issue is not that the chunk size is greater than 64k. I also find it
hard to believe it could be any kind of lvm issue simply because the
message in dmesg clearly shows its related to the raid0.

Any ideas on what I'm missing here would be greatly appreciated. I
would imagine it is some kind of alignment between block and chunk
sizes but I can't seem to figure it out :)

More detailed information including raid information and errors is at
http://pastebin.com/f6a52db74

- chris
