From: Luca Berra <bluca@comedia.it>
Subject: Re: Confusion with setting up new RAID6 with mdadm
Date: Sun, 14 Nov 2010 20:50:36 +0100
Message-ID: <20101114195036.GA23982@maude.comedia.it>
References: <4CE00206.4000301@geograph.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CE00206.4000301@geograph.co.za>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Nov 14, 2010 at 05:36:38PM +0200, Zoltan Szecsei wrote:
> *If I have to reformat the drives and redo mdadm --create, other than mdadm 
> stop, how can I get rid of all the /dev/md* etc etc so that when I restart 
> this exercise, the original bad RAID does not interfere with this new 
> attempt?

mdadm -Ss
mdadm --zero-superblock on each partition
>
>
> *Partition alignment?
> Is this relevant for modern HDs (I'm using 5900rpm Seagate 2TB drives)
for modern hdds with 4k sectors it is
new fdisk and/or parted should already know how to align
in any case, since you want to use the whole space for raid, why create
partitions at all, md works nicely without

> *Chunk size:
> After reading MANY different opinions, I'm guessing staying at the default 
> chunk size is optimal? Anyone want to add to this argument?
i believe the default in newer mdadm is fine

>
> *After partitioning the 8 drives, is this the correct sequence?
> mdadm --create /dev/md0 --metadata=1.2 --auto=md --chunk=64 --level=raid6 
why you state the chunk size here, i tought you wanted to stay with the
defauklt
> --raid devices=8 /dev/sd[abcdefgh]1
> mdadm --detail --scan >> /etc/mdadm.conf
> mdadm --assemble /dev/md0 /dev/sd[abcdefg]1
it should be already assembled after create, and after you appended the
info to mdadm.conf you just need mdadm --assemble /dev/md0 or mdadm
--assemble --scan.

> *After this, do I mkfs ext4 first, or LVM first?
if you want to use lvm it would be lvm first, but... do you want to?
there is no point if the aim is allocating the whole space to a single
filesystem.

> *What stride and stripe values should I use?
new toolstack should already find the correct stripe/stride for you

one more note:
for such a big array i would suggest to create a bitmap, so in case of
an unclean shutdown you do not have to wait for 27 hours for it to
rebuild. an internal bitmap will do.

L.

-- 
Luca Berra -- bluca@comedia.it
