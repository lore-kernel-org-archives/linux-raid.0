From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: ANNOUNCE: mdadm 1.10.0 - A tool for managing Soft RAID under Linux
Date: Tue, 5 Apr 2005 11:49:13 +1000
Message-ID: <16977.61081.999463.177414@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



I am pleased to announce the availability of 
   mdadm version 1.10.0
It is available at
   http://www.cse.unsw.edu.au/~neilb/source/mdadm/
and
   http://www.{countrycode}.kernel.org/pub/linux/utils/raid/mdadm/

as a source tar-ball and (at the first site) as an SRPM, and as an RPM for i386.

mdadm is a tool for creating, managing and monitoring
device arrays using the "md" driver in Linux, also
known as Software RAID arrays.

Release 1.9.0 adds:
    -   Fix bug with --config=partitions
    -   Open sub-devices with O_EXCL to detect if already in use
    -   Make sure superblock updates are flushed directly to disk.

The first update is the most significant ("mdadm -Escpartitions" would crash).
The others are mildly useful extras.

Development of mdadm is sponsored by CSE@UNSW: 
  The School of Computer Science and Engineering
at
  The University of New South Wales

NeilBrown  04 April 2005

