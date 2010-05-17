From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: RE: [PATCH 1/2] mdadm: Add takeover support for external meta
Date: Mon, 17 May 2010 14:33:18 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801D45296C@irsmsx503.ger.corp.intel.com>
References: <BE2BFE91933D1B4089447C64486040801B61C4B2@irsmsx503.ger.corp.intel.com>
 <AANLkTilbdHWxx_oaKthLRrF7UaiUP91PdGWgueRokGta@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTilbdHWxx_oaKthLRrF7UaiUP91PdGWgueRokGta@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

Hello Dan, 
thanks for the input.

> 
> This seems wrong... we should be checking with the metadata handler
> before allowing a level change to occur.  It's only luck that a
> raid5-to-raid6 conversion is currently broken by an inability to set
> stripe_cache_size.  So I would do the call to update_super() before
> the level is changed to give the handler a chance to abort
> orom/metadata incompatible level changes.
> 

Sure, but do you mean calling update_super() or rather validate_geometry() ?
Update_super() is called after kernel takeover...
So, maybe just before kernel level change we should check the metadata handler
(validate_geometry) to check current level capabilities...??

--
Maciek.
