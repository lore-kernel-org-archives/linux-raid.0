From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: report 'write_pending' state when array in sync
Date: Mon, 24 Oct 2016 15:24:35 -0700
Message-ID: <20161024222435.jadcmbypln3baw7c@kernel.org>
References: <1477306048-26097-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1477306048-26097-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 24, 2016 at 12:47:28PM +0200, Tomasz Majchrzak wrote:
> If there is a bad block on a disk and there is a recovery performed from
> this disk, the same bad block is reported for a new disk. It involves
> setting MD_CHANGE_PENDING flag in rdev_set_badblocks. For external
> metadata this flag is not being cleared as array state is reported as
> 'clean'. The read request to bad block in RAID5 array gets stuck as it
> is waiting for a flag to be cleared - as per commit c3cce6cda162
> ("md/raid5: ensure device failure recorded before write request
> returns.").
> 
> The meaning of MD_CHANGE_PENDING and MD_CHANGE_CLEAN flags has been
> clarified in commit 070dc6dd7103 ("md: resolve confusion of
> MD_CHANGE_CLEAN"), however MD_CHANGE_PENDING flag has been used in
> personality error handlers since and it doesn't fully comply with
> initial purpose. It was supposed to notify that write request is about
> to start, however now it is also used to request metadata update.
> Initially (in md_allow_write, md_write_start) MD_CHANGE_PENDING flag has
> been set and in_sync has been set to 0 at the same time. Error handlers
> just set the flag without modifying in_sync value. Sysfs array state is
> a single value so now it reports 'clean' when MD_CHANGE_PENDING flag is
> set and in_sync is set to 1. Userspace has no idea it is expected to
> take some action.
> 
> Swap the order that array state is checked so 'write_pending' is
> reported ahead of 'clean' ('write_pending' is a misleading name but it
> is too late to rename it now).


Applied, thanks!
