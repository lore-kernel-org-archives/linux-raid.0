From: Stephen C Woods <scw@seas.ucla.edu>
Subject: How to force raid to stop, cleanly?
Date: Tue, 8 Apr 2003 11:12:21 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200304081812.LAA01914@washington.seas.ucla.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

   We're running 2.4.20,  we've come across a situation where the 
raid and overlying LVM seems to be stuck.  No I/O is occuring, processes
trying to access to raid or overlying volumes hang and can't be
terminated.

   What we'd like to do is to force the raid volume to terminate
and sync its disks and superblocks, so that the raid volume is
or thinks it is consistant.

 The overlying JFS will clean up when it restarts, but we don't want to
wait 3 days for the RAID to finish recomputing parity (these are some really
large arrays).

-----
Stephen C. Woods; UCLA SEASnet; 2567 Boelter hall; LA CA 90095; (310)-825-8614
Unless otherwise noted these statements are my own, Not those of the 
University of California.                      Internet mail:scw@seas.ucla.edu
