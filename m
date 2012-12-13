From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: [PATCH 1/2] lib/raid6: Add AVX2 optimized gen_syndrome functions
Date: Thu, 13 Dec 2012 16:56:07 +0800
Message-ID: <20121213085607.GA2095@yliu-dev.sh.intel.com>
References: <1354309840-9360-1-git-send-email-james.t.kukunas@linux.intel.com>
 <20121213083509.GZ2095@yliu-dev.sh.intel.com>
 <20121213195317.540c55b4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121213195317.540c55b4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>, Linux Raid <linux-raid@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-raid.ids

On Thu, Dec 13, 2012 at 07:53:17PM +1100, NeilBrown wrote:
> On Thu, 13 Dec 2012 16:35:09 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
> wrote:
> 
> > On Fri, Nov 30, 2012 at 01:10:39PM -0800, Jim Kukunas wrote:
> > > From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > > 
> > > Add AVX2 optimized gen_syndrom functions, which is simply based on
> > > sse2.c written by hpa.
> > > 
> > > Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > > Reviewed-by: H. Peter Anvin <hpa@zytor.com>
> > > Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
> > > ---
> > >  include/linux/raid/pq.h |   3 +
> > >  lib/raid6/Makefile      |   2 +-
> > >  lib/raid6/algos.c       |   9 ++
> > >  lib/raid6/avx2.c        | 251 ++++++++++++++++++++++++++++++++++++++++++++++++
> > >  lib/raid6/test/Makefile |  12 ++-
> > >  5 files changed, 275 insertions(+), 2 deletions(-)
> > >  create mode 100644 lib/raid6/avx2.c
> > 
> > Hi Neil,
> > 
> > Ping...
> 
> Ahh ..... yeah ... sorry...
> 
> Applied.

Thanks!

	--yliu
