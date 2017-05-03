From: Shaohua Li <shli@kernel.org>
Subject: RAID creation resync behaviors
Date: Wed, 3 May 2017 13:27:48 -0700
Message-ID: <20170503202748.7r243wj5h4polt6y@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, neilb@suse.de
List-Id: linux-raid.ids

Hi,

Currently we have different resync behaviors in array creation.

- raid1: copy data from disk 0 to disk 1 (overwrite)
- raid10: read both disks, compare and write if there is difference (compare-write)
- raid4/5: read first n-1 disks, calculate parity and then write parity to the last disk (overwrite)
- raid6: read all disks, calculate parity and compare, and write if there is difference (compare-write)

Write whole disk is very unfriendly for SSD, because it reduces lifetime. And
if user already does a trim before creation, the unncessary write could make
SSD slower in the future. Could we prefer compare-write to overwrite if mdadm
detects the disks are SSD? Surely sometimes compare-write is slower than
overwrite, so maybe add new option in mdadm. An option to let mdadm trim SSD
before creation sounds reasonable too.

Thanks,
Shaohua
