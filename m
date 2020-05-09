From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 01/15] nfblock: use gendisk private_data
Date: Sat, 9 May 2020 12:38:00 +0200
Message-ID: <CAMuHMdUBRsZQ1BOD9jW99NTm_8NZDootGrqzz3nPeeJ+mUAoTw@mail.gmail.com>
References: <20200508161517.252308-1-hch@lst.de> <20200508161517.252308-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20200508161517.252308-2-hch@lst.de>
Sender: linux-bcache-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>, Geoff Levand <geoff@infradead.org>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, linux-m68k <linux-m68k@lists.linux-m68k.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:TENSILICA XTENSA PORT (xtensa)" <linux-xtensa@linux-xtensa.org>, Lars Ellenberg <drbd-dev@lists.linbit.com>, linux-block@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-Id: linux-raid.ids

Hi Christoph,

On Fri, May 8, 2020 at 6:16 PM Christoph Hellwig <hch@lst.de> wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks for your patch!

> --- a/arch/m68k/emu/nfblock.c
> +++ b/arch/m68k/emu/nfblock.c
> @@ -61,7 +61,7 @@ struct nfhd_device {
>
>  static blk_qc_t nfhd_make_request(struct request_queue *queue, struct bio *bio)
>  {
> -       struct nfhd_device *dev = queue->queuedata;
> +       struct nfhd_device *dev = bio->bi_disk->private_data;
>         struct bio_vec bvec;
>         struct bvec_iter iter;
>         int dir, len, shift;
> @@ -122,7 +122,6 @@ static int __init nfhd_init_one(int id, u32 blocks, u32 bsize)
>         if (dev->queue == NULL)
>                 goto free_dev;
>
> -       dev->queue->queuedata = dev;
>         blk_queue_logical_block_size(dev->queue, bsize);
>
>         dev->disk = alloc_disk(16);
> @@ -136,6 +135,7 @@ static int __init nfhd_init_one(int id, u32 blocks, u32 bsize)
>         sprintf(dev->disk->disk_name, "nfhd%u", dev_id);
>         set_capacity(dev->disk, (sector_t)blocks * (bsize / 512));
>         dev->disk->queue = dev->queue;
> +       dev->disk->private_data = dev;

This is already set above, just before the quoted sprintf() call.

>
>         add_disk(dev->disk);

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
