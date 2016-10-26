From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid5: write an empty meta-block when creating
 logsuper-block
Date: Wed, 26 Oct 2016 11:35:52 -0700
Message-ID: <20161026183552.hxx5zu2r4g4a46is@kernel.org>
References: <tencent_048678816CFA01ED3101C078@qq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <tencent_048678816CFA01ED3101C078@qq.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Cc: Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>, liuzhengyuang521 <liuzhengyuang521@gmail.com>
List-Id: linux-raid.ids

On Tue, Oct 25, 2016 at 08:43:50PM +0800, Zhengyuan Liu wrote:
> After discussion with my colleague, I think there is still a problem that
> may happen very unlikely.The superblock should point to the last meta
> block we have written after log reclaim or point to the emtpy meta block
> after log recovery, just consider we write some meta block behind the
> superblock position and suppose crash happens. If the first meta block we
> have written neighboring the superblock position is invalid,  ctx.seq would 
> also equal to last_cp_seq+1 after we did a recovery . So the safest way is 
> we always write an empty meta block at ctx.pos no matter how much
> ctx.req is more than last_cp_seq after we did a recovery. 
> How do you think, Shaohua? If it is necessary, I'd revert this patch and
> resend one.

I didn't get the point. Could you please elaborate it again?

Thanks,
Shaohua

> 
> ------------------ Original ------------------
> From:  "Shaohua Li"<shli@kernel.org>;
> Date:  Tue, Oct 25, 2016 05:23 AM
> To:  "Zhengyuan Liu"<liuzhengyuan@kylinos.cn>;
> Cc:  "shli"<shli@fb.com>; "Song Liu"<songliubraving@fb.com>; "linux-raid"<linux-raid@vger.kernel.org>; "liuzhengyuang521"<liuzhengyuang521@gmail.com>;
> Subject:  Re: [PATCH] md/raid5: write an empty meta-block when creating logsuper-block
>  
> On Mon, Oct 24, 2016 at 04:15:59PM +0800, Zhengyuan Liu wrote:
> > If superblock points to an invalid meta block, r5l_load_log will set
> > create_super with true and create an new superblock, this runtime path
> > would always happen if we do no writing I/O to this array since it was
> > created. Writing an empty meta block could avoid this unnecessary
> > action at the first time we created log superblock.
> > 
> > Another reason is for the corretness of log recovery. Currently we have
> > bellow code to guarantee log revocery to be correct.
> > 
> >         if (ctx.seq > log->last_cp_seq + 1) {
> >                 int ret;
> > 
> >                 ret = r5l_log_write_empty_meta_block(log, ctx.pos, ctx.seq + 10);
> >                 if (ret)
> >                         return ret;
> >                 log->seq = ctx.seq + 11;
> >                 log->log_start = r5l_ring_add(log, ctx.pos, BLOCK_SECTORS);
> >                 r5l_write_super(log, ctx.pos);
> >         } else {
> >                 log->log_start = ctx.pos;
> >                 log->seq = ctx.seq;
> >         }
> > 
> > If we just created a array with a journal device, log->log_start and
> > log->last_checkpoint should all be 0, then we write three meta block
> > which are valid except mid one and supposed crash happened. The ctx.seq
> > would equal to log->last_cp_seq + 1 and log->log_start would be set to
> > position of mid invalid meta block after we did a recovery, this will
> > lead to problems which could be avoided with this patch.
> 
> This would be very unlikely, but better to fix. Applied, thanks!
