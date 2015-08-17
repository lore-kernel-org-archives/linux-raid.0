From: NeilBrown <neilb@suse.com>
Subject: Re: [patch v2 00/11]md: fix raid5 write hole
Date: Mon, 17 Aug 2015 14:45:31 +1000
Message-ID: <20150817144531.7acc01b1@noble>
References: <cover.1439500639.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1439500639.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Thu, 13 Aug 2015 14:31:53 -0700 Shaohua Li <shli@fb.com> wrote:

> Hi Neil,
> 
> This is the updated patch for the raid5 write hole issue. I thought I addressed
> most of issues from you and Christoph. Please let me know if anything is
> missed. Something not done yet:

Hi Shaohua,
 thanks for your persistence and patience. I does look like you have
 address everything, though I'm a bit foggy today (recovering from a
 cold) so I cannot give it the attention it deserves right now.
 Hopefully I'll give you more feedback later in the week.  I'll be
 offline after that until late September so I'll try really hard to
 raising anything important before then.

 I'll probably queue these in my "devel" branch and aim for Linux 4.4.
 That will give me (and others??) time to test and experiment some more.

 I'd be quite happy to see patches on top of these for the write-ahead
 caching when I get back in late September, if you happen to have them
 ready by then.

> 
> - Still use NOFAIL allocation. I don't think 2-element mempool is ok. An
>   io_unit will have several bio (> 2), 2 element bioset isn't ok. We can
> dispatch all bio of the io_unit if bio allocation fails, but this will increase
> complexity. I'd prefer using NOFAIL allocation now for simplicity and fix it
> later if necessary

 You might need to get a patch accepted which removes the line:

                         * __GFP_NOFAIL is not to be used in new code.

 from mm/page_alloc.c :-(
 ... though from looking at the code, I think the flag is (currently)
 ignored for single-page allocations, they never fail (if they are
 allowed to wait).
 It's all very confusing.

 It can stay for now.  It serves as useful documentation at least.


> - Add flag for reshape handling in disk format, but don't support it yet

 That looks good, thanks.


Thanks,
NeilBrown


> 
> Thanks,
> Shaohua
> 
> 
> Shaohua Li (9):
>   md: override md superblock recovery_offset for journal device
>   raid5: export some functions
>   raid5: add a new state for stripe log handling
>   raid5: add basic stripe log
>   raid5: log reclaim support
>   raid5: log recovery
>   raid5: disable batch with log enabled
>   raid5: don't allow resize/reshape with cache(log) support
>   raid5: enable log for raid array with cache disk
> 
> Song Liu (2):
>   MD: replace special disk roles with macros
>   MD: add a new disk role to present write journal device
> 
>  drivers/md/Makefile            |    2 +-
>  drivers/md/md.c                |   44 +-
>  drivers/md/md.h                |   13 +-
>  drivers/md/raid5-cache.c       | 1094 ++++++++++++++++++++++++++++++++++++++++
>  drivers/md/raid5.c             |  137 +++--
>  drivers/md/raid5.h             |   20 +
>  include/uapi/linux/raid/md_p.h |   70 ++-
>  7 files changed, 1320 insertions(+), 60 deletions(-)
>  create mode 100644 drivers/md/raid5-cache.c
> 

