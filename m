From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 01:08:26 +0100
Message-ID: <qonra2-n0n.ln1@news.it.uc3m.es>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <20050104024108.GK99565@caffreys.strugglers.net> <895qa2-0qa.ln1@news.it.uc3m.es> <200501042002.32292.maarten@ultratux.net> <j6dra2-9vs.ln1@news.it.uc3m.es> <16859.5895.203013.789777@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> wrote:
> On Tuesday January 4, ptb@lab.it.uc3m.es wrote:
> > 
> > Uh, that's not at issue. The question is whether it is CORRECT, not
> > whether it is consistent.
> > 
> 
> What exactly do you mean by "correct".

Whatever you mean by it - I don't have a preference myself, though I
might have an opinion in specific situations.  It means whatever you
consider and it is up to you to make your own definition for yourself,
to your own satisfaction in particular circumstances, if you feel you
need a constructive definition in other terms (and I don't!).  I merely
gave the concept a name for you.

> If I have a program that writes some data:
>    write(fd, buffer, 8192);
> and then makes sure the data is on disk:
>    fsync(fd);
> 
> but the computer crashes sometime between when the write call started
> and the fsync called ended, then I reboot and read back that block of
> data from disc, what is the "CORRECT" value that I should read back?

I would say that if nothing on your machine or elsewhere "noticed" you
doing the write of any part of the block, then the correct answer is
"the block as it was before you wrote any of it".  However, if nothing
cares at all one way or the other, then it could be annything, what you
wrote, what you got, or even any old nonsense.

In other words, I would say "anything that conforms with what the
universe outside the program has observed of the transaction".  If you
wish to apply a general one-size-fits rule, then I would say "as many
blocks as you have written that have been read by other processes which
in turn have communicated their state elsewhere should be present on the
disk as is necessary to conform with that state".

So if you had some other process watching the file grow, you would need
to be sure that as much as that other process had seen was actually on
the disk.

Anyway, I don't care. It's up to you. I merely ask that you assign a
probability to it (and don't tell me what it is! Please).

> The answer is, of course, that there is no one "correct" value.

There is whatever one pleases you as correct.  Please do not fall into a
sollipsistic trap!  It is up to YOU to decide what is correct and assign
probabilities.  I only pointed out how those probabilities scale with
the size of a RAID array WHATEVER THEY ARE.

I don't care what they are to you. It's absurd to ask me. I only tell
you how they grow with size of array.

> After an unclean shutdown of a raid1 array, every (working) device
> has correct data on it.  They may not all be the same, but they are
> all correct.

No they are not.  They are consistent. That is different! 

Peter

