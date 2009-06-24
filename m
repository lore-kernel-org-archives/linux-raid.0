From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] md: Use new topology calls to indicate alignment and I/O  sizes
Date: Wed, 24 Jun 2009 01:03:34 -0400
Message-ID: <yq1zlbyrzo9.fsf@sermon.lab.mkp.net>
References: <yq1ws73turf.fsf@sermon.lab.mkp.net>
	<170fa0d20906231444t5432998eo8cc2335c6d4a3a0d@mail.gmail.com>
	<19009.42494.925771.283731@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19009.42494.925771.283731@notabene.brown> (Neil Brown's message
	of "Wed, 24 Jun 2009 14:05:18 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Mike Snitzer <snitzer@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid@vger.kernel.org, snitzer@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

>>>>> "Neil" == Neil Brown <neilb@suse.de> writes:

Neil,

Neil> 1/ Is there any documentation on exactly what "io_min" etc mean?
Neil>   I can guess that "io_opt" means "try to use this size, or a
Neil>   multiple of this size, whenever possible" and does not
Neil>   differentiate between read and write (despite the fact that I
Neil>   probably care a lot more about write than read).

This was discussed a while back.  My first take did provide min + opt
parameters for both I/O directions.  However, the values provided by the
hardware that we feed off are somewhat write biased.  And obviously
there's no read-modify-write penalty for reads.  So there was not much
point in providing the knobs for the latter.


Neil>   But when io_min is larger than physical_block_size, what does it
Neil>   mean?  Maybe I just didn't look hard enough for the
Neil>   documentation??

Documentation/ABI/testing/sysfs-block.txt

The difference is that the io_min parameter can be scaled up by stacking
drivers.  For RAID5 you may sit on top of disks with 512 byte physical
blocks but I/Os that small will cause MD to perform read-modify-write.
So you scale io_min up to whatever makes sense given the chunk size.

Think of physical_block_size as an indicator of physical atomicity for
correctness reasons and io_min as the smallest I/O you'd want to issue
for performance reasons.


Neil> 2/ Is it too late to discuss moving the sysfs files out of the
Neil> 'queue' subdirectory?  'queue' has a lot of values the are purely
Neil> related to the request queue used in the elevator algorithm, and
Neil> are completely irrelevant to md and other virtual devices (I look
Neil> forward to the day when md devices don't have a 'queue' at all).

These sat under /sys/block/<dev>/topology for a while but there was
overlap with the existing queue params and several apps expected to find
the values in queue.  Also, at the storage summit several people
advocated having the limits in queue instead of introducing a new
directory.

If you look at the patches that went in through block you'll see that MD
devices now have the queue directory exposed in sysfs despite not really
having a queue (nor an associated elevator).  To me, it's more a matter
of the term "queue" being a misnomer rather than the actual
values/functions that are contained in struct request_queue.  I always
implicitly read request_queue as request_handling_goo.

That being said I don't have a problem moving the limits somewhere else
if that's what people want to do.  I agree that the current sysfs
location for the device limits is mostly a function of implementation
and backwards compatibility.

-- 
Martin K. Petersen	Oracle Linux Engineering
