From: Neil Brown <neilb@suse.de>
Subject: Re: Device role question
Date: Sun, 28 Feb 2010 15:41:58 +1100
Message-ID: <20100228154158.6717097d@notabene.brown>
References: <20100226142331.GA2328@lazy.lzy>
	<4877c76c1002262156k6675877am79a7da9b63446dc7@mail.gmail.com>
	<20100227080845.GA2287@lazy.lzy>
	<4877c76c1002270055o2ebc038ag52e0b9a8f5b407d@mail.gmail.com>
	<20100227091027.GA3510@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100227091027.GA3510@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Michael Evans <mjevans1983@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 27 Feb 2010 10:10:27 +0100
Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> wrote:

> Hi,
> 
> > Ok, please run this for each disk in the array:
> > 
> > mdadm --examine /dev/(DEVICE)
> > 
> > The output would be most readable if you did each array's devices in
> > order, and you can list them on the same command (- - examine takes
> > multiple inputs)
> > 
> > If you still think the situation isn't as I described above, post the results.
> 
> Well, here it is:
> 
> $> mdadm -E /dev/sd[ab]2
> /dev/sda2:
>           Magic : a92b4efc
>         Version : 1.1
>     Feature Map : 0x1
>      Array UUID : 54db81a7:b47e9253:7291055e:4953c163
>            Name : lvm
>   Creation Time : Fri Feb  6 20:17:13 2009
>      Raid Level : raid10
>    Raid Devices : 2
> 
>  Avail Dev Size : 624928236 (297.99 GiB 319.96 GB)
>      Array Size : 624928000 (297.99 GiB 319.96 GB)
>   Used Dev Size : 624928000 (297.99 GiB 319.96 GB)
>     Data Offset : 264 sectors
>    Super Offset : 0 sectors
>           State : clean
>     Device UUID : 8f6cd2c4:0efc8286:09ec91c6:bc5014bf
> 
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Sat Feb 27 10:08:22 2010
>        Checksum : 1703ded0 - correct
>          Events : 161646
> 
>          Layout : far=2
>      Chunk Size : 64K
> 
>    Device Role : spare
>    Array State : AA ('A' == active, '.' == missing)
> /dev/sdb2:
>           Magic : a92b4efc
>         Version : 1.1
>     Feature Map : 0x1
>      Array UUID : 54db81a7:b47e9253:7291055e:4953c163
>            Name : lvm
>   Creation Time : Fri Feb  6 20:17:13 2009
>      Raid Level : raid10
>    Raid Devices : 2
> 
>  Avail Dev Size : 624928236 (297.99 GiB 319.96 GB)
>      Array Size : 624928000 (297.99 GiB 319.96 GB)
>   Used Dev Size : 624928000 (297.99 GiB 319.96 GB)
>     Data Offset : 264 sectors
>    Super Offset : 0 sectors
>           State : clean
>     Device UUID : 6e2763b5:9415b181:e41a9964:b0c21ca6
> 
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Sat Feb 27 10:08:22 2010
>        Checksum : 87d25401 - correct
>          Events : 161646
> 
>          Layout : far=2
>      Chunk Size : 64K
> 
>    Device Role : Active device 0
>    Array State : AA ('A' == active, '.' == missing)
> 
> And the details too:
> 
> $> mdadm -D /dev/md1
> /dev/md1:
>         Version : 1.1
>   Creation Time : Fri Feb  6 20:17:13 2009
>      Raid Level : raid10
>      Array Size : 312464000 (297.99 GiB 319.96 GB)
>   Used Dev Size : 312464000 (297.99 GiB 319.96 GB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
> 
>   Intent Bitmap : Internal
> 
>     Update Time : Sat Feb 27 10:09:24 2010
>           State : active
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : far=2
>      Chunk Size : 64K
> 
>            Name : lvm
>            UUID : 54db81a7:b47e9253:7291055e:4953c163
>          Events : 161646
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       18        0      active sync   /dev/sdb2
>        2       8        2        1      active sync   /dev/sda2
> 
> bye,
> 


Thanks for all the details.  They help.

It looks like a bug in mdadm which was fixed in 3.1.1.  It is only present in
3.0 and 3.0.x (I don't think you said what version of mdadm you are using).

NeilBrown
