From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 16:12:20 +0100
Message-ID: <kboqa2-ana.ln1@news.it.uc3m.es>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <l1nna2-e9i.ln1@news.it.uc3m.es> <200501031846.42950.maarten@ultratux.net> <200501032052.21459.maarten@ultratux.net> <a9noa2-o12.ln1@news.it.uc3m.es> <fh0pa2-kvp.ln1@news.it.uc3m.es> <16857.55609.534526.297577@cse.unsw.edu.au> <jh4pa2-pi.ln1@news.it.uc3m.es> <16857.64086.362458.177296@cse.unsw.edu.au> <ms4qa2-0qa.ln1@news.it.uc3m.es> <41DAA243.3060202@dgreaves.com> <qikqa2-4m2.ln1@news.it.uc3m.es> <41DAAB7D.2030400@dgreaves.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves <david@dgreaves.com> wrote:
> Disks suffer from random *detectable* corruption events on (or after) 
> write (eg media or transient cache being hit by a cosmic ray, cpu 
> fluctuations during write, e/m or thermal variations).

Well, and also people hitting the off switch (or the power going off)
during a write sequence to a mirror, but after one of a pair of mirror
writes has gone to disk, but before the other of the pair has.

(If you want to say "but the fs is journalled", then consider what if 
the write is to the journal ...).

> Disks suffer from random *undetectable* corruption events on (or after) 
> write (eg media or transient cache being hit by a cosmic ray, cpu 
> fluctuations during write, e/m or thermal variations)

Yes. This is not different from what I have said. I didn't have any
particular scenario in mind.

But I see that you are correct in pointing out that some error
posibilities arer _created_ by the presence of raid that would not
ordinarily be present. So there is some scaling with the
number of disks that needs clarification.

> Raid disks have more 'corruption-susceptible' data capacity per useable 
> data capacity and so the probability of a corruption event is higher. 

Well, the probability is larger no matter what the nature of the event.
In principle, and vry apprximately, there are simply more places (and
times!) for it to happen TO.

Yes, you may say but those errors that are produced by the cpu don't
scale, nor do those that are produced by software. I'd demur. If you
think about each kind you have in mind you'll see that they do scale:
for example, the cpu has to work twice as often to write to two raid
disks as it does to have to write to one disk, so the opportunities for
IT to get something wrong are doubled.  Ditto software.  And of course,
since it is writing twice as often , the chance of being interrupted at
an inopportune time by a power failure are also doubled.

See?


> Since a detectable error is detected it can be retried and dealt with.

No. I made no such assumption. I don't know or care what you do with a
detectable error. I only say that whatever your test is, it detects it!
IF it looks at the right spot, of course. And on raid the chances of
doing that are halved, because it has to choose which disk to read.


> This leaves the fact that essentially, raid disks are less reliable than 
> non-raid disks wrt undetectable corruption events.

Well, that too. There is more real estate.

But this "corruption"  word seems to me to imply that you think I was
imagining errors produced by cosmic rays. I made no such restriction.

> However, we need to carry out risk analysis to decide if the increase in 
> susceptibility to certain kinds of corruption (cosmic rays) is 


Ahh. Yes you do. No I don't! This is your own invention, and I said no
such thing. By "errors", I meant anything at all that you consider to be
an error. It's up to you.  And I see no reason to restrict the term to
what is produced by something like "cosmic rays". "People hitting the
off switch at the wrong time" counts just as much, as far as I know.

I would guess that you are trying to classify errors by the way their
probabilities scale with number of disks. I made no such distinction,
in principle.  I simply classified errors according to whether you could
(in principle, also) detect them or not, whatever your test is.

> acceptable given the reduction in susceptibility to other kinds (bearing 
> or head failure).

Peter

