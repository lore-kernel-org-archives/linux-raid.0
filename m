From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: ANNOUNCE: mdadm 1.4.0 - A tools for managing Soft RAID under Linux
Date: Wed, 29 Oct 2003 10:25:58 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16286.64262.782600.613302@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



I am pleased to announce the availability of 
   mdadm version 1.4.0
It is available at
   http://www.cse.unsw.edu.au/~neilb/source/mdadm/
and
   http://www.{countrycode}.kernel.org/pub/utils/raid/mdadm/

as a source tar-ball and (at the first site) as an SRPM, and as an RPM for i386.

mdadm is a tool for creating, managing and monitoring
device arrays using the "md" driver in Linux, also
known as Software RAID arrays.

Release 1.4.0 adds:
    SparesMissing event in --monitor mode if a number of spares is declared
       in mdadm.conf, but that number of spares isn't found.
    --update=summaries option for --assemble mode to update some summary information
        in the superblock
    --test option for --detail to get a useful exit status.

Development of mdadm is sponsored by CSE@UNSW: 
  The School of Computer Science and Engineering
at
  The University of New South Wales

NeilBrown  29 Oct 2003
