From: Greg KH <greg@kroah.com>
Subject: Re: [klibc] Exporting which partitions to md-configure
Date: Mon, 30 Jan 2006 19:24:38 -0800
Message-ID: <20060131032438.GB8920@kroah.com>
References: <43DEB4B8.5040607@zytor.com> <20060131032133.GA8920@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060131032133.GA8920@kroah.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org, klibc list <klibc@zytor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jan 30, 2006 at 07:21:33PM -0800, Greg KH wrote:
> On Mon, Jan 30, 2006 at 04:52:08PM -0800, H. Peter Anvin wrote:
> > I'm putting the final touches on kinit, which is the user-space 
> > replacement (based on klibc) for the whole in-kernel root-mount complex. 
> >   Pretty much the one thing remaining -- other than lots of testing -- 
> > is to handle automatically mounted md devices.  In order to do that, 
> > without adding userspace versions of all the paritition code (which may 
> > be a future change, but a pretty big one) it would be good if the 
> > partition flag to auto-configure RAID was available in userspace, 
> > presumably through sysfs.
> 
> What are you looking for exactly?  udev has a great helper program,
> volume_id, that identifies any type of filesystem that Linux knows about
> (it was based on the ext2 lib code, but smaller, and much more sane, and
> works better.)
> 
> Would that help out here?

Oh, an example of it working:
	# vol_id /dev/sda3
	ID_FS_USAGE=filesystem
	ID_FS_TYPE=ext3
	ID_FS_VERSION=1.0
	ID_FS_UUID=9d2efd53-6b5a-4f84-86cc-def71269b7ca
	ID_FS_LABEL=
	ID_FS_LABEL_SAFE=
	# vol_id -t /dev/sda3
	ext3
	# vol_id -u /dev/sda3
	9d2efd53-6b5a-4f84-86cc-def71269b7ca

It also shows just the label if you have one set (I don't on this
disk...)

thanks,

greg k-h
