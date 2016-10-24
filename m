From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid5: write an empty meta-block when creating log
 super-block
Date: Mon, 24 Oct 2016 14:23:45 -0700
Message-ID: <20161024212345.dehpl26uweujlmsl@kernel.org>
References: <1477296959-20123-1-git-send-email-liuzhengyuan@kylinos.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1477296959-20123-1-git-send-email-liuzhengyuan@kylinos.cn>
Sender: linux-raid-owner@vger.kernel.org
To: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Cc: shli@fb.com, songliubraving@fb.com, linux-raid@vger.kernel.org, liuzhengyuang521@gmail.com
List-Id: linux-raid.ids

On Mon, Oct 24, 2016 at 04:15:59PM +0800, Zhengyuan Liu wrote:
> If superblock points to an invalid meta block, r5l_load_log will set
> create_super with true and create an new superblock, this runtime path
> would always happen if we do no writing I/O to this array since it was
> created. Writing an empty meta block could avoid this unnecessary
> action at the first time we created log superblock.
> 
> Another reason is for the corretness of log recovery. Currently we have
> bellow code to guarantee log revocery to be correct.
> 
>         if (ctx.seq > log->last_cp_seq + 1) {
>                 int ret;
> 
>                 ret = r5l_log_write_empty_meta_block(log, ctx.pos, ctx.seq + 10);
>                 if (ret)
>                         return ret;
>                 log->seq = ctx.seq + 11;
>                 log->log_start = r5l_ring_add(log, ctx.pos, BLOCK_SECTORS);
>                 r5l_write_super(log, ctx.pos);
>         } else {
>                 log->log_start = ctx.pos;
>                 log->seq = ctx.seq;
>         }
> 
> If we just created a array with a journal device, log->log_start and
> log->last_checkpoint should all be 0, then we write three meta block
> which are valid except mid one and supposed crash happened. The ctx.seq
> would equal to log->last_cp_seq + 1 and log->log_start would be set to
> position of mid invalid meta block after we did a recovery, this will
> lead to problems which could be avoided with this patch.

This would be very unlikely, but better to fix. Applied, thanks!
