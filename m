From: Michael Robinton <michael@bizsystems.com>
Subject: RAID-1 md comes up degraded every time
Date: Sat, 8 Jun 2002 10:37:42 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0206081035540.23582-100000@pandora.is.bizsystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


the one time this happened to me, I'd forgotten to marke the partition as
"FD"

Michael

I created a RAID-1 volume on Linux 2.4.18 by creating the volume in
degraded
mode, then hot-adding the second disk.  It syncs up fine, but every time I
reboot, it comes back in degraded mode.  Can someone help me figure out
what
I'm doing wrong?


