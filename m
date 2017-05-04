From: "Ravi (Tom) Hale" <ravi@hale.ee>
Subject: Fault tolerance in RAID0 with badblocks
Date: Thu, 4 May 2017 17:04:34 +0700
Message-ID: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Since btrfs doesn't support badblocks, this btrfs mailing list post[1]
suggested to use mdadm RAID0 3.1+.

Is there a way of having blocks from a spare device automatically
replacing bad blocks when they are next written to (like SMART does for
HDDs)?

Or would mdadm be able to add a "badblocks layer" to btrfs in some other
way?

My use case is mining storj - I don't mind some data loss.

[1] https://www.spinics.net/lists/linux-btrfs/msg40909.html

-- 
Cheers,

Tom Hale
