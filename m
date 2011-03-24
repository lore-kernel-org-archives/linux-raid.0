From: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Subject: RE: [PATCH] FIX: imsm: Do not change serial if disk failed
Date: Thu, 24 Mar 2011 15:42:38 +0000
Message-ID: <BE2BFE91933D1B4089447C6448604080823B18CC@irsmsx503.ger.corp.intel.com>
References: <20110323163629.15574.93174.stgit@gklab-128-111.igk.intel.com>
 <20110324101745.524e90e2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110324101745.524e90e2@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Thursday, March 24, 2011 12:18 AM
> To: Wojcik, Krzysztof
> Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech; Kwolek, Adam;
> Williams, Dan J; Ciechanowski, Ed
> Subject: Re: [PATCH] FIX: imsm: Do not change serial if disk failed
> 
> That was my last remaining issue before I'm comfortable releasing
> mdadm-3.2.1
> Does Intel have anything concerns about releasing the current code as
> mdadm-3.2.1?

Neil,

We have only two patches for test suite. Anna will sent them today.
After applying this, we are ready to 3.2.1 release.

Regards
Krzysztof

> 
> Thanks,
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
