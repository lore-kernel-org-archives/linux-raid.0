From: Mike Lovell <mlovell@bluehost.com>
Subject: [PATCH 0/1] Bug fix for mdadm 3.3 with large md device numbers
Date: Fri, 13 Feb 2015 18:08:07 -0700
Message-ID: <1423876088-7169-1-git-send-email-mlovell@bluehost.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, mlovell@bluehost.com
List-Id: linux-raid.ids

A co-worker discovered a situation were new arrays were not being created on
a system. Invoking mdadm similar to 'mdadm --create /dev/md/array-name ...'
would fail where 'mdadm --create /dev/md999 ...' would not. This system had
previously created 128 arrays successfully. He was able to work around the
problem by reverting from mdadm 3.3 to 3.2. The error reported from mdadm
was "mdadm: unexpected failure opening /dev/md1048575."

Some digging with strace showed that mdadm would try to call
open("/sys/block/md1048575/dev") which would fail and then would fail on a
call to open("-4087:-1"). I tested 'mdadm --create /dev/md1048575 ...' on an
empty test VM which would fail as well. 

The problem was traced to the md device number being used to create a
major:minor pair which would be passed to makedev(). The result, which is a
dev_t or u32, was then being used as a signed int before being passed to
major() and minor() and then into a string as signed ints. This meant that 
the major:minor string had negative numbers in it causing dev_open() to not
recognize it as a valid pair and just calling open() on the string.

The large number was generated because the problem system already had 128
arrays on it. This caused find_free_devnm() to loop from 0 to (1<<20)-1, or
1048575. Triggering the bug is done by specifying a md device number larger
than (1<<19)-1 or by creating a md array by name on a system with 128 already
configured arrays.

Originally, I was going to modify find_free_devnm to loop to (1<<19)-1 but,
since 3.2 works with the larger numbers, I decided to change the signed int
use around devnm2devid and devid2devnm. This patch has been tested against
a number of the tests that weren't already failing on my test system and
didn't cause any more tests to fail. I didn't test all but got the basics.
I am new to the mdadm source and not normally a C developer so this may not
be the best way to fix this but it seems to be working.

