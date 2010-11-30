From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] FIX: chunk_size cannot be read by mdstat
Date: Tue, 30 Nov 2010 18:36:18 +1100
Message-ID: <20101130183618.54660849@notabene.brown>
References: <20101129095650.12551.98023.stgit@gklab-170-024.igk.intel.com>
	<20101130112211.700f5940@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D174C8A476@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D174C8A476@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Tue, 30 Nov 2010 07:28:01 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> In such case code: 
> 	a->info.array.chunk_size = mdstat->chunk_size;
> 
> from managemon.c, function manage_member() 
> has to be removed or guarded for 0 value of mdstat->chunk_size as it corrupts information in active array.
> 

Good point.  I have removed that assignment, and removed the chunk_size field
from mdstat_ent.

Thanks,
NeilBrown

