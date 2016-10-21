From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/2 v3] md: add bad block support for external metadata
Date: Fri, 21 Oct 2016 15:30:06 -0700
Message-ID: <20161021223006.GA105663@kernel.org>
References: <1477060017-8217-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1477060017-8217-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 21, 2016 at 04:26:57PM +0200, Tomasz Majchrzak wrote:
> Add new rdev flag which external metadata handler can use to switch
> on/off bad block support. If new bad block is encountered, notify it via
> rdev 'unacknowledged_bad_blocks' sysfs file. If bad block has been
> cleared, notify update to rdev 'bad_blocks' sysfs file.
> 
> When bad blocks support is being removed, just clear rdev flag. It is
> not necessary to reset badblocks->shift field. If there are bad blocks
> cleared or added at the same time, it is ok for those changes to be
> applied to the structure. The array is in blocked state and the drive
> which cannot handle bad blocks any more will be removed from the array
> before it is unlocked.
> 
> Simplify state_show function by adding a separator at the end of each
> string and overwrite last separator with new line.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

Thanks, applied. After the badblocks patch upstream, I'll push these two.

Thanks,
Shaohua
