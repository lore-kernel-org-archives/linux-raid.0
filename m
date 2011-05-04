From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: md question re: max_hw_sectors_kb
Date: Wed, 04 May 2011 13:58:05 -0400
Message-ID: <yq17ha6z6tu.fsf@sermon.lab.mkp.net>
References: <4DC0639E.1070707@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DC0639E.1070707@sgi.com> (Michael Reed's message of "Tue, 03
	May 2011 15:20:46 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, Jeremy Higdon <jeremy@sgi.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-raid.ids

>>>>> "Michael" == Michael Reed <mdr@sgi.com> writes:

Michael> There is code in blk_queue_make_request() which lowers the
Michael> default value from INT_MAX to BLK_SAFE_MAX_SECTORS, which is
Michael> 255.  This is generally lower than all the underlying devices
Michael> with which I use md.

Yeah, the SAFE value is there to appease legacy low-level drivers.


Michael> As md appears to be a stacking driver, i.e., it calls
Michael> disk_stack_limits() for each member of a volume, it would seem
Michael> reasonable for md to use the, INT_MAX setting for
Michael> max_hw_sectors_kb instead of BLK_SAFE_MAX_SECTORS.

Your fix is functionally correct. However, another case just popped up
this week where we need to distinguish between stacking driver and LLD
defaults. So I think we should try to handle this at the block layer
instead of explicitly tweaking this knob in MD.

I'll get this fixed up and will CC: you on the patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
