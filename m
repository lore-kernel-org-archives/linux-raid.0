From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 10:28:53 +0100
Message-ID: <ljosa2-lg.ln1@news.it.uc3m.es>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <20050104024108.GK99565@caffreys.strugglers.net> <895qa2-0qa.ln1@news.it.uc3m.es> <200501042002.32292.maarten@ultratux.net> <j6dra2-9vs.ln1@news.it.uc3m.es> <41DB127F.3090303@wasp.net.au> <qukra2-s1j.ln1@news.it.uc3m.es> <41DB7EB7.4090404@wasp.net.au> <4umsa2-c9q.ln1@news.it.uc3m.es> <41DBB012.5040308@wasp.net.au>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brad Campbell <brad@wasp.net.au> wrote:
> I'm detecting errors using md5sums and fsck.
> 
> If the drive checks out clean 1 minute, but has a bit error in a parity stripe and I remove/re-add a 
> drive the array is going to rebuild that disk from the remaning data and parity. Therefore the data 
> on that drive is going to differ compared to what it was previously.

Indeed.

> Next time I do an fsck or md5sum I'm going to notice that something has changed. I'd call that an error.

If your check can find that type of error, then it will detect it, but
it is intrinsically unlikely that an fsck will see it because the "real
estate" argument say that it is 99% likely that the error occurs inside
a file or in free space rather than in metadata, so it is 99% likely
that fsck will not see anything amiss.

If you do an md5sum on file contents and compare with a previous md5sum
run, then it will be detected provided that the error occurs in a file,
but assuming that your disk is 50% full, that is only 50% likely.

I.e. "it depends on your test".

Peter

