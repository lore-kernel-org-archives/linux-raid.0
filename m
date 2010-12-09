From: "Dailey, Nate" <Nate.Dailey@stratus.com>
Subject: RE: interrupted resync not restarted properly?
Date: Thu, 9 Dec 2010 11:53:25 -0500
Message-ID: <AC1B83CE65082B4DBDDB681ED2F6B2EF866E07@EXHQ.corp.stratus.com>
References: <AC1B83CE65082B4DBDDB681ED2F6B2EF866DF8@EXHQ.corp.stratus.com> <20101209141611.38a26357@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20101209141611.38a26357@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I tried this out, and it does indeed fix the problem I was seeing.

Thanks!
Nate




-----Original Message-----
From: Neil Brown [mailto:neilb@suse.de] 
Sent: Wednesday, December 08, 2010 10:16 PM
To: Dailey, Nate
Cc: linux-raid@vger.kernel.org
Subject: Re: interrupted resync not restarted properly?

On Tue, 7 Dec 2010 15:37:00 -0500 "Dailey, Nate"
<Nate.Dailey@stratus.com>
wrote:

> It seems to me that resuming an interrupted resync doesn't always work
> right... here's what I'm doing (kernel 2.6.36):
> 
> - start with a 2 disk raid1 with internal bitmap
> - fail/remove one disk and zero the superblock
> - add the disk to the raid1
> - before resync completes, fail/remove the disk again
> - re-add the disk again
> 
> For version 0 superblocks, this works the way I'd expect: on adding
the
> disk the second time, the resync continues (or restarts from the
> beginning, not sure).
> 
> But for version 1 superblocks, on adding the disk the second time, the
> resync completes immediately, leaving some part of the array
> out-of-sync.
> 
> Should there be something in the v1 superblock to prevent this?
> 
> If the raid1 is stopped in the middle of the resync (instead of
removing
> the target disk) the resync is resumed correctly on re-assembly with
> both devices.
> 
> Nate
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks for the report.
That is pretty bad behaviour.

The following is a patch that I plan to submit to -linus and -stable.
It
doesn't make it work quite as I would like (that would be a lot more
code)
but it makes it a lot safer.

Thanks,
NeilBrown

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5170,7 +5174,10 @@ static int add_new_disk(mddev_t * mddev,
mdu_disk_info_t *info)
 		} else
 			super_types[mddev->major_version].
 				validate_super(mddev, rdev);
-		rdev->saved_raid_disk = rdev->raid_disk;
+		if (test_bit(In_sync, &rdev->flags))
+			rdev->saved_raid_disk = rdev->raid_disk;
+		else
+			rdev->saved_raid_disk = -1;
 
 		clear_bit(In_sync, &rdev->flags); /* just to be sure */
 		if (info->state & (1<<MD_DISK_WRITEMOSTLY))
