From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: ANNOUNCE: mdadm-1.0.9 - prelease for 1.1.0
Date: Wed, 12 Feb 2003 11:28:15 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15945.38175.58593.681394@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi all,
 I have just placed mdadm-1.0.9 at

   http://www.cse.unsw.edu.au/~neilb/source/mdadm/mdadm-1.0.9.tgz

 and it should appear at
 
   http://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-1.0.9.tar.gz

 shortly.

 I plan to release it as 1.1.0 and announce it more widely after
 incorporating any feedback.

 I expect the next release of mdadm after 1.1.0 to have  support for
 different superblock layouts (shortly to appear in 2.5...) and to be
 called version 2.0 (though there might be some 1.9. pre-releases
 first).

 The changelog includes:

    -   Documentation updates including kernel parameters documented
	in md.4
    -   --assemble --force for raid4/5 will mark clean, needed for 2.5
    -   --detail prints out the events counter as well
    -   flush device before reading superblock to be sure to get
	current data
    -   added mdadm.static target to makefile for static linking
    -	--monitor was ignoring  /dev/md0 due to off-by-one error
    -	Fix assorted typos
    -   Fix printing of Gibibytes - calc was wrong.
    -   Fix printing of Array Size in --detail when very big.
    -   --monitor no longer tries to work for raid0 or linear as these
	have nothing to be monitors.
    -   The word 'partitions' on a DEVICE line will cause all partitions
	listed in /proc/partitions to be considered
    -   If the config file is called 'partitions' then it will be treated
        as though it contained exactly 'device partitions' so e.g.
	  mdadm -Ebsc partitions
	will fill all raid partitions easily.	
    -	successfully assemble multipath devices by ignoring raid_disk
	value from superblock (it is always the same).
    -   --assemble not tied to MD_SB_DISKS limit quite so much
    -   Support compiling with tcc
    -   Support compiling with uclibc - just skip scan of /dev
    -   Add --update= option for Assemble mode.  Either sparc2.2
	or super-minor updates are possible.  See mdadm.8

 Please try it out and let me know what you think.

NeilBrown
