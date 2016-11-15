From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH v6 03/11] md/r5cache: State machine for raid5-cache write
 back mode
Date: Mon, 14 Nov 2016 17:38:28 -0800
Message-ID: <20161115013828.GA17893@shli-mbp.local>
References: <20161110204623.3484694-1-songliubraving@fb.com>
 <20161110204623.3484694-4-songliubraving@fb.com>
 <20161115012221.5holqbeqi542k7pa@kernel.org>
 <E9BA3F38-D363-42CA-9360-B5CFF0F30671@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E9BA3F38-D363-42CA-9360-B5CFF0F30671@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: Shaohua Li <shli@kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids

On Tue, Nov 15, 2016 at 01:36:45AM +0000, Song Liu wrote:
> 
> > On Nov 14, 2016, at 5:22 PM, Shaohua Li <shli@kernel.org> wrote:
> > 
> >> The following detailed explanation is copied from the raid5-cache.c:
> >> 
> >> /*
> >> * raid5 cache state machine
> >> *
> >> * With rhe RAID cache, each stripe works in two modes:
> >> *      - caching mode
> >> *      - writing-out mode
> > 
> > 'mode' is quite confusing here. it always remainders me r5c_journal_mode. can
> > you use state?
> 
> I am not very sure whether state is the best name here. Maybe we can use "phase"?

sounds good
