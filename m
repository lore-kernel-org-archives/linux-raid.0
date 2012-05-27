From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Hi! Strange issue with LSR -- bitmaps hadn't been used during 2 of 3
 RAIDs resync
Date: Sun, 27 May 2012 19:32:40 +0800
Message-ID: <CA+sTkh74rDvV05pjhVAD5wa4fxXsZE5MLN4y4fMd=Js7_BoTDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

   A power outage has happened to system (which was in "suspend"
state) with RAID-10, RAID-5 and RAID-6. Later on boot, RAID-10 was
fast re-synced using bitmap, but both RAID-5 and RAID-6 were in
auto-readonly mode with resync=DELAYED. When they flipped to
Read-Write, LSR started re-syncing not using bitmaps seemingly. A bug?

   Occurred once on Linux 3.2.12, x86_64.

--
