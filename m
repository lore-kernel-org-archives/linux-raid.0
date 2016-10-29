From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: be careful not lot leak internal curr_resync value
 into metadata.
Date: Fri, 28 Oct 2016 22:01:08 -0700
Message-ID: <20161029050108.fdfawfxgbxp4cad7@kernel.org>
References: <8737jht6f6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8737jht6f6.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@fb.com>, Linux-RAID <linux-raid@vger.kernel.org>, Viswesh <viswesh.vichu@gmail.com>
List-Id: linux-raid.ids

On Fri, Oct 28, 2016 at 03:59:41PM +1100, Neil Brown wrote:
> 
> 
> mddev->curr_resync usually records where the current resync is up to,
> but during the starting phase it has some "magic" values.
> 
>  1 - means that the array is trying to start a resync, but has yielded
>      to another array which shares physical devices, and also needs to
>      start a resync
>  2 - means the array is trying to start resync, but has found another
>      array which shares physical devices and has already started resync.
> 
>  3 - means that resync has commensed, but it is possible that nothing
>      has actually been resynced yet.
> 
> It is important that this value not be visible to user-space and
> particularly that it doesn't get written to the metadata, as the
> resync or recovery checkpoint.  In part, this is because it may be
> slightly higher than the correct value, though this is very rare.
> In part, because it is not a multiple of 4K, and some devices only
> support 4K aligned accesses.
> 
> There are two places where this value is propagates into either
> ->curr_resync_completed or ->recovery_cp or ->recovery_offset.
> These currently avoid the propagation of values 1 and 3, but will
> allow 3 to leak through.
> 
> Change them to only propagate the value if it is > 3.
> 
> As this can cause an array to fail, the patch is suitable for -stable.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Viswesh <viswesh.vichu@gmail.com>
> Signed-off-by: NeilBrown <neilb@suse.com>

Good catch, applied, thanks!
