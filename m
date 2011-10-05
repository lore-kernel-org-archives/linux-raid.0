From: Jim Schatzman <james.schatzman@futurelabusa.com>
Subject: Appropriate kernel group for IDE/ATA/SAS/SATA issues?
Date: Tue, 04 Oct 2011 22:25:26 -0600
Message-ID: <20111005042534.29590581FAC@mail.futurelabusa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Group-

Sorry for a slightly off-topic question. I have built a number of systems recently with an unraided SSD system drive and data on software SATA RAID. Unfortunately, I have noticed that the currently Linux IDE/ATA/SAS/SATA  drivers don't seem to handle SSD drives well. What is  worse, once the kernel starts "detecting" errors with the SSD, it starts making bad adjustments to the SATA RAID devices, such as changing link speeds of RAID devices, even when the RAID devices and SSD are on completely separate controllers. Also, the kernel appears to get confused sometimes and decide that, say ata9 is having problems when it is actually ata3 (after properly accounting for the kernel's multiple different ways of numbering the same devices).

Although the problem impacts my software RAIDs, it does not appear to be a RAID problem. Which is the right kernel news group to corresponding with about this kind of issue?

Thanks-

Jim
 

