From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH 00/13] convert block layer to bioset_init()/mempool_init()
Date: Sun, 20 May 2018 19:11:48 -0400
Message-ID: <CAC7rs0vUCMuCvNez4Rr0M=OFEokKbL92e_R-M3nJ-gfoaLhgxw@mail.gmail.com>
References: <20180520222558.7053-1-kent.overstreet@gmail.com> <87603i0vtx.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87603i0vtx.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Chris Mason <clm@fb.com>, bacik@fb.com, linux-xfs@vger.kernel.org, Lars Ellenberg <drbd-dev@lists.linbit.com>, linux-btrfs@vger.kernel.org, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks - sending it to him

On Sun, May 20, 2018 at 7:08 PM, NeilBrown <neilb@suse.com> wrote:
> On Sun, May 20 2018, Kent Overstreet wrote:
>
>> Jens - this series does the rest of the conversions that Christoph wanted, and
>> drops bioset_create().
>>
>> Only lightly tested, but the changes are pretty mechanical. Based on your
>> for-next tree.
>>
>> It's also in the for-jens branch at https://evilpiepirate.org/git/bcachefs.git
>>
>> Kent Overstreet (12):
>>   block: convert bounce, q->bio_split to bioset_init()/mempool_init()
>>   drbd: convert to bioset_init()/mempool_init()
>>   pktcdvd: convert to bioset_init()/mempool_init()
>>   lightnvm: convert to bioset_init()/mempool_init()
>>   bcache: convert to bioset_init()/mempool_init()
>>   md: convert to bioset_init()/mempool_init()
>
> Hi Kent,
>  this conversion looks really good, thanks for Ccing me on it.
>  However as Shaohua Li is now the maintainer of md, it probably should
>  have gone to him as well.
>
> Thanks,
> NeilBrown
