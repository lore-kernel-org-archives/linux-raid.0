From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH 002 of 4] md: Define ->congested_fn for raid1, raid10,
 and multipath
Date: Tue, 29 Aug 2006 08:12:32 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0608290811330.952@yvahk01.tjqt.qr>
References: <20060829153414.6475.patches@notabene> <1060829053935.6628@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1060829053935.6628@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Since we're all about nits, I'll do my part:

>diff .prev/drivers/md/multipath.c ./drivers/md/multipath.c
>--- .prev/drivers/md/multipath.c	2006-08-29 14:52:50.000000000 +1000
>+++ ./drivers/md/multipath.c	2006-08-29 14:33:34.000000000 +1000
>@@ -228,6 +228,28 @@ static int multipath_issue_flush(request
> 	rcu_read_unlock();
> 	return ret;
> }
>+static int multipath_congested(void *data, int bits)

Missing white line.

>diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
>--- .prev/drivers/md/raid1.c	2006-08-29 14:52:50.000000000 +1000
>+++ ./drivers/md/raid1.c	2006-08-29 14:26:59.000000000 +1000
>@@ -601,6 +601,32 @@ static int raid1_issue_flush(request_que
> 	return ret;
> }
> 
>+static int raid1_congested(void *data, int bits)
>+{
>+	mddev_t *mddev = data;
>+	conf_t *conf = mddev_to_conf(mddev);
>+	int i, ret = 0;
>+
>+	rcu_read_lock();
>+	for (i = 0; i < mddev->raid_disks; i++) {
>+		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
>+		if (rdev && !test_bit(Faulty, &rdev->flags)) {
>+			request_queue_t *q = bdev_get_queue(rdev->bdev);
>+
>+			/* Note the '|| 1' - when read_balance prefers
>+			 * non-congested targets, it can be removed
>+			 */
>+			if ((bits & (1<<BDI_write_congested)) || 1)
>+				ret |= bdi_congested(&q->backing_dev_info, bits);
>+			else
>+				ret &= bdi_congested(&q->backing_dev_info, bits);
>+		}
>+	}
>+	rcu_read_unlock();
>+	return ret;
>+}
>+
>+
> /* Barriers....

And one white line too much, but YMMV ;-)


Jan Engelhardt
-- 
