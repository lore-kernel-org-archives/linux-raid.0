From: Chris Webb <chris@arachsys.com>
Subject: Re: harmful parallel AoE check/resync
Date: Mon, 6 Apr 2009 17:39:18 +0100
Message-ID: <20090406163918.GC17707@arachsys.com>
References: <87ljqdvopc.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87ljqdvopc.fsf@tac.ki.iif.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ferenc Wagner <wferi@niif.hu> writes:

> md_do_sync() in md.c takes care not to resync/check MD devices built
> on different parts of the same physical device in parallel.  This does
> not account for AoE devices, which, however, most of the time share
> and are limited by network bandwidth.

...and may also share underlying backing devices at the far end.

I run a cluster with a lot of cross-access of storage via AoE, combined
using md. In fact, every RAID device on every host shares physical devices
behind AoE, so I crack this particular nut locally with the following
sledge-hammer:

diff --git a/drivers/md/md.c b/drivers/md/md.c
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5744,8 +5744,7 @@
 			if (mddev2 == mddev)
 				continue;
 			if (!mddev->parallel_resync
-			&&  mddev2->curr_resync
-			&&  match_mddev_units(mddev, mddev2)) {
+			&&  mddev2->curr_resync) {
 				DEFINE_WAIT(wq);
 				if (mddev < mddev2 && mddev->curr_resync == 2) {
 					/* arbitrarily yield */

This clearly isn't the right solution more generally, though, and it'd be
great to have a more elegant way of defining which backing devices conflict
with one another, and which are independent.

Cheers,

Chris.
