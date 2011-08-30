From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 7/9] imsm: support 'missing' devices at Create
Date: Tue, 30 Aug 2011 12:26:34 +1000
Message-ID: <20110830122634.41d69592@notabene.brown>
References: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
	<20110826021434.28015.93967.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110826021434.28015.93967.stgit@localhost6.localdomain6>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, marcin.labun@intel.com, Dave Jiang <dave.jiang@intel.com>, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, 25 Aug 2011 19:14:35 -0700 Dan Williams <dan.j.williams@intel.com>
wrote:

> Specifying missing devices at create is very useful for array recovery.
> 
> For imsm create dummy disk entries at init_super_imsm time, and then use
> them to fill in unoccupied slots in the final array (if the container is
> unpopulated).
> 
> If the container is already populated (has a subarray)
> 'missing' disks must be in reference to already recorded missing devices
> in the metadata.

It would appear you have also implement --assume-clean:

> -	vol->dirty = 0;
> +	vol->dirty = !info->state;

Thanks - that has been bothering me.

I'll update the commit-log to record this.

Thanks,
NeilBrown
