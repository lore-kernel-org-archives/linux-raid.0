From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] enable auto=yes by default when using udev
Date: Mon, 3 Jul 2006 09:14:38 +1000
Message-ID: <17576.21342.685662.432117@cse.unsw.edu.au>
References: <20060702224549.GD12733@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Luca Berra on Monday July 3
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday July 3, bluca@comedia.it wrote:
> Hello,
> the following patch aims at solving an issue that is confusing a lot of
> users.
> when using udev, device files are created only when devices are
> registered with the kernel, and md devices are registered only when
> started.
> mdadm needs the device file _before_ starting the array.
> so when using udev you must add --auto=yes to the mdadm commandline or
> to the ARRAY line in mdadm.conf
> 
> following patch makes auto=yes the default when using udev
> 

The principle I'm reasonably happy with, though you can now make this
the default with a line like

  CREATE auto=yes
in mdadm.conf.

However....

> +
> +	/* if we are using udev and auto is not set, mdadm will almost
> +	 * certainly fail, so we force it here.
> +	 */
> +	if (autof == 0 && access("/dev/.udevdb",F_OK) == 0)
> +		autof=2;
> +

I'm worried that this test is not very robust.
On my Debian/unstable system running used, there is no
 /dev/.udevdb
though there is a
 /dev/.udev/db

I guess I could test for both, but then udev might change
again.... I'd really like a more robust check.

Maybe I could test if /dev was a mount point?

Any other ideas?

NeilBrown
