From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm GIT PULL] rebuild checkpoints, incremental assembly,
 volume delete/rename, and fixes
Date: Wed, 16 Jun 2010 16:33:43 +1000
Message-ID: <20100616163343.2c57de59@notabene.brown>
References: <1274921452.17973.253.camel@dwillia2-linux>
	<20100531113710.29e12d97@notabene.brown>
	<AANLkTimgVuEIkB2s9rra5QS11YMUSpvSkBOcbzza44LX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimgVuEIkB2s9rra5QS11YMUSpvSkBOcbzza44LX@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, Doug Ledford <dledford@redhat.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, marcin.labun@intel.com, linux-raid <linux-raid@vger.kernel.org>, dave.jiang@intel.com
List-Id: linux-raid.ids

On Thu, 10 Jun 2010 23:42:16 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> > I've merged and pushed out the other bits which all seem OK.  
> 
> Ok, there was one more you didn't comment on and didn't cherry-pick [2]
> 
> Dave Jiang (1):
>       create: Check with OROM limit before setting default chunk size
> 
> Thanks,
> Dan

I don't remember seeing that before - sorry.
It looks OK.  It might be nice to combine it with the ->default_layout
setting somehow, but that isn't necessary in the first instance.

Include it in the next pull request and I'll take it.

Thanks,
NeilBrown
