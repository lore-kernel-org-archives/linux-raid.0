From: Shaohua Li <shli@fusionio.com>
Subject: [patch v2 0/6] Add TRIM support for raid linear/0/1/10
Date: Fri, 16 Mar 2012 15:32:13 +0800
Message-ID: <20120316073213.656519005@fusionio.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, vgoyal@redhat.com, martin.petersen@oracle.com
List-Id: linux-raid.ids

The patches add TRIM support for raid linear/0/1/10. I'll add TRIM support for
raid 4/5/6 later. The implementation is pretty straightforward and
self-explained.

v1->v2:
1. fixed a checking issue
2. dropped discard request plug and replace it with no discard merege, because
current SCSI layer can't handle discard request merge.

Thanks,
Shaohua
