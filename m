From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid1 doesn't balance under high load [patch]
Date: Fri, 11 Jun 2004 11:26:32 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16585.2632.321497.620210@cse.unsw.edu.au>
References: <20040610113019.GA8660@cistron.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Miquel van Smoorenburg on Thursday June 10
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 10, miquels@cistron.nl wrote:
> I have several servers installed with a bootable raid1 array. I noticed
> that under high load, the load wasn't balanced over the 2 disks in
> the array anymore - all reads went to just one of the disks.
> 
> The problem is in raid1.c:read_balance().
> 
> There's a check to see if the array is in sync:
> 
>         /*
>          * Check if it if we can balance. We can balance on the whole
>          * device if no resync is going on, or below the resync window.
>          * We take the first readable disk when above the resync window.
>          */
>         if (!conf->mddev->in_sync && (this_sector + sectors >= conf->next_resync)) {
> 
> Now if you write to the array, the array is marked not in sync by
> md.c:md_write_start(). conf->next_resync is initialized to zero, so
> that means read balancing doesn't work anymore.

Yes, you are right.  Thanks.
Your patch is close, but not quite right (though it would be hard to
cause it to actually fail).
I think it patch is more correct.  I would appreciate it if you could
confirm that it works for you.

Thanks again,
NeilBrown

==========================================
Fix raid1 read_balancing code.

The meaning of mddev->in_sync changed subtly a while ago, and raid1
wasn't changed to match.  This results in raid1 read_balancing
not working properly.
This patch corrects the relevant test.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid1.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-06-11 11:20:34.000000000 +1000
+++ ./drivers/md/raid1.c	2004-06-11 11:21:57.000000000 +1000
@@ -375,7 +375,8 @@ static int read_balance(conf_t *conf, st
 	 * device if no resync is going on, or below the resync window.
 	 * We take the first readable disk when above the resync window.
 	 */
-	if (!conf->mddev->in_sync && (this_sector + sectors >= conf->next_resync)) {
+	if (!conf->mddev->recovery_cp < MaxSector &&
+	    (this_sector + sectors >= conf->next_resync)) {
 		/* make sure that disk is operational */
 		new_disk = 0;
 
