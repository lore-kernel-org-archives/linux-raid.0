From: "Lucas Albers" <admin@cs.montana.edu>
Subject: mdadm create keeps giving error about existing file system
Date: Tue, 21 Sep 2004 15:44:26 -0600 (MDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <2986.153.90.198.54.1095803066.squirrel@153.90.198.54>
Reply-To: admin@cs.montana.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

While trying to create a software raid set:
with the following command:
mdadm --create etc etc etc
The correct syntax.

I get the following error:
"/dev/blah appears to contain an ext2fs file system"

I have tried the following methods to resolve the error:
1.) deleting the partition,
then remaking the partiton with a different partition type.
including the compulsory reboots.

2.) clearing the superblock.
mdadm --zero-superblock /dev/partition

Any ideas?
Just dd the parition?

-- 
Luke Computer Science System Administrator
Security Administrator,College of Engineering
Montana State University-Bozeman,Montana


