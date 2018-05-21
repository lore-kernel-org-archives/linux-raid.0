From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 00/13] convert block layer to bioset_init()/mempool_init()
Date: Mon, 21 May 2018 08:20:50 -0600
Message-ID: <dd30e115-f1c7-aa13-bb82-bffece8d07d7@kernel.dk>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180520222558.7053-1-kent.overstreet@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, colyli@suse.de, snitzer@redhat.com, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

On 5/20/18 4:25 PM, Kent Overstreet wrote:
> Jens - this series does the rest of the conversions that Christoph wanted, and
> drops bioset_create().
> 
> Only lightly tested, but the changes are pretty mechanical. Based on your
> for-next tree.

Looks good to me. I'll let it simmer for a bit to give folks a chance
to comment on it.

-- 
Jens Axboe
