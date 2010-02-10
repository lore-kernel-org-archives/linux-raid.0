From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 4/4] md: Enable takeover for external metadata
Date: Wed, 10 Feb 2010 16:57:10 +1100
Message-ID: <20100210165710.11493bc5@notabene.brown>
References: <F2A46F4A087B8547923AD59C289DC90E01D16228@irsmsx002.ger.corp.intel.com>
	<20100201110829.5516c80e@notabene.brown>
	<F2A46F4A087B8547923AD59C289DC90E01DCD389@irsmsx002.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F2A46F4A087B8547923AD59C289DC90E01DCD389@irsmsx002.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Trela, Maciej" <Maciej.Trela@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Wed, 3 Feb 2010 12:29:53 +0000
"Trela, Maciej" <Maciej.Trela@intel.com> wrote:

> 
> This is one more patch for md takeover that was accidentally skipped while sending...
> Please, apply it together with the rest of md takeover patches.
> 
> Now md will notify mdmon about the level change.
> Also sysfs redundancy_group specific to non-raid0 is now handled when switching personalities.
> 


Thanks for these.

You should get into the habit of checking your patches
with ./scripts/checkpatch.pl.  There was lots of stray white space and
various other issues.  I have fixed them.  You can find the current patches
in my "md-scatch" branch:
  http://neil.brown.name/git?p=md;a=shortlog;h=refs/heads/md-scratch

I also fixed some other little issues like the fact that you don't want to
set ->delta_disks when converting between RAID0 and RAID5.

I think there are still some issues with error handling if kzalloc fails
while allocating the new 'private' structures.   I'll have another run
through the patches in a few days and see what else I can fix it.

I seem to have misplaced the mdadm patches.  If you would like to send those
again I will have a look and possibly apply them.

Thanks,
NeilBrown
