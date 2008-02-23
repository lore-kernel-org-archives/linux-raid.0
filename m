From: "Joe Landman" <joe.landman@gmail.com>
Subject: Odd performance observation for RAID0
Date: Sat, 23 Feb 2008 00:21:18 -0500
Message-ID: <9f5edc120802222121p771db02exff4e3751b088fcad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi folks:

  I built a RAID0 stripe across two large hardware RAID cards
(identical cards/driver).  What I am finding is that direct IO is
about the performance I expect (2x the single RAID card) while
buffered IO is about the same as the performance of a single RAID
card.  This is true across chunk sizes of 64 through 4096k, with an
xfs file system.

 This is a 2.6.23.14 kernel.  I tried 2.6.24.2, and there the direct
IO was the same speed as the buffered IO on one RAID card, even though
the RAID0 striped across 2 RAID cards.

  There appears to be some issue with this combination of RAID0,
buffer cache, and the driver. Breaking the raid in 2, and performing
the same tests on each RAID card results in the expected performance
during buffered io and direct IO.

  Is there something I can do to tune how the raid0 driver deals with
buffer cache?  Standard vm-tweaking yields modest changes, but I am
not convinced the issue is there.  It looks like the raid0 driver is
serializing something in buffer cache access.  Does this make sense?
For small drives and SATA drivers, I see the "expected" RAID0
behavior.  Is it possible that with very large or very fast devices
that there is some sort of buffer serialization?

  Clues and guidance are requested.  Thanks!

Joe
