From: maarten <maarten@ultratux.net>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 20:02:32 +0100
Message-ID: <200501042002.32292.maarten@ultratux.net>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <20050104024108.GK99565@caffreys.strugglers.net> <895qa2-0qa.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <895qa2-0qa.ln1@news.it.uc3m.es>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 04 January 2005 10:46, Peter T. Breuer wrote:
> Andy Smith <andy@strugglers.net> wrote:
> > [-- text/plain, encoding quoted-printable, charset: us-ascii, 20 lines
> > --]
> >
> > On Tue, Jan 04, 2005 at 01:22:56PM +1100, Neil Brown wrote:
> > > On Monday January 3, ewan.grantham@gmail.com wrote:

> > Except that Peter says that the ext3 journals should be on separate
> > non-mirrored devices and the reason this is not mentioned in any
> > documentation (md / ext3) is that everyone sees it as obvious.

>
> It's not obvious to anyone, where by "it" I mean whether or not you
> "should" put a journal on the same raid device.  There are pros and
> cons.  I would not.  My reasoning is that I don't want data in the
> journal to be subject to the same kinds of creeping invisible corruption
> on reboot and resync that raid is subject to.  But you can achieve that



[ I'll attempt to adress all issues that have come up in this entire thread 
until now here...  please bear with me. ]


@Peter:
I still need you to clarify what can cause such creeping corruption.
There are several possible cases:

1) A bit flipped on the platter or the drive firmware had a 'thinko'.

This will be signalled by the CRC / ECC on the drive.  You can't flip a bit 
unnoticed.  Or in fact, bits get 'flipped' constantly, therefore the highly 
sophisticated error correction code in modern drives.  If the ECC can't 
rectify such a read error, it will issue a read error to the OS.

Obviously, the raid or FS code handles this error in the usual way; this is 
what we call a bad sector, and we have routines that handle that perfectly.

2) An incomplete write due to a crash.

This can't happen on the drive itself, as the onboard cache will ensure 
everything that's in there gets written to the platter. I have no reason to 
doubt what the manufacturer promises here, but it is easy to check if one 
really wants to; just issue a couple thousand cycles of well timed <write 
block, kill power to drive> commands, and verify if it all got written.
(If not: start a class action suit against the manufacturer)

Another possibility is it happening in a higher layer, the raid code or the FS 
code.  Let's examine this further.  The raid code does not promise that that 
can't happen ("MD raid is no substitute for a UPS").  But, the FS helps here.

In the case of a journaled FS, the first that must be written is the delta. 
Then the data, then the delta is removed again.  From this we can trivially 
deduce that indeed a journaled FS will not(*) suffer write reordering; as 
that is the only way data could get written without there first being a 
journal delta on disk.  So at least that part is correct indeed(!)
So in fact, a journaled FS will either have to rely on lower layers *not* 
reordering writes, or will have to wait for the ACK on the journal delta 
before issuing the actual_data write command(!).

(*) unless it waits for the ACK mentioned above.  

Further, we thus can split up the write in separate actions:

A) the time during which the journal delta gets written
B) the time during which the data gets written
C) the time during which the journal delta gets removed.

Now at what point do or did we crash ?  If it is at A) the data is consistent, 
no matter whether the delta got written or not.  If it is at B) the data 
block is in an unknown state and the journal reflects that, so the journal 
code rolls back.  If it is at C) the data is again consistent. Depending on 
what sense the journal delta makes, there can be a rollback, or not.  In 
either case, the data still remains fully consistent. 
It's really very simple, no ?

Now to get to the real point of the discussion.  What changes when we have a 
mirror ?  Well, if you think hard about that: NOTHING.  What Peter tends to 
forget it that there is no magical mixup of drive 1's journal with drive 2's 
data (yep, THAT would wreak havoc!).
  
At any point in time -whether mirror 1 is chosen as true or mirror 2 gets 
chosen does not matter as we will see- the metadata+data on _that_ mirror by 
definition will be one of the cases A through C outlined above.  IT DOES NOT 
MATTER that mirror one might be at stage B and mirror two at stage C. We use 
but one mirror, and we read from that and the FS rectifies what it needs to 
rectify.  
This IS true because the raid code at boot time sees that the shutdown was not 
clean, and will sync the mirrors.  At this point, the FS layer has not even 
come into play.  Only when the resync has finished, the FS gets to examine 
its journal.  -> !! At this point the mirrors are already in sync again !! <-

If, for whatever reason, the raid code would NOT have seen the unclean 
shutdown, _then_ you may have a point, since in that special case it would be 
possible for the journal entry from mirror one (crashed during stage C) gets 
used to evaluate the data block on mirror two (being in state B). In those 
cases, bad things may happen obviously.
If I'm not mistaken, this is what happens when one has to assemble --force an 
array that has had issues.  But as far as I can see, that is the only time...

Am I making sense so far ?  (Peter, this is not adressed to you, as I already 
know your answer beforehand: I'd be "baby raid tech talk", correct ?)

So.  What possible scenarios have I overlooked until now...?

Oh yeah, the possibility number 3).

3) The inconsistent write comes from a bug in the CPU, RAM, code or such.

As Neil already pointed out, you gotta trust your CPU to work right otherwise 
all bets are off.  But even if this could happen, there is no blaming the FS 
or the raid code, as the faulty request was carried out as directed.  The 
drives may not be in sync, but neither the drive, the raid code nor the FS 
knows this (and cannot reasonably know!)  If a bit in RAM gets flipped in 
between two writes there is nothing except ECC ram that's going to help you.

Last possible theoretical case: the bug is actually IN the raid code. Well, in 
this case, the error will most certainly be reproduceable.  I cannot speak 
for the code as I haven't written nor reviewed it (nor would I be able to...) 
but this really seems far-fetched.  Lots of people use and test the code, it 
would have been spotted at some point.

Does this make any sense to anybody ?  (I sure hope so...)

Maarten

-- 


