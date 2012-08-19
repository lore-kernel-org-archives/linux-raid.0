From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: O_DIRECT to md raid 6 is slow
Date: Sun, 19 Aug 2012 18:34:28 -0500
Message-ID: <50317804.9010701@hardwarefreak.com>
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com> <502B8D1F.7030706@anonymous.org.uk> <CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com> <201208152307.q7FN7hMR008630@xs8.xs4all.nl> <502CD3F8.70001@hardwarefreak.com> <502D6B0A.6090508@xs4all.net> <502DF357.8090205@hardwarefreak.com> <502E2817.8040306@xs4all.net> <502F237D.6060806@hardwarefreak.com> <502F698C.9010507@msgid.tls.msk.ru> <50305AB9.5080302@hardwarefreak.com> <5030F1C6.90205@hesbynett.no>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5030F1C6.90205@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Miquel van Smoorenburg <mikevs@xs4all.net>, Linux RAID <linux-raid@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On 8/19/2012 9:01 AM, David Brown wrote:
> I'm sort of jumping in to this thread, so my apologies if I repeat
> things other people have said already.

I'm glad you jumped in David.  You made a critical statement of fact
below which clears some things up.  If you had stated it early on,
before Miquel stole the thread and moved it to LKML proper, it would
have short circuited a lot of this discussion.  Which is:

> AFAIK, there is scope for a few performance optimisations in raid6.  One
> is that for small writes which only need to change one block, raid5 uses
> a "short-cut" RMW cycle (read the old data block, read the old parity
> block, calculate the new parity block, write the new data and parity
> blocks).  A similar short-cut could be implemented in raid6, though it
> is not clear how much a difference it would really make.

Thus my original statement was correct, or at least half correct[1], as
it pertained to md/RAID6.  Then Miquel switched the discussion to
md/RAID5 and stated I was all wet.  I wasn't, and neither was Dave
Chinner.  I was simply unaware of this md/RAID5 single block write RMW
shortcut.  I'm copying lkml proper on this simply to set the record
straight.  Not that anyone was paying attention, but it needs to be in
the same thread in the archives.  The takeaway:

md/RAID6 must read all devices in a RMW cycle.

md/RAID5 takes a shortcut for single block writes, and must only read
one drive for the RMW cycle.

[1}The only thing that's not clear at this point is if md/RAID6 also
always writes back all chunks during RMW, or only the chunk that has
changed.

-- 
Stan

