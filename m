From: "kyle" <kylewong@southa.com>
Subject: Re: questions about ext3, raid-5, small files and wasted disk space
Date: Mon, 14 Nov 2005 11:47:19 +0800
Message-ID: <003901c5e8ce$1d1c0610$b7df0f3d@kyleont8n3poyo>
References: <000901c5e6ff$0865deb0$b7df0f3d@kyleont8n3poyo> <17269.54844.139.18467@cse.unsw.edu.au>
Reply-To: "kyle" <kylewong@southa.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I understand now, thanks. RAID is more low level than filesystem, working at
block device level, parity doesn't related to filesystem and file size at
all, right?

----- Original Message ----- 
From: "Neil Brown" <neilb@suse.de>
To: "kyle" <kylewong@southa.com>
Cc: <linux-raid@vger.kernel.org>
Sent: Saturday, November 12, 2005 7:47 PM
Subject: Re: questions about ext3, raid-5, small files and wasted disk space


> On Saturday November 12, kylewong@southa.com wrote:
> > Hi,
> >
> > Assume I want to build a 8 x 250GB disks RAID-5, totally around 1.7TB,
with
> > ext3 file system, 4KB block size, and 32KB chunk size.
>
> Sounds like a reasonable configuration.
>
> >
> > Almost half of the files will be very small ( < 8KB), I'm quite confused
> > with how RAID-5 store data so I want to understand how relation between
file
> > system block size and RAID5 chunk size, to minimize possible wasted
> > space.
>
> RAID-5 will always use one drive worth of space for parity.  It
> doesn't matter at all how the filesystem arranges data.
> So in your config, the filesystem will appear to be about 1.7TB, and
> you will have access to all of that space (or all that the file system
> will allow you).
>
> >
> > I understand that if I store a 224KB file into the RAID5, the file will
be
> > divided into 7 parts x 32KB, plus 32KB parity. (Am I correct in
> > this?)
>
> Sort of ... if the filesystem happens to lay it out like that.  But
> this isn't a useful way to think about it.  The filesystem writes the
> data in 4K blocks.  The raid5 layer worries about how to create the
> parity block.
>
> >
> > However, If I store a file smaller than chunk size into the RAID5, what
will
> > happen?  For example, If  I store a 1KB file into it, how much disk
space
> > will be used? will it 4KB (plus 4KB parity or 1KB parity) ?
>
> Well... if you store 7 4K files, there could be a parity block which
> contains the xor-sum of all those files.  But it depends on exactly
> where the filesystem puts things.
>
> >
> > Please CC me if possible, thanks.
> ofcourse.
>
>
> I hope that helps your understanding.
>
> NeilBrown
>

