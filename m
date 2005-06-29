From: John Rowe <rowe@excc.ex.ac.uk>
Subject: Slow reconstruction
Date: Wed, 29 Jun 2005 17:10:30 +0100
Message-ID: <1120061430.21458.236.camel@volt>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

First, thanks to all the authors of software RAID, which works really
well. 

I have just one problem(!) and as disks get bigger it gets worse:
reconstruction takes a long time. At the moment I've just had a disk
fail on a 5x250 GB RAID5 array and it's going to take eight days to
recover. Is there anything I can do to speed things up?

FWIW, each disk is the master drive on an IDE card, two of the disks are
shared with the RAID1 root partition and one of the 5 devices is a RAID0
stripe. The system isn't doing anything else, it's just used for backup.

Thanks again.

John

