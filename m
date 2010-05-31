From: Neil Brown <neilb@suse.de>
Subject: Re: Confused about reshape?
Date: Mon, 31 May 2010 16:48:44 +1000
Message-ID: <20100531164844.0f15838e@notabene.brown>
References: <20100531155753.6662b882@notabene.brown>
	<B5.9D.03062.922530C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B5.9D.03062.922530C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 31 May 2010 01:07:38 -0500
"Leslie Rhorer" <lrhorer@satx.rr.com> wrote:

> > -----Original Message-----
> > From: Neil Brown [mailto:neilb@suse.de]
> > Sent: Monday, May 31, 2010 12:58 AM
> > To: Leslie Rhorer
> > Cc: linux-raid@vger.kernel.org
> > Subject: Re: Confused about reshape?
> > 
> > On Mon, 31 May 2010 00:32:07 -0500
> > "Leslie Rhorer" <lrhorer@satx.rr.com> wrote:
> > 
> > > > Just tell mdadm what you want and it will do it, or report that it
> > cannot.
> > >
> > > 	Um, OK, I tried it, and it failed:
> > >
> > > Backup:/# mdadm --grow /dev/md0 --level=6
> > > mdadm: no changes to --grow
> > 
> > cat /proc/mdstat ??
> > mdadm -D /dev/md0 ??
> > mdadm -V ??
> > uname -a ??
> > 
> > Maybe add -vv to the --grow
> 
> /dev/md0:
>         Version : 1.02
>   Creation Time : Sun Jul 12 20:44:02 2009
>      Raid Level : raid5
>      Array Size : 10255969024 (9780.85 GiB 10502.11 GB)
>   Used Dev Size : 1465138432 (1397.26 GiB 1500.30 GB)
>    Raid Devices : 8
>   Total Devices : 9
>     Persistence : Superblock is persistent
> 
>   Intent Bitmap : Internal

You'll probably need to remove the bitmap for --grow to work... I really
should fix that.

> 
>     Update Time : Mon May 31 00:44:25 2010
>           State : active
>  Active Devices : 8
> Working Devices : 9
>  Failed Devices : 0
>   Spare Devices : 1
> 
>          Layout : left-symmetric
>      Chunk Size : 256K
> 
>            Name : Backup:0  (local to host Backup)
>            UUID : 940ae4e4:04057ffc:5e92d2fb:63e3efb7
>          Events : 987130
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        0        0      active sync   /dev/sda
>        1       8       16        1      active sync   /dev/sdb
>        2       8       32        2      active sync   /dev/sdc
>        8       8       48        3      active sync   /dev/sdd
>        4       8       64        4      active sync   /dev/sde
>        5       8       80        5      active sync   /dev/sdf
>        6       8       96        6      active sync   /dev/sdg
>        7       8      112        7      active sync   /dev/sdh
> 
>        9       8      128        -      spare   /dev/sdi
> 
> Backup:/tmp# mdadm -V >> temp
> mdadm - v3.0.3 - 22nd October 2009

I should have checked when you mention the mdadm version in the first email.
You need at least 3.1.1 to convert RAID5 to RAID6.

NeilBrown


> 
> Backup:/tmp# uname -a
> Linux Backup 2.6.32-3-amd64 #1 SMP Wed Feb 24 18:07:42 UTC 2010 x86_64
> GNU/Linux
> 
> Backup:/tmp# mdadm --grow -vv /dev/md0 --level=6 >> temp
> mdadm: no changes to --grow
> 
> 
> 

