From: Nix <nix@esperi.org.uk>
Subject: Re: A sector-of-mismatch warning patch (was Re: Fault tolerance with badblocks)
Date: Tue, 16 May 2017 10:13:31 +0100
Message-ID: <87pof9rwp0.fsf@esperi.org.uk>
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
        <87bmr14u5f.fsf_-_@esperi.org.uk>
        <87efvpmqf6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87efvpmqf6.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Tue, 16 May 2017 13:27:57 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Chris Murphy <lists@colorremedies.com>, David Brown <david.brown@hesbynett.no>, Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16 May 2017, NeilBrown said:

>> -			else {
>> +				pr_warn_ratelimited("%s: mismatch around sector "
>> +						    "%llu\n", __func__,
>> +						    (unsigned long long)
>> +						    sh->sector);
>> +			} else {
>
> I think there is no point giving the function name,
> but that you should give the name of the array.

*ouch* I can't believe I forgot that. I have more than one array
myself... "we have a fault but we don't know what array it's on" is not
much of an improvement over the status quo, really! (though you could
make a good guess by looking for preceding sync-start messages, you can
of course sync two arrays at the same time...)

> Also "around" is a little vague.

Intentionally: I couldn't think of the right terminology. Yours is
better.

> Maybe something like:
>
>> +				pr_warn_ratelimited("%s: mismatch sector in range "
>> +						    "%llu-%llu\n", mdname(conf->mddev),
>> +						    (unsigned long long) sh->sector,
>> +						    (unsigned long long) sh->sector + STRIPE_SECTORS);

Nice! Here's a rerolled patch. (We exceed the 80-char limit but that's
pr_warn_ratelimited()'s fault for having such a long name!)

Tested by making a raid array on a bunch of sparse files then dding a
byte of garbage into one of them and checking it. I got a nice error
message, name and all, and the sector count looked good.


From f05a451d46900849c7965a0e7dde085f1fb50dfc Mon Sep 17 00:00:00 2001
From: Nick Alcock <nick.alcock@oracle.com>
Date: Tue, 9 May 2017 21:55:17 +0100
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
 drivers/md/raid5.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ed5cd705b985..937314051be5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3959,10 +3959,15 @@ static void handle_parity_checks5(struct r5conf *conf, struct stripe_head *sh,
 			set_bit(STRIPE_INSYNC, &sh->state);
 		else {
 			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
-			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
+			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
 				/* don't try to repair!! */
 				set_bit(STRIPE_INSYNC, &sh->state);
-			else {
+				pr_warn_ratelimited("%s: mismatch sector in range "
+						    "%llu-%llu\n", mdname(conf->mddev),
+						    (unsigned long long) sh->sector,
+						    (unsigned long long) sh->sector +
+						    STRIPE_SECTORS);
+			} else {
 				sh->check_state = check_state_compute_run;
 				set_bit(STRIPE_COMPUTE_RUN, &sh->state);
 				set_bit(STRIPE_OP_COMPUTE_BLK, &s->ops_request);
@@ -4111,10 +4116,15 @@ static void handle_parity_checks6(struct r5conf *conf, struct stripe_head *sh,
 			}
 		} else {
 			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
-			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
+			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
 				/* don't try to repair!! */
 				set_bit(STRIPE_INSYNC, &sh->state);
-			else {
+				pr_warn_ratelimited("%s: mismatch sector in range "
+						    "%llu-%llu\n", mdname(conf->mddev),
+						    (unsigned long long) sh->sector,
+						    (unsigned long long) sh->sector +
+						    STRIPE_SECTORS);
+			} else {
 				int *target = &sh->ops.target;
 
 				sh->ops.target = -1;
-- 
2.12.2.212.gea238cf35.dirty
