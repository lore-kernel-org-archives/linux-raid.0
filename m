From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Possible to rescue SW Raid5 with 2 missing Disks
Date: Fri, 15 Feb 2013 12:23:36 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302151220060.32644@uplift.swm.pp.se>
References: <20130214213908.282850@gmx.net> <alpine.DEB.2.00.1302151055500.32644@uplift.swm.pp.se> <511E1890.6060708@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511E1890.6060708@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 15 Feb 2013, Brad Campbell wrote:

> To the point I've been ready to submit a patch for --assume-clean along 
> the lines of what hdparm does and makes you also attach 
> --please-destroy-my-disk before it'll work.

Yes, I think this is an excellent idea. It should have 
--please-destroy-my-disk, and if there are existing superblocks, it should 
save the contents of mdadm --examine before overwriting or zero:ing them.

--assemble --force should list the drive event count and say which drives 
have differing event counts and ask for confirmation that this is really 
what the operator wants to do. If the event count differs more than 50 (or 
some other value), there should be a requirement for 
--please-destroy-my-array to be added :P

> --assume-clean is great for those that need it, but for the great majority 
> who rely on google and wikis it's a data-destroyer.

I agree.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
