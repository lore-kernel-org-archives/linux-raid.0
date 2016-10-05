From: Shaohua Li <shli@kernel.org>
Subject: Re: kernel BUG at block/bio.c:1785 while trying to issue a discard
 to LVM on RAID1 md
Date: Wed, 5 Oct 2016 14:39:45 -0700
Message-ID: <20161005213945.GA84123@kernel.org>
References: <CALjAwxgg-m2bgFf10hLB3j=2ntVxqt0vDSKuQyOavqvKXC2G5Q@mail.gmail.com>
 <CALjAwxhYh0JDKh7E_t9sm-vBBPX-3dzL5hDMi4rA6uE2RqaJoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALjAwxhYh0JDKh7E_t9sm-vBBPX-3dzL5hDMi4rA6uE2RqaJoQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Oct 05, 2016 at 10:31:11PM +0100, Sitsofe Wheeler wrote:
> On 3 October 2016 at 17:47, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> >
> > While trying to do a discard (via blkdiscard --length 1048576
> > /dev/<pathtodevice>) to an LVM device atop a two disk md RAID1 the
> > following oops was generated:
> >
> > [  103.306243] md: resync of RAID array md127
> > [  103.306246] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> > [  103.306248] md: using maximum available idle IO bandwidth (but not
> > more than 200000 KB/sec) for resync.
> > [  103.306251] md: using 128k window, over a total of 244194432k.
> > [  103.308158] ------------[ cut here ]------------
> > [  103.308205] kernel BUG at block/bio.c:1785!
> 
> This still seems to be here but slightly modified with a 4.8.0 kernel:

Does this fix the issue? Looks there is IO error


diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 21dc00e..349eb11 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2196,7 +2196,6 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 			wbio = bio_clone_mddev(r1_bio->master_bio, GFP_NOIO, mddev);
 		}
 
-		bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
 		wbio->bi_iter.bi_sector = r1_bio->sector;
 		wbio->bi_iter.bi_size = r1_bio->sectors << 9;
 
