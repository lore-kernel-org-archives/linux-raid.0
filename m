From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: mismatch_cnt, random bitflips, silent corruption(?), mdadm/sw
	raid[156]
Date: Tue, 30 Dec 2008 08:20:26 -0600
Message-ID: <20081230142026.GB3549@sewage.raw-sewage.fake>
References: <alpine.DEB.1.10.0812250435260.12329@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812250435260.12329@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, smartmontools-support@lists.sourceforge.net, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

On Thu, Dec 25, 2008 at 01:04:07PM -0500, Justin Piszcz wrote:
> Options/alternatives for maintaining data integrity?
>
> 1. Obviously DVD and/or LTO-tape (multiple copies of data at rest)
> http://epoka.dk/media/Linear_Tape_Open_(LTO)_Ultrium_Data_Cartridges.pdf
> -> For LTO-2/LTO-3
> -> Uncorrected bit error rate 1x10-17 1x10-17
> -> Undetected bit error rate 1x10-27 1x10-27
>
> 2. ZFS, but only runs in user-space in Linux.
>
> 3. Keep an md5sum for each file on the filesystem and run daily
> checks?

I've recently started using par2[1][2] on backed up files.

I just started doing this, so don't know how it will work in the
long run.  Can't hurt, anyway, other than taking up more space.

[1] http://www.par2.net/
[2] http://parchive.sourceforge.net/

