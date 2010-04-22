From: Jordan Russell <jr-list-2010@quo.to>
Subject: raid1.c read_balance() LBD issue?
Date: Thu, 22 Apr 2010 13:21:13 -0500
Message-ID: <4BD09399.4090901@quo.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

raid1.c's read_balance() function has:

        const unsigned long this_sector = r1_bio->sector;

Doesn't that need to be:

        const sector_t this_sector = r1_bio->sector;

for compatibility with LBD on 32-bit platforms?

It looks as though truncating the sector number to 32 bits could cause
it to read *above* the resync window on an unsync'ed disk.

-- 
Jordan Russell
