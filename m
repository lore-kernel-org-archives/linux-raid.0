From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: Fast (intelligent) raid1
Date: Fri, 24 Jan 2003 10:34:08 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200301240934.h0O9Y8E23813@oboe.it.uc3m.es>
References: <Pine.LNX.4.44.0301240354520.3568-100000@devserv.devel.redhat.com>
Reply-To: ptb@it.uc3m.es
Mime-Version: 1.0
Content-Type: text/plain; charset=UNKNOWN-8BIT
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0301240354520.3568-100000@devserv.devel.redhat.com>
 from Ingo Molnar at "Jan 24, 2003 04:03:40 am"
To: Ingo Molnar <mingo@redhat.com>
Cc: "Peter T. Breuer" <ptb@it.uc3m.es>, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"A month of sundays ago Ingo Molnar wrote:"
> your patch looks really interesting.

Thanks - I had a look at changing it to depend on the md.c module last
night on the train home, but I need some architectural information. I
see the personality struct and its methods, but I need to knwo the
semantics that's expected in the methods. There are underlying
assumptions - whatis nb_disk (total? Actual?). Whatshoudl the run
method do. Does it run through a lits of disk components? It looks like
it does. Etc.

I may try for raid4 first.

> > The driver keeps a bitmap of pending writes in memory, and writes t=
hem
> > to the mirror component that's just been repaired when it comes bac=
k on
> > line.  The bitmap is two-level and created pagewise on demand, so i=
t's
> > not too expensive. [...]
>=20
> how do you ensure that the 'repaired' drive indeed only differs in th=
e
> dirty-bitmap portions of the data disk? It's perfectly valid to add a

If the disk has been hotremoved and then hotadded, it is completely
resynced. If, OTOH, it has only been setfaulty=E9d and then hotadded, i=
t
is repaired according to the bitmap.

I would really prefer that there were a raidhotrepair utility and ioctl
(to repair setfaulty), but in the meantime I use the idea that fixing
a disk "only" in the setfaulty state is always done from the bitmap.
If the disk has been hotremoved, then the repair is made complete.

I would like to use the suberblock information to identify and
differentiate between replacement disks, but unfortunately I need
instruction there too. I could tell from the uuid if the same disk were
being put back or not. If it's the same disk, then the repair can be
done using the bitmap.

> completely new (and unsynced) disk to the system when one disk fails.=
 Or
> is this the responsibility of the administrator?

The admin can always override.

> also, your resyncing method does not attempt to address the resync
> necessary to be done after an unclear shutdown (eg. power failure),
> correct?

Possibly, but I only say that because I'm not sure what that is. It has
been my experience that the current softraid is itself not very clear
on the issue! If the array is somehow taken down badly, then there is
no very easy way of deternining who has the best copy of the data the
nexttime it is restarted.

I suspect that you mean the "sync on startup" that should in principle
be done, but which can be avoided if there is sufficient "good
indicators" in the various superblocks.  Since I need to be taught
about the superblock from zero, yes, I have not used it! The
current code does no sync at start up _at all_, nor does it
deal with persistent superblocks. I need documentation - or instruction=
=2E

Yes, the admin will have to identify the correct component and resync f=
rom
that, if necessary.

I was thinking of maintaining an mmap'ed copy of the bitmap on disk, by
the way. But that's for later. I could try it. At startup I can read
in the bitmap(s).


Peter

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
