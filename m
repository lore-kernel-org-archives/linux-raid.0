From: Schuett Thomas EXT <Thomas.Schuett.extern@mchh.siemens.de>
Subject: AW: AW: RAID1 and data safety?
Date: Fri, 8 Apr 2005 12:28:33 +0200
Message-ID: <76592C4D3DA1AC4FB8424084D10D31A8061152B2@mchh2c4e.mchh.siemens.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Doug Ledford' <dledford@xsintricity.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Doug,

(in case you are short in time, please just answer to the last part)

> (or at the very
> absolute least, it should be in a small enough queue of pending writes
> that should the power get lost, it can still write the last bits out
> during spin down).

Whow. I have heard about this before, but was not sure, if it was fiction talk.
I imagine it might be a problem, that most buyers can't see their benefits of such
features, and so there is no big incentive for the manifactures to build them in.
I never saw HD descriptions mentioning anything like this (on the other hand, 
I am just a usual end user).


> It [write barriers] doesn't bring down system performance because the journaling
> filesystem isn't single task so to speak.  What this means is that when
> ...
> Make sense?

Makes perfect sense! (As 7 universes and time backwards ;-)

>> So event counters are the 2nd type of information, that gets written with write 
>> barriers. [...]
>
>Not really.  The event counter is *much* courser grained than journal
>entries.

I see. As long, as the HDs are fine, write barriers for "j"fs writes (which 
"block" until both media got written) are all you need to make it power failure
save. Only when the HDs are not fine any more, then the event counter comes 
into play.

> You don't have to wait for *all* writes to
> the drive to complete, just the journal writes.  This is why performance
> isn't killed by journaling.  The filesystem proper writes for previous
> journal transactions can be taking place while you are doing this
> waiting.

I wonder, if an logic error sliped in here, or if I just still don't have
the right understanding of what "writing with write barrier" really means.
The end-of-transaction cannot be written, before the *data* is *really* written.
I thought, this is called "the data must be witten with write barrier". 
But probably a "write with write barrier" means:
1. wait-for-completion-event 2. write 3. wait-for-completion-event again.
Then it be the same after all.
In any case, for the reasons you explained earlier, it wouldn't kill the
performance at all. 

> I use ext3 personally.  But that's as much because it's the default
> filesystem and I know Stephen Tweedie will fix it if it's broken ;-)

Good point :-)

----

> Of course, if it's supported on your system, you could
> also just enable the SMART daemon and have it tell the drives to do
> continuous background media checks to detect sectors that are either
> already bad or getting ready to go bad (corrected error conditions).

This is something of very very big interest to me!
I have asked several times in several NGs about it with no answer:
Afaik a CD player can correct one-bit-errors, but not two-bit-errors
(or let it be two-bit vs. three-bit, it doesn't make a difference.)
And: A CD player doesn't tell you, when it had to correct one-bit-errors.

Big problem: Your CD (=valuable backup) becomes worse and worse, with
more and more one-bit-errors, but you never notice, until one rainy day
you suddenly cannot read the CD (a special sector/file) at all any more.
And then it is too late. 

Now you are just saying, that errors get corrected on HDs too (what I 
didn't know), but that it is possible to find out about it (so either the
HDs tell it, when they make a correction, or the correction happens
somewhere more uplayer in the driver or so). My question: Do CD players
offer an interface to get noticed about error corrections too, or do
they really hide this whithout any chance to get that info?

(And of course I will have a look at the SMART daemon.)

best regards,
  Thomas
