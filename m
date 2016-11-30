From: JackieLiu <liuyun01@kylinos.cn>
Subject: Re: [PATCH 4/4] md/raid5-cache: adjust the write position of the
 empty block and mark it as a checkpoint
Date: Wed, 30 Nov 2016 12:03:14 +0800
Message-ID: <256217AC-28C5-4C52-ABDB-9C36221E6A1B@kylinos.cn>
References: <20161128081921.5641-1-liuyun01@kylinos.cn>
 <20161128081921.5641-4-liuyun01@kylinos.cn>
 <20161129223150.tseez7b4y6lb72fs@kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3256\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161129223150.tseez7b4y6lb72fs@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: songliubraving@fb.com, =?gb2312?B?wfXV/dSq?= <liuzhengyuan@kylinos.cn>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> 在 2016年11月30日，06:31，Shaohua Li <shli@kernel.org> 写道：
> 
> On Mon, Nov 28, 2016 at 04:19:21PM +0800, JackieLiu wrote:
>> When recovery is complete, we write an empty block and record his
>> position first, then make the data-only stripes rewritten done,
>> the location of the empty block as the last checkpoint position
>> to write into the super block. And we should update last_checkpoint
>> to this empty block position.
>> ...
>> +	pos = ctx.pos;
>> +	r5l_log_write_empty_meta_block(log, ctx.pos, (ctx.seq += 10));
> 
> hmm, move the ctx.seq += 10 out please

yep, if this patch is OK,I will resend an appropriate patch.

>> +	ctx.pos = r5l_ring_add(log, ctx.pos, BLOCK_SECTORS);
>> +
>> 	if ((ctx.data_only_stripes == 0) && (ctx.data_parity_stripes == 0))
>> 		pr_debug("md/raid:%s: starting from clean shutdown\n",
>> 			 mdname(mddev));
>> @@ -2167,9 +2171,9 @@ static int r5l_recovery_log(struct r5l_log *log)
>> 
>> 	log->log_start = ctx.pos;
>> 	log->next_checkpoint = ctx.pos;
>> +	log->last_checkpoint = pos;
>> 	log->seq = ctx.seq;
>> -	r5l_log_write_empty_meta_block(log, ctx.pos, ctx.seq);
>> -	r5l_write_super(log, ctx.pos);
>> +	r5l_write_super(log, pos);
>> 	return 0;
>> }
> 
> Applied the first 3 patches in the series. This one looks good too, but why we
> always create the empty meta block? It's only required when we don't rewrite
> the data. Eg, the data_only_stripes == 0.
> 
> Thanks,
> Shaohua

As you said, when data_only_stripes != 0, does not need to write an empty 
meta block, but we need to calculate the position of the first list member and
save it.  at the same time, when data_only_stripes == 0, then you need to write
an empty block, and let the super block pointing to him; In any case, Since 
there is a possibility that invalid blocks are connected to valid blocks, we still 
need to add 10 to them.

In my option, if this empty block has been added, we just let the super block 
pointing to him, everything is OK now, the code is more clean, and the logic 
is clear.

Thanks
Jackie




