From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 22:08:03 +0100
Message-ID: <j6dra2-9vs.ln1@news.it.uc3m.es>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <20050104024108.GK99565@caffreys.strugglers.net> <895qa2-0qa.ln1@news.it.uc3m.es> <200501042002.32292.maarten@ultratux.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maarten <maarten@ultratux.net> wrote:
> @Peter:
> I still need you to clarify what can cause such creeping corruption.

The classical cause in raid systems is 

  1) that data is only partially written to the array on system crash
     and on recovery the inappropriate choice of alternate datasets
     from the redundant possibles is propagated.

  2) corruption occurs unnoticed in a part of the redundant data that
     is not currently in use, but a disk in the array then drops out,
     bringing the data with the error into use. On recovery of the
     failed disk, the error data is then propagated over the correct 
     data.

Plus the usual causes. And anything else I can't think of just now.

> 1) A bit flipped on the platter or the drive firmware had a 'thinko'.
> 
> This will be signalled by the CRC / ECC on the drive.

Bits flip on our client disks all the time :(.  It would be nice if it
were the case that they didn't, but it isn't.  Mind you, I don't know
precisely HOW.  I suppose more bits than the CRC can recover change, or
something, and the CRC coincides.  Anyway, it happens.  Probably cpu
-mediated.  Sorry but I haven't kept any recent logs of 1-bit errors in
files on readonly file systems for you to look at.

> You can't flip a bit 
> unnoticed. 

Not by me, but then I run md5sum every day. Of course, there is a
question if the bit changed on disk, in ram, or in the cpu's fevered
miscalculations. I've seen all of those. One can tell which after a bit
more detective work.

> Or in fact, bits get 'flipped' constantly, therefore the highly 
> sophisticated error correction code in modern drives.  If the ECC can't 
> rectify such a read error, it will issue a read error to the OS.

Nope. Or at least, we see one-bit errors.

> Obviously, the raid or FS code handles this error in the usual way; this is 

This is not an error, it is a "failure"! An error is a wrong result, not
a complete failure.

> what we call a bad sector, and we have routines that handle that perfectly.

Well, as I recall the raid code, it doesn't handle it correctly - it
simply faults the disk implicated offline.

Mind you, there are indications in the comments (eg for the resync
thread)  that it was intended that reads (or writes?) be retried
there, but I don't recall any actual code for it.

> 2) An incomplete write due to a crash.
> 
> This can't happen on the drive itself, as the onboard cache will ensure 

Of course it can! I thought you were the one that didn't swallow
manufacturer's figures! 

> everything that's in there gets written to the platter. I have no reason to 
> doubt what the manufacturer promises here, but it is easy to check if one 

Oh yes you do.

> Another possibility is it happening in a higher layer, the raid code or the FS 
> code.  Let's examine this further.  The raid code does not promise that that 

There's no need to. All these modes are possible and very well known.

> In the case of a journaled FS, the first that must be written is the delta. 
> Then the data, then the delta is removed again.  From this we can trivially 
> deduce that indeed a journaled FS will not(*) suffer write reordering; as 

Eh, we can't.  Or do you mean "suffer" as in "withstand"? Yes, of
course it's vulnerable to it.

> So in fact, a journaled FS will either have to rely on lower layers *not* 
> reordering writes, or will have to wait for the ACK on the journal delta 
> before issuing the actual_data write command(!).

Stephen (not Neil, sorry) says that ext3 requires just acks after write
completed. Hans has said that reiserfs required no write reordering (i
don't know if that has changed since he said it).

(analysis of a putative journal update sequence - depending strongly on
ordered writes to the journal area)

> A) the time during which the journal delta gets written
> B) the time during which the data gets written
> C) the time during which the journal delta gets removed.
> 
> Now at what point do or did we crash ?  If it is at A) the data is consistent, 

The FS metadata is ALWAYS consistent. There is no need for this. 

> no matter whether the delta got written or not. 

Uh, that's not at issue. The question is whether it is CORRECT, not
whether it is consistent.

> If it is at B) the data 
> block is in an unknown state and the journal reflects that, so the journal 
> code rolls back.

Is a rollback correct? I maintain it is always correct.

> If it is at C) the data is again consistent. Depending on 
> what sense the journal delta makes, there can be a rollback, or not.  In 
> either case, the data still remains fully consistent. 
> It's really very simple, no ?

