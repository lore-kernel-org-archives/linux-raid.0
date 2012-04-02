From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: RE: [PATCH 1/6] imsm: avoid overflows for disks over 1TB
Date: Mon, 2 Apr 2012 07:51:06 +0000
Message-ID: <3F8F31A3BFD1664EAB894D1BD6AF32B918A20EF7@IRSMSX102.ger.corp.intel.com>
References: <3F8F31A3BFD1664EAB894D1BD6AF32B918A205CE@IRSMSX102.ger.corp.intel.com>
 <20120402101455.189f614e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120402101455.189f614e@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids


> > @@ -984,7 +1050,8 @@ static __u32 imsm_min_reserved_sectors(struct
> intel_super *super)
> >  {
> >  	struct extent *e;
> >  	int i;
> > -	__u32 min_active, remainder;
> > +	unsigned long long min_active;
> > +	__u32 remainder;
> 
> I'm a bit concerned that 'remainder' is still a '__u32'.  It is
> calculated as
> the difference of two 'unsigned long long'....
> I'll take the patch as is, but you might like to fix this up.

Remainder here will always be small as it is just the size of metadata.
get_extents makes sure the last extent starts close to the end of the disk.

> 
> Applied.
> 
> Thanks,
> NeilBrown

Regards
Anna
