From: maarten <maarten@ultratux.net>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 01:38:53 +0100
Message-ID: <200501050138.53373.maarten@ultratux.net>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <200501042002.32292.maarten@ultratux.net> <j6dra2-9vs.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j6dra2-9vs.ln1@news.it.uc3m.es>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



[ Spoiler: this text may or may not contain harsh language and/or insulting ] 
[  remarks, specifically in the middle part. The reader is advised to exert ] 
[  some mild caution here and there.  Sorry for that but my patience can ] 
[  and does really reach its limits, too.     -   Maarten                ]


On Tuesday 04 January 2005 22:08, Peter T. Breuer wrote:
> maarten <maarten@ultratux.net> wrote:
> > @Peter:
> > I still need you to clarify what can cause such creeping corruption.
>
>   1) that data is only partially written to the array on system crash
>      and on recovery the inappropriate choice of alternate datasets
>      from the redundant possibles is propagated.
>
>   2) corruption occurs unnoticed in a part of the redundant data that
>      is not currently in use, but a disk in the array then drops out,
>      bringing the data with the error into use. On recovery of the
>      failed disk, the error data is then propagated over the correct
>      data.

Congrats, you just described the _symptoms_.  We all know the alledged 
symptoms, if only for you repeating them over and over and over...
My question was HOW they [can] occur.   Disks don't go around randomly 
changing bits just because they dislike you, you know.

> > 1) A bit flipped on the platter or the drive firmware had a 'thinko'.
> >
> > This will be signalled by the CRC / ECC on the drive.
>
> Bits flip on our client disks all the time :(.  It would be nice if it
> were the case that they didn't, but it isn't.  Mind you, I don't know
> precisely HOW.  I suppose more bits than the CRC can recover change, or
> something, and the CRC coincides.  Anyway, it happens.  Probably cpu
> -mediated.  Sorry but I haven't kept any recent logs of 1-bit errors in
> files on readonly file systems for you to look at.

Well I don't think we would want to crosspost this flamefest ^W discussion to 
a mailinglist where our resident linux blockdevice people hang out, but I'm 
reasonably certain that the ECC correction in drives is very solid, and very 
good at correcting multiple bit errors, or at least signalling them so an 
official read error can be issued.  If you experience bit errors that often 
I'd wager it is in another layer of your setup, be it CPU, network layer, or 
rogue scriptkiddie admins changing your files on disk.  I dunno.
What I do know is that nowadays the bits-per-square inch on media (CD, DVD and 
harddisks alike) is SO high that even during ideal circumstances the head 
will not read all the low-level bits correctly. It has a host of tricks to 
compensate for that, first and foremost error correction.  If that doesn't 
help it can retry the read, and if that still doesn't help it can / will 
adjust the head very slightly in- or outwards to see if that gives a better 
result. (in all fairness, this happens earlier, during the read of the servo 
tracks, but it may still adjust slightly).  If even after all that the read 
still fails, it issues a read error to the I/O subsystem, ie. the OS.

Now it may be conceivable that a bit gets flipped by a cosmic ray, but the 
error correction would notice that and correct it.  If too many bits got 
flipped, there comes a point that it will give up and give an error.  What it 
will NOT do at this point, AFAIK, is return the entire sector with some bit 
errors in them. It will either return a good block, or no block at all 
accompanied by a "bad sector" error. This is logical, as most of the time 
you're more interested in knowing the data in unretrievable than getting it 
back fubar'ed.  (your undetectable vs detectable, in fact)

The points where there is no ECC protection against cosmic rays are in your 
RAM.  I believe the data path between disk and controller has error checks, 
so do the other electrical paths.  So if you see random bit errors, suspect 
your memory above all and not your I/O layer.  Go out and buy some ECC ram, 
and don't forget to actually enable it in the BIOS.  But you may want to 
change data-cables to your drives nevertheless, just to be safe.

> > You can't flip a bit
> > unnoticed.
>
> Not by me, but then I run md5sum every day. Of course, there is a
> question if the bit changed on disk, in ram, or in the cpu's fevered
> miscalculations. I've seen all of those. One can tell which after a bit
> more detective work.

Hehe.  Oh yeah, sure you can.   Would you please elaborate to the group here 
how in the hell you can distinguish a bit being flipped by the CPU and one 
being flipped while in RAM ?  Cause I'd sure like to see you try...!

I suppose lots of terms like axiom, poisson and binomial etc. will be used in 
your explanation ?  Otherwise we might not believe it, you know...  ;-)
Luckily we don't yet use quantum computers, otherwise just you observing the 
bit would make it vanish, hehehe.

