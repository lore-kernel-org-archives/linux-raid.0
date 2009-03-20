From: Neil Brown <neilb@suse.de>
Subject: Re: [ md/for-next git pull ] Support setting the array size from
	userspace
Date: Fri, 20 Mar 2009 11:02:42 +1100
Message-ID: <18882.56610.951405.653376@notabene.brown>
References: <1237337937.4026.13.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Tuesday March 17
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Andre Noll <maan@systemlinux.org>, Jacek Danecki <jacek.danecki@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Tuesday March 17, dan.j.williams@intel.com wrote:
> The following changes since commit 28453471bcdd767f22b8c03987f1acd73a8f34c3:
>   Atsushi SAKAI (1):
>         md: fix typo in FSF address
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/md.git md-array-size
> 
> Dan Williams (3):
>       md: add 'size' as a personality method
>       md: centralize ->array_sectors modifications
>       md: 'array_size' sysfs attribute

Thanks again.

I like "strict_blocks_to_sectors".  I wonder if there would ever by
any value it allowing it to parse 2000000.5 as 4000001 sectors ???
Probably not.

I don't feel comfortable about md_set_array_sectors_lock.
It makes me think there is something wrong with the locking somewhere.

Maybe we should have an explicit "end_reshape" method which is called
under the lock by md_check_recovery.  That would seem more "obviously
right".
I cannot see any demonstrable problem with the current code so I'll
take it as it is, but I might add a patch along those lines.

Thanks,
NeilBrown
