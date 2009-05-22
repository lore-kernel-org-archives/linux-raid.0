From: "NeilBrown" <neilb@suse.de>
Subject: Re: Does raid5 have error handling while reading?
Date: Fri, 22 May 2009 21:21:38 +1000 (EST)
Message-ID: <826660809fa6b6432ed8866d24482b74.squirrel@neil.brown.name>
References: <691c243c0905220110y541ab523v5998b8054c89da60@mail.gmail.com>
    <2bf95d5420210a8cab4700798fb6030c.squirrel@neil.brown.name>
    <691c243c0905220213i603ba115ga6aea27b7c564c1d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <691c243c0905220213i603ba115ga6aea27b7c564c1d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xu Yuehai <raid.yuehai@gmail.com>
Cc: linux-raid@vger.kernel.org, green.trace@gmail.com
List-Id: linux-raid.ids

On Fri, May 22, 2009 7:13 pm, Xu Yuehai wrote:
>>
>> If chunk_aligned_read results in an error, then the request
>> is re-tried through the stripe cache.  I would call that "error
>> handling".
>
> I think you mean that error() and raid5_align_endio are invoked and
> the read request is sent to conf->retry_read_aligned_list, then the
> raid5d will handle it.

Yes, that sounds right.

>
>> If the cache finds that a drives is failed, the data is calculated
>> from the other drives, though the code is not a straight forward
>> as it used to be.
>> See fetch_block5 which sets STRIPE_OP_COMPUTE_BLK which causes
>> ops_run_compute5 to do the work (or to schedule the work on separate
>> hardware).
>>
> I notice that the bit STRIPE_OP_COMPUTE_BLK is set if only s->uptodate
> == disks - 1, however, suppose there is just a single read request, I
> fail to find out why this condition is satisfied.

If there is just one read for a block on a device that has failed,
then fetch_block5 will schedule read requests (Wantread) on all
the other devices.  Once all those reads complete Uptodate will
be set, so s->update will indeed equal disks - 1, and so
COMPUTE_BLK will get set.

NeilBrown

