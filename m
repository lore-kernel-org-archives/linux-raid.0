From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 0/2] Make it possible to disable create_on_open
 semantics.
Date: Wed, 12 Apr 2017 12:24:07 -0700
Message-ID: <20170412192407.3hxadmmtfgpsn2bc@kernel.org>
References: <149197804398.19936.12809382889200123725.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <149197804398.19936.12809382889200123725.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-raid.ids

On Wed, Apr 12, 2017 at 04:26:12PM +1000, Neil Brown wrote:
> Currently, opening an md /dev node will create the array object.
> This makes it hard to destroy the object as udev will typically
> re-open the device node when handling REMOVE events.
> 
> The "new_array" module parameter was created to work towards avoiding
> this problem, and it can be used when
>   CREATE names=yes
> 
> is given in /etc/mdadm.conf.
> How this doesn't currently support names like "md%d", which lots of
> people use and expect, so we need more work before we can transition
> away from create_on_open.
> 
> These patches add support to "new_array" so that md%d devices
> can be created.  This will make it, once again, possible to have
> md%d devices with numbers > 511. (3.17 make this impossible).
> 
> An enhancement to mdadm that uses this will cause new_array to always
> be used (where available), and we can then disable create_on_open
> completely (after suitable transition periods).

Thanks, applied! The md device creation interface especially create_on_open is
a disaster, hopefully the future sysfs/configfs interface deprecates all of these.

Thanks,
Shaohua
