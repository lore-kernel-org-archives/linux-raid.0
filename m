From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: Fast (intelligent) raid1
Date: Tue, 18 Feb 2003 01:57:37 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302180057.h1I0vbN29768@oboe.it.uc3m.es>
References: <15952.20989.131713.951636@notabene.cse.unsw.edu.au>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15952.20989.131713.951636@notabene.cse.unsw.edu.au> from Neil Brown
 at "Feb 17, 2003 02:07:41 pm"
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: ptb@it.uc3m.es, Ross Vandegrift <ross@willow.seitz.com>, Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Neil Brown wrote:"
> Rather than having several bitmaps, have just one.  Normally it is
> full of zero and isn't touched.

> On hot-add, read the old superblock.  If it looks valid and matches
> the current array, and has an event counter of X or more, then ignore

I've made a preliminary patch. Available as

  ftp://oboe.it.uc3m.es/pub/Programs/fr1-2.2.tgz

This still needs to have the checkpoint (X) stuff put in, but I'm too
tired to do it right now. What it has is

  1) single bitmap
  2) recognition of a "hotrepair" via the superblock on a persistent 
    sb array

and also

  3) allow "hotrepair" on a nonpersistent sb array when a hotadd
     follows a setfaulty directlym without hotremove.

I'll complete it tomorrow. I checked basic functionality (i.e. "it
works", tm).

Peter
