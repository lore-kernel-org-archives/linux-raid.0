From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: ANNOUNCE: mdadm 1.1.0 - A tool for managing Soft RAID under Linux
Date: Mon, 3 Mar 2003 10:23:05 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15970.37465.869711.682093@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



I am pleased to announce the availability of 
   mdadm version 1.1.0
It is available at
   http://www.cse.unsw.edu.au/~neilb/source/mdadm/
and
   http://www.{countrycode}.kernel.org/pub/utils/raid/mdadm/

as a source tar-ball and (at the first site) as an SRPM, and as an RPM for i386.

mdadm is a tool for creating, managing and monitoring
device arrays using the "md" driver in Linux, also
known as Software RAID arrays.

Release 1.1.0 contains a number of spell corrections, and bug fixes.
It has improved support for MULTIPATH arrays.
It has some new features including:
  --daemonise   	for use with --monitor
  --config=partitions   to find devices by examining /proc/partitions
  --update=super-minor  to change the recorded minor-number for an array

Much of the improvements are due to user feed-back.  Thanks are due to all who 
gave suggestions and reported problems.

I expect the next major release to be 2.0.0 which will include support for 
a new super-block format soon to be supported by 2.5 series kernels.


Development of mdadm is sponsored by CSE@UNSW: 
  The School of Computer Science and Engineering
at
  The University of New South Wales

NeilBrown  03/03/03
   The third day 
of the third month
of the third year
of the third millenium

