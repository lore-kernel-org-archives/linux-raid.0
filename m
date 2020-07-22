From: Song Liu <song@kernel.org>
Subject: Re: [PATCH v4 19/24] raid5: Use sequence counter with associated spinlock
Date: Tue, 21 Jul 2020 23:40:16 -0700
Message-ID: <CAPhsuW7Cd1FyV7SgH5AtCEYHREOeG75nFqeZKNObPt3bA12Ygg@mail.gmail.com>
References: <20200519214547.352050-1-a.darwish@linutronix.de>
 <20200720155530.1173732-1-a.darwish@linutronix.de> <20200720155530.1173732-20-a.darwish@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200720155530.1173732-20-a.darwish@linutronix.de>
Sender: linux-raid-owner@vger.kernel.org
To: "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@kernel.org>, "Sebastian A. Siewior" <bigeasy@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jul 20, 2020 at 8:57 AM Ahmed S. Darwish
<a.darwish@linutronix.de> wrote:
>
> A sequence counter write side critical section must be protected by some
> form of locking to serialize writers. A plain seqcount_t does not
> contain the information of which lock must be held when entering a write
> side critical section.
>
> Use the new seqcount_spinlock_t data type, which allows to associate a
> spinlock with the sequence counter. This enables lockdep to verify that
> the spinlock used for writer serialization is held when the write side
> critical section is entered.
>
> If lockdep is disabled this lock association is compiled out and has
> neither storage size nor runtime overhead.
>
> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>

Acked-by: Song Liu <song@kernel.org>
