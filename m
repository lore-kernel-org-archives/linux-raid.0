From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 18:42:31 +0100
Message-ID: <751ra2-amt.ln1@news.it.uc3m.es>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <l1nna2-e9i.ln1@news.it.uc3m.es> <200501031846.42950.maarten@ultratux.net> <200501032052.21459.maarten@ultratux.net> <a9noa2-o12.ln1@news.it.uc3m.es> <fh0pa2-kvp.ln1@news.it.uc3m.es> <16857.55609.534526.297577@cse.unsw.edu.au> <jh4pa2-pi.ln1@news.it.uc3m.es> <16857.64086.362458.177296@cse.unsw.edu.au> <ms4qa2-0qa.ln1@news.it.uc3m.es> <41DAA243.3060202@dgreaves.com> <qikqa2-4m2.ln1@news.it.uc3m.es> <41DAAB7D.2030400@dgreaves.com> <kboqa2-ana.ln1@news.it.uc3m.es> <41DACA39.4020700@dgreaves.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves <david@dgreaves.com> wrote:
> >(If you want to say "but the fs is journalled", then consider what if 
> >the write is to the journal ...).

> Hmm.
> In neither case would a journalling filesystem be corrupted.

A joournalled file system is always _consistent_. That does no mean it
is correct!

> The md driver (somehow) gets to decide which half of the mirror is 'best'.

Yep - and which is correct?

> If the journal uses the fully written half of the mirror then it's replayed.
> If the journal uses the partially written half of the mirror then it's 
> not replayed.

Which is correct?

> It's just the same as powering off a normal non-resilient device.

Well, I see what you mean - yes, it is the same in terms of the total
event space.  It's just that with a single disk, the possible outcomes
are randomized only over time, as you repeat the experiment.  Here you
have randomization of outcomes over space as well, depending on which
disk you test (or how you interleave the test across the disks).

And the question remains - which outcome is correct?

Well, I'll answer that.  Assuming that the fs layer is only notified
when BOTH journal writes have happened, and tcp signals can be sent
off-machine or something like that, then the correct result is the 
rollback, not the completion, as the world does not expect there to
have been a completion given the data it has got.

It's as I said. One always wants to rollback. So one doesn't want the
journal to bother with data at all. 

> (Is your point here back to the failure to guarantee write ordering? I 
> thought Neil answered that?)

I don't see what that has to do with anything (Neil said that write
ordering is not preserved, but that writes are not acked until they have
occurred - which would allow write order to be preserved if you were
interested in doing so; you simply have to choose "synchronous write").


> >No. I made no such assumption. I don't know or care what you do with a
> >detectable error. I only say that whatever your test is, it detects it!
> >IF it looks at the right spot, of course. And on raid the chances of
> >doing that are halved, because it has to choose which disk to read.

> I did when I defined detectable.... tentative definitions:
> detectable = noticed by normal OS I/O. ie CRC sector failure etc
> undetectable = noticed by special analysis (fsck, md5sum verification etc)

A detectable error is one you detect with whatever your test is.  If
your test is fsck, then that's the kind of error that is detected by the
detection that you do ... the only condition I imposed for the analysis
was that the test be conducted on the raid array, not on its underlying
components.

> And a detectable error occurs on the underlying non-raid device - so the 
> chances are not halved since we're talking about write errors which go 
> to both disks. Detectable read errors are retried until they succeed - 
> if they fail then I submit that a "write (or after)" corruption occured.

I don't understand you here - you seem to be confusing hardware
mechanisms with ACTUAL errors/outcomes.  It is the business of your
hardware to do something for you: how and what it does is immaterial to
the analysis.  The question is whether that something ends up being
CORRECT or INCORRECT, in terms of YOUR wishes.  Whether the hardware
consisders something an error or not and what it does about it is
immaterial here.  It may go back in time and ask your grandmother what
is your favorite colour, as far as I care - all that is important is
what ENDS UP on the disk, and whether YOU consider that an error or not.

So you are on some wild goose chase of your own here, I am afraid!

> It also occurs to me that undetectable errors are likely to be temporary 

You are again on a trip of your own :( undetectable errors are errors you
cannot detect with your test, and that is all! There is no implication.

> - nothing's broken but a bit flipped during the write/store process (or 
> the power went before it hit the media). Detectable errors are more 
> likely to be permanent (since most detection algorithms probably have a 
> retry).

I think that for some reason you are considering that a test (a
detection test) is carried out at every moment of time.  No.  Only ONE
test is ever carried out.  It is the test you apply when you do the
observation: the experiment you run decides at that single point wether
the disk (the raid array) has errors or not.  In practical terms, you do
it usualy when you boot the raid array, and run fsck on its file system.

OK? 

You simply leave an experiment running for a while (leave the array up,
let monkeys play on it, etc.) and then you test it. That test detects
some errors. However, there are two types of errors - those you can
detect with your test, and those you cannot detect. My analysis simply
gave the probabilities for those on the array, in terms of basic
parameters for the probabilities per an individual disk.

I really do not see why people make such a fuss about this!



> >>However, we need to carry out risk analysis to decide if the increase in 
> >>susceptibility to certain kinds of corruption (cosmic rays) is 
> >>
> >
> >Ahh. Yes you do. No I don't! This is your own invention, and I said no
> >such thing. By "errors", I meant anything at all that you consider to be
> >an error. It's up to you.  And I see no reason to restrict the term to
> >what is produced by something like "cosmic rays". "People hitting the
> >off switch at the wrong time" counts just as much, as far as I know.
> >  
> >
> You're talking about causes - I'm talking about classes of error.

No, I'm talking about classes of error! You're talking about causes. :)

> 
> Hitting the power off switch doesn't cause a physical failure - it 
> causes inconsistency in the data.

I don't understand you - it causes errors just like cosmic rays do (and
we can even set out and describe the mechanisms involved).  The word
"failure" is meaningless to me here.

> >I would guess that you are trying to classify errors by the way their
> >probabilities scale with number of disks.
> >
> Nope - detectable vs undetectable.

Then what's the problem? An undetectable error is one you cannot detect
via your test. Those scale with real estate. A detectible error is one
you can spot with your test (on the array, not its components).  The
missed detectible errors scale as n-1, where n is the number of disks in
the array.

Thus a single disk suffers from no missed detectible errors, and a
2-disk raid array does.

That's all.

No fuss, no muss!


> Also, it strikes me that raid can actually find undetectable errors by 
> doing a bit-comparison scan.

No, it can't, by definition. Undetectible errors are undetectible. If
you change your test, you change the class of errors that are
undetectible.

That's all.

> Non-resilient devices with only one copy of each bit can't do that.
> raid 6 could even fix undetectable errors.

Then they are not "undetectible".

The analisis in not affected by your changing the definition of what is
in the undetectible class of error and what is not. It stands. I have
made no assumption at all on what they are. I simply pointed out how
the probabilities scale for a raid array.


Peter

