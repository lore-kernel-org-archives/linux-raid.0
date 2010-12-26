From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 0/5] Autorebuild, spare/spare-same-slot fixes
Date: Sun, 26 Dec 2010 22:40:19 +1100
Message-ID: <20101226224019.33daa533@notabene.brown>
References: <20101223155614.5562.4773.stgit@gklab-170-211.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101223155614.5562.4773.stgit@gklab-170-211.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, 23 Dec 2010 17:02:00 +0100 Przemyslaw Czarnowski
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:

> The following series changes (improves) behaviors implemented so far in 
> Incremental for bare disks.
> It enables some features for containers working so far only for native
> metadata (size check and degradation) and fixes domain checking for 
> "same slot" action.
> 
> ---
> 
> Przemyslaw Czarnowski (5):
>       external: get number of failed disks for container
>       Added test for array degradation for spare-same-slot
>       Skip domain check for spare-same-slot
>       Validate size of potential spare disk for external metadata (with containers)
>       Consider target only for spare-same-domain
> 

Thanks. All of these applied, with one changes as I described separately.

NeilBrown
