From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 10/12] btrfs: convert to bioset_init()/mempool_init()
Date: Wed, 30 May 2018 17:30:35 -0400
Message-ID: <630E6353-552E-433D-8022-D1FAA93B0209@fb.com>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
 <20180520222558.7053-11-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180520222558.7053-11-kent.overstreet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, colyli@suse.de, snitzer@redhat.com, darrick.wong@oracle.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

On 20 May 2018, at 18:25, Kent Overstreet wrote:

> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> ---
>  fs/btrfs/extent_io.c | 25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
>

Assuming the rest of the comments/questions for the series get worked 
out, the btrfs side of this looks fine.

Acked-by: Chris Mason <clm@fb.com>
