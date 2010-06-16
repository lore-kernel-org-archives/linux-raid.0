From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: RE: [PATCH 3/3] md: fix invalid dev slots after takeover
Date: Wed, 16 Jun 2010 11:33:34 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801E873EBC@irsmsx503.ger.corp.intel.com>
References: <BE2BFE91933D1B4089447C64486040801E8734B6@irsmsx503.ger.corp.intel.com>
 <20100616144008.5b404e54@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100616144008.5b404e54@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Wednesday, June 16, 2010 6:40 AM
> To: Trela, Maciej
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed
> Subject: Re: [PATCH 3/3] md: fix invalid dev slots after takeover
> 
> On Tue, 15 Jun 2010 09:36:36 +0100
> "Trela, Maciej" <Maciej.Trela@intel.com> wrote:
> 
> > From: Maciej Trela <maciej.trela@intel.com>
> >
> > While raid10->raid0 takeover incorrect slot numbers are set for
> raid0. This was caused by invalidating dev slot numbers before calling
> pers->run(). We are invalidating all devs that has (rdev->raid_disk >=
> mddev->raid_disks) but rdev->raid_disk numbers are scaled in pers-
> >run().
> >
> > Another option to fix the problem:
> > If invalidating devs should rather be performed before run() we could
> use devlist[index] for invalidating - devlist is already updated after
> calling takeover...
> 
> Thanks.  I see the problem but don't really like the fix.
> 
> I propose the following (Which includes the 2/3 patch - all part of the
> same
> big problem really).
> 


It looks good to me. ports and sysfs links are updating correctly now.

While testing the patch I've found two minor issues/enhancements for takeover.
I'll sent them in a minute along with reworked 1/3 "new_layout" fix.

Maciek.

