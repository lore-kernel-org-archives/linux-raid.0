From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 0/6] use irqsafe variant of refcount_dec_and_lock() / atomic_dec_and_lock()
Date: Tue,  3 Jul 2018 22:01:35 +0200
Message-ID: <20180703200141.28415-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The irqsave variant of refcount_dec_and_lock() and atomic_dec_and_lock()
made it into v4.18-rc2. This is just a repost of the users so that they
can be routed through the individual subsystems.
=20
Sebastian
=20
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