Back to seriousness, tho.

> Nope. Or at least, we see one-bit errors.

Yep, I'm sure you do. I'm just not sure they originate on the I/O layer.

> > Obviously, the raid or FS code handles this error in the usual way; this
> > is
>
> This is not an error, it is a "failure"! An error is a wrong result, not
> a complete failure.

Be that as it may (it's just language definitions) you perfectly understand 
what I meant: a "bad sector"-error is issued to the nearest OS layer.

> > what we call a bad sector, and we have routines that handle that
> > perfectly.
>
> Well, as I recall the raid code, it doesn't handle it correctly - it
> simply faults the disk implicated offline.

True, but that is NOT the point. The point is, the error IS detectable; the 
disk just said as much.  We're hunting for your improbable UNdetectable 
errors, and how they can technically occur.  Because you say you see them, 
but you have not shown us HOW they could even originate.  
Basically, *I* am doing your research now!

> > 2) An incomplete write due to a crash.
> >
> > This can't happen on the drive itself, as the onboard cache will ensure
>
> Of course it can! I thought you were the one that didn't swallow
> manufacturer's figures!

MTBF, no. Because that is purely marketspeak. Technical and _verifiable_ specs 
I can believe, if only for the fact that I can verify them to be true.  
I outlined already how you can do that yourself too...:

Look, it isn't rocket science.  All you'd need is a computer-controlled relay 
that switches off the drive.  Trivially made off the parallel port.  Then you 
write some short code that issues write requests and sends block to the drive 
and then shuts the drive down with varying timings in between to cover all 
possibilities.  All that in a loop which sends different data to different 
offsets each time.  Then you leave that running for a night or so.  The next 
morning you check all the offsets for your written data and compare. 

Without being overly paranoid, I think someone has already conducted such 
tests. Ask around on the various ATA mailinglists (if you care enough).

But honestly, deploying a working UPS is both more elegant, less expensive and 
more logical.  Who cares if a write gets botched during a power cut to the 
drive, you just make triple sure that that can never happen:  Simple.
OS crashes do not cut power to the drive, only PSUs and UPSes can.  So cover 
those two bases and you're set.  Child's play.

> > Another possibility is it happening in a higher layer, the raid code or
> > the FS code.  Let's examine this further.  The raid code does not promise
> > that that
>
> There's no need to. All these modes are possible and very well known.

You're like a stuck record aren't you ? We're searching for the real truth 
here, and all you say in your defense is "It's the truth!"  "It is the 
truth!"  "It IS the truth!" like a small child repeating over and over.  
You've never attempted to prove any of your wild statements, yet demand from 
us that we take your word for granted. Not so. Either you prove your point, 
or at the very least you try not to sabotage people who try to find proof. 
As I am attempting now. You're harassing me. Go away until you have a 
meaningful input !  dickwad !

> > In the case of a journaled FS, the first that must be written is the
> > delta. Then the data, then the delta is removed again.  From this we can
> > trivially deduce that indeed a journaled FS will not(*) suffer write
> > reordering; as
>
> Eh, we can't.  Or do you mean "suffer" as in "withstand"? Yes, of
> course it's vulnerable to it.

suffer as in withstand, yes.

> > So in fact, a journaled FS will either have to rely on lower layers *not*
> > reordering writes, or will have to wait for the ACK on the journal delta
> > before issuing the actual_data write command(!).

> > A) the time during which the journal delta gets written
> > B) the time during which the data gets written
> > C) the time during which the journal delta gets removed.
> >
> > Now at what point do or did we crash ?  If it is at A) the data is
> > consistent,
>
> The FS metadata is ALWAYS consistent. There is no need for this.

Well, either you agree that an error cannot originate here, or you don't. 
There is no middle way stating things like the data getting corrupt yet the 
metadata not showing that. The write gets verified, bit by bit, so I don't 
see where you're going with this...?

> > no matter whether the delta got written or not.
>
> Uh, that's not at issue. The question is whether it is CORRECT, not
> whether it is consistent.

Of course it is correct.  You want to know how the bit errors originate during 
crashes.  Thus the bit errors are obviously not written _before_ the crash.  
Because IF they did, your only recourse is to go for one of the options in 3) 
further below.
For now we're only describing how the data that the OS hands the FS lands on 
disk.  Whether the data given to us by the OS is good or not is irrelevant 
(now).  So, get with the program, please.  The delta is written first and 
that's a fact. Next step.

> > If it is at B) the data
> > block is in an unknown state and the journal reflects that, so the
> > journal code rolls back.
>
> Is a rollback correct? I maintain it is always correct.

