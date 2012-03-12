From: Shaohua Li <shli@fusionio.com>
Subject: [patch 0/7] Add TRIM support for raid linear/0/1/10
Date: Mon, 12 Mar 2012 11:04:12 +0800
Message-ID: <20120312030412.375458948@fusionio.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk
List-Id: linux-raid.ids

The patches add TRIM support for raid linear/0/1/10. I'll add TRIM support for
raid 4/5/6 later. The implementation is pretty straightforward and
self-explained.

Thanks,
Shaohua
