From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: ensure sectors is nonzero when change component size
Date: Fri, 13 Oct 2017 12:05:58 -0700
Message-ID: <20171013190558.svbyj35i7xtls4wr@kernel.org>
References: <1507797051-18545-1-git-send-email-zlliu@suse.com>
 <20171012173743.nocrm6ejov3pvhjd@kernel.org>
 <111b18f3-4db6-bf53-3a9f-15db452192ba@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <111b18f3-4db6-bf53-3a9f-15db452192ba@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

On Fri, Oct 13, 2017 at 10:47:29AM +0800, Zhilong Liu wrote:
> 
> 
> On 10/13/2017 01:37 AM, Shaohua Li wrote:
> > On Thu, Oct 12, 2017 at 04:30:51PM +0800, Zhilong Liu wrote:
> > > Against the raids which chunk_size is meaningful, the component_size
> > > must be >= chunk_size when require resize. If "new_size < chunk_size"
> > > has required, the "mddev->pers->resize" will set sectors as '0', and
> > > then the raids isn't meaningful any more due to mddev->dev_sectors is
> > > '0'.
> > > 
> > > Cc: Neil Brown <neilb@suse.com>
> > > Signed-off-by: Zhilong Liu <zlliu@suse.com>
> > Not sure about this, does size 0 disk really harm?
> > 
> 
> From my site, I think changing the component size as '0' should be avoided.
> When resize changing required and new_size < current_chunk_size, such as
> raid5:
> 
> raid5.c: raid5_resize()
> ...
> 7727         sectors &= ~((sector_t)conf->chunk_sectors - 1);
> ...
> 
> 'sectors' got '0'.
> 
> then:
> ...
> 7743         mddev->dev_sectors = sectors;
> ...
> 
> the dev_sectors(the component size) got '0'.
> same scenario happens in raid10.
> 
> So, it's really not meaningful if changing the raid component_size to '0',
> md
> should give this scenario a test, otherwise, it's a trouble thing to restore
> after
> doing such invalid re-size.

Yes, I understand how it could be 0. My question is what's wrong with a size-0
disk? For example, if you don't setup file for a loop block device, its size is
0.

Thanks,
Shaohua
