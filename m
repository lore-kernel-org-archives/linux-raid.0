From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: Fast (intelligent) raid1
Date: Mon, 17 Feb 2003 16:08:15 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302171508.h1HF8Fe31915@oboe.it.uc3m.es>
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
> 
> I'm not too sure what whole-array structure to attach the bitmap to.
> Suggestions welcome.

This would be the raid1_conf_t ("conf") that is referenced in the private
data field of the mddev_t.

I'll do that first, though I presume it should later be promoted to
become an md-wide field.

Peter
