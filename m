From: Neil Brown <neilb@suse.de>
Subject: Re: RAID6 Problem (in conjunction with nested LVM and encryption)
Date: Mon, 4 Sep 2006 16:07:26 +1000
Message-ID: <17659.49822.2769.474527@cse.unsw.edu.au>
References: <20060903012118.3e0b7485@30_bodo.rupinet>
	<17659.46039.259569.312043@cse.unsw.edu.au>
	<20060904074539.25e930e7@30_bodo.rupinet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bodo Thiesen on Monday September 4
Sender: linux-raid-owner@vger.kernel.org
To: Bodo Thiesen <bothie@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday September 4, bothie@gmx.de wrote:
> Neil Brown <neilb@suse.de> wrote:
> 
> > On Sunday September 3, bothie@gmx.de wrote:
> >
> >> I have a really really big problem. In fact, the problem is the output of 
> >> mdadm --examine as shown on http://nomorepasting.com/paste.php?pasteID=68021
> > 
> > Please explain why you think that output is a problem.  It looks fine
> > to me.
> 
> 1. craida1 claims about itself to be raidh-raidh1 ...

Thanks.  I didn't notice that (there was a lot of detail to wade
through).

Presumably /dev/mapper/raidh-raidh1 has major/minor of 254,20, but
that seems odd..
What does
   ls -l /dev/mapper/raidh-raidh1 /dev/mapper/craida1
show?

> 
> 2. according to craida1 the raid is composed of raidh-raidh1, a faulty disk 
>    (that was craid1b), craidb1, craidc1 and craida2, but not craida1 itself, 
>    of course                                ^^^^^^^

For craida1 I see:
49		
50		      Number   Major   Minor   RaidDevice State
51		this     0     254       20        0      active sync   /dev/mapper/raidh-raidh1
52		
53		   0     0     254       20        0      active sync   /dev/mapper/raidh-raidh1
54		   1     1       0        0        1      faulty removed
55		   2     2     254       22        2      active sync   /dev/mapper/craidb1
56		   3     3     254       23        3      active sync   /dev/mapper/craidc1
57		   4     4     254       24        4      active sync   /dev/mapper/craidd1

so the raidh-raidh1 - craida1 confusion is still there, but I don't
see craida2 at all.


> 
> 2b. Continue with craida2. It claims to be craide1 and being part of 
>     craide1, craidh1, craida2, craidc2, craidd2.

Ok, I see the issue now.
The device names reported by 'mdadm -E' are based on the major/minor
numbers that are stored in the superblock.  They are only meaningful
if major/minor device numbers are stable.  Presumably dm minor numbers
are very unstable, in that if you take down a target and the
reassemble it could very well have a different minor number.
So the information in the superblock is out-of-date.

Don't worry.  The major/minor information in the superblock is ignored
except by "mdadm -E".  It is not used when assembling arrays.

So this output does look weird, but it doesn't indicate a problem.

> 
> PS: You may stop putting me CC as I finally managed successfully to join the 
>     list ;)

I didn't Cc you.  I sent the mail to you, and Cced the list, as I
always do.  (It is, in general, the safest thing to do). Hopefully
getting two copies of the reply wont be a major inconvenience, and if
it is I believe procmail can be configured to remove such duplicates.

NeilBrown

-- 
VGER BF report: H 0.0361865
