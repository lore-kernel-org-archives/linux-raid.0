From: "Ana Paula" <anapaula@cs.rutgers.edu>
Subject: Out of sync mirrors
Date: Thu, 24 Jul 2008 12:03:34 -0400
Message-ID: <e6432b760807240903s57815b2aib5547d35b701ca70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I am using linux 2.6.8 for my research on raid systems.

I need to have the disks of an array out of sync for a while.
I want to be able to stop a disk request queue (blk_stop_queue) and
start it sometime later. Meanwhile its mirrors should be serving r/w
as if this mirror was up.
Whenever the stopped mirror comes back it will serve all the requests
already sent to it.

I am queueing up the requests sent to all others while my mirror queue
is stopped.

The problem is that the other mirrors stop serving as well. Even if I
don't stop the queue, only delay its request a little bit, still the
others also slow down.

Question: how do I get raid to allow mirrors to be out of sync?

Obviously, I am missing something out in the code.

Any clues?

Thanks,
Ana Paula
