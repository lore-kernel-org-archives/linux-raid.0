From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: *terrible* direct-write performance with raid5
Date: Wed, 23 Feb 2005 00:43:32 +0300
Message-ID: <421BA784.8040909@tls.msk.ru>
References: <421B6E5D.6030004@tls.msk.ru> <u7gse2-sul.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <u7gse2-sul.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:
> Michael Tokarev <mjt@tls.msk.ru> wrote:
> 
>>When debugging some other problem, I noticied that
>>direct-io (O_DIRECT) write speed on a software raid5
> 
> And normal write speed (over 10 times the size of ram)?

There's no such term as "normal write speed" in this context
in my dictionary, because there are just too many factors
influencing the speed of non-direct I/O operations (I/O
scheduler aka elevator is the main factor I guess).  More,
when going over the buffer cache, "cache trashing" is plays
significant role for the whole system (eg, when just copying
a large amount of data with cp, system becomes quite
unresponsible die to "cache trashing" while the whole stuff
it is copying should not be cached in the first place, for
this task anyway).  Also, I don't think linux elevator is
optimized for this task (accessing large amounts of data).

I come across this issue when debugging very slow database
(oracle10 in this case) which tries to do direct I/O where
possible because "it knows better" when/how to cache data.
If I "turn on" vfs/block cache here, system becomes much
slower (under normal conditions anyway, not counting this
md slowness) (ok ok, i know it isn't a good idea to place
datbase files on raid5... or wasn't some time ago when
raid5 checksumming was the bottleneck anyway... but that's
a different story).

More to the point seems to be the same direct-io but in
larger chunks - eg 1Mb or more instead of 8Kb buffer.  And
this indeed makes alot of difference, the numbers looks
much more nice.

>>is terrible slow.  Here's a small table just to show
>>the idea (not numbers by itself as they vary from system
>>to system but how they relate to each other).  I measured
>>"plain" single-drive performance (sdX below), performance
>>of a raid5 array composed from 5 sdX drives, and ext3
>>filesystem (the file on the filesystem was pre-created
> 
> And ext2? You will be enormously hampered by using a journalling file
> system, especially with journal on the same system as the one you are
> testing! At least put the journal elsewhere - and preferably leave it
> off.

This whole issue has exactly nothing to do with journal.
I don't mount the fs with data=journal option, and the
file I'm writing to is "preallocated" first (i create the
file of a given size when measure re-writing speed).  In
this case, data never touches ext3 journal.

>>during tests).  Speed measurements performed with 8Kbyte
>>buffer aka write(fd, buf, 8192*1024), units a Mb/sec.
[]
>>"Absolute winner" is a filesystem on top of a raid5 array:
> 
> I'm afraid there are too many influences to say much from it overall.
> The "legitimate" (i.e.  controlled) experiment there is between sdX and
> md (over sdx), with o_direct both times.  For reference I personally
> would like to see the speed withut o_direct on those two.  And the
> size/ram of the transfer - you want to run over ten times size of ram
> when you run without o_direct.

I/O speed without O_DIRECT is very close to 44 Mb/sec for sdX (it's the
spid of the drives it seems), and md performs at about 80 Mb/sec.  That
numbers are very close to the case with O_DIRECT and large block size
(eg 1Mb).

There's much more to the block size really.  I just used 8Kb block because
I have real problem with performance of our database server (we're trying
oracle10 and it performs very badly, and now i don't understand whenever
the machine has always been like that (the numbers above) but we never
noticied with different usage pattern of previous oracle releases, or
something else changed...

> Then I would like to see a similar comparison made over hdX instead of
> sdX.

Sorry no IDE drives here, and i don't see the point in trying them anyway.

> You can forget the fs-based tests for the moment, in other words. You
> already have plenty there to explain in the sdX/md comparison. And to
> explain it I would like to see sdX replaced with hdX.
> 
> A time-wise graph of the instantaneous speed to disk would probably
> also be instructive, but I guess you can't get that!
> 
> I would guess that you are seeing the results of one read and write to
> two disks happening in sequence and not happening with any great
> urgency.  Are the writes sent to each of the mirror targets from raid

Hmm point.

> without going through VMS too?  I'd suspect that - surely the requests
> are just queued as normal by raid5 via the block device system. I don't
> think the o_direct taint persists on the requests - surely it only
> exists on the file/inode used for access.

Well, O_DIRECT performs very-very similar to O_SYNC here (both cases --
with and without a filesystem involved) in terms of speed.

I don't care much now whenever it relly performs direct I/O (from
userspace buffer directly to controller), esp. since it can't work
exactly this way with raid5 implemented in software (checksums must
be written too).  I just don't want to see unnecessary cache trashing
and do want to know about I/O errors immediately.

> Suppose the mirrored requests are NOT done directly - then I guess we
> are seeing an interaction with the VMS, where priority inversion causes
> the high-priority requests to the md device to wait on the fulfilment of
> low priority requests to the sdX devices below them.  The sdX devices
> requests may not ever get treated until the buffers in question age
> sufficiently, or until the kernel finds time for them. When is that?
> Well, the kernel won't let your process run .. hmm. I'd suspect the
> raid code should be deliberately signalling the kernel to run the
> request_fn of the mirror devices more often.

I guess if that's the case, buffer size should not make much difference.

>>Comments anyone? ;)
> 
> Random guesses above. Purely without data, of course.

Heh.  Thanks anyway ;)

/mjt
