From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: Badstripe proposal (was Re: Bad blocks are killing us!)
Date: Thu, 18 Nov 2004 10:29:05 +0000
Message-ID: <419C7971.6090902@robinbowes.com>
References: <200411162307.iAGN7lN28260@www.watkins-home.com> <419B5050.1010501@dgreaves.com> <419C729D.3E36A473@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <419C729D.3E36A473@libero.it>
Sender: linux-raid-owner@vger.kernel.org
To: Maurilio Longo <maurilio.longo@libero.it>
Cc: David Greaves <david@dgreaves.com>, Guy <bugzilla@watkins-home.com>, 'Neil Brown' <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org, dean-list-linux-raid@arctic.org
List-Id: linux-raid.ids

Maurilio Longo wrote:
> David and others,
> 
> I'd like to add that evms ( http://evms.sourceforge.net/ ) already has a
> bad-block management layer, maybe it could be merged inside md to have write
> errors management as well, maybe :)

Good point.

When I set up my RAID (albeit a relatviely non-critical domestic system) 
I considered whether or not to use EVMS because of the bad block 
relocation feature.

In the end, I went with md, lvm2, and mdadm, primarily as I recall 
because at the time EVMS did not support lvm2 and also required 
additional kernel patches to support bad block relocation. Plus, there 
were issues about having the root filesystem managed by EVMS (it 
requires the set up of a custom initrd).

All things considered, I chose the path of least resistance and went 
with md/lvm2/mdadm. Perhaps it's time to reconsider that and look at 
EVMS again?

R.
-- 
http://robinbowes.com
