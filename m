From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: ANNOUNCE: mdadm 1.11.0 - A tool for managing Soft RAID under Linux
Date: Mon, 11 Apr 2005 10:34:51 +1000
Message-ID: <16985.50731.39176.449730@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Dave Jiang <djiang@mvista.com>
List-Id: linux-raid.ids


I am pleased (embarrassed?) to announce the availability of 
   mdadm version 1.11.0
It is available at
   http://www.cse.unsw.edu.au/~neilb/source/mdadm/
and
   http://www.{countrycode}.kernel.org/pub/linux/utils/raid/mdadm/

as a source tar-ball and (at the first site) as an SRPM, and as an RPM for i386.

mdadm is a tool for creating, managing and monitoring
device arrays using the "md" driver in Linux, also
known as Software RAID arrays.

Release 1.11.0 adds:
    -   Fix embarrasing bug in 1.10.0 which causes --add to always fail.
          thanks to Dave Jiang <djiang at mvista dot com> for reporting it.

Development of mdadm is sponsored by CSE@UNSW: 
  The School of Computer Science and Engineering
at
  The University of New South Wales

NeilBrown  11 April 2005

