From: Shaohua Li <shli@kernel.org>
Subject: [patch 0/3 v3] Optimize raid1 read balance for SSD
Date: Mon, 02 Jul 2012 09:08:40 +0800
Message-ID: <20120702010840.197370335@kernel.org>
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

The patches try to address the issues.

V3:
makes the algorithm for the first issue work for hard disk and SSD mixed raid
as suggested by Neil. The algorithm for the second issue only applies to SSD,
because in my test it degrades performance for hard disk raid or hard disk/SSD
mixed raid.

V1->V2:
rebase to latest kernel.

Thanks,
Shaohua
