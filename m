From: John Lange <john.lange@bighostbox.com>
Subject: Raid 1 vs 5 ?
Date: Thu, 06 May 2004 15:51:44 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1083876704.26703.188.camel@ws101.darkcore.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have 4 identical Serial ATA drives.

I'm thinking that I'll use drives hda and hdb as a RAID 1 set and drive
hdc as a spare with hdd used for swap and archive storage.

Another option would be to use hda, hdb, and hdc as RAID 5 with hdd as
swap and archive.

Which one is the better choice and what are the trade offs? Or is
another configuration more sensible? I'm under the impression that you
shouldn't (can't?) boot from RAID 5.

Thanks.
-- 
John Lange

