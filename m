From: Dimitrios Apostolou <jimis@gmx.net>
Subject: RAID1 and load-balancing during read
Date: Mon, 10 Sep 2007 22:29:30 +0300
Message-ID: <200709102229.30655.jimis@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list, 

I just created a RAID1 array consisting of two disks. After experiments with 
processes *reading* from the device (badblocks, dd) and the iostat program, I 
can see that only one disk is being utilised for reading. To be exact, every 
time I execute the command one of the two disks is being randomly used, but 
the other one has absolutely no activity. 

My question is: why isn't load balancing happening? Is there an option I'm 
missing? Until now I though it was the default for all RAID1 implementations. 
Even md man page mentions in the RAID1 section: 

  The driver attempts to distribute read requests across all devices to 
maximise performance.


Thanks in advance, 
Dimitris
