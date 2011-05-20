From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Best way to create RAID-6 for swap partition - existing one failed
Date: Thu, 19 May 2011 22:32:31 -0500
Message-ID: <3A.5F.03893.8C0E5DD4@cdptpa-omtalb.mail.rr.com>
References: <4DD47FD3.2000909@hardwarefreak.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD47FD3.2000909@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Stan Hoeppner' <stan@hardwarefreak.com>, 'Gavin Flower' <gavinflower@yahoo.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, mb@gem.win.co.nz
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Stan Hoeppner
> Sent: Wednesday, May 18, 2011 9:26 PM
> To: Gavin Flower
> Cc: linux-raid@vger.kernel.org; neilb@suse.de; mb@gem.win.co.nz
> Subject: Re: Best way to create RAID-6 for swap partition - existing one
> failed
> 
> On 5/18/2011 7:11 PM, Gavin Flower wrote:
> 
> We're getting pretty OT here...
> 
> > What obvious thing have I done, or not done, here?
> >
> > What should I do now?
> >
> > (I am not panicking, because I can always revert back...)
> >
> > I tried to implement you suggestion,
> >
> > # swapoff -a
> > # dd if=/dev/zero of=/swapfile1 bs=1K count=16M
> > 16777216+0 records in
> > 16777216+0 records out
> > 17179869184 bytes (17 GB) copied, 119.642 s, 144 MB/s
> > # mkswap /swapfile1
> > Setting up swapspace version 1, size = 16777212 KiB
> > no label, UUID=9afbf206-9a79-45b8-ad4b-148f71c440d7
> 
> 17GB is a bit ridiculous for swap, especially on a single user machine.

	I once encountered an fsck that required more than 400G.  I had to
kill the process, slot a new 500G drive, and enable swap on the new drive.


