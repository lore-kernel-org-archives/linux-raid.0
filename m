From: Neil Brown <neilb@suse.de>
Subject: Re: Confusion with setting up new RAID6 with mdadm
Date: Mon, 15 Nov 2010 09:13:26 +1100
Message-ID: <20101115091326.42b38b84@notabene.brown>
References: <4CE00206.4000301@geograph.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CE00206.4000301@geograph.co.za>
Sender: linux-raid-owner@vger.kernel.org
To: Zoltan Szecsei <zoltans@geograph.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 14 Nov 2010 17:36:38 +0200
Zoltan Szecsei <zoltans@geograph.co.za> wrote:

> Hi,
> I hope this is the correct list to address this on - I've done a lot of 
> typing for nothing, if not :-)
> 
> I have done days of research, including reading 
> https://raid.wiki.kernel.org/index.php/Linux_Raid, but all I am doing is 
> getting confused in the detail.
> 
> My goal is to set up an 8*2TB SiI3132 based RAID6 on Ubuntu 10.04LTS, 
> with LVM and ext4.
> The setup will mostly hold thousands of 400MB image files, and they will 
> not be accessed regularly - they mostly just need to be online. The 
> entire space on all 8 drives can be used, and I want 1 massive 
> filesystem, when I finally mount this RAID device. No boot, root or swap.
> 
> I have gone quite far with the help of the local linux group, but after 
> I had completed the 27 hour mdadm --create run, further tidbits were 
> thrown at me, and I am trying to get an opinion on if it is worth 
> scrapping this effort, and starting again.
> 
> 
> 
> Please can someone provide clarity on:
> 
> *If I have to reformat the drives and redo mdadm --create, other than 
> mdadm stop, how can I get rid of all the /dev/md* etc etc so that when I 
> restart this exercise, the original bad RAID does not interfere with 
> this new attempt?
> 
> 
> 
> *Partition alignment?
> Is this relevant for modern HDs (I'm using 5900rpm Seagate 2TB drives)
> None of the mdadm helps I've googled or received speak about how to 
> correctly format the drives before running mdadm --create.
> All the benchmarks & performance tests I've found, do not bother to say 
> whether they have aligned the partitions on the HD
> 
> *What is the correct fdisk or parted method get rid of the DOS & GPT 
> flags, and create a correctly aligned partition, and should this be a 
> 0xda partiton (& then I use metatdata 1.2 for mdadm)?
> 
> 
> *Chunk size:
> After reading MANY different opinions, I'm guessing staying at the 
> default chunk size is optimal? Anyone want to add to this argument?

Depending on which version of mdadm you are using, the default chunk size
will be 64K or 512K.  I would recommend using 512K even if you have an older
mdadm.  64K appears to be too small for modern hardware, particularly if you
are storing large files.

For raid6 with the current implementation it is safe to use "--assume-clean"
to avoid the long recovery time.  It is certainly safe to use that if you
want to build a test array, do some performance measurement, and then scrap
it and try again.  If some time later you want to be sure that the array is
entirely in sync you can
  echo repair > /sys/block/md0/md/sync_action
and wait a while.

I agree with what Mikael and Luca suggested - particularly the suggested for
"--bitmap internal".  You really want that.


NeilBrown


