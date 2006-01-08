From: David Greaves <david@dgreaves.com>
Subject: Using a disk image file as a device in a raid set (like a loopback
 device)
Date: Sun, 08 Jan 2006 10:25:33 +0000
Message-ID: <43C0E89D.3040209@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi

First, this is not a raid recovery problem !!!

I'm recovering a disk failure and for various reasons I've ended up with
a partition that's too small to hold the file system that belongs in it.

I managed to create a second small partition on a good bit of the
failing disk and use linear mode to concatenate the almost big enough
partition (sdc2) with the temp partition (sdb2) to make a big enough
space to ddrescue the failing data.

All is now good with 95% of data on the good disk and the small
partition is holding up.  However I need to get rid of it ASAP.
So I dd'ed the small partition onto a good filesystem on sdc1.
Now I want to:

mdadm -B /dev/md0 -l linear -n2 /dev/sdc2 /space/sdb2.dd_image

but of course mdadm correctly complains that /space/sdb2.dd_image isn't
a block device.

Does anyone know how I can do this?


David

-- 

