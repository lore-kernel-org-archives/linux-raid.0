From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH 000 of 2] md: Introduction - bugfixes for md/raid{1,10}
Date: Tue, 12 Jun 2007 13:04:46 -0400
Message-ID: <466ED22E.8050506@tmr.com>
References: <20070612110634.25171.patches@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070612110634.25171.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Mike Accetta <maccetta@laurelnetworks.com>, stable@kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> Following are a couple of bugfixes for raid10 and raid1.  They only
> affect fairly uncommon configurations (more than 2 mirrors) and can
> cause data corruption.  Thay are suitable for 2.6.22 and 21-stable.
>
> Thanks,
> NeilBrown
>
>
>  [PATCH 001 of 2] md: Fix two raid10 bugs.
>  [PATCH 002 of 2] md: Fix bug in error handling during raid1 repair.

I don't know about uncommon, given that I have six machines in this 
building with three way RAID-1 for the boot partition, to be sure I can 
get off the ground enough to get the other partitions up.

And since you added "write-mostly" for remote mirrors I do have a few 
systems doing >2 mirrors as well. This set of patches definitely will be 
in my kernel by this afternoon.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