That is not an issue, you can safely leave that to the FS to figure out. It 
will most certainly make a more logical decision than you at this point.

In any case, since the block is not completely written yet, the FS probably 
has no other choice than to roll back, since it probably misses data...
This is a question left for the relevant coders, though. It still is 
irrelevant to this discussion however.

> > If it is at C) the data is again consistent. Depending on
> > what sense the journal delta makes, there can be a rollback, or not.  In
> > either case, the data still remains fully consistent.
> > It's really very simple, no ?
>
> Yes - I don't know why you consistently dive into details and miss the
> big picture! This is nonsense - the question is not if it is
> consistent, but if it is CORRECT. Consistency is guaranteed. However,
> it will likely be incorrect.

NO.  For crying out loud !!  We're NOT EVEN talking about a mirror set here! 
That comes later on. This is a SINGLE disk, very simple, the FS gets handed 
data by the OS, the FS directs it to the MD code, the MD code hands it on 
down.  Nothing in here except for a code bug can flip your friggin' bits !!  
If you indeed think it is a code bug, skip all this chapter and go to 3). 
Otherwise, just shut the hell up !!

> > Now to get to the real point of the discussion.  What changes when we
> > have a mirror ?  Well, if you think hard about that: NOTHING.  What Peter
> > tends to forget it that there is no magical mixup of drive 1's journal
> > with drive 2's data (yep, THAT would wreak havoc!).
>
> There is. Raid knows nothing about journals. The raid read strategy
> is normally 128 blocks from one disk, then 128 blocks from the next
> disk  - in kernel 2.4 . In kernel 2.6 it seems to me that it reads from
> the disk that it calculates the heads are best positoned for the read
> (in itself a bogus calculation). As to what happens on a resync rather
> than a read, well, it will read from one disk or another - so the
> journals will not be mixed up - but the result will still likely
> be incorrect, and always consistent (in that case).

Irrelevant.  You should read on before you open your mouth and start blabbing.

> > At any point in time -whether mirror 1 is chosen as true or mirror 2 gets
> > chosen does not matter as we will see- the metadata+data on _that_ mirror
> > by
>
> And what if there are three mirrors? You don't know either the raid read
> startegy or the raid resync strategy - that is plain.

Wanna stick with the program here ?  What do you do if your students interrupt 
you and start about "But what if the theorem is incorrect and we actually 
have three possible outcomes?"  Again: shut up and read on.

> > definition will be one of the cases A through C outlined above.  IT DOES
> > NOT MATTER that mirror one might be at stage B and mirror two at stage C.
> > We use but one mirror, and we read from that and the FS rectifies what it
> > needs to rectify.
>
> Unfortunately, EVEN given your unwarranted assumption that things are
> like that, the  result is still likely to be incorrect, but will be
> consistent!

Unwarranted...!  I took you by the hand and led you all the way here. All the 
while you whined and whined that that was unneccessary, and now that we got 
here you say I did not explain nuthin' along the way ?!?  
You have some nerve, mister.

For the <incredibly thick> over here: IS there, yes or no, any other possible 
state for a disk than either state A, B or C above, at any particular time?? 
If the answer is YES, fully describe that imaginary state for us.
If the answer is NO, shut up and listen. I mean read. Oh hell... 

> > This IS true because the raid code at boot time sees that the shutdown
> > was not clean, and will sync the mirrors.
>
> But it has no way of knowing which mirror is the correct one.

Djeez.  Are you thick or what?  I say it chooses any one, at random, BECAUSE 
_after_ the rollback of the jounaled FS code it will ALWAYS be correct(YES!) 
AND consistent.

