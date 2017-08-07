From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: raid1 mismatch_cnt 128 revisited - so I can sleep better at night...
Date: Mon, 7 Aug 2017 02:35:19 -0500
Message-ID: <dbe4e7d5-0d46-fec3-346b-67628144743d@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil, all,

  After a recent scrub on my / filesystem raid1 array, I checked and received
a mismatch_cnt of 128. E.g.

$ cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sda6[0] sdb6[1]
      52396032 blocks super 1.2 [2/2] [UU]

md3 : active raid1 sdb8[1] sda8[0]
      2115584 blocks super 1.2 [2/2] [UU]

md0 : active raid1 sda5[0] sdb5[1]
      511680 blocks super 1.2 [2/2] [UU]

md2 : active raid1 sda7[0] sdb7[1]
      921030656 blocks super 1.2 [2/2] [UU]
      bitmap: 0/7 pages [0KB], 65536KB chunk

md4 : active raid1 sdd[2] sdc[0]
      2930135488 blocks super 1.2 [2/2] [UU]
      bitmap: 0/22 pages [0KB], 65536KB chunk


md3 is swap,

$ for i in {{0..2},4}; do \
    echo -n "md$i mismatch count: " \
    cat /sys/block/md$i/md/mismatch_cnt \
  done
md0 mismatch count: 0
md1 mismatch count: 128
md2 mismatch count: 0
md4 mismatch count: 0

  The normal search of raid1 mismatch_cnt brings up the old bug report where
this has been addressed and fixed several times since the 2.6 days:

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=405919

  The apt title of the bug is "please explain mismatch_cnt so I can sleep
better at night" which is usually why admins end up searching after
encountering a non-zero mismatch_cnt.

  So, have we had a regression in the 4.12.4 kernel code?

  Or, should I just chock it up to the same of logic of a page of memory that
hasn't changed being written out to swap and the write-request sitting on the
array until it eventually copied out of the page resulting in different times
that are flagged as mismatched -- and ignore it?

  The only thing that worries me is top report nothing in swap, e.g.

GiB Swap:  0.0/2.018

so the old swap caused time difference wouldn't seem to apply?

  What say the experts? Should I be concerned here or is this still a running
issue I can ignore.

-- 
David C. Rankin, J.D.,P.E.
