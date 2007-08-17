From: Neil Brown <neilb@suse.de>
Subject: Re: detecting read errors after RAID1 check operation
Date: Fri, 17 Aug 2007 12:09:10 +1000
Message-ID: <18117.838.460416.573228@notabene.brown>
References: <18115.33874.732489.977468@notabene.brown>
	<15506.1187234841@mdt.ecitele.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Accetta on Wednesday August 15
Sender: linux-raid-owner@vger.kernel.org
To: Mike Accetta <maccetta@laurelnetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday August 15, maccetta@laurelnetworks.com wrote:
> Neil Brown writes:
> > On Wednesday August 15, maccetta@laurelnetworks.com wrote:
> > > 
> > > There are already files like /sys/block/md_d0/md/dev-sdb/errors in /sys
> > > which would be very convenient to consult but according to the kernel
> > > driver implementation the error counts reported there are apparently
> > > for corrected errors and not relevant for read errors during a "check"
> > > operation.
> > > 
> > 
> > When 'check' hits a read error, an attempt is made to 'correct' it by
> > over-writing with correct data.  This will either increase the
> > 'errors' count or fail the drive completely.
> > 
> > What 'check' doesn't do (and 'repair' does) it react when it find that
> > successful reads of all drives (in a raid1) do not match.
> > 
> > So just use the 'errors' number - it is exactly what you want.
> 
> This happens in our old friend sync_request_write()?  I'm dealing with

Yes, that would be the place.

> simulated errors and will dig further to make sure that is not perturbing
> the results but I don't see any 'errors' effect.  This is with our
> patched 2.6.20 raid1.c.  The logic doesn't seem to be any different in
> 2.6.22 from what I can tell, though.
> 
> This fragment
> 
> 	if (j < 0 || test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
> 		sbio->bi_end_io = NULL;
> 		rdev_dec_pending(conf->mirrors[i].rdev, mddev);
> 	} else {
> 		/* fixup the bio for reuse */
> 		...
> 	}
> 
> looks suspicously like any correction attempt for 'check' is being
> short-circuited to me, regardless of whether or not there was a read
> error.  Actually, even if the rewrite was not being short-circuited,
> I still don't see the path that would update 'corrected_errors' in this
> case.  There are only two raid1.c sites that touch 'corrected_errors', one
> is in fix_read_errors() and the other is later in sync_request_write().
> With my limited understanding of how this all works, neither of these
> paths would seem to apply here.

hmmm.... yes....
I guess I was thinking of the RAID5 code rather than the RAID1 code.
It doesn't do the right thing does it?
Maybe this patch is what we need.  I think it is right.

Thanks,
NeilBrown


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-08-16 10:29:58.000000000 +1000
+++ ./drivers/md/raid1.c	2007-08-17 12:07:35.000000000 +1000
@@ -1260,7 +1260,8 @@ static void sync_request_write(mddev_t *
 					j = 0;
 				if (j >= 0)
 					mddev->resync_mismatches += r1_bio->sectors;
-				if (j < 0 || test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
+				if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
+					      && text_bit(BIO_UPTODATE, &sbio->bi_flags))) {
 					sbio->bi_end_io = NULL;
 					rdev_dec_pending(conf->mirrors[i].rdev, mddev);
 				} else {
