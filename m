From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH 0/6] raid5-cache fixes
Date: Wed, 7 Oct 2015 19:56:12 -0700
Message-ID: <20151008025603.GA3007253@devbig084.prn1.facebook.com>
References: <cover.1443973492.git.shli@fb.com>
 <87mvvu6rfr.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87mvvu6rfr.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Thu, Oct 08, 2015 at 01:10:32PM +1100, Neil Brown wrote:
> Shaohua Li <shli@fb.com> writes:
> 
> > Hi,
> >
> > some fixes for raid5-cache.
> > patch 1, a small fix
> > patch 2-3, move reclaim teardown to quiesce handling and add trim support. I
> > still need md_update_sb there and play the mddev_is_locked trick as the
> > reconfig_mutex is already hold at md stop. The md_update_sb probably can move
> > to md core later.
> > patch 4-6, add error handling. For patch 4, I still need the journal bit check
> > in in md core, otherwise there is no way to prevent 'echo remove > rdev/state'
> > to delete journal disk. For patch 6, I didn't change has_failed() yet. Handling
> > assemble with miss/failed log disk is still on going.
> >
> > Next step is to make assemble correct with miss/failed log disk. This will need
> > kernel/utilities cooperation. Song and I are working on it.
> >
> > Thanks,
> > Shaohua
> >
> > Shaohua Li (6):
> >   md: show journal for journal disk in disk state sysfs
> >   raid5-cache: move reclaim stop to quiesce
> >   raid5-cache: add trim support for log
> >   md: don't export log device
> >   md: set In_Sync for log disk
> >   raid5-cache: IO error handling
> >
> >  drivers/md/md.c          |  9 ++++--
> >  drivers/md/raid5-cache.c | 83 ++++++++++++++++++++++++++++++++++++++++--------
> >  drivers/md/raid5.c       |  7 +++-
> >  drivers/md/raid5.h       |  3 ++
> >  4 files changed, 85 insertions(+), 17 deletions(-)
> >
> > -- 
> > 2.4.6
> 
> Thanks.
> 
> I've applied 1, 2, and 5. Should appear in 'devel' shortly.
> 3 and 4 I've replies to separately, 6 depends on 3.

please hold 5 currently. I'm a little confused about the In_sync bit.
It's quite tricky to handle this bit. For example, if both In_sync and
Journal bits are set, I'll need move checking the 'Journal' bit ahead of
checking the 'In_sync' in super_1_sync (current patch haven't done it
yet, it's a bug). There are similar cases in mdadm too. This makes me
thinking about What's the exact role for the In_sync bit for journal
disk. The comments in the bit definition doesn't give an answer. We can
use the Faulty bit for error handling. Any thoughts?

Thanks,
Shaohua
