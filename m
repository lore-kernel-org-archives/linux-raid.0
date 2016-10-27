From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid5: write an empty meta-block when
 creatinglogsuper-block
Date: Thu, 27 Oct 2016 15:21:45 -0700
Message-ID: <20161027222145.h6wwtls6a5qynb7u@kernel.org>
References: <tencent_647E309D0106DEBE08875B26@qq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <tencent_647E309D0106DEBE08875B26@qq.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Cc: Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>, liuzhengyuang521 <liuzhengyuang521@gmail.com>
List-Id: linux-raid.ids

On Thu, Oct 27, 2016 at 10:05:06PM +0800, Zhengyuan Liu wrote:
> Sorry for the unclear expression.
> 
> The log might look like this before we did a recovery :
> | mb1 | mb2 | mb3  |           |            |           | 
>  last_checkpoint = mb1'postion,    last_cp_seq = mb1'seq
> After we did a recovery(we would write a empty meta block emb at log tail):
> | mb1 | mb2 | mb3 |  emb |            |           | 
> last_checkpoint = emb'position,  last_cp_seq = mb1'seq + 11
> Then we write two meta blocks and suppose crash happens:
> | mb1 | mb2 | mb3 |  emb |  mb4 | mb5 | 
> last_checkpoint = emb'position,  last_cp_seq = mb1'seq + 11
> Now we did another recovery after restart and suppose mb4 was invalid: 
> | mb1 | mb2 | mb3 |  emb |  mb4 | mb5 | 
> last_checkpoint = emb'position,  last_cp_seq = mb1'seq + 11
> Since mb4 was invalid, we would stop recovering mb5 which should be discarded.
> After recovery, log_start points to mb4 and we wouldn't write a empty meta block
> because condition "ctx.seq > log->last_cp_seq + 1" doesn't satisfy. If we are going to
> write a valid meta block and crash happens again, the new meta block will fall into
> position of mb4 and recovery process may do a recovery to mb5 since it's seq
> is matched.
> 
> What I try to say is that if the first meta block ,not only the mid one, we written was
> invalid, the log recovery could bring problem here too . I think the condition for 
> write a empty meta block should like this:
>     - if (ctx.seq > log->last_cp_seq + 1) {
>     + if (ctx.seq > log->last_cp_seq） {

Get it, thanks! That's correct, as long as we recover one block, we should
rewirte the empty meta block. I'll queue a patch for this.

Thanks,
Shaohua

