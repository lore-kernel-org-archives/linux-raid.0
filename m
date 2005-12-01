From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 003 of 14] Make sure read error on last working drive of raid1 actually returns failure.
Date: Thu, 1 Dec 2005 14:23:01 +1100
Message-ID: <1051201032301.29581@suse.de>
References: <20051201141508.29384.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


We are inadvertently setting the R1BIO_Uptodate bit on read errors
when we decide not to try correcting (because there are no other
working devices).  This means that the read error is reported to
the client as success.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-11-28 17:20:37.000000000 +1100
+++ ./drivers/md/raid1.c	2005-11-29 10:28:21.000000000 +1100
@@ -284,7 +284,8 @@ static int raid1_end_read_request(struct
 		 * user-side. So if something waits for IO, then it will
 		 * wait for the 'master' bio.
 		 */
-		set_bit(R1BIO_Uptodate, &r1_bio->state);
+		if (uptodate)
+			set_bit(R1BIO_Uptodate, &r1_bio->state);
 
 		raid_end_bio_io(r1_bio);
 	} else {
