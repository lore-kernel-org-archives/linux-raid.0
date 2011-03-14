From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/3] UT and error case changes
Date: Tue, 15 Mar 2011 08:53:46 +1100
Message-ID: <20110315085346.3bf9feb7@notabene.brown>
References: <20110314140052.20478.45664.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110314140052.20478.45664.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Mon, 14 Mar 2011 15:09:20 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> The following series implements 2 changes:
> 1. Fix for unit tests failure.
> UT suits 12 and 13 fails, when backup file cannot be opened
> for grow operation (backup file exists already).

Thanks - applied.


> 
> 2. I've got proposal for handling/rollback metadata in error case.
> Currently in case of error external metadata can remain in reshape state.
> In some cases metadata can be automatically restored to initial state
> (i.e. metadata during  imsm container operation can be rolled back 
> when error occurs on first reshaped array before reshape is started).
> For such cases, additional superswitch function can be introduced.
> 
> Metadata shouldn't be rolled back in restart case.
> I'm passing restart flag to abort function in Grow.c only, as this is general rule.
> In the same way array reshape state is checked. 
> 
> This is proposal, so I've put no implementation in to imsm handler (no metadata update is created yet).
> Please let me know your opinion. If you will like it, I'll fill out gaps in imsm code.

I'm not sure.. it sounds like it might be a good idea, but I'd like to have
some concrete examples to help me think about it.

Do you have an example in mind of an error which might be detected after
the metadata has been updated, but before the reshape has actually started,
and for which reverting the metadata update is likely to be useful?

The more general case of changing your mind just after a reshape has 
started and asking the reshape to revert would certainly be useful, but
md isn't capable of that in general (yet).

Thanks,
NeilBrown

