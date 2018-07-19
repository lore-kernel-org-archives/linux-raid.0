From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 1/6] drivers/md/raid5: Use irqsave variant of
 atomic_dec_and_lock()
Date: Thu, 19 Jul 2018 09:35:48 +0200
Message-ID: <20180719073548.r5n7is4svcsnu3ro@linutronix.de>
References: <20180703200141.28415-1-bigeasy@linutronix.de>
 <20180703200141.28415-2-bigeasy@linutronix.de>
 <20180716122740.q7oim7te5bybcniz@linutronix.de>
 <20180717003727.GA128433@kernel.org>
 <20180718105721.rcd6l7s6l4yfbahg@linutronix.de>
 <20180719024405.GA99813@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180719024405.GA99813@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Anna-Maria Gleixner <anna-maria@linutronix.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2018-07-18 19:44:05 [-0700], Shaohua Li wrote:
> Since you sent a series, I suppose you want someone else to take it. But I can
> take it for sure, will do soon.

I'm sorry for the miss understanding. I tried to explain this in the
cover letter. The prerequisites are already merged so then the actual
changes can be merged via the individual maintainer.
Thank you Shaohua.

> Thanks,
> Shaohua

Sebastian
