From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 1/6] drivers/md/raid5: Use irqsave variant of
 atomic_dec_and_lock()
Date: Wed, 18 Jul 2018 12:57:21 +0200
Message-ID: <20180718105721.rcd6l7s6l4yfbahg@linutronix.de>
References: <20180703200141.28415-1-bigeasy@linutronix.de>
 <20180703200141.28415-2-bigeasy@linutronix.de>
 <20180716122740.q7oim7te5bybcniz@linutronix.de>
 <20180717003727.GA128433@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180717003727.GA128433@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Anna-Maria Gleixner <anna-maria@linutronix.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2018-07-16 17:37:27 [-0700], Shaohua Li wrote:
> On Mon, Jul 16, 2018 at 02:27:40PM +0200, Sebastian Andrzej Siewior wrote:
> > On 2018-07-03 22:01:36 [+0200], To linux-kernel@vger.kernel.org wrote:
> > > From: Anna-Maria Gleixner <anna-maria@linutronix.de>
> > > 
> > > The irqsave variant of atomic_dec_and_lock handles irqsave/restore when
> > > taking/releasing the spin lock. With this variant the call of
> > > local_irq_save is no longer required.
> > 
> > Shaohua, are you with this?
> 
> Acked-by: Shaohua Li <shli@kernel.org> 

Thank you. 
Is there a reason why you did not apply it or are you too busy now and
do it later (and just signal the ack that you are fine with it)?

Sebastian
