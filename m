From: Shaohua Li <shli@kernel.org>
Subject: [patch 0/4] Optimize raid1 read balance for SSD
Date: Tue, 08 May 2012 18:08:53 +0800
Message-ID: <20120508100853.412193855@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk
List-Id: linux-raid.ids

raid1 read balance is an important algorithm to make read performance optimal.
It's a distance based algorithm, eg, for each request dispatch, choose disk
whose last finished request is close the request. This is great for hard disk.
But SSD has some special characteristics:

1. nonrotational. Distance means nothing for SSD, though merging small rquests
to big request is still optimal for SSD. If no merge, distributing rquests to
raid disks as more as possible is more optimal.

2. Getting too big request isn't always optimal. For hard disk, compared to
spindle move, data transfer overhead is trival, so we always prefer bigger
request. In SSD, request size exceeds specific value, performance isn't always
increased with request size increased.  An example is readahead. If readahead
merges too big request and causes some disks idle, the performance is less
optimal than that when all disks are busy and running small requests.

The patches try to address the issues. The first two patches are clean up. The
third patch addresses the first item above. The forth addresses the second item
above. The idea can be applied to raid10 too, which is in my todo list.
