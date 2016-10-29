From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 23/60] block: introduce flag QUEUE_FLAG_NO_MP
Date: Sun, 30 Oct 2016 06:20:09 +0800
Message-ID: <CACVXFVPVW0YJ1+X_EhHAbt1zxF6BWqgmjOM_VRdzyLTJNxJWTw@mail.gmail.com>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
 <1477728600-12938-24-git-send-email-tom.leiming@gmail.com> <20161029152933.GA17241@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161029152933.GA17241@infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.de>, Dan Williams <dan.j.williams@intel.com>, Toshi Kani <toshi.kani@hpe.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Oct 29, 2016 at 11:29 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sat, Oct 29, 2016 at 04:08:22PM +0800, Ming Lei wrote:
>> MD(especially raid1 and raid10) is a bit difficult to support
>> multipage bvec, so introduce this flag for not enabling multipage
>> bvec, then MD can still accept singlepage bvec only, and once
>> direct access to bvec table in MD and other fs/drivers are cleanuped,
>> the flag can be removed. BTRFS has the similar issue too.
>
> There is really no good reason for that.  The RAID1 and 10 code really
> just needs some love to use the bio cloning infrastructure, bio
> iterators and generally recent bio apis.  btrfs just needs a tiny little
> bit of help and I'll send patches soon.

That is very nice of you to do this cleanup, cool!

I guess it still need a bit time, and hope that won't be the block
for the whole patchset, :-)

[linux-2.6-next]$git grep -n -E "bi_io_vec|bi_vcnt" ./fs/btrfs/ | wc -l
45

[linux-2.6-next]$git grep -n -E "bi_io_vec|bi_vcnt" ./drivers/md/ |
grep raid | wc -l
54

>
> Having two different code path is just asking for trouble in the long
> run.

Definitely, that flag is introduced just as a short-term solution.

Thanks,
Ming Lei
