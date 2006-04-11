From: Alex Tomas <bzzz@tmi.comex.ru>
Subject: Re: linear writes to raid5
Date: Wed, 12 Apr 2006 01:05:41 +0400
Message-ID: <m3y7ybrffe.fsf@bzzz.home.net>
References: <m37j60udi8.fsf@bzzz.home.net>
	<17465.43983.345817.253532@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17465.43983.345817.253532@cse.unsw.edu.au> (Neil Brown's
 message of "Mon, 10 Apr 2006 10:50:23 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Alex Tomas <alex@clusterfs.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> Neil Brown (NB) writes:

 NB> The raid5 code attempts to do this already, though I'm not sure how
 NB> successful it is.  I think it is fairly successful, but not completely
 NB> successful. 

hmm. could you tell me what the code should I look at?


 NB> There is a trade-off that raid5 has to make.  Waiting longer can mean
 NB> more blocks on the same stripe, and so less reads.  But waiting longer
 NB> can also increase latency which might not be good.

yes, I agree.

 NB> The thing to would be to put some tracing in to find out exactly what
 NB> is happening for some sample workloads, and then see if anything can
 NB> be improved.

well, the simplest case I tried was this:

mdadm -C /dev/md0 --level=5 --chunk=8 --raid-disks=3 ...
then open /dev/md0 with O_DIRECT and send a write of 16K.
it ended up, doing few writes and one read. the sequence was:
1) serving first 4K of the request - put the stripe it onto delayed list
2) serving 2nd 4KB -- again onto delayed list
3) serving 3rd 4KB -- get a full uptodate stripe, time to make the parity
   3 writes are issued for stripe #0
4) raid5_unplug_device() is called because of those 3 writes
   it activates delayed stripe #4
5) raid5d() finds stripe #4 and issues READ
...

I tend to think this isn't the most optimal way. couldn't we take current
request into account somehow. something like "keep delayed off the queue
until current requests aren't served AND stripe cache isn't full".

another similar case is when you have two processes writing to very
different stripes and low-level requests they make from handle_stripe()
cause delayed stripes to get activated.

thanks, Alex
