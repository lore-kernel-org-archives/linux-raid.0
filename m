From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 000 of 2] Introduction
Date: Tue, 15 Nov 2005 12:56:31 +1100
Message-ID: <20051115125442.9317.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Following are two patches for md in 2.6.14-mm2 that are suitable to go
into the 2.6.15-rc series.

The first adds a date to the deprecation of START_ARRAY ioctl.

The second fixes a recently introduced problem that causes md threads
to permanently add to the load average (other than that, every works
fine).

 [PATCH md 001 of 2] Mark START_ARRAY deprecated with a date.
 [PATCH md 002 of 2] Make md threads interruptible again.
