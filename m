From: Daniel Brahneborg <daniel.com@wtnord.net>
Subject: More info regarding failed RAID over VIA
Date: Sun, 11 Jan 2004 14:34:17 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040111143417.F2945@nettis.grimsta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

With SATA disks connected to the chipset VIA237SATA, handled
by the generic IDE PCI driver, RAID0 and RAID1 work fine as
long as one waits for the sync to finish.  Even RAID1 over
RAID0 works fine.

However, RAID5 on the same partitions causes file corruption
every time.  I've tried both 2 and 4 partitions, with and
without the Device Mapper.

/Basic

