From: "Dat Chu" <dattanchu@gmail.com>
Subject: Re: Linear RAID hot grow
Date: Mon, 20 Aug 2007 22:18:03 -0500
Message-ID: <d0e8f6370708202018p7bd20122o56c577507320c84a@mail.gmail.com>
References: <d0e8f6370708201435s33547f5agfdf44b384c9489f2@mail.gmail.com>
	 <Pine.LNX.4.64.0708201745170.16270@p34.internal.lan>
	 <d0e8f6370708201455i37e21a4mf2dbf8ecb0133cb0@mail.gmail.com>
	 <d0e8f6370708201521g15974927lbfb91c03cb4428fe@mail.gmail.com>
	 <18122.9211.998879.841835@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18122.9211.998879.841835@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am currently running 2.6.22.1 kernel with mdadm version 2.6.2.

When I try to run
mdadm --grow /dev/md2 --add /dev/sdd1
mdadm: Cannot add new disk to this array

mdadm -D /dev/md2
/dev/md2:
        Version : 00.90.03
  Creation Time : Thu Apr 12 15:10:30 2007
     Raid Level : linear
     Array Size : 4394524224 (4190.94 GiB 4499.99 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Mon Aug 20 21:59:02 2007
          State : active
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

       Rounding : 64K

           UUID : 2d55a746:46480234:2bd67da3:078a1f37
         Events : 0.17

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1

I am missing something?

Thanks for the quick reply Neil.

With warm regards,
Dat Chu

On 8/20/07, Neil Brown <neilb@suse.de> wrote:
> On Monday August 20, dattanchu@gmail.com wrote:
> > The links on Neil's website to those patches are no longer there. When
> > I try to hot grow a linear raid, it says that hot grow for linear raid
> > is not supported.
>
> What is the exact error message?
> What kernel are you using?
>
> hot-grow for linear does work with recent kernels and mdadm - it is
> part of my test suite.
>   mdadm --grow /dev/md-linear --add /dev/new-device
>
> NeilBrown
>
