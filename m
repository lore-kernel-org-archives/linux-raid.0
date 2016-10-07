From: Doug Dumitru <doug@easyco.com>
Subject: Re: [GIT PULL] MD update for 4.9
Date: Fri, 7 Oct 2016 11:15:50 -0700
Message-ID: <CAFx4rwRWei3wrSG=aq3-x0NApVNWA6ro2qe2i2-tfjWkGY1X0g@mail.gmail.com>
References: <20161007003850.GA7197@kernel.org> <CAFx4rwTo7s7uVH3PuGF-ys52QaEdxHoP2viYuJteRQqmeiEyqA@mail.gmail.com>
 <20161007173957.GA37192@kernel.org>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161007173957.GA37192@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

For the vast majority of cases, Linus is correct.  Pre-fetch is a
hardware specific tweak that just doesn't apply across the breadth of
systems Linus has to pay attention to.

In this case, our tunnel-vision is somewhat encouraged by the code and
logic at hand.  The AVX2 and AVX512 code is pretty specific to new,
64-bit, x86_64 platforms that tend to share a lot of cache behavior.
It is not like this will ever run on an Atom or ARM CPU.  Even more
important, the data access patterns are 100% defined by the task at
hand.  With RAID parity calculation, you are basically taking a stroll
through RAM with 100% defined patterns.  This is one case, where you
can pre-fetch memory enough ahead of time so that the hardware
prefetch unit never triggers and you will always be correct.

I am somewhat surprised you see 10%.  10% on an expensive function
like this is a lot.  Even more amazing is that the AVX2 and AVX512
code look to be memory bandwidth limited.  256 bytes of source reads
in about 30 clocks is about 17 GB/sec, which is faster than a single
RAM channel.  Congrats to Intel for "finding the next bottleneck".

I also see a follow-up from Linus, and again, totally agree with him.
I guess my take is that prefetch only works when you have a use case
where you are 100% correct with your pre-fetches.  I would also note
that this "raid case" is the default, clean array, parity calc code.
The same logic probably needs to be applied to the recovery cases, but
I have not looked at those yet.

Doug

On Fri, Oct 7, 2016 at 10:39 AM, Shaohua Li <shli@kernel.org> wrote:
> On Thu, Oct 06, 2016 at 10:39:21PM -0700, Doug Dumitru wrote:
>> Mr. Li,
>>
>> There is another thread in [linux-raid] discussing pre-fetches in the
>> raid-6 AVX2 code.  My testing implies that the prefetch distance is
>> too short.  In your new AVX512 code, it looks like there are 24
>> instructions, each with latencies of 1, between the prefetch and the
>> actual memory load.  I don't have a AVX512 CPU to try this on, but the
>> prefetch might do better at a bigger distance.  If I am not mistaken,
>> it takes a lot longer than 24 clocks to fetch 4 cache lines.
>>
>> Just a comment while the code is still fluid.
>
> I did try your patch and it improved 10% in my machine, but this isn't
> relevent to the pull. We can do the tunning later if necessary. I'm
> hoping the intel guys can share some hints, but apparently Linus isn't a
> fan for such tuning.
>
> Thanks,
> Shaohua
>
>> On Thu, Oct 6, 2016 at 5:38 PM, Shaohua Li <shli@kernel.org> wrote:
>> > Hi Linus,
>> > Please pull MD update for 4.9. This update includes:
>> > - new AVX512 instruction based raid6 gen/recovery algorithm
>> > - A couple of md-cluster related bug fixes
>> > - Fix a potential deadlock
>> > - Set nonrotational bit for raid array with SSD
>> > - Set correct max_hw_sectors for raid5/6, which hopefuly can improve
>> >   performance a little bit
>> > - Other minor fixes
>> >
>> > Thanks,
>> > Shaohua
>> >
>> > The following changes since commit 7d1e042314619115153a0f6f06e4552c09a50e13:
>> >
>> >   Merge tag 'usercopy-v4.8-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux (2016-09-20 17:11:19 -0700)
>> >
>> > are available in the git repository at:
>> >
>> >   git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.9-rc1
>> >
>> > for you to fetch changes up to bb086a89a406b5d877ee616f1490fcc81f8e1b2b:
>> >
>> >   md: set rotational bit (2016-10-03 10:20:27 -0700)
>> >
>> > ----------------------------------------------------------------
>> > Chao Yu (1):
>> >       raid5: fix to detect failure of register_shrinker
>> >
>> > Gayatri Kammela (5):
>> >       lib/raid6: Add AVX512 optimized gen_syndrome functions
>> >       lib/raid6: Add AVX512 optimized recovery functions
>> >       lib/raid6/test/Makefile: Add avx512 gen_syndrome and recovery functions
>> >       lib/raid6: Add AVX512 optimized xor_syndrome functions
>> >       raid6/test/test.c: bug fix: Specify aligned(alignment) attributes to the char arrays
>> >
>> > Guoqing Jiang (9):
>> >       md-cluster: call md_kick_rdev_from_array once ack failed
>> >       md-cluster: use FORCEUNLOCK in lockres_free
>> >       md-cluster: remove some unnecessary dlm_unlock_sync
>> >       md: changes for MD_STILL_CLOSED flag
>> >       md-cluster: clean related infos of cluster
>> >       md-cluster: protect md_find_rdev_nr_rcu with rcu lock
>> >       md-cluster: convert the completion to wait queue
>> >       md-cluster: introduce dlm_lock_sync_interruptible to fix tasks hang
>> >       md-cluster: make resync lock also could be interruptted
>> >
>> > Shaohua Li (5):
>> >       raid5: allow arbitrary max_hw_sectors
>> >       md/bitmap: fix wrong cleanup
>> >       md: fix a potential deadlock
>> >       raid5: handle register_shrinker failure
>> >       md: set rotational bit
>> >
>> >  arch/x86/Makefile        |   5 +-
>> >  drivers/md/bitmap.c      |   4 +-
>> >  drivers/md/md-cluster.c  |  99 ++++++---
>> >  drivers/md/md.c          |  44 +++-
>> >  drivers/md/md.h          |   5 +-
>> >  drivers/md/raid5.c       |  11 +-
>> >  include/linux/raid/pq.h  |   4 +
>> >  lib/raid6/Makefile       |   2 +-
>> >  lib/raid6/algos.c        |  12 +
>> >  lib/raid6/avx512.c       | 569 +++++++++++++++++++++++++++++++++++++++++++++++
>> >  lib/raid6/recov_avx512.c | 388 ++++++++++++++++++++++++++++++++
>> >  lib/raid6/test/Makefile  |   5 +-
>> >  lib/raid6/test/test.c    |   7 +-
>> >  lib/raid6/x86.h          |  10 +
>> >  14 files changed, 1111 insertions(+), 54 deletions(-)
>> >  create mode 100644 lib/raid6/avx512.c
>> >  create mode 100644 lib/raid6/recov_avx512.c
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Doug Dumitru
>> EasyCo LLC



-- 
Doug Dumitru
EasyCo LLC
