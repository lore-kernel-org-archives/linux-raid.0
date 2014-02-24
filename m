From: Denis Golovan <denis.golovan@gmail.com>
Subject: RAID5 hard freeze
Date: Tue, 25 Feb 2014 00:01:42 +0200
Message-ID: <CAF8Fvyz2PnEd=t=E-xUuG6anoLhm1zJCn0txD=P_aE_5AmoVUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

I am struggling to diagnose a strange freeze of software RAID5 array.
My RAID5 consists of 4 Toshiba SATA drives and has ext4 filesystem on top of it.

It works fine unless I start several process writing intensively to it.
At first, it looks like the system is under high pressure, then the
system starts lagging a lot and a hard freeze always follows after
several minutes.

No errors in system log, nothing is emitted to console. Just hard
freeze with HDD light always on. I tried enabling kernel network
logging to another machine and again no information when hanging.
After reboot, my array starts reconstruction and finishes without
errors.

I tried disabling quotas and barriers for ext4.
After disabling barriers, it almost seemed to work, but after some
time the same hard freeze happens.

I tested the same hardware configuration under Linux v3.10, 3.11, 3.12
and now 3.13.5 (all x86 arch) behaves the same way. The same issue can
be reproduced easily.

So now I tested everything Google suggests on the matter.
Could you give a hint on how to debug this issue?

BR,
Denis
