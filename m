From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] env-11spare-migration: imsm requires
 IMSM_NO_PLATFORM set with loop devices
Date: Mon, 31 Jan 2011 11:35:49 +1100
Message-ID: <20110131113549.4abeb2bb@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D17701BDEF@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D17701BDEF@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Fri, 28 Jan 2011 16:48:27 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> >From 45b5bfb78e1e46f58b7176ca6ba32c0228f41d33 Mon Sep 17 00:00:00 2001
> From: Marcin Labun <marcin.labun@intel.com>
> Date: Fri, 28 Jan 2011 17:22:11 +0100
> Subject: [PATCH 1/2] env-11spare-migration: imsm requires IMSM_NO_PLATFORM set with loop devices
> 
> By default IMSM checks if member device belongs to AHCI or ISCI controller.
> When using loop devices one must disable these checks by setting
> IMSM_NO_PLATFORM.
> 
> Signed-off-by: Marcin Labun <marcin.labun@intel.com>

Applied, thanks.

NeilBrown


> ---
>  tests/env-11spare-migration |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/tests/env-11spare-migration b/tests/env-11spare-migration
> index 7bf468d..d5eb76d 100644
> --- a/tests/env-11spare-migration
> +++ b/tests/env-11spare-migration
> @@ -1,9 +1,11 @@
>  setup_env() {
>         export IMSM_DEVNAME_AS_SERIAL=1
>         export IMSM_TEST_OROM=1
> +       export IMSM_NO_PLATFORM=1
>         }
>  
>  reset_env() {
>         unset IMSM_DEVNAME_AS_SERIAL
>         unset IMSM_TEST_OROM
> +       unset IMSM_NO_PLATFORM
>  }

