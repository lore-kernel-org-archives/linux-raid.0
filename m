From: Tzung Liu <tzungl@yahoo.com>
Subject: Cache block size in RAID5 stripe cache
Date: Wed, 19 Jan 2005 17:07:31 -0800 (PST)
Message-ID: <20050120010732.62053.qmail@web80507.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Currently (in 2.6.x), the RAID5 stripe cache has a cache
unit size of PAGE_SIZE (4KB for x86, as STRIPE_SIZE is
defined in md/raid5.c).

For 2.4.x, due to buffer_head restriction of one vector per
header, this is a reasonable restriction.  For 2.6.x with
bio capable of multiple vectors, we might consider
increasing STRIPE_SIZE for performance reasons.

Is there any work or patch available in this area?

Thanks.

Tzung.
