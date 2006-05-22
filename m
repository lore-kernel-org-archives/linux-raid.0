From: Alex Tomas <alex@clusterfs.com>
Subject: spin_lock_irq() in handle_stripe()
Date: Mon, 22 May 2006 18:05:38 +0400
Message-ID: <m33bf2f93h.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, alex@clusterfs.com
List-Id: linux-raid.ids



Good day Neil, all

if I understand right, we disable irqs in handle_stripe()
just because of using device_lock which can be grabbed
from interrupt context (_end_io functions). can we replace
it by a new separate spinlock and don't block interrupts
in handle_stripe() + add_stripe_bio() ?

thanks, Alex
