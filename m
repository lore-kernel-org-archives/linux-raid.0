From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: One more question about the linux md driver
Date: Thu, 10 Apr 2003 16:46:47 +0200 (MET DST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200304101446.h3AEklj30240@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: From "(env:" "ptb)" at "Mar 13, 2003 07:49:40 pm"
To: linux-raid@vger.kernel.org
Cc: Paul Clements <Paul.Clements@SteelEye.com>, Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

Can someone tell me about the difference between (when they are called)

    bind_rdev_to_array
    unbind_rdev_from_array

and

   import_rdev
   export_rdev

?? I want to detect when a device is first inducted into an (any) array
and when it is expelled (from the last array in which it figures). I am
currently using the first two functions, and counting. I suspect I
should be using the second two?

Peter
