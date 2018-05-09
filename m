From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v2 0/8] Introduce refcount_dec_and_lock_irqsave()
Date: Wed,  9 May 2018 21:36:37 +0200
Message-ID: <20180509193645.830-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Anna-Maria Gleixner <anna-maria@linutronix.de>
List-Id: linux-raid.ids

This series is a v2 of the atomic_dec_and_lock_irqsave(). Now refcount_*
is used instead of atomic_* as suggested by Peter Zijlstra.

Patch
- 1-3 converts the user from atomic_* API to refcount_* API
- 4 implements refcount_dec_and_lock_irqsave
- 5-8 converts the local_irq_save() + refcount_dec_and_lock() users to
  refcount_dec_and_lock_irqsave()

The whole series sits also at
  git://git.kernel.org/pub/scm/linux/kernel/git/bigeasy/staging.git refcoun=
t_t_irqsave

Sebastian
