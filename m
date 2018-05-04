From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Introduce atomic_dec_and_lock_irqsave()
Date: Fri,  4 May 2018 17:45:28 +0200
Message-ID: <20180504154533.8833-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This series introduces atomic_dec_and_lock_irqsave() and converts a few
users to use it. They were using local_irq_save() +
atomic_dec_and_lock() before that series.

Sebastian