Yes - I don't know why you consistently dive into details and miss the
big picture! This is nonsense - the question is not if it is
consistent, but if it is CORRECT. Consistency is guaranteed. However,
it will likely be incorrect.

> Now to get to the real point of the discussion.  What changes when we have a 
> mirror ?  Well, if you think hard about that: NOTHING.  What Peter tends to 
> forget it that there is no magical mixup of drive 1's journal with drive 2's 
> data (yep, THAT would wreak havoc!).

There is. Raid knows nothing about journals. The raid read strategy
is normally 128 blocks from one disk, then 128 blocks from the next
disk  - in kernel 2.4 . In kernel 2.6 it seems to me that it reads from
the disk that it calculates the heads are best positoned for the read
(in itself a bogus calculation). As to what happens on a resync rather
than a read, well, it will read from one disk or another - so the
journals will not be mixed up - but the result will still likely
be incorrect, and always consistent (in that case).

There is nothing unusual here. Will you please stop fighting about
NOTHING?


> At any point in time -whether mirror 1 is chosen as true or mirror 2 gets 
> chosen does not matter as we will see- the metadata+data on _that_ mirror by 

And what if there are three mirrors? You don't know either the raid read
startegy or the raid resync strategy - that is plain.

> definition will be one of the cases A through C outlined above.  IT DOES NOT 
> MATTER that mirror one might be at stage B and mirror two at stage C. We use 
> but one mirror, and we read from that and the FS rectifies what it needs to 
> rectify.  

Unfortunately, EVEN given your unwarranted assumption that things are
like that, the  result is still likely to be incorrect, but will be
consistent!

> This IS true because the raid code at boot time sees that the shutdown was not 
> clean, and will sync the mirrors.

But it has no way of knowing which mirror is the correct one.

> At this point, the FS layer has not even 
> come into play.  Only when the resync has finished, the FS gets to examine 
> its journal.  -> !! At this point the mirrors are already in sync again !! <-

Sure! So?

> If, for whatever reason, the raid code would NOT have seen the unclean 
> shutdown, _then_ you may have a point, since in that special case it would be 
> possible for the journal entry from mirror one (crashed during stage C) gets 
> used to evaluate the data block on mirror two (being in state B). In those 
> cases, bad things may happen obviously.

And do you know what happens in the case of a three way mirror, with a
2-1 split on what's in the mirrored journals,  and the raid resyncs?

(I don't!)

> If I'm not mistaken, this is what happens when one has to assemble --force an 
> array that has had issues.  But as far as I can see, that is the only time...
> 
> Am I making sense so far ?  (Peter, this is not adressed to you, as I already 

Not very much. As usual you are bogged down in trivialities, and are
missing the  big picture :(. There is no need for this little baby step
analysis! We know perfectly well that crashing can leave the different
journals in different states. I even suppose that half a block can e
written to one of them (a sector), instead of a whole block. Are
journals written to in sectors or blocks? Logic would say that it
should be written in sectors, for atomicity, but I haven't checked the
ext3fs code.

And then you haven't considered the problem of what happens if only
some bytes get sent over the BUS before hitting the disk. What happens?
I don't know. I suppose bytes are acked only in units of 512.

> know your answer beforehand: I'd be "baby raid tech talk", correct ?)

More or less - this is horribly low-level, it doesn't get anywhere.

> So.  What possible scenarios have I overlooked until now...?

All of them.

> 3) The inconsistent write comes from a bug in the CPU, RAM, code or such.

It doesn't matter! You really cannot see the wood for the trees.

> As Neil already pointed out, you gotta trust your CPU to work right otherwise 
> all bets are off.


Tough - when it overheats it can and does do anything. Ditto memory.
LKML is full of Linus doing Zen debugging of an oops, saying "oooooooom,
ooooooom, you have a one bit flip in bit 7 at address  17436987,
ooooooom".

> But even if this could happen, there is no blaming the FS 
> or the raid code, as the faulty request was carried out as directed.  The 

Who's blaming! This is most odd! It simply happens, that's all.

> Does this make any sense to anybody ?  (I sure hope so...)

No. It is neither useful nor sensical, the latter largely because of
the former. APART from your interesting layout of the sequence of
steps in writing the journal. Tell me, what do you mean by "a delta"?

(to be able to rollback it is either a xor of the intended block versus
the original, or a copy of the original block plus a copy of the
intended block).

Note that it is not at all necessary that a journal work that way. 


Peter

