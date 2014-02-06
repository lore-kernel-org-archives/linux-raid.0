From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: raid1 repair does not repair errors?
Date: Thu, 6 Feb 2014 15:21:32 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1402061519440.24915@uplift.swm.pp.se>
References: <52EE3910.3040205@msgid.tls.msk.ru> <20140203120431.400a8a1b@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140203120431.400a8a1b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 3 Feb 2014, NeilBrown wrote:

> We only try to fix a read error when all reads failed rather than when any
> read fails.
> Most of the time there is only one read so this makes no difference.
> However for 'check' and 'repair' we read all devices so the current code will
> only try to repair a read error if *every*  device failed, which of course
> would be pointless.

Is this the same problem I hit and documented in my thread a few weeks 
back? ("read errors not corrected when doing check on RAID6")

Is the same problem is valid for RAID6 as well and it fixes that as well?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
