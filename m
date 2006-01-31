From: Greg KH <greg@kroah.com>
Subject: Re: [klibc] Exporting which partitions to md-configure
Date: Mon, 30 Jan 2006 19:21:33 -0800
Message-ID: <20060131032133.GA8920@kroah.com>
References: <43DEB4B8.5040607@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43DEB4B8.5040607@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org, klibc list <klibc@zytor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jan 30, 2006 at 04:52:08PM -0800, H. Peter Anvin wrote:
> I'm putting the final touches on kinit, which is the user-space 
> replacement (based on klibc) for the whole in-kernel root-mount complex. 
>   Pretty much the one thing remaining -- other than lots of testing -- 
> is to handle automatically mounted md devices.  In order to do that, 
> without adding userspace versions of all the paritition code (which may 
> be a future change, but a pretty big one) it would be good if the 
> partition flag to auto-configure RAID was available in userspace, 
> presumably through sysfs.

What are you looking for exactly?  udev has a great helper program,
volume_id, that identifies any type of filesystem that Linux knows about
(it was based on the ext2 lib code, but smaller, and much more sane, and
works better.)

Would that help out here?

thanks,

greg k-h
