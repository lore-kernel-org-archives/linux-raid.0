From: Nix <nix@esperi.org.uk>
Subject: A sector-of-mismatch warning patch (was Re: Fault tolerance with badblocks)
Date: Tue, 09 May 2017 22:06:36 +0100
Message-ID: <87bmr14u5f.fsf_-_@esperi.org.uk>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
        <590B3039.3060000@youngman.org.uk>
        <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
        <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
        <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
        <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
        <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
        <87vapb6s9h.fsf@esperi.org.uk>
        <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>
        <87inla73vz.fsf@esperi.org.uk> <5911A371.3030008@hesbynett.no>
        <878tm65kyx.fsf@esperi.org.uk> <5911AED4.9030007@hesbynett.no>
        <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com>
        (Chris Murphy's message of "Tue, 9 May 2017 11:25:30 -0600")
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: David Brown <david.brown@hesbynett.no>, Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 9 May 2017, Chris Murphy verbalised:

> 1. md reports all data drives and the LBAs for the affected stripe

Enough rambling from me. Here's a hilariously untested patch against
4.11 (as in I haven't even booted with it: my systems are kind of in
flux right now as I migrate to the md-based server that got me all
concerned about this). It compiles! And it's definitely safer than
trying a repair, and makes it possible to recover from a real mismatch
without losing all your hair in the process, or determine that a
mismatch is spurious or irrelevant. And that's enough for me, frankly.
This is a very rare problem, one hopes.

(It's probably not ideal, because the error is just known to be
somewhere in that stripe, not on that sector, which makes determining
the affected data somewhat harder. But at least you can figure out what
filesystem it's on. :) )

8<------------------------------------------------------------->8
From: Nick Alcock <nick.alcock@oracle.com>
Subject: [PATCH] md: report sector of stripes with check mismatches

This makes it possible, with appropriate filesystem support, for a
sysadmin to tell what is affected by the mismatch, and whether
it should be ignored (if it's inside a swap partition, for
instance).

We ratelimit to prevent log flooding: if there are so many
mismatches that ratelimiting is necessary, the individual messages
are relatively unlikely to be important (either the machine is
swapping like crazy or something is very wrong with the disk).

Signed-off-by: Nick Alcock <nick.alcock@oracle.com>
---
 drivers/md/raid5.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ed5cd705b985..bcd2e5150e29 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3959,10 +3959,14 @@ static void handle_parity_checks5(struct r5conf *conf, struct stripe_head *sh,
 			set_bit(STRIPE_INSYNC, &sh->state);
 		else {
 			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
-			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
+			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
 				/* don't try to repair!! */
 				set_bit(STRIPE_INSYNC, &sh->state);
-			else {
+				pr_warn_ratelimited("%s: mismatch around sector "
+						    "%llu\n", __func__,
+						    (unsigned long long)
+						    sh->sector);
+			} else {
 				sh->check_state = check_state_compute_run;
 				set_bit(STRIPE_COMPUTE_RUN, &sh->state);
 				set_bit(STRIPE_OP_COMPUTE_BLK, &s->ops_request);
@@ -4111,10 +4115,14 @@ static void handle_parity_checks6(struct r5conf *conf, struct stripe_head *sh,
 			}
 		} else {
 			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
-			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
+			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
 				/* don't try to repair!! */
 				set_bit(STRIPE_INSYNC, &sh->state);
-			else {
+				pr_warn_ratelimited("%s: mismatch around sector "
+						    "%llu\n", __func__,
+						    (unsigned long long)
+						    sh->sector);
+			} else {
 				int *target = &sh->ops.target;
 
 				sh->ops.target = -1;
-- 
2.12.2.212.gea238cf35.dirty

