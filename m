From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] fix: detect container early in Create
Date: Tue, 15 Feb 2011 09:37:57 +1100
Message-ID: <20110215093757.3a0ae2ad@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F01114985F2@irsmsx504.ger.corp.intel.com>
	<20110214095235.0fce04e9@notabene.brown>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F0111762445@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F0111762445@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Mon, 14 Feb 2011 11:19:24 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> Hi Neil,
> I can't fully agree with you. 
> Loading orom in validate_geometry_imsm is a good idea but
> it will only work when -e imsm option is given.
> When we have an imsm  container with sda and sdb and just call 
> mdadm -CR v0 -l 0 -n 2 /dev/sd[ab]
> then default geometry will not be called and chunk will still be set to 512.
> We need to realize that /dev/sda is already in an imsm container to get the correct setting.


OK.  How about we treat it the same way as 'layout'?
So if we set a default, we also set a var called 'do_default_chunk' and then
in the same places where we check do_default_layout, we also check
do_default_chunk and apply a similar st-specific default.

Longer term, I think I would like to check validate_geometry to pass
layout and chunksize by reference and if they are UnSet, validate_geometry
can set defaults.
Then we can get rid of ->default_geometry.

Thanks,
NeilBrown


