From: Chris Murphy <lists@colorremedies.com>
Subject: md raid behavior, bad sector uncorrectable read error
Date: Sat, 18 Aug 2012 16:40:56 -0600
Message-ID: <3E06D7FC-092A-4CB6-B79C-7EC94424DEEE@colorremedies.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm not experiencing this at the moment, but I'm curious about what happens if it were to happen.

A drive detects a sector error, but can't correct it, and returns an 0x40 error to the system.

Presumably md raid (any RAID I would think) becomes aware of this error, as the chunk is incomplete without the sector. Next, does md raid rebuild the affected chunk from parity on-the-fly? Or is the entire drive dropped from the array and placed into degraded mode?

If the affected chunk is rebuilt from parity (or copy in case of mirror), does md raid issue a write command to write the rebuilt chunk back to the disk at the same LBAs? If so, shouldn't this force the drive to determine if the sector error is transient or persistent, and if persistent the disk firmware will remap the bad sector to a reserve sector?

Thanks,

Chris Murphy


