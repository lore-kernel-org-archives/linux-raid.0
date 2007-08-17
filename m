From: Mike Accetta <maccetta@laurelnetworks.com>
Subject: Re: detecting read errors after RAID1 check operation
Date: Fri, 17 Aug 2007 17:31:37 -0400
Message-ID: <28851.1187386297@mdt.ecitele.com>
References: <18117.838.460416.573228@notabene.brown>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: Your message of "Fri, 17 Aug 2007 12:09:10 +1000."
             <18117.838.460416.573228@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Neil Brown writes:
> On Wednesday August 15, maccetta@laurelnetworks.com wrote:
> > Neil Brown writes:
> > > On Wednesday August 15, maccetta@laurelnetworks.com wrote:
> > > > 
> > ... 
> > This happens in our old friend sync_request_write()?  I'm dealing with
> 
> Yes, that would be the place.
> 
> > ...
> > This fragment
> > 
> > 	if (j < 0 || test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
> > 		sbio->bi_end_io = NULL;
> > 		rdev_dec_pending(conf->mirrors[i].rdev, mddev);
> > 	} else {
> > 		/* fixup the bio for reuse */
> > 		...
> > 	}
> > 
> > looks suspicously like any correction attempt for 'check' is being
> > short-circuited to me, regardless of whether or not there was a read
> > error.  Actually, even if the rewrite was not being short-circuited,
> > I still don't see the path that would update 'corrected_errors' in this
> > case.  There are only two raid1.c sites that touch 'corrected_errors', one
> > is in fix_read_errors() and the other is later in sync_request_write().
> > With my limited understanding of how this all works, neither of these
> > paths would seem to apply here.
> 
> hmmm.... yes....
> I guess I was thinking of the RAID5 code rather than the RAID1 code.
> It doesn't do the right thing does it?
> Maybe this patch is what we need.  I think it is right.
> 
> Thanks,
> NeilBrown
> 
> 
> Signed-off-by: Neil Brown <neilb@suse.de>
> 
> ### Diffstat output
>  ./drivers/md/raid1.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
> --- .prev/drivers/md/raid1.c	2007-08-16 10:29:58.000000000 +1000
> +++ ./drivers/md/raid1.c	2007-08-17 12:07:35.000000000 +1000
> @@ -1260,7 +1260,8 @@ static void sync_request_write(mddev_t *
>  					j = 0;
>  				if (j >= 0)
>  					mddev->resync_mismatches += r1_bio->sec
> tors;
> -				if (j < 0 || test_bit(MD_RECOVERY_CHECK, &mddev
> ->recovery)) {
> +				if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mdde
> v->recovery)
> +					      && text_bit(BIO_UPTODATE, &sbio->
> bi_flags))) {
>  					sbio->bi_end_io = NULL;
>  					rdev_dec_pending(conf->mirrors[i].rdev,
>  mddev);
>  				} else {

I tried this (with the typo fixed) and it indeed issues a re-write.
However, it doesn't seem to do anything with the corrected errors
count if the rewrite succeeds.  Since end_sync_write() is only used one
other place when !In_sync, I tried the following and it seems to work
to get the error count updated.  I don't know whether this belongs in
end_sync_write() but I'd think it needs to come after the write actually
succeeds so that seems like the earliest it could be done.

--- BUILD/kernel/drivers/md/raid1.c	2007-06-04 13:52:42.000000000 -0400
+++ drivers/md/raid1.c	2007-08-17 16:52:14.219364000 -0400
@@ -1166,6 +1166,7 @@ static int end_sync_write(struct bio *bi
 	conf_t *conf = mddev_to_conf(mddev);
 	int i;
 	int mirror=0;
+	mdk_rdev_t *rdev;
 
 	if (bio->bi_size)
 		return 1;
@@ -1175,6 +1176,8 @@ static int end_sync_write(struct bio *bi
 			mirror = i;
 			break;
 		}
+
+	rdev = conf->mirrors[mirror].rdev;
 	if (!uptodate) {
 		int sync_blocks = 0;
 		sector_t s = r1_bio->sector;
@@ -1186,7 +1189,13 @@ static int end_sync_write(struct bio *bi
 			s += sync_blocks;
 			sectors_to_go -= sync_blocks;
 		} while (sectors_to_go > 0);
-		md_error(mddev, conf->mirrors[mirror].rdev);
+		md_error(mddev, rdev);
+	} else if (test_bit(In_sync, &rdev->flags)) {
+		/*
+		 * If we are currently in sync, this was a re-write to
+		 * correct a read error and we should account for it.
+		 */
+		atomic_add(r1_bio->sectors, &rdev->corrected_errors);
 	}
 
 	update_head_pos(mirror, r1_bio);
@@ -1251,7 +1260,8 @@ static void sync_request_write(mddev_t *
 				}
 				if (j >= 0)
 					mddev->resync_mismatches += r1_bio->sectors;
-				if (j < 0 || test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
+				if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
+					      && test_bit(BIO_UPTODATE, &sbio->bi_flags))) {
 					sbio->bi_end_io = NULL;
 					rdev_dec_pending(conf->mirrors[i].rdev, mddev);
 				} else {
--
Mike Accetta

ECI Telecom Ltd.
Transport Networking Division, US (previously Laurel Networks)
