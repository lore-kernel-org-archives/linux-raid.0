From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: ANNOUNCE: mdadm 2.0-devel-1 DEVELOPMENT RELEASE - A tool for managing Soft RAID under Linux
Date: Fri, 18 Feb 2005 11:41:17 +1100
Message-ID: <16917.14765.284045.508864@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




I am pleased to announce the availability of 
   mdadm version 2.0-devel-1
It is available at
   http://www.cse.unsw.edu.au/~neilb/source/mdadm/
and
   http://www.{countrycode}.kernel.org/pub/linux/utils/raid/mdadm/

as a source tar-ball and (at the first site) as an SRPM, and as an RPM for i386.

mdadm is a tool for creating, managing and monitoring
device arrays using the "md" driver in Linux, also
known as Software RAID arrays.

Release 2.0-devel-1 is a development release that quit possible has
  bugs.  It released in the hope of getting wider testing.
  It adds support for version-1 superblock which allow more that 28 devices
  in an array (among other things) and for bitmap-based-write-intent-logging
  which can improve resync speed after an unclean shutdown.

  The bitmap logging requires patches which should be in the next -mm release
  after 2.6.11-rc4 and can be downloaded from
    http://neilb.web.cse.unsw.edu.au/patches/linux-devel/2.6/2005-02-18-00/
  which contains patches against 2.6.11-rc3-mm2.


Development of mdadm is sponsored by CSE@UNSW: 
  The School of Computer Science and Engineering
at
  The University of New South Wales

NeilBrown  18 February 2005

