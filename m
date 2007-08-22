From: "Dat Chu" <dattanchu@gmail.com>
Subject: Re: Linear RAID hot grow
Date: Tue, 21 Aug 2007 23:12:43 -0500
Message-ID: <d0e8f6370708212112k64cfb316lac27893e0fc5a1f6@mail.gmail.com>
References: <d0e8f6370708201435s33547f5agfdf44b384c9489f2@mail.gmail.com>
	 <Pine.LNX.4.64.0708201745170.16270@p34.internal.lan>
	 <d0e8f6370708201455i37e21a4mf2dbf8ecb0133cb0@mail.gmail.com>
	 <d0e8f6370708201521g15974927lbfb91c03cb4428fe@mail.gmail.com>
	 <18122.9211.998879.841835@notabene.brown>
	 <d0e8f6370708202018p7bd20122o56c577507320c84a@mail.gmail.com>
	 <18122.30381.180760.497094@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18122.30381.180760.497094@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

md: sdd1 has invalid sb, not importing!
md: md_import_device returned -22

That is what I get for running dmesg | tail -20

Here is the relevant stanza from fdisk -l

Disk /dev/sda: 1649.2 GB, 1649267441664 bytes
255 heads, 63 sectors/track, 200512 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1      200512  1610612608+  83  Linux

Disk /dev/sdb: 1638.2 GB, 1638272335872 bytes
255 heads, 63 sectors/track, 199175 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *           1      199175  1599873156   83  Linux

Disk /dev/sdc: 1212.4 GB, 1212459515904 bytes
255 heads, 63 sectors/track, 147406 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1      147406  1184038663+  83  Linux

Disk /dev/sdd: 1124.9 GB, 1124999233536 bytes
255 heads, 63 sectors/track, 136773 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1      136773  1098629091   83  Linux

Disk /dev/sde: 1124.9 GB, 1124999233536 bytes
255 heads, 63 sectors/track, 136773 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1               1      136773  1098629091   83  Linux


On 8/21/07, Neil Brown <neilb@suse.de> wrote:
> On Monday August 20, dattanchu@gmail.com wrote:
> > I am currently running 2.6.22.1 kernel with mdadm version 2.6.2.
>
> That combination should work.
>
> >
> > When I try to run
> > mdadm --grow /dev/md2 --add /dev/sdd1
> > mdadm: Cannot add new disk to this array
>
> Odd.  I tried add a drive to a three-drive linear array and it
> worked, though my drives are somewhat smaller than yours - that
> shouldn't matter though.
>
> Do you get any kernel messages at the time when you try to add?
>   dmesg | tail -20
>
> NeilBrown
>
