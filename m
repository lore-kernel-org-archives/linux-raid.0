From: Andargor The Wise <andargor@yahoo.com>
Subject: First RAID Setup
Date: Thu, 15 Dec 2005 11:09:33 -0800 (PST)
Message-ID: <20051215190933.16009.qmail@web54612.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I admit it. I'm a RAID virgin.

However, after a disastrous failure of the sole drive
I wasn't backing up, I decided to go RAID-5 under
Slack 10.2 (first time ever with RAID-5).

The config:

Asus P5GL-MX (ICH6) mobo w/1 GB RAM, 4 x SATA ports
P4 3.0G/1M
3 x WD2000JS 200.0 GB SATA drives

First, a question: the BIOS on this machine seems to
list the SATA ports as "third/fourth IDE
master/slave". Further, the documentation seems to say
that SATA 1/2 are "master" and SATA 3/4 are "slave"
(black and red connectors, respectively).

My understanding is that SATA drives are each on
separate buses. Is this because the BIOS offers a
P-ATA emulation mode for SATA and it makes it "easier"
to understand for novices to show them that way?

I ask because people have said that it is not a good
idea to have both IDE masters and slaves on the same
bus as part of a RAID-5 array. I know SATA is
different, but will using three of the SATA ports on
this mobo be OK?

Second, after reading the excellent advice in this
list, I decided that booting from RAID-5 might not be
a good idea. So this is what I've been thinking:

Each disk partitioned alike:
	1	30MB 
	2	8GB (to allow for memory upgrades later)
	5	rest_of_disk

mds:
	md0	raid1 sda1 sdb1 sdc1
	md1	raid1 sda2 sdb2 sdc2
	md2	raid5 sda5 sdb5 sdc5

	md0	/boot
	md1	swap
	md2	/

Does this look OK? What should the stripe and chunk
sizes be, considering I'll be going with reiserfs?
Typical usage: development machine, some DB apps with
medium load, read-only mostly, not many writes. Very
few large files (such as multimedia).

Or should I set up separate RAID-5's for /usr and /var
as well?

Lastly, can I install directly to this configuration,
or should I install on a separate disk and move things
into the array?

Andargor


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
