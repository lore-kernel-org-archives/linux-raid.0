From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: RE: [md PATCH 2/5]  md: Enable reshape for external metadata
Date: Thu, 17 Jun 2010 10:40:36 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801E8E686C@irsmsx503.ger.corp.intel.com>
References: <905EDD02F158D948B186911EB64DB3D11EECE8A2@irsmsx503.ger.corp.intel.com>
	<20100616145343.1fc13b4c@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D11F2FF471@irsmsx503.ger.corp.intel.com>
 <20100617161135.73a377a0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100617161135.73a377a0@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

> 
> >
> > Another thing is waiting during reshape for metadata update on
> MD_CHANGE_DEVS flag.
> > To roll reshape I've added the following code (instead calling
> md_ubdate_sb()):
> 
> Yes, there is a real issue there...
> 
> I don't think we ever need the kernel to wait for an external metadata
> handler
> to respond to device changes (apart from failure which is handled
> separately).
> So maybe the best thing is to guard all settings of MD_CHANGE_DEVS with
> if (mddev->persistent)
> 
> I think that would be best, but I've make a note to review that later.
> 

Neil,
from what I see in the raid5.c/md.c "native" code uses MD_CHANGE_DEVS
during the reshape if it reaches special points when metadata
write is really needed to update the reshape checkpoint.
In reshape_request():
	/* Cannot proceed until we've updated the superblock */
	..
	set_bit(MD_CHANGE_DEVS, mddev->flags)

In md_check_recovery() we have:
	if (mddev->flags) 
		md_update_sb()

Couldn't we follow this logic with MD_CHANGE_DEVS for external metadata?
If not, how to detect the need for migration checkpoint update?

Thanks,
Maciek

