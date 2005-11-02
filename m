From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH md 004 of 10] Fix some locking and module refcounting issues with md's use of sysfs.
Date: Wed, 2 Nov 2005 13:47:22 -0800
Message-ID: <20051102214722.GF23247@kroah.com>
References: <20051102205640.22689.patches@notabene> <1051102101510.23887@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1051102101510.23887@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 02, 2005 at 09:15:10PM +1100, NeilBrown wrote:
> 
> 1/ I really should be using the __ATTR macros for defining attributes, so
>  that the .owner field get set properly, otherwise modules can be removed
>  while sysfs files are open.
>  This also involves some name changes of _show routines.
> 
> 2/ Always lock the mddev (against reconfiguration) for all sysfs
>  attribute access.  This easily avoid certain races and is completely
>  consistant with other interfaces (ioctl and /proc/mdstat both 
>  always lock against reconfiguration).
> 
> 3/ raid5 attributes must check that the 'conf' structure actually 
>   exists (the array could have been stopped while an attribute file
>   was open).
> 
> 4/ A missing 'kfree' from when the raid5_conf_t was converted to have
>   a kobject embedded, and then converted back again.
> 
> 
> 
> Signed-off-by: Neil Brown <neilb@suse.de>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
