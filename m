From: "bmoon" <bo@anthologysolutions.com>
Subject: Deadlock on mkfs while resyncing the raid1 device
Date: Wed, 22 Jan 2003 18:26:53 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000b01c2c286$e4a574d0$6a01a8c0@bmoon>
References: <Pine.LNX.4.44.0301221900450.11300-100000@pcmy.sei.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Raiders!

This is special for ARM linux with Debian package.
I tried with linux2418 on pc without any problem.

I am running linux2.4.18 with debian2.0 on ARM based system.
The system will be hang if I try to run "mkfs" on the md device which
is now resyncing on reboot after crash.

Does the SMP compile option make any difference on this problem?

Here are some clues and symptoms from my test on this hang case;

From " raid1_sync_request" in raid1.c,

It hangs while it is looping in " while (sector_nr >= conf->start_pending)".

If it has 0 on conf->cnt_pending it should be OK. However, it is non-zero
on conf->cnt_pending when we do "mkfs" while it is resyncing.

Do you have any idea to solve or to work around this problem?

Are there anyone who tried the ARM linux with SMP option? How?


THanks in advance,

BO

