From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v1 01/14] block: introduce bio_segments_all()
Date: Tue, 28 Feb 2017 20:15:37 +0800
Message-ID: <CACVXFVMjf0trmc8jggdYUm8k1HS+vHa26=godzJ-jQ_23yha0w@mail.gmail.com>
References: <1487950971-1131-1-git-send-email-tom.leiming@gmail.com>
 <1487950971-1131-2-git-send-email-tom.leiming@gmail.com> <20170225182216.GB26447@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170225182216.GB26447@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Feb 26, 2017 at 2:22 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> +static inline unsigned bio_segments_all(struct bio *bio)
>> +{
>> +     WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
>> +
>> +     return bio->bi_vcnt;
>> +}
>
> I don't think this helpers really adds any benefit.

IMO the first benefit is that misusing of .bi_vcnt can be warned, and
another one is that we have to introduce this helper if multipage bvec
is supported.

Thanks,
Ming Lei
