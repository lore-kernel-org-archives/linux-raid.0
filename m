From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: ANNOUNCE: mdadm 1.6.0 - A tool for managing Soft RAID under Linux
Date: Fri, 4 Jun 2004 16:29:14 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16576.5818.189830.563396@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




I am pleased to announce the availability of 
   mdadm version 1.6.0
It is available at
   http://www.cse.unsw.edu.au/~neilb/source/mdadm/
and
   http://www.{countrycode}.kernel.org/pub/linux/utils/raid/mdadm/

as a source tar-ball and (at the first site) as an SRPM, and as an RPM for i386.

mdadm is a tool for creating, managing and monitoring
device arrays using the "md" driver in Linux, also
known as Software RAID arrays.

Release 1.6.0 adds:
  - --grow which (in 2.6.7-rc1-mm1 and hopefully 2.6.8) allows raid1/4/5/6
    arrays to change the active size of the underlying devices, and allows
    raid1 arrays to change the number of active drives.
  - Allows --build to buld raid1 and multipath arrays.
  - adds "degraded" and "recovering" as possibilities for the status line
    in --detail
  - fixes a bug in 1.5.0 which stopped resync status messages from being
    generated in --monitor mode
  - Further support for partitionable arrays included "--auto=" option
    and "auto=" config file entry which instructs mdadm to create the necessary
    device files after allocating an unused array number.
  - assorted minor fixes and improvements.

Development of mdadm is sponsored by CSE@UNSW: 
  The School of Computer Science and Engineering
at
  The University of New South Wales

NeilBrown  4 Jun 2004
