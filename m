From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 3/3] imsm: FIX: UT '08imsm-overlap' fails
Date: Tue, 20 Dec 2011 08:02:50 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A061915@IRSMSX101.ger.corp.intel.com>
References: <20111214150448.21483.16231.stgit@gklab-128-013.igk.intel.com>
	<20111214150720.21483.27249.stgit@gklab-128-013.igk.intel.com>
	<CABE8wwt44LbrKEGJjoUyjOt5zDP2=uO60hVPYfWpxMHi+EuQwg@mail.gmail.com>
	<20111215150314.7e5694c7@notabene.brown>
	<CABE8wwvfzxM1e2S7XOotMHWT40JF6sbRH3mW688dpuWmwoCtZQ@mail.gmail.com>
	<79556383A0E1384DB3A3903742AAC04A060EEA@IRSMSX101.ger.corp.intel.com>
	<CABE8wwu1RNQsHPHZ7xWNsQ6-qym4LHQjsnf+LT8qrZpdHkQ-Hg@mail.gmail.com>
	<79556383A0E1384DB3A3903742AAC04A061319@IRSMSX101.ger.corp.intel.com>
 <20111220103845.0b9ae8e2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111220103845.0b9ae8e2@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Tuesday, December 20, 2011 12:39 AM
> To: Kwolek, Adam
> Cc: Williams, Dan J; Labun, Marcin; Ciechanowski, Ed; linux-
> raid@vger.kernel.org
> Subject: Re: [PATCH 3/3] imsm: FIX: UT '08imsm-overlap' fails
> 
> On Fri, 16 Dec 2011 08:32:07 +0000 "Kwolek, Adam"
> <adam.kwolek@intel.com>
> wrote:
> 
> 
> > I've checked, you are right. OROM check will resolve problem.
> > Do you post your patch or I should do it? We are short of time
> > regarding Neil's plans about v3.2.3
> >
> >
> 
> I've created a commit myself.  See below.


Thanks :)

> 
> Thanks,
> NeilBrown
> 
> From 5fe62b9455b6b43f050f3a52610ce1048a44623c Mon Sep 17 00:00:00
> 2001
> From: "Williams, Dan J" <dan.j.williams@intel.com>
> Date: Wed, 14 Dec 2011 18:21:07 -0800
> Subject: [PATCH] imsm: FIX: UT '08imsm-overlap' fails
> 
> Make test for all sub arrays having the same number of devices dependant
> on the option ROM requirements being checked.
> 08imsm-overlap disables the OROM check but then fails because this test
> causes it to.
> 
> Reported-by: Adam Kwolek <adam.kwolek@intel.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/super-intel.c b/super-intel.c index 9074485..0e77537 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5314,12 +5314,6 @@ static int validate_geometry_imsm_volume(struct
> supertype *st, int level,
> 
>  	mpb = super->anchor;
> 
> -	if (mpb->num_raid_devs > 0 && mpb->num_disks != raiddisks) {
> -		fprintf(stderr, Name ": the option-rom requires all "
> -			"member disks to be a member of all volumes.\n");
> -		return 0;
> -	}
> -
>  	if (!validate_geometry_imsm_orom(super, level, layout, raiddisks,
> chunk, verbose)) {
>  		fprintf(stderr, Name ": RAID gemetry validation failed. "
>  			"Cannot proceed with the action(s).\n"); @@ -5398,6
> +5392,11 @@ static int validate_geometry_imsm_volume(struct supertype
> *st, int level,
>  		fprintf(stderr, Name ": The option-rom requires all member"
>  			" disks to be a member of all volumes\n");
>  		return 0;
> +	} else if (super->orom && mpb->num_raid_devs > 0 &&
> +		   mpb->num_disks != raiddisks) {
> +		fprintf(stderr, Name ": The option-rom requires all member"
> +			" disks to be a member of all volumes\n");
> +		return 0;
>  	}
> 
>  	/* retrieve the largest free space block */
