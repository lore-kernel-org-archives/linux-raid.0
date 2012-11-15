From: Ming Lei <Ming.Lei@riverbed.com>
Subject: a code question on raid5.c
Date: Thu, 15 Nov 2012 19:14:44 +0000
Message-ID: <2CE44BD3DBCF9541909CCB42F11CA392872F23@SFO1EXC-MBXP06.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


In add_stripe_bio() there is some code as shown below:
 
    if (forwrite) {
        /* check if page is covered */
        sector_t sector = sh->dev[dd_idx].sector;
        for (bi=sh->dev[dd_idx].towrite;
             sector < sh->dev[dd_idx].sector + STRIPE_SECTORS &&
                 bi && bi->bi_sector <= sector;
             bi = r5_next_bio(bi, sh->dev[dd_idx].sector)) {
            if (bi->bi_sector + (bi->bi_size>>9) >= sector)
                sector = bi->bi_sector + (bi->bi_size>>9);
        }
        if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS)
            set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
    }

Say I have 3 bio(s) that is:
1. bi->bi_sector = 654618968;
    bi->bi_size = 2*512;
2. bi->bi_sector = 654618970;
    bi->bi_size = 1*512;
3. bi->bi_sector = 654618973;
    bi->bi_size = 5*512;

I expected that the third bio could cause R5_OVERWRITE be set. But I didn't see this bit got set. What does this code really do? I thought it checks if the single 4K page can cover the bio chains targeted at this stripe cache(4K).

Thanks
M.
