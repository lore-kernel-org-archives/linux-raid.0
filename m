From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Subject: possible deadlock through raid5/md
Date: Thu, 5 Oct 2006 10:24:52 +0200 (MET DST)
Message-ID: <200610050824.k958Oqp04752@inv.it.uc3m.es>
Reply-To: ptb@inv.it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

A user has sent me a ps ax output showing an enbd client daemon
blocked in get_active_stripe (I presume in raid5.c).


   ps ax -o f,uid,pid,ppid,pri,ni,vsz,rss,wchan:30,stat,tty,time,command

   F   UID   PID  PPID PRI  NI   VSZ  RSS WCHAN STAT TT           TIME COMMAND

   5     0 26540     1  23   0  2140 1048 get_active_stripe
   Ds   ?  00:00:00 enbd-client iss04 1300 -i iss04-hdd -n 2 -e -m -b 4096 -p 30 /dev/ndl

Any idea how it can get there and what the blockage is? I assume it
is in wait_event_lock_irq(conf->wait_for_stripe ...) or
unplug_slaves(), modulo inlining.

I believe the client(s) was/were doing a read over the network in
general terms, looking at other info supplied.  That means something
would be writing into a local kernel buffer attached to a bh.

That buffer would have come in attached to a kernel request to the enbd
driver.  I presume that the enbd device is a component of a raid5 array,
being read.

Curiously, the above client daemon appears NOT to be a transfer daemon,
but rather a "watchdog". Its only function is to hold the enbd device
open. Getting into a D state like that is a neat trick, but nothing
compared with the trick of getting into the raid code!

My theory, and it is mine, is that on the last close of a device, the
blkdev_put/get code does a flush of requests to the device as the
openers count falls to zero. That would exert pressure through the
device at least, which could deadlock since the transfer daemons are
dying, but again, I have no idea how anything got into raid code.

Maybe a method attached to a page or bh? If in order to write into
a buffer, the buffer somehow had to be "decided" by the raid code
via  a method attached, maybe that would account for where this
got parked?

I'll add more info later as I get it. For the moment, wild theories
appreciated.

Peter

