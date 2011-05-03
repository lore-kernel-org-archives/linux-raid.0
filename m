From: "Morad, Steve" <morad@amazon.com>
Subject: Mirrored volume peformance questions
Date: Tue, 3 May 2011 12:42:04 -0700
Message-ID: <96B30EF4F3E17749BCFF7F1816090EDA02DCE41A87@EX-SEA31-B.ant.amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a few questions about volume mirroring performance implications.

1. I'm looking for an optimal configuration to maximize read speed while protecting the data from a disk failure (e.g. for an application that primarily does reads).  For RAID 1, does the linux raid driver perform parallel read requests across all available disks?  If, for example, I set up a RAID 1 volume with 4 disks, would the OS handle concurrently reading (different) data from all 4 disks at the same time?

2. Similarly, would a RAID10 configuration give me the same (or better) read behavior across these same disks, while providing twice the storage capacity of the above configuration?

3. Is the raid driver smart enough to keep track of underlying volume performance history or queue lengths and make read requests appropriately? For example, if for some crazy reason a 10K disk was mirrored with a 7K disk, would the OS make more read requests to the 10K disk than to the 7K disk, or would read requests be equally distributed across both disks?

