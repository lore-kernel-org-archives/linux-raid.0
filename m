From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Reliability of bitmapped resync
Date: Mon, 23 Feb 2009 20:40:19 +0100
Message-ID: <20090223194019.GA3488@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I've a strange issue.

I've a PC with 2 HDs in RAID-10 f2 with bitmap.
There are actually 3 md devices, boot, swap and root.

It happens that one SATA cable is/was flaky, so sometimes,
at boot, /dev/sdb does not show up.
The RAID starts in degraded mode, tracking the writes
in the bitmap.
On the next reboot, /dev/sdb is again there, so it is
possible to re-add it.
The md device resyncs what is to be resynced, very
quickly, due to the bitmap.

Later, if I run a check, usually a lot of mismatches
show up.

After repair (or add) further checks return zero mismatches.
Without boot failure, no mismatches showed up after check.

On a different PC, with same setup, but good cables,
something similar happened.

I tried, just for testing, to fail-remove-writeSomething-reAdd
one HD, a then run a check.
This was also returned some (few) mismatches.
Now, this test I did not repeat, so I cannot say this was
always the case.

Nevertheless I'm a bit concerned.

Is this behaviour somehow expected?
Is there something special to take into account when
removing and re-adding a RAID component?

Thanks a lot in advance,

bye,

-- 

piergiorgio
