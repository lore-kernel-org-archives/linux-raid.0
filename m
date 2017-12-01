From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: limit mdstat resync progress to max_sectors
Date: Fri, 1 Dec 2017 11:40:46 -0800
Message-ID: <20171201194046.dzjy35lnjugqidlm@kernel.org>
References: <20171130163330.26309-1-nate.dailey@stratus.com>
 <1ef7fb87-65a9-1008-5c5d-43012f078a16@suse.com>
 <fa9d87b0-8bea-9670-a5d6-38a50ce09a10@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fa9d87b0-8bea-9670-a5d6-38a50ce09a10@stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nate Dailey <nate.dailey@stratus.com>
Cc: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 01, 2017 at 08:36:07AM -0500, Nate Dailey wrote:
> Yes, I also wondered if setting curr_resync to MaxSector could be changed...
> but not understanding why it's done, it seemed safer to just catch this in
> status_resync.

we use it to set rdev->recovery_offset, but that doesn't mean we must set it to
MaxSector though. I applied the patch as-is, it's not a big issue.

Thanks,
Shaohua

> 
> Nate
> 
> 
> 
> On 12/01/2017 03:37 AM, Guoqing Jiang wrote:
> > Actually, it is recovery :).
> > 
> > 
> > On 12/01/2017 12:33 AM, Nate Dailey wrote:
> > > There is a small window near the end of md_do_sync where mddev->curr_resync
> > > can be equal to MaxSector.
> > 
> > I am curious about the purpose of set it to MaxSector, maybe the setting
> > is not
> > necessary.
> > 
> > Acked-by: Guoqing Jiang <gqjiang@suse.com>
> > 
> > Thanks,
> > Guoqing
> > 
> > > If status_resync is called during this window, the resulting /proc/mdstat
> > > output contains a HUGE number of = signs due to the very large curr_resync:
> > >
> > > Personalities : [raid1]
> > > md123 : active raid1 sdd3[2] sdb3[0]
> > > 204736 blocks super 1.0 [2/1] [U_]
> > > [=====================================================================
> > > ... (82 MB more) ...
> > > ================>] recovery =429496729.3% (9223372036854775807/204736)
> > > finish=0.2min speed=12796K/sec
> > > bitmap: 0/1 pages [0KB], 65536KB chunk
> > >
> > > Modify status_resync to ensure the resync variable doesn't exceed
> > > the array's max_sectors.
> > >
> > > Signed-off-by: Nate Dailey <nate.dailey@stratus.com>
> > > ---
> > > drivers/md/md.c | 4 +++-
> > > 1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index 41c050b59ec4..4e4dee0ec2de 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -7605,7 +7605,9 @@ static int status_resync(struct seq_file *seq,
> > struct mddev *mddev)
> > > if (test_bit(MD_RECOVERY_DONE, &mddev->recovery))
> > > /* Still cleaning up */
> > > resync = max_sectors;
> > > - } else
> > > + } else if (resync > max_sectors)
> > > + resync = max_sectors;
> > > + else
> > > resync -= atomic_read(&mddev->recovery_active);
> > >
> > > if (resync == 0) {
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at http://vger.kernel.org/majordomo-info.html
> > <http://vger.kernel.org/majordomo-info.html>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
