From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: Use new topology calls to indicate alignment and I/O  sizes
Date: Wed, 24 Jun 2009 16:22:43 +1000
Message-ID: <19009.50739.830769.821582@notabene.brown>
References: <yq1ws73turf.fsf@sermon.lab.mkp.net>
	<170fa0d20906231444t5432998eo8cc2335c6d4a3a0d@mail.gmail.com>
	<19009.42494.925771.283731@notabene.brown>
	<yq1zlbyrzo9.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Martin K. Petersen on Wednesday June 24
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@gmail.com>, linux-raid@vger.kernel.org, snitzer@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids


On Wednesday June 24, martin.petersen@oracle.com wrote:
> >>>>> "Neil" == Neil Brown <neilb@suse.de> writes:
> Neil>   But when io_min is larger than physical_block_size, what does it
> Neil>   mean?  Maybe I just didn't look hard enough for the
> Neil>   documentation??
> 
> Documentation/ABI/testing/sysfs-block.txt

Ahh, thanks.  I searched for "io_min" not "minimum_io" :-)

> 
> The difference is that the io_min parameter can be scaled up by stacking
> drivers.  For RAID5 you may sit on top of disks with 512 byte physical
> blocks but I/Os that small will cause MD to perform read-modify-write.
> So you scale io_min up to whatever makes sense given the chunk size.
> 
> Think of physical_block_size as an indicator of physical atomicity for
> correctness reasons and io_min as the smallest I/O you'd want to issue
> for performance reasons.

That correctness/performance distinction is a good one, but is not at
all clear from the documentation.

Are you saying that if you tried to write a 512byte sector to a SATA
drive with 4KB sectors it would corrupt the data?  Or it would fail?
In either case, the reference to "read-modify-write" in the
documentation seems misplaced.

So a write MUST be physical_block_size
and SHOULD be minimum_io_size

Now I don't get the difference between "preferred" and "optimal".
Surely we would always prefer everything to be optimal.
The definition of "optimal_io_size" from the doco says it is the
"preferred unit of receiving I/O".  Very confusing.

What I can see at present is 5 values:
  logical_block_size
  physical_block_size
  minimum_io_size
  optimal_io_size
  read_ahead_kb
and only one distinction: "correctness" vs "performance" aka "MUST" vs
"SHOULD".  Maybe there is another distinction: "SHOULD" for read and
"SHOULD" for write.

Though reading further about the alignment, it seems that the
physical_block_size isn't really a 'MUST', as having a partition that
was not properly aligned to a MUST size would be totally broken.

Is it possible to get more precise definitions of these?
I would like definitions that make strong statements so I can compare
these to the actual implementation to see if the implementation is
correct or not.

My current thought for raid0 for example is that the only way it
differs from the max of the underlying devices is that the read-ahead
size should be N times the max for N drives.  A read_ahead related to
optimal_io_size ??

> 
> 
> Neil> 2/ Is it too late to discuss moving the sysfs files out of the
> Neil> 'queue' subdirectory?  'queue' has a lot of values the are purely
> Neil> related to the request queue used in the elevator algorithm, and
> Neil> are completely irrelevant to md and other virtual devices (I look
> Neil> forward to the day when md devices don't have a 'queue' at all).
> 
> These sat under /sys/block/<dev>/topology for a while but there was
> overlap with the existing queue params and several apps expected to find
> the values in queue.  Also, at the storage summit several people
> advocated having the limits in queue instead of introducing a new
> directory.

(not impressed with having summits like that in meat-space - they
exclude people who are not in a position to travel.. Maybe we should
try on-line summits).

I think /sys/block/<dev>/topology is an excellent idea (except that
the word always makes me think of rubber sheets with cups and handles
- from third year mathematics).  I'd go for "metrics" myself.  Or bdi.

Yes, some values would be duplicated from 'queue', but we already have
read_ahead_kb duplicated in queue and bdi.  Having a few more
duplicated, and then trying to phase out the legacy usage would not be
a bad idea.

Actually, the more I think about it the more I like the idea that this
is all information about the backing device for a filesystem,
information that is used by the VM and the filesystem to choose
suitable IO sizes (just like read_ahead_kb).
So I *really* think it belongs in bdi.

> 
> If you look at the patches that went in through block you'll see that MD
> devices now have the queue directory exposed in sysfs despite not really
> having a queue (nor an associated elevator).  To me, it's more a matter
> of the term "queue" being a misnomer rather than the actual
> values/functions that are contained in struct request_queue.  I always
> implicitly read request_queue as request_handling_goo.

Agreed, the name 'queue' is part of the problem, and 'goo' might work
better.
But there is more to it than that.
Some fields are of interest only to code that has special knowledge
about the particular implementation.  These fields will be different
for different types of devices.  nr_request for the elevator,
chunk_size for a raid array.  This is 'goo'.
Other fields are truly generic.  'size' 'read_ahead_kb'
'hw_sector_size'  are relevant to all devices and needed by some
filesystems.  This is metrics, or bdi.
I think the 'particular' and the 'generic' should be in different
places.

> 
> That being said I don't have a problem moving the limits somewhere else
> if that's what people want to do.  I agree that the current sysfs
> location for the device limits is mostly a function of implementation
> and backwards compatibility.

Who do I have to get on side for you to be comfortable moving the
various metrics to 'bdi' (leaving legacy duplicates in 'queue' where
that is necessary) ??  i.e. which people need to want it?

NeilBrown
