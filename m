From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: dmcrypt on top of raid5, or raid5 on top of dmcrypt?
Date: Thu, 17 Apr 2014 10:05:43 +0200
Message-ID: <20140417080543.GA1941@lazy.lzy>
References: <20140411195953.GN9923@merlins.org>
 <20140416223640.GA5164@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140416223640.GA5164@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 16, 2014 at 03:36:40PM -0700, Marc MERLIN wrote:
> Anyone? :)
> 
> Clearly I can't be the only person using md raid5 and dmcrypt, right? :)
> 
> If you are, how did you build yours?

Hi Marc,

I tested, with 5 HDDs RAID-6, LUKS-on-RAID,
and RAID-on-crypt (raw crypt, not LUKS).
The first approach is faster than the second.
It is easy to see ("cryptsetup benchmark"),
that with AES-NI instructions (the CPU I use
has them), the encrypion process goes 2GB/sec,
so the bottleneck is not there (with rotating
HDDs, with SSD, maybe different story).

On the other hand, having 5 HDDs and 4 cores,
means the parallel encryption does not really
occur completely.

Final words, the performances come with tuning
of parameters, like read-ahead (for all layers,
from top to bottom) and stripe cache size.

Hope this helps,

bye,

pg

> 
> Thanks,
> Marc
> 
> On Fri, Apr 11, 2014 at 12:59:53PM -0700, Marc MERLIN wrote:
> > I have a btrfs filesystem with many many files which got slow likely due to
> > btrfs optimization issues, but someone pointed out that I should also look
> > at write amplification problems.
> > 
> > This is my current array:
> > gargamel:~# mdadm --detail /dev/md8
> > /dev/md8:
> >         Version : 1.2
> >   Creation Time : Thu Mar 25 20:15:00 2010
> >      Raid Level : raid5
> >      Array Size : 7814045696 (7452.05 GiB 8001.58 GB)
> >   Used Dev Size : 1953511424 (1863.01 GiB 2000.40 GB)
> >     Persistence : Superblock is persistent
> >   Intent Bitmap : Internal
> >          Layout : left-symmetric
> >      Chunk Size : 512K   < I guess this is too big
> > 
> > http://superuser.com/questions/305716/bad-performance-with-linux-software-raid5-and-luks-encryption
> > says:
> > "LUKS has a botleneck, that is it just spawns one thread per block device.
> > 
> > Are you placing the encryption on top of the RAID 5? Then from the point of
> > view of your OS you just have one device, then it is using just one thread
> > for all those disks, meaning disks are working in a serial way rather than
> > parallel."
> > but it was disputed in a reply.
> > Does someone know if this is still valid/correct in 3.14?
> > 
> > Since I'm going to recreate the filesystem considering the troubles I've had
> > with it, I might as well do it better this time :)
> > (but doing the copy back will take days, so I'd rather get it right the first time)
> > 
> > How would you recommend I create the array when I rebuild it?
> > 
> > This filesystem contains may backup with many files, most small, and ideally
> > identical stuff is hardlinked together (many files, many hardlinks)
> > gargamel:~# btrfs fi df /mnt/btrfs_pool2
> > Data, single: total=3.28TiB, used=2.29TiB
> > System, DUP: total=8.00MiB, used=384.00KiB
> > System, single: total=4.00MiB, used=0.00
> > Metadata, DUP: total=74.50GiB, used=70.11GiB  <<< muchos metadata
> > Metadata, single: total=8.00MiB, used=0.00
> > 
> > 
> > #1 move the intent bitmap to another device. I have /boot on swraid1 with
> >    ext4, so I'll likely use this (man page says ext3 only, but I hope ext4
> >    is good too, right?)
> > #2 change chunk size to something smaller? 128K better?
> > #3 anything else?
> > 
> > Then, I used this for dmcrypt:
> > cryptsetup luksFormat --align-payload=8192 -s 256 -c aes-xts-plain64  
> > 
> > The align-payload was good for my SSD, but probably not for a hard drive.
> > http://wiki.drewhess.com/wiki/Creating_an_encrypted_filesystem_on_a_partition
> > says
> > "To calculate this value, multiply your RAID chunk size in bytes by the
> > number of data disks in the array (N/2 for RAID 1, N-1 for RAID 5 and N-2
> > for RAID 6), and divide by 512 bytes per sector."
> > 
> > So 512K * 4 / 512 = 4K
> > In other words, I can do align-payload=4096 for a small reduction of write
> > amplification, or =1024 if I change my raid chunk size to 128K
> > 
> > Correct? 
> > Do you recommend that I indeed rebuild that raid5 with a chunk size of 128K?
> > 
> > Other bits I found that can maybe help others:
> > http://superuser.com/questions/305716/bad-performance-with-linux-software-raid5-and-luks-encryption
> > 
> > This seems to help work around the write amplification a bit:
> > for i in /sys/block/md*/md/stripe_cache_size; do echo 16384 > $i; done
> > 
> > This looks like an easy thing, done.
> > 
> > If you have other suggestions/comments, please share :)
> > 
> > Thanks,
> > Marc
> > -- 
> > "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> > Microsoft is to operating systems ....
> >                                       .... what McDonalds is to gourmet cooking
> > Home page: http://marc.merlins.org/  
> 
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
