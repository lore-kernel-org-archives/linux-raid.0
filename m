From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 00:20:26 +0100
Message-ID: <qukra2-s1j.ln1@news.it.uc3m.es>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <20050104024108.GK99565@caffreys.strugglers.net> <895qa2-0qa.ln1@news.it.uc3m.es> <200501042002.32292.maarten@ultratux.net> <j6dra2-9vs.ln1@news.it.uc3m.es> <41DB127F.3090303@wasp.net.au>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brad Campbell <brad@wasp.net.au> wrote:
> I'm wondering how difficult it may be for you to extend your md5sum script to diff the pair of files 
> and actually determine the extent of the corruption. bit/byte/word/.../sector/.../stripe wise?

Not much.  But I don't bother.  It's a majority vote amongst all the
identical machines involved and the loser gets rewritten. The script
identifies a majority group and a minority group. If the minority is 1
it rewrites it without question.  If the minority group is bigger it
refers the notice to me.

> I have 2 RAID-5 arrays here. a 3x233GiB and a 10x233GiB and I when I install new data on the drives 
> I add the md5sum of that data to an existing database stored on another machine. This gets compared 
> against the data on the arrays weekly and I have yet to see a silent corruption in 18 months.

Looking at the lists of pending repairs over xmas, I see a pile that
will have to be investigated. I am about to do it, since you reminded me
to look at these.

> I do occasionally remove/re-add a drive to each array, which causes a full resync of the array and 
> should show up any parity inconsistency by a faulty fsck or md5sum. It has not as yet.

No - it should not show it. 

> Honestly, in my years running Linux and multiple drive arrays I have never experienced errors such 
> as you are getting.

Then you are not trying to manage hundreds of clients at a time.

> Oh.. and both my arrays are running ext3 with an internal journal (as are all my other partitions on 
> all my other machines).
> 
> Perhaps I'm lucky?

You're both not looking in the right way and not running the right
experiment.

Peter

