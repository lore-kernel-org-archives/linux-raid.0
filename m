From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: Fast (intelligent) raid1
Date: Wed, 19 Feb 2003 21:59:10 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302192059.h1JKxAH28572@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: From "(env:" "ptb)" at "Feb 19, 2003 12:29:55 pm"
To: ptb@it.uc3m.es
Cc: Neil Brown <neilb@cse.unsw.edu.au>, Ross Vandegrift <ross@willow.seitz.com>, Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"ptb wrote:"
> "A month of sundays ago ptb wrote:"
> >  ftp://oboe.it.uc3m.es/pub/Programs/fr1-2.2.tgz

I've now added asynchronous writes to the fr1-2.4 patch (note,
2.4, not 2.2). This uses the bitmap as a journal log. Ordinary
writes mark the bitmap and they bitmap is cleared when the last i/o in
the set completes.

However, success is reported back to the user after ONE successful
completion (i.e. we run the original end_io handed down to md), not
after two or more or however many components are in the array...

We can afford to do that because the bitmap records if we miss
any.

Peter
