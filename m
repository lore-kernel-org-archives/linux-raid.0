From: John Rowe <rowe@excc.ex.ac.uk>
Subject: Two RAID6 questions
Date: Fri, 20 Jan 2006 13:11:44 +0000
Message-ID: <1137762704.20659.51.camel@kenny>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(Before I start, thanks to everybody who replied to my previous
questions.)

First, can raidreconf grow a RAID6 device? The man page doesn't seem to
mention RAID6 at all.

Second, with RAID5 or RAID6 my biggest fear is a system crash whilst the
RAID is writing resulting in dirty blocks. Does RAID6 give some sort of
ECC capability when reconstructing? I'm imagining checking the parity of
a RAID block and if it's wrong assuming each block in turn is dirty,
recalculating it from the first parity and then checking the result
against the second parity.

Thanks

John




