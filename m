From: Song Liu <song@kernel.org>
Subject: Re: [PATCH] md: improve io stats accounting
Date: Tue, 2 Jun 2020 10:16:23 -0700
Message-ID: <CAPhsuW6JNjnGQg6BARGGzb+ohOrcLKaTvs4bAm60NzAwQ-svpw@mail.gmail.com>
References: <20200601161256.27718-1-artur.paszkiewicz@intel.com>
 <CAPhsuW4fjc4NgFGQUPuAKSvtWvtzyPor876anj64NF=nqaPo5g@mail.gmail.com> <26d5f5c7-9a20-e7f9-617f-0353c5d9bb2e@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <26d5f5c7-9a20-e7f9-617f-0353c5d9bb2e@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jun 2, 2020 at 4:47 AM Artur Paszkiewicz
<artur.paszkiewicz@intel.com> wrote:
>
> On 6/2/20 8:48 AM, Song Liu wrote:
> >> +               clone = bio_clone_fast(bio, GFP_NOIO, &mddev->md_io_bs);
> >
> > Handle clone == NULL?
>
> I think this should never fail - bio_alloc_bioset() guarantees that. It
> is used in a similar manner in raid1 and raid10. How about
> BUG_ON(clone == NULL)?

I misread the code. Current version is fine.

>
> > Also, have you done benchmarks with this change?
>
> I tested 4k random reads on a raid0 (4x P4510 2TB) and it was 2550k vs
> 2567k IOPS, that's slower only by about 0.66%:

Thanks for the test. I will do some more tests and process the patch
after the merge
window.

Song
