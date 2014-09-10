From: shli@kernel.org
Subject: [patch v2 0/6] raid5: automatically batch adjacent full stripe write
Date: Wed, 10 Sep 2014 20:40:09 +0800
Message-ID: <20140910124009.810771309@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is the 2nd attempt to make adjacent full stripe write together. The main
change against v1 is how to detect if stripes can be batched. Also some bugs
are fixed.

Thanks,
Shaohua
