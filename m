From: NeilBrown <neilb@suse.com>
Subject: Re: NULL pointer dereference at 0000000000000038 IP:
 [<ffffffff815f514f>] bitmap_load+0x45f/0x610
Date: Thu, 25 Jun 2015 17:11:43 +1000
Message-ID: <20150625171143.2cd16d63@noble>
References: <CAG2YfWODJEAV2i=WhzvJQw2AicKL0-c-EvAMA+Y-UVQRo+jgrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG2YfWODJEAV2i=WhzvJQw2AicKL0-c-EvAMA+Y-UVQRo+jgrQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nate Clark <nate@neworld.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 19 Jun 2015 17:18:45 -0400 Nate Clark <nate@neworld.us> wrote:

> Hi,
> 
> I encountered a null pointer in md on kernel 4.0.4 and 4.0.5. I was running
> Fedora so I filed this bug with redhat,
> https://bugzilla.redhat.com/show_bug.cgi?id=1232492.
> 
> It seems pretty easy to encounter.
> 1) Add PROGRAM line in mdadm.conf, which points to a script that just
> sleeps for 5 or 10 seconds
> 2) Create md device (I used raid 1 but I don't think that matters)
> 3) Stop that md device
> 4) Before the monitor program finishes execution assemble that md device.
> 
> On my system this always cause an Oops.

Hi,
 thanks for the report.
I managed to reproduce this, though it didn't seem quite as easy for me as for
you.

Anyway I found the bug and have a fix - see below.
should get into 4.2 soon and into stable releases in due course.

Thanks,
NeilBrown

From: NeilBrown <neilb@suse.de>
Date: Thu, 25 Jun 2015 17:01:40 +1000
Subject: [PATCH] md: clear mddev->private when it has been freed.

If ->private is set when ->run is called, it is assumed to be
a 'config'  prepared as part of 'reshape'.

So it is important when we free that config, that we also clear ->private.
This is not often a problem as the mddev will normally be discarded
shortly after the config us freed.
However if an 'assemble' races with a final close, the assemble can use
the old mddev which has a stale ->private.  This leads to any of
various sorts of crashes.

So clear ->private after calling ->free().

Reported-by: Nate Clark <nate@neworld.us>
Cc: stable@vger.kernel.org (v4.0+)
Fixes: afa0f557cb15 ("md: rename ->stop to ->free")
Signed-off-by: NeilBrown <neilb@suse.com>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5a6681ad9778..4b7b31b6f25c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5178,6 +5178,7 @@ int md_run(struct mddev *mddev)
 		mddev_detach(mddev);
 		if (mddev->private)
 			pers->free(mddev, mddev->private);
+		mddev->private = NULL;
 		module_put(pers->owner);
 		bitmap_destroy(mddev);
 		return err;
@@ -5313,6 +5314,7 @@ static void md_clean(struct mddev *mddev)
 	mddev->changed = 0;
 	mddev->degraded = 0;
 	mddev->safemode = 0;
+	mddev->private = NULL;
 	mddev->merge_check_needed = 0;
 	mddev->bitmap_info.offset = 0;
 	mddev->bitmap_info.default_offset = 0;
@@ -5385,6 +5387,7 @@ static void __md_stop(struct mddev *mddev)
 	mddev->pers = NULL;
 	spin_unlock(&mddev->lock);
 	pers->free(mddev, mddev->private);
+	mddev->private = NULL;
 	if (pers->sync_request && mddev->to_remove == NULL)
 		mddev->to_remove = &md_redundancy_group;
 	module_put(pers->owner);

