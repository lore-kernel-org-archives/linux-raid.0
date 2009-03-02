From: Harry Mangalam <harry.mangalam@uci.edu>
Subject: Re: rescue an alien md raid5
Date: Mon, 2 Mar 2009 08:57:58 -0800
Message-ID: <200903020857.58595.harry.mangalam@uci.edu>
References: <200902231013.46082.harry.mangalam@uci.edu> <ae41ed6f5db4a30599973b9466f89e19.squirrel@neil.brown.name> <20090302122238.67785n3th69tw4w8@cakebox.home>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090302122238.67785n3th69tw4w8@cakebox.home>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Nagilum <nagilum@nagilum.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

that's a good idea...if we can subvert the NAS box to boot an 
alternative system.  There's no CD, but there is a USB port, so we 
could try to boot a USB ARM distro.  One problem with this is that 
there's no video system so it's all blind until we can log into it, 
unless there's some hidden video tap on the mobo.

I'll check into that - thank you for the idea.

Harry

On Monday 02 March 2009, Nagilum wrote:
> >> The docs and files on the USR web site imply that the native
> >> filesystem was originally XFS, but when i try to mount it as
> >> such, I can't:
> >
> > I heard Dave Chinner talking about this during LCA-2009.
> > If I remember correctly, there is something a bit funny about
> > structure layout and padding on the ARM and it affects XFS is
> > some strange way, and some NAS vendors 'fixed' it the wrong way,
> > so they are incompatible with mainline..... or something like
> > that.  What I really remember is ARM + XFS + NAS == BAD Vendor
> >
> > I suggest asking at xfs@oss.sgi.com
> >
> > No, those other partitions are relevant.  One was clearly for
> > swap.  The other was probably /boot.
>
> Maybe it can be salvaged using QEMU?
> There are even preconfigured ARM environments available:
> http://www.scratchbox.org/
>
>
>
>
> ===================================================================
>===== #    _  __          _ __     http://www.nagilum.org/ \n
> icq://69646724 # #   / |/ /__ ____ _(_) /_ ____ _ 
> nagilum@nagilum.org \n +491776461165 # #  /    / _ `/ _ `/ / / // /
>  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   # # /_/|_/\_,_/\_,
> /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux # #          
> /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
> ===================================================================
>=====
>
>
> ----------------------------------------------------------------
> cakebox.homeunix.net - all the machine one needs..



-- 
Harry Mangalam - Research Computing, NACS, E2148, Engineering Gateway, 
UC Irvine 92697  949 824-0084(o), 949 285-4487(c)
---
Good judgment comes from experience; 
Experience comes from bad judgment. [F. Brooks.]
