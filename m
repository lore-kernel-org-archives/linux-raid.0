From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: RE: Devel 3.2 branch issues
Date: Fri, 26 Nov 2010 18:23:34 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010C009E36@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BF03CC6@irsmsx504.ger.corp.intel.com>
	<20101123115213.3664ec27@notabene.brown>
 <20101125190152.01d61cbd@notabene.brown>
 <A9DE54D0CD747C4CB06DCE5B6FA2246F010BF92E9D@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BF92E9D@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

> Well, this didn't help.
> In the set of tests I have just posted even the basic ones fail for
> imsm.
> For native there are still some problems with tests:
>  5c - spare not moved to degraded array in the same domain. This is
> really basic test with 4 arrays instead of 2.
>  9 - spare moved between different metadata arrays
> 13 - spare moved despite action=include which doesn't allow migration
> 
> Test9 run in scan mode generates a segmentation fault.
> 
> I will have a look at this in debugger and give you more info on the
> reasons later on.
> 
> Anna

After applying yesterday's fixes test5 and test9 don't fail any more for native.

Test6 often fails because Monitor keeps removing and re-adding spare
that is too small to add to degraded array. Test fails when we see it removed.

I have prepared few further fixes to address possible problems with Monitor
as described in each patch.

Spare migration works now also for imsm. (test12 and 13 still fail).
Test12 - two spares are taken when just one needed.
Test13 - action=include so spare should not be moved

Scan mode still needs to be investigated.

Anna
