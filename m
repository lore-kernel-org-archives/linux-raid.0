From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: mismatch_count != 0 on multiple hosts
Date: Sat, 19 Sep 2009 17:10:48 +0200
Message-ID: <slrnhb9t3o.f3a.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <20090916171714.GA24629@atlantis.cc.ndsu.nodak.edu>
 <slrnhb2ek3.dbe.Mario.Holbe@darkside.dyn.samba-tng.org>
 <20090919003357.GA19690@atlantis.cc.ndsu.nodak.edu>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bryan Mesich <bryan.mesich@ndsu.edu> wrote:
> On Wed, Sep 16, 2009 at 09:20:35PM +0200, Mario 'BitKoenig' Holbe wrote:
>> They should not appear on RAID5.
> I would agree.  The only reason I mentioned RAID5 was to remove the
> possibility that the HD were spontaneously flipping bits.  Our SAN

This should not happen on recent disks (and even not that recent ones)
either. Disks do error correction and don't deliver faulty data, they
deliver read errors instead. Maybe there are some disks where you can
disable ECC (I'm not aware of such), but I doubt you would get even one
reasonable bit out of them then :)

And *if* spontaneously flipping bits *would* happen on single disks,
they would also happen on your RAID5. No RAID level except RAID2 (which
does ECC on its own) tolerates this kind of error, they all rely on
disks delivering either correct data or error messages.

> Yes, we are running ext3 :).

Strange :)

> I'm not sure if I follow you on the inode problem.  If there was a
> problem, shouldn't the problem be replicated to both block devices?

Just have a look at past mails to this list for that, I had an
interesting discussion about it with Heinz Mauelshagen back in early
2006 starting with:

From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Newsgroups: gmane.linux.raid
Subject: Re: No syncing after crash. Is this a software raid bug?
Date: Thu, 2 Mar 2006 14:48:25 +0100
Message-ID: <du6t39$be5$1@sea.gmane.org>

This is btw. my reason to state the above "They should not appear on
RAID5".

> I worry about running a repair for fear that I might tromp over
> something.  I was hoping that future writes might fix some of the
> problem?

Maybe. What mirror do the reads come from? ... Got the point?


regards
   Mario
-- 
The question of whether a computer can think is no more interesting than
the question of whether a submarine can swim.          -- E. W. Dijkstra

