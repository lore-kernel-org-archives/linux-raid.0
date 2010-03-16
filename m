From: Neil Brown <neilb@suse.de>
Subject: Re: Sysfs update frequency
Date: Wed, 17 Mar 2010 08:52:56 +1100
Message-ID: <20100317085256.6caee9bb@notabene.brown>
References: <150c16851003161432gf38c0f5o1cc957435efd4c3e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <150c16851003161432gf38c0f5o1cc957435efd4c3e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 16 Mar 2010 14:32:55 -0700
Justin Maggard <jmaggard10@gmail.com> wrote:

> I've noticed on recent kernels that /sys/block/md?/md/sync_completed
> seems to rarely get updated.  What is the expected update interval?
> For me, it seems to only update about once every 6% or so during the
> resync.  Of course, /proc/mdstat has the actual current progress.

The expected update time is every 6% - actually 1/16 which is 6.25%.

sync_completed includes a guarantee that all blocks before this point really
have been processed.  The number in /proc/mdstat is less precise.  The much
of the array has been resynced, but due to the possibility of out-of-order
completion of writes they may not be a contiguous series of blocks.

Providing the guarantee (which is needed for externally-managed metadata)
requires briefly stalling the resync, so I didn't want to do it more often.
I could possibly make it time-bases instead of size-based though.

Is this a problem for you?

NeilBrown
