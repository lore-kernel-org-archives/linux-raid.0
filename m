From: Dag Nygren <dag@newtech.fi>
Subject: RAID 1 not fixing up sector errors?
Date: Thu, 14 Apr 2016 16:03:59 +0300
Message-ID: <29813347.d6oRyCVBGp@dag.newtech.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

Have set up a RAID1 here for temporary storage of some backup files.
As I am using Seagate barracudas I am prepared for sector errors :-).
that's why I am using RAID1.

Anyway I do get those occasional "Pending Reallocate" with
the appropriate corresponding
Unrecovered read error - auto reallocate failed
in the log.

A resync of the array will rewrite the failing sector 
and the drive seems to reallocate it and all is fine again .

But I was expecting the MD layer to try to fixup that sector
automatically by using the data from the other drive ??

Is there something I need to explicitly enable?
Or am I expecting too much ;-)

Best
Dag


