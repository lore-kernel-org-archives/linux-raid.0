From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC 1/2] MD: raid5 trim support
Date: Wed, 9 May 2012 11:12:32 +0800
Message-ID: <20120509031232.GA507@kernel.org>
References: <CABE8wwswKWQ=LDbx0ysTaZf2Hz0jD_q45FNF0jw96ZwZdJiHPw@mail.gmail.com>
 <20120418062641.000e881c@notabene.brown>
 <4F8E11A6.7090305@kernel.org>
 <20120418144841.04ce1a10@notabene.brown>
 <4F8E5185.8050809@kernel.org>
 <20120418155749.4afae9cb@notabene.brown>
 <4F8E605C.9090803@kernel.org>
 <20120425034307.GA454@kernel.org>
 <20120508101653.GA9757@kernel.org>
 <CABE8wwtZKrerxq4OFGnjUOgjvRb-6FNWdgUkiVwUVuV-uycv6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CABE8wwtZKrerxq4OFGnjUOgjvRb-6FNWdgUkiVwUVuV-uycv6Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, axboe@kernel.dk, Shaohua Li <shli@fusionio.com>
List-Id: linux-raid.ids

On Tue, May 08, 2012 at 08:52:07AM -0700, Dan Williams wrote:
> On Tue, May 8, 2012 at 3:16 AM, Shaohua Li <shli@kernel.org> wrote:
> >> > Writing the parity disk is worse. Discard is to improve the garbage
> >> > collection
> >> > of SSD firmware, so improve later write performance. While write is bad for
> >> > SSD, because SSD can be wear leveling out with extra write and also write
> >> > increases garbage collection overhead. So the result of small
> >> > discard is data
> >> > disk garbage collection is improved but parity disk gets worse and
> >> > parity disk
> >> > gets fast to end of its life, which doesn't make sense. This is even
> >> > worse when
> >> > the parity is distributed.
> >> Neil,
> >> Any comments about the patches?
> > ping!
> >
> 
> So, are we still in the position of needing to degrade individual
> stripes to support trim?  Is there any benefit to making this a
> temporary condition?  I.e. trim large ranges, including the parity
> disk, and then once all the trim sequences have coalesced resync the
> stripes that remain only partially trimmed?

Yes, we need trim a whole stripe one time. This is the best I can do now.
resync involves write and I don't want to do any unnecessary write, because
trim is to improve ssd firmware garbage collection while write goes to the
oppositive and makes flash wear out faster.

Or your suggestion is if a trim is small (for example, only covers one disk),
we don't do trim immediately but just record it in bitmap. Later if the small
trim can be coalesced to one strip, trim the strip. This is optimal but
involves disk format change. And to make it efficient, we need track 4kB range.
From Neil's blog, there isn't such space left.

Thanks,
Shaohua
