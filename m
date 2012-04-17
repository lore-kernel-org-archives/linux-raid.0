From: Shaohua Li <shli@kernel.org>
Subject: [RFC 0/2] raid5 trim support
Date: Tue, 17 Apr 2012 16:35:52 +0800
Message-ID: <20120417083552.483324288@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, dan.j.williams@intel.com, axboe@kernel.dk
List-Id: linux-raid.ids

These are the raid5 trim support patches I'm working on. There are some
limitations to support raid5 trim. I explained the details in the first patch.
The raid5 state machine is quite complicated and I'm sure I missed something,
so it's a RFC so far. And the raid5 trim suffers from the same discard request
merge issue as raid0/10. If you try these in a SSD, please ignore the warning
from block layer. But anyway, my raid4/5/6 tests work well with a fusionio
card.  Comments and suggestions are welcome!

Thanks,
Shaohua
