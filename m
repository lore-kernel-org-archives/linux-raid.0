From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 16:20:43 +0100
Message-ID: <broqa2-ana.ln1@news.it.uc3m.es>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <200501031846.42950.maarten@ultratux.net> <200501032052.21459.maarten@ultratux.net> <a9noa2-o12.ln1@news.it.uc3m.es> <fh0pa2-kvp.ln1@news.it.uc3m.es> <16857.55609.534526.297577@cse.unsw.edu.au> <jh4pa2-pi.ln1@news.it.uc3m.es> <16857.64086.362458.177296@cse.unsw.edu.au> <6d5bedd80501031816eb8f296@mail.gmail.com> <16857.65024.745883.752981@cse.unsw.edu.au> <20050104024108.GK99565@caffreys.strugglers.net> <16858.4291.816499.371678@cse.unsw.edu.au> <0h5qa2-0qa.ln1@news.it.uc3m.es> <41DAA510.4060202@dgreaves.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves <david@dgreaves.com> wrote:
> Peter T. Breuer wrote:
> 
> >>ext3 journals are much safer on mirrored devices than on non-mirrored
> >That's irrelevant - you don't care what's in the journal, because if
> >your system crashes before committal you WANT the data in the journal
> >to be lost, rolled back, whatever, and you don't want your machine to
> >have acked the write until it actually has gone to disk.
> >
> >Or at least that's what *I* want. But then everyone has different
> >wants and needs. What is obvious, however, are the issues involved.
> 
> If the journal is safely written to the journal device and the machine 

You don't know it has been. Raid can't tell.

> crashes whilst updating the main filesystem you want the journal to be 
> replayed, not erased. The journal entries are designed to be replayable 
> to a partially updated filesystem.

It doesn't work. You can easily get a block  written to the journal on
disk A, but not on disk B (supposing raid 1 with disks A and B).
According to you "this" should be replayed. Well, which result do you
want? Raid has no way of telling.

Suppose that A contains the last block to be written to a file, and
does not. Yet B is chosen by raid as the "reliable" source.

Then what happens? 

Is the transaction declared "completed" with incomplete data? With
incorrect data?

Myself I'd hope it were rolled back, whichever of A or B were chosen,
because some final annotation was missing from the journal, saying
"finished and ready to send" (alternating bit protocol :-). But you
can't win ... what if the "final" annotation were written to journal on
A but not on B.

Then what would happen?

Well, then whichever of A or B the raid chose, you'd either get the
data rolled forward or backward.


Which would you prefer? 

I'd just prefer that it was all rolled back. 



> That's the whole point of journalling filesystems, write the deltas to 
> the journal, make the changes to the fs, delete the deltas from the journal.

Consider the above. There is no magic.

> If the machine crashes whilst the deltas are being written then you 
> won't play them back - but your fs will be consistent.

What if the delta is written to one journal, but not to the other, when
the machine crashes?

I outlined the problem above. You can't win this game.

Peter

