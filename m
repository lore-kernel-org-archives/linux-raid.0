From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0 of 4]  MD RAID10:  Improve redundancy of RAID10 'far' and
 'offset' algorithms
Date: Mon, 17 Dec 2012 12:33:23 -0600
Message-ID: <1355769203.15326.20.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, agk@redhat.com, jbrassow@redhat.com
List-Id: linux-raid.ids

Neil,

I've changed the way 'far' and 'offset' algorithms are done to reflect
your latest suggestions.  The case where there were a non-multiple of
'far_copies' devices in the array was the tricky issue we were dealing
with.  I've separated my patch into two - one dealing with the
multiple-of-far_copies case and the other dealing with the non-multiple
case.

I had to make some adjustments to the dm-raid patch that includes the
new 'far' and 'offset' algorithms and I've included that revised patch
in this set.

[PATCH 1 of 4]MD RAID10: Minor non-functional code changes
[PATCH 2 of 4]MD RAID10:  Improve redundancy for 'far' and 'offset' algorithms (part 1)
[PATCH 3 of 4]MD RAID10:  Improve redundancy for 'far' and 'offset' algorithms (part 2)
[PATCH 4 of 4]DM RAID:  Add support for MD's RAID10 "far" and "offset" algorithms

Thanks,
 brassow

