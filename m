From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: *terrible* direct-write performance with raid5
Date: Tue, 22 Feb 2005 21:11:10 +0100
Message-ID: <u7gse2-sul.ln1@news.it.uc3m.es>
References: <421B6E5D.6030004@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:
> When debugging some other problem, I noticied that
> direct-io (O_DIRECT) write speed on a software raid5

And normal write speed (over 10 times the size of ram)?

> is terrible slow.  Here's a small table just to show
> the idea (not numbers by itself as they vary from system
> to system but how they relate to each other).  I measured
> "plain" single-drive performance (sdX below), performance
> of a raid5 array composed from 5 sdX drives, and ext3
> filesystem (the file on the filesystem was pre-created

And ext2? You will be enormously hampered by using a journalling file
system, especially with journal on the same system as the one you are
testing! At least put the journal elsewhere - and preferably leave it
off.

> during tests).  Speed measurements performed with 8Kbyte
> buffer aka write(fd, buf, 8192*1024), units a Mb/sec.
> 
>            write   read
>    sdX      44.9   45.5
>    md        1.7*  31.3
> fs on md    0.7*  26.3
> fs on sdX  44.7   45.3
> 
> "Absolute winner" is a filesystem on top of a raid5 array:

I'm afraid there are too many influences to say much from it overall.
The "legitimate" (i.e.  controlled) experiment there is between sdX and
md (over sdx), with o_direct both times.  For reference I personally
would like to see the speed withut o_direct on those two.  And the
size/ram of the transfer - you want to run over ten times size of ram
when you run without o_direct.

Then I would like to see a similar comparison made over hdX instead of
sdX.

You can forget the fs-based tests for the moment, in other words. You
already have plenty there to explain in the sdX/md comparison. And to
explain it I would like to see sdX replaced with hdX.

A time-wise graph of the instantaneous speed to disk would probably
also be instructive, but I guess you can't get that!

I would guess that you are seeing the results of one read and write to
two disks happening in sequence and not happening with any great
urgency.  Are the writes sent to each of the mirror targets from raid
without going through VMS too?  I'd suspect that - surely the requests
are just queued as normal by raid5 via the block device system. I don't
think the o_direct taint persists on the requests - surely it only
exists on the file/inode used for access.

Suppose the mirrored requests are NOT done directly - then I guess we
are seeing an interaction with the VMS, where priority inversion causes
the high-priority requests to the md device to wait on the fulfilment of
low priority requests to the sdX devices below them.  The sdX devices
requests may not ever get treated until the buffers in question age
sufficiently, or until the kernel finds time for them. When is that?
Well, the kernel won't let your process run .. hmm. I'd suspect the
raid code should be deliberately signalling the kernel to run the
request_fn of the mirror devices more often.

> Comments anyone? ;)

Random guesses above. Purely without data, of course.

Peter

