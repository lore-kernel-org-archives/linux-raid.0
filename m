From: Liam Kurmos <quantum.leaf@gmail.com>
Subject: raid5 wont start
Date: Fri, 10 Jun 2011 16:24:58 +0100
Message-ID: <BANLkTinT-LF=+bDUK_1h35imsWhQWLjkog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi All,

I'm currently experiencing a nightmare scenario, and hoping someone
here might be able to help me.

I have a deadline on my phd at the end of the weekend. I was just
running some calculations when an unexpected power failure took my
system down.
Restarting and fsck tried to run but failed. rebooting again the
system drive starts but is unable to mount my /home which on a
separate /md1 raid5.

I am able to get to a console where i'm trying to fix the problem.

my devices are
md0 level=10 devices /dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1
md1 level=5 devices /dev/sda5,/dev/sdb3, /dev/sdc3,/dev/sdd3

doing cat /proc/mdstat
shows md1: inactive sdc3[2] sdb3[1] sdd3[3]

and md0: active raid10 sdd1[3] sdc1[2] sdb3[1]`

this makes me wonder if there was a temporary problem with sda after
the powercut (it appears to be fine now)

examining sda1 it appears to be fine (similar to sdb1 etc)
Array state is AAAA
yet md0 appear to be active without sda1 according to /proc/mdstat.

examining sda5 there where it lists the other drives in the array
there is an anomaly

the right hand to columns read:

active sync  /dev/sda5
active sync  /dev/sdc3
active sync  /dev/sdd3
active sync

so there is no mention of sdb3 and the bottom device has no name...

examining the other partitions b3,c3,d3 the RHS of the bottom 4 lines
are identically

removed
active sync  /dev/sdb3
active sync  /dev/sdc3
active sync  /dev/sdd3

so those partitions suggest it is a which is removed.

I would be tempted to try re-adding sda5 to md1, and sda1 to md0.
but the anomaly above makes me concerned this could make things worse
as I really cant afford to loose data on md1 now. I would have thought
the raid5 would still be able to run with 1 drive removed, as the
raid10 appears to be...

finally i should mention attempting to run /dev/md1 i  get errors

cannot start dirty degraded array
failed to run raid set
md: pers->run() failed...

can anyone suggest how i should proceed?

Liam
