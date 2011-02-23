From: Lasse Jensen <fafler@gmail.com>
Subject: Assembling RAID 5 array with missing superblock
Date: Wed, 23 Feb 2011 15:05:32 +0100
Message-ID: <AANLkTinfMUaLOVHBh0ZXFmHs353u==XkbGYtM8MPNkh8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just keep having bad luck with my RAID 5 array. One drive (out of 4
WD15EARS drives) was dropped from the array due to powerfailure and
rebuild failed because of bad sectors on another drive. I have been
spending the last few days with ddrescue, copying the data from the
drive with bad sectors to the dropped one. The problem is now that the
drive has bad sectors have spread where the md superblock used to be
on the faulty drive (the very last sectors of the drive, right?), so
how do i force it to assemble without it and with one drive missing?

What drives are by the way the best consumer grade drives to use for
RAID operation?

I really, really hope this is the last time i need to ask you guys for help.

-- 
Lasse Jensen (fafler at gmail dot com)
