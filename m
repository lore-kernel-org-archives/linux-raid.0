From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH 2.5.68] eliminate deprecated
 MOD_INC_USE_COUNT/MOD_DEC_USE_COUNT in md.c
Date: Fri, 2 May 2003 15:02:20 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16049.64476.440042.635337@notabene.cse.unsw.edu.au>
References: <3EA595D9.E4CBB684@SteelEye.com>
	<16037.55226.267006.507998@notabene.cse.unsw.edu.au>
	<3EA6BA35.3A5F25CF@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Wednesday April 23
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday April 23, Paul.Clements@SteelEye.com wrote:
> Neil Brown wrote:
> > On Tuesday April 22, Paul.Clements@SteelEye.com wrote:
> > > Following is a simple patch to remove deprecated MOD_INC_USE_COUNT from
> > > md.c.
> > >
> > > If it looks good, please apply.
> > 
> > I don't think it is that easy.
> 
> Well, I think that it's safe to remove the MOD_INC_USE_COUNT...here's
> why:
> 
> We're protected while a device is open (by the infrastructure in the
> block layer that takes a module reference when an md device is opened
> and keeps it until the device is closed).
> 
> So, while any ioctl is being done, there's an md device open...and...the
> ioctls are currently the only way to activate md devices (autorun,
> RUN_ARRAY, etc.). 
> 
> Now, none of these ioctls will succeed (activate a device) unless there
> is an underlying raid personality module (raid0, raid1, et al.) for the
> array already loaded. The underlying raid modules also take module
> references against md, so by the time a device is activated, md is
> already pinned into memory...
> 
> So we're safe from every angle...the MOD_INC_USE_COUNT/MOD_DEC_USE_COUNT
> appears to have been superfluous in the first place...(at least with the
> way 2.5 kernel module refs work)

Almost.. but not quite.

It is possible for an array to be half-assembled.  To have some drives
attached, but not to have been started.
This can happen (for example) if you use mdadm to assemble a raid5
array without given all of the drives, and without giving --run.

In this case you don't want 'md' to be unloaded, but you haven't
loaded a personality module yet.  So you need to take a reference to
the md module whenever you start putting an md array together.

NeilBrown
