From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: Fast (intelligent) raid1
Date: Mon, 17 Feb 2003 18:54:13 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302171754.h1HHsDn15125@oboe.it.uc3m.es>
References: <200302171317.h1HDH1J20820@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200302171317.h1HDH1J20820@oboe.it.uc3m.es> from "Peter T. Breuer"
 at "Feb 17, 2003 02:17:01 pm"
To: ptb@it.uc3m.es
Cc: Neil Brown <neilb@cse.unsw.edu.au>, Ross Vandegrift <ross@willow.seitz.com>, Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Peter T. Breuer wrote:"
> "A month of sundays ago Neil Brown wrote:"
> > Rather than having several bitmaps, have just one.  Normally it is
> > full of zero and isn't touched.

Well, this bit was no trouble - it works fine. I'll publish a patch
presently, when I have a few more things in.

> > On hot-add, read the old superblock.  If it looks valid and matches

Yah. Any clues as to what function does that? I need to WRITE the
superblock too, from time to time. I need all the clues I can get. This
must be in md.c, somewhere, right?

Peter
