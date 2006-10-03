From: Neil Brown <neilb@suse.de>
Subject: Re: old raid tools dangerous with 2.6.18?
Date: Tue, 3 Oct 2006 17:15:00 +1000
Message-ID: <17698.3572.190300.504962@cse.unsw.edu.au>
References: <7744a2840609281120g5a4308d5id79ea8d487e7ae2b@mail.gmail.com>
	<87lknz998s.87k63j998s@87irj3998s.message.id>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from syrius.ml@no-log.org on Sunday October 1
Sender: linux-raid-owner@vger.kernel.org
To: syrius.ml@no-log.org, Richard Bollinger <rabollinger@gmail.com>
Cc: linux-raid@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids

On Sunday October 1, syrius.ml@no-log.org wrote:
> "Richard Bollinger" <rabollinger@gmail.com> writes:
> 
> > It appears that raidhotadd doesn't always trigger a resync under 2.6.18.
> >
> > Starting with a broken raid1 mirror:
> 
> Same with evms and 2.6.18. it does not trigger the raid1 resync in any
> case. (while it does with 2.6.17)
> Have these tools to be updated ?

Well, mdadm-2.x should work, but this is a serious bug in md.

The following patch fixes it and should go in 2.6.18.1.

Thanks and apologies.

NeilBrown


--------------------
Fix problem where hot-added drives are not resynced.

If a drive is added with HOT_ADD_DISK rather than ADD_NEW_DISK,
saved_raid_disk isn't initialised properly, and the drive can be
included in the array without a resync.


### Diffstat output
 ./drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-10-03 17:10:54.000000000 +1000
+++ ./drivers/md/md.c	2006-10-03 17:11:19.000000000 +1000
@@ -3867,6 +3867,7 @@ static int hot_add_disk(mddev_t * mddev,
 	}
 	clear_bit(In_sync, &rdev->flags);
 	rdev->desc_nr = -1;
+	rdev->saved_raid_disk = -1;
 	err = bind_rdev_to_array(rdev, mddev);
 	if (err)
 		goto abort_export;
