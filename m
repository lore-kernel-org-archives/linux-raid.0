From: jahammonds prost <gmitch64@yahoo.com>
Subject: trouble creating array
Date: Sun, 25 Feb 2007 14:33:17 -0800 (PST)
Message-ID: <727816.19226.qm@web55809.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just built a new FC6 machine, with 5x 320Gb drives and 1x 300Gb drive. Made a 300Gb partition on all the drives /dev/hd{c,d,e} and /dev/sd{a,b,c}... Trying to create an array gave me an error, since it thought there was already an array on some of the disks (and there was an old one).

I decided to clear off the superblock on the drives with mdadm --zero-superblock on all the drives. It worked fine on all drives, except for /dev/sd{b,c)1, which returns an error "mdadm: Couldn't open /dev/sdb1 for write - not zeroing". There doesn't seem to be a problem with the drive, as I've run a non destructive badblocks on it, and also done a dd if=/dev/zero of=/dev/sdb1 on it, and Ive written out 300Gb onto the partition.

When I try and create an array using these 2 partitions, I get an error

mdadm: Cannot open /dev/sdb1: Device or resource busy
mdadm: Cannot open /dev/sdc1: Device or resource busy

and it aborts. I've double checked that the drives aren't mounted anywhere. There's nothing in /var/log/messages either...

Any suggestions where to check next?



Graham


		
___________________________________________________________ 
To help you stay safe and secure online, we've developed the all new Yahoo! Security Centre. http://uk.security.yahoo.com
