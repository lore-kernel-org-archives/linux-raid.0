From: Doug Dumitru <doug@easyco.com>
Subject: Re: Question about raid1_make_request
Date: Mon, 28 Nov 2016 15:53:02 -0800
Message-ID: <CAFx4rwQQrETbpi-kQ56wj3izmvSpDiCQ3iD6dyK2LkkM-JZBTg@mail.gmail.com>
References: <CAANLjFpb0ZCEVtvaib8nsoKhKZs55agy35HEByeo1g1OSWBGjg@mail.gmail.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAANLjFpb0ZCEVtvaib8nsoKhKZs55agy35HEByeo1g1OSWBGjg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Not the best code organization, but no real harm done.  Look at the
front of md_write_start:

void md_write_start(struct mddev *mddev, struct bio *bi)
{
        int did_change = 0;
        if (bio_data_dir(bi) != WRITE)
                return;

So writes fall thru really quickly.

Doug


On Mon, Nov 28, 2016 at 3:41 PM, Robert LeBlanc <robert@leblancnet.us> wrote:
> I'm looking through the code and am wondering why this is at the start
> of raid1_make_request. It seems that it is only needed for WRITE and
> would unnecessarily delay READ requests waiting for the superblock.
> Would it make more sense to put this at the start of the WRITE branch?
> What am I missing?
>
> 1057         /*
> 1058          * Register the new request and wait if the
> reconstruction
> 1059          * thread has put up a bar for new requests.
> 1060          * Continue immediately if no resync is active currently.
> 1061          */
> 1062
> 1063         md_write_start(mddev, bio); /* wait on superblock update
> early */
> 1064
> 1065         if (bio_data_dir(bio) == WRITE &&
> 1066             ((bio_end_sector(bio) > mddev->suspend_lo &&
> 1067             bio->bi_iter.bi_sector < mddev->suspend_hi) ||
> 1068             (mddev_is_clustered(mddev) &&
> 1069              md_cluster_ops->area_resyncing(mddev, WRITE,
> 1070                      bio->bi_iter.bi_sector,
> bio_end_sector(bio))))) {
> 1071                 /* As the suspend_* range is controlled by
> 1072                  * userspace, we want an interruptible
> 1073                  * wait.
> 1074                  */
> 1075                 DEFINE_WAIT(w);
> 1076                 for (;;) {
> 1077                         flush_signals(current);
> 1078                         prepare_to_wait(&conf->wait_barrier,
> 1079                                         &w, TASK_INTERRUPTIBLE);
> 1080                         if (bio_end_sector(bio) <=
> mddev->suspend_lo ||
> 1081                             bio->bi_iter.bi_sector >=
> mddev->suspend_hi ||
> 1082                             (mddev_is_clustered(mddev) &&
> 1083
> !md_cluster_ops->area_resyncing(mddev, WRITE,
> 1084                                      bio->bi_iter.bi_sector,
> bio_end_sector(bio))))
> 1085                                 break;
> 1086                         schedule();
> 1087                 }
> 1088                 finish_wait(&conf->wait_barrier, &w);
> 1089         }
> 1090
> 1091         start_next_window = wait_barrier(conf, bio);
> 1092
> 1093         bitmap = mddev->bitmap;
> 1094
>
> Thanks
>
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Doug Dumitru
EasyCo LLC
