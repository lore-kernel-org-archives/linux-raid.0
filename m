From: wiebittewas <wiebittewas@googlemail.com>
Subject: seagate-"archive"-disks with raid6?
Date: Sat, 13 Jun 2015 17:58:40 +0200
Message-ID: <557C5330.1090605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi.

for a larger archive, we're thinking about buying six 8TB-Archive-Disks from Seagate to build a 4+2 Raid6-Array.

now we've seen, that these disks are told not-recommended for raid, because they lack ERC/TLER (like many desktop-disks)

unfortunately we didn't found any real actual information about behaviour of linux-raid with such disks.

so our first questions is, if anyone here already has disks (without ERC/TLER) with linux-raid running and can say something about?


other item is, - as we understand - ERC leads to a limited timeout on read-errors, so the wanted data of that read-access may recovered by the redundant data and marks that disk for soon replace (or a sync to an existant spare is started).

but this is also done, if that disk does not timeout and will be dropped by the controller, or is this wrong?

so the only benefit seems to be, that with ERC the disk is not dropped immediately, so errors on two further disks won't lead to a data-loss before sync (as long the additional errors are not corresponding raid-sectors)

but: how likely is it, that three disks have permamnent errors during the sync? (we already had two disks in the past, but never three at a time...)

how is your experience with multiple disk-errors?

regards

w.
