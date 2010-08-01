From: wiebittewas <wiebittewas@googlemail.com>
Subject: failed to re-assemble after cable-problem...
Date: Sun, 01 Aug 2010 18:28:24 +0000
Message-ID: <4C55BCC8.1060604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


well, ext4 fails with IO-errors, so I checked the disks of the raid
and found, that's something wrong with the cables...


after an exchange of cables I tried a "mdadm --assemble --force",
but result was that the missing devices are only added as
spare-drives, not as active ones.

well maybe, there are errors in filesystem, but the raid should be
ok, so how can I change the disk from spare to active?

maybe setting the right info directly in superblock of the disk?

any help would be appreciated

wiebittewas
