From: Harry Mangalam <harry.mangalam@uci.edu>
Subject: Re: rescue an alien md raid5
Date: Mon, 23 Feb 2009 12:04:39 -0800
Message-ID: <200902231204.39660.harry.mangalam@uci.edu>
References: <200902231013.46082.harry.mangalam@uci.edu> <ae41ed6f5db4a30599973b9466f89e19.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ae41ed6f5db4a30599973b9466f89e19.squirrel@neil.brown.name>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday 23 February 2009, NeilBrown wrote:
> On Tue, February 24, 2009 5:13 am, Harry Mangalam wrote:
> > Here's an unusual (long) tale of woe.
> >
> > We had a USRobotics 8700 NAS appliance with 4 SATA disks in
> > RAID5:
> > <http://www.usr.com/support/product-template.asp?prod=8700> which
> > was a fine (if crude) ARM-based Linux NAS until it stroked out at
> > some point, leaving us with a degraded RAID5 and comatose NAS
> > device.
> >
> > We'd like to get the files back of course and I've moved the
> > disks to a Linux PC, hooked them up to a cheap Silicon Image 4x
> > SATA controller and brought up the whole frankenmess with mdadm. 
> > It reported a clean but degraded array:
>
> Isn't it nice that it was Linux inside that box, rather than some
> proprietary OS with some undocumented raid metadata....

And that it used mdadm.. - /IT/ worked perfectly.

> > The docs and files on the USR web site imply that the native
> > filesystem was originally XFS, but when i try to mount it as
> > such, I can't:
>
> I heard Dave Chinner talking about this during LCA-2009.
> If I remember correctly, there is something a bit funny about
> structure layout and padding on the ARM and it affects XFS is some
> strange way, and some NAS vendors 'fixed' it the wrong way, so they
> are incompatible with mainline..... or something like that.  What I
> really remember is ARM + XFS + NAS == BAD Vendor
>
> I suggest asking at xfs@oss.sgi.com

Thanks - I'll go over and bug them a bit before I give up.

>
> No, those other partitions are relevant.  One was clearly for
> swap.  The other was probably /boot.

Yes, I now remember that it did provide a small /boot (+ a bit of OS 
space).  I added some utils there while I was testing it before I 
decided it was too much effort for the return.
Thanks very much for the note.

-- 
Harry Mangalam - Research Computing, NACS, E2148, Engineering Gateway, 
UC Irvine 92697  949 824-0084(o), 949 285-4487(c)
---
Good judgment comes from experience; 
Experience comes from bad judgment. [F. Brooks.]
