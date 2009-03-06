From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 2.6.29-rc7] md: fix deadlock when stopping arrays
Date: Fri, 6 Mar 2009 16:27:46 +1100
Message-ID: <18864.46162.353471.534054@notabene.brown>
References: <20090305230615.9122.62640.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Thursday March 5
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, jacek.danecki@intel.com
List-Id: linux-raid.ids

On Thursday March 5, dan.j.williams@intel.com wrote:
> Resolve a deadlock when stopping redundant arrays, i.e. ones that
> require a call to sysfs_remove_group when shutdown.  The deadlock is
> summarized below:
> 
> Thread1                Thread2
> -------                -------
> read sysfs attribute   stop array
>                        take mddev lock
>                        sysfs_remove_group
> sysfs_get_active
> wait for mddev lock
>                        wait for active

Thanks.

It's pretty sneaking overloading ->private to let mddev_delayed_delete
know that it has something else to do ... wish I'd thought of it :-)

Can you add 
   Cc: stable@kernel.org
at the bottom.  Then I'll pull it and send a pull request to Linus.  I
think it should go straight in.

[If a commit contains "cc: stable@kernel.org" then the "stable team"
will automatically notice it as soon as Linus pulls it - no need to
bother them with extra email.]

Thanks.
NeilBrown
