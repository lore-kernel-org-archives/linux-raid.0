From: "Niclas Arndt" <niclas@arndt.se>
Subject: Add missing and grow at the same time
Date: Fri, 26 Apr 2013 23:02:44 +0200
Message-ID: <0d409f65e1a04b22b2b776c9929169e0.squirrel@mail.arndt.se>
Reply-To: niclas@arndt.se
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a "3-drive" RAID5 that was created in degraded mode with 2 drives.
I now want to both add the missing drive and grow the array to 4 drives.

Is it possible to do this in one step or must I first add the missing
drive (rebuild) and then add + grow with the 4th drive?

Thanks in advance.

Kind regards

Niclas
