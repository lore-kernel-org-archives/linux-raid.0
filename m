From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 23/60] block: introduce flag QUEUE_FLAG_NO_MP
Date: Sat, 29 Oct 2016 08:29:33 -0700
Message-ID: <20161029152933.GA17241@infradead.org>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
 <1477728600-12938-24-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1477728600-12938-24-git-send-email-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.de>, Dan Williams <dan.j.williams@intel.com>, Toshi Kani <toshi.kani@hpe.com>, shli@kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Oct 29, 2016 at 04:08:22PM +0800, Ming Lei wrote:
> MD(especially raid1 and raid10) is a bit difficult to support
> multipage bvec, so introduce this flag for not enabling multipage
> bvec, then MD can still accept singlepage bvec only, and once
> direct access to bvec table in MD and other fs/drivers are cleanuped,
> the flag can be removed. BTRFS has the similar issue too.

There is really no good reason for that.  The RAID1 and 10 code really
just needs some love to use the bio cloning infrastructure, bio
iterators and generally recent bio apis.  btrfs just needs a tiny little
bit of help and I'll send patches soon.

Having two different code path is just asking for trouble in the long
run.
