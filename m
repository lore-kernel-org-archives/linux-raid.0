From: Nicholas Leippe <nick@byu.edu>
Subject: smart raid1 reads?
Date: Thu, 19 Jun 2003 19:14:52 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200306191914.52921.nick@byu.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I searched the archives, and the last time this was mentioned was in 2001, and 
no response was ever given.

In a raid0, of course, reads pull off every disk in parallel, thus performance 
scales with # of disks.

However, with raid1, it does not do this--it always reads from just one half 
of the mirror.  Why doesn't it read from both halves of the mirror in 
parallel?  I would expect it to, and would expect raid1 to perform similar to 
raid0 for reads.

I have observed this with 2.4.18 and 2.4.20 thru at least 21rc2.


Nick
please cc

