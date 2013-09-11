From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: change '%' to condition
Date: Wed, 11 Sep 2013 19:37:16 -0400
Message-ID: <20130911233716.GB23721@redhat.com>
References: <1373890837-3475-1-git-send-email-Jes.Sorensen@redhat.com>
 <1373890837-3475-67-git-send-email-Jes.Sorensen@redhat.com>
 <alpine.LRH.2.02.1307151445220.23929@file01.intranet.prod.int.rdu2.redhat.com>
 <wrfjfvvely2a.fsf@redhat.com>
 <alpine.LRH.2.02.1307201112210.2761@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1307201112210.2761@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>, Jes Sorensen <Jes.Sorensen@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, rhkernel-list@redhat.com
List-Id: linux-raid.ids

On Wed, Sep 11 2013 at  7:18pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> I think you should revert the patch 
> 4c0ca26bd260dddf3b9781758cb5e2df3f74d4a3 that did this change:
> 
>                 for (f = 1; f < geo->far_copies; f++) {
>                         d += geo->near_copies;
> -                       if (d >= geo->raid_disks)
> -                               d -= geo->raid_disks;
> +                       d %= geo->raid_disks;
>                         s += geo->stride;
>                         r10bio->devs[slot].devnum = d;
>                         r10bio->devs[slot].addr = s;
> 
> 
> On most processors, the divide and modulo operations are slower than a 
> possibly misprediteced branch or conditional move instruction.
> 
> So, replacing a condition with modulo doesn't make sense.
> 
> A benchmark on AMD K10 shows that mispredicted branch is 8.7 times faster 
> than a divide operation:
> 
>         for (i = 0; i < 10000000; i++) {
>                 q++;
>                 if (q >= 8)
>                         q -= 8;
>         }
> - 11607us (it compiles to cmov and runs at a rate of 3 ticks per 
> iteration)
> 
>         for (i = 0; i < 10000000; i++) {
>                 q++;
>                 q %= max;
>         }
> - 101241us (26 ticks per iteration)

Patch 68 in this series goes on to introduce more use of %= (upstream
commit 9a3152ab024867100f2f50d124b998d05fb1c3f6).

But regardless Jes' original point still stands: if this should be
changed it needs to be done upstream first.

Mike
