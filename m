From: "Robin Bowes" <robin-lists@robinbowes.com>
Subject: How to replace faulty disk in RAID5 setup?
Date: Sun, 8 Aug 2004 09:06:36 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1142.212.134.28.56.1091952396.squirrel@212.134.28.56>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

This question came up in another thread, but buried at the end so I thought it would be worth pulling out and asking explicitly.

I have a 6-disk RAID5 array made up of 6 x 250GB Maxtor SATA drives (5 + 1 hot spare)

Suppose one fails. What is the process I need to follow to replace the faulty disk?

Here's my best guess so far:

(assume /dev/sdc has failed).

Shutdown server.
Pull dead drive
Insert new drive
Boot up server
Create partition table on new drive (all my drives are partitioned identically):
  # sfdisk -d /dev/sda | sfdisk /dev/sdc

(Is it necessary to explicitly "remove" the failed device from the
arrays (before shutting down?) and to add it back in after replacing the
disk?)

For example, would this work?:

# mdadm /dev/md5 -f /dev/sdc2 -r /dev/sdc2 -a /dev/sdc2

According to my understanding, this does the following:

1. Marks /dev/sdc2 as faulty in /dev/md5 (if the drive has failed it should
already be marked faulty??)
2. removes /dev/sdc2 from /dev/md5
3. Adds /dev/sdc2 to /dev/md5

Am I missing any important steps?

R.
-- 
http://robinbowes.com