You just don't get the concept, do you ? There IS no INcorrect mirror, neither 
is there a correct mirror. They're both just mirrors in various, as yet 
undetermined, states of completing a write.  Since the journal delta is 
consistent, it WILL be able to roll back (or through, or forward, or on, or  
whatever) to a clean state. And it will.   (fer cryin' out loud...!!)

> > At this point, the FS layer has not even
> > come into play.  Only when the resync has finished, the FS gets to
> > examine its journal.  -> !! At this point the mirrors are already in sync
> > again !! <-
>
> Sure! So?

So the FS code will find an array in either state A, B or C and take it from 
there.  Just as with any normal single, non-raided disk.  Get it now?

> > If, for whatever reason, the raid code would NOT have seen the unclean
> > shutdown, _then_ you may have a point, since in that special case it
> > would be possible for the journal entry from mirror one (crashed during
> > stage C) gets used to evaluate the data block on mirror two (being in
> > state B). In those cases, bad things may happen obviously.
>
> And do you know what happens in the case of a three way mirror, with a
> 2-1 split on what's in the mirrored journals,  and the raid resyncs?

Yes. Either at random or intelligently, one is chosen(which one is entirely 
irrelevant!).  Then the raid resync follows, then the FS code finds an array 
in (hey! again!) either state A, B or C.  And it will roll back or roll on to 
reinstate the clean state. (again: do you get it now????)

> (I don't!)

Well, sure. That goes without saying.

> > If I'm not mistaken, this is what happens when one has to assemble
> > --force an array that has had issues.  But as far as I can see, that is
> > the only time...
> >
> > Am I making sense so far ?  (Peter, this is not adressed to you, as I
> > already
>
> Not very much. As usual you are bogged down in trivialities, and are
> missing the  big picture :(. There is no need for this little baby step
> analysis! We know perfectly well that crashing can leave the different
> journals in different states. I even suppose that half a block can e
> written to one of them (a sector), instead of a whole block. Are
> journals written to in sectors or blocks? Logic would say that it
> should be written in sectors, for atomicity, but I haven't checked the
> ext3fs code.

Man oh man you are pityful.  The elephant is right in front of you, if you'd 
stick out your arm you would touch it, but you keep repeating there is no 
elephant in sight.  I give up.

> And then you haven't considered the problem of what happens if only
> some bytes get sent over the BUS before hitting the disk. What happens?
> I don't know. I suppose bytes are acked only in units of 512.

No shit...!   Would that be why they call disks "block devices" ??  Your 
levels of comprehension amaze me more every time.

No of course you can't send half block or bytes or bits to a drive.  Else they 
would be called serial devices, not block devices, now wouldn't they ?
A drive will not ACK anything unless it is received completely (how obvious is 
that?)

> > know your answer beforehand: I'd be "baby raid tech talk", correct ?)
>
> More or less - this is horribly low-level, it doesn't get anywhere.

Some people seem to disagree with you.  Let's just leave it at that shall we ?

> > So.  What possible scenarios have I overlooked until now...?
>
> All of them.

Oh really.     (God. Is there no end to this.)

> > 3) The inconsistent write comes from a bug in the CPU, RAM, code or such.
>
> It doesn't matter! You really cannot see the wood for the trees.

I see only Peters right now, and I know I will have nightmares over you.

> > As Neil already pointed out, you gotta trust your CPU to work right
> > otherwise all bets are off.
>
> Tough - when it overheats it can and does do anything. Ditto memory.
> LKML is full of Linus doing Zen debugging of an oops, saying "oooooooom,
> ooooooom, you have a one bit flip in bit 7 at address  17436987,
> ooooooom".

How this even remotely relates to MD raid, or even I/O in general, completely 
eludes me.  And everyone else, I suppose.  
But for academic purposes, I'd like to see you discuss something with Linus.  
He is way more short-tempered than I am, if you read LKML you'd know that.
But hey, it's 2005, maybe it's time to add a chapter to the infamous Linus vs 
AST archives.  You might qualify.    Oh well, never mind...

> > But even if this could happen, there is no blaming the FS
> > or the raid code, as the faulty request was carried out as directed.  The
>
> Who's blaming! This is most odd! It simply happens, that's all.

Yeah...   That is the nature of computers innit ? Unpredictable bastards is 
what they are.  Math is also soooooo unpredictable, I really hate that.
(do I really need to place a smiley here?)

> > Does this make any sense to anybody ?  (I sure hope so...)
>
> No. It is neither useful nor sensical, the latter largely because of
> the former. APART from your interesting layout of the sequence of
> steps in writing the journal. Tell me, what do you mean by "a delta"?

The entry in the journal that contains the info on what a next data-write will 
be, where it will take place, and how to reconstruct the data in case of 
<problem>.  (As if that wasn't obvious by now.)

> (to be able to rollback it is either a xor of the intended block versus
> the original, or a copy of the original block plus a copy of the
> intended block).

I have no deep knowledge of how the intricacies of a journaled FS work.  If I 
would have, we would not have had this discussion in the first place since I 
would have said yesterday "Peter you're wrong" and that would've ended all of  
this right then and there. (oh yes!) 
If you care to know, go pester other lists about it, or read some reiserfs or 
ext3 code and find out for yourself.

> Note that it is not at all necessary that a journal work that way.

To me the sole thing I care about is that it can repair the missing block and 
how it manages that is of no great concern to me.  I do not have to know how 
a pentium is made in order to use it and program for it.

Maarten

-- 

