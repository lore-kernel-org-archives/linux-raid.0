From: "bmoon" <bo@anthologysolutions.com>
Subject: How do we handle the same but uptodated data to disk cache?
Date: Mon, 26 May 2003 19:41:06 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <004301c323f9$71916a10$6b01a8c0@bmoon>
References: <Pine.LNX.4.44.0305261738440.19678-100000@q7.q7.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I want to write the data to the fixed sector with the same size frequently
just like MD super block, but I do not want to sync and flush the dev
on each write.

For example, to write md super block in /drivers/md/md.c

we do

        fsync_dev(dev);
        bh=getblk(dev, block, size);

        mark_buffer_uptodate(bh,1);
        mark_buffer_dirty(bh);
        ll_rw_block(WRITE,1, &bh);
        wait_on_buffer(bh);
        brelse(bh);
        fsync_dev(dev);

Instead, Can I do as follow

        bh=getblk(dev, block, size);
        if (buffer_uptodate(bh)) { /* still in cache, not flushed yet */
           bh->b_data = new SB data;
            brelse(bh);
        }
        else { /* it must be flushed */
            same as in above
       }

Please provide me your openion or suggestions.

Thanks in advance,

Bo
