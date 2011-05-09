From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/5] imsm support for raid0->raid5 migration
Date: Mon, 9 May 2011 12:03:28 +1000
Message-ID: <20110509120328.75e5b2a7@notabene.brown>
References: <20110504151011.24386.14976.stgit@gklab-128-081.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110504151011.24386.14976.stgit@gklab-128-081.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Wed, 04 May 2011 17:10:33 +0200 Przemyslaw Czarnowski
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:

> Migration r0->r5 once again; with a fix comming from your comment.
> 
> The following series implements support for raid0->raid5 migration for IMSM
> metadata. These patches blocks opposite direction of migration.
> Code mostly bases on patches sent to you by Adam Kwolek. I have incorporated
> your remarks and I tested it quite extensively for comformity with IMSM
> standard. I have also removed opposite direction, as it is just not supported
> right now.
> 
> Note:
> Please do not include these patches on 'master' branch, as they are supposed
> to be a part of next minor mdadm version (ie. mdadm 3.2.2). I think good place
> for it is devel-3.2. Master should be reserved just for bug/stability fixes
> for previous release.

I have applied these patches, and in fact I have applied them to 'master'
because that if where I think they belong.  Eventually 3.2.2 will be whatever
is on 'master' at that time.

I might create a devel-3.3 at some stage to do some brand new development,
but these patches are just a continuation of what went into 3.2 and 3.2.1 so
I think this is where they belong.

Thanks,
NeilBrown

> ---
> 
> Przemyslaw Czarnowski (5):
>       imsm: prepare update for level migrations reshape
>       imsm: fix: disable migration from raid5->raid0
>       imsm: prepare memory for level migration update
>       imsm: process update for raid level migrations
>       imsm: add new chunk size to metadata update
> 
> 
>  super-intel.c |  337 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 330 insertions(+), 7 deletions(-)
> 

