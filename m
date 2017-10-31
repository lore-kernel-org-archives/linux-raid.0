From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Raid 6 recovery
Date: Tue, 31 Oct 2017 18:11:53 +0000
Message-ID: <59F8BCE9.1070607@youngman.org.uk>
References: <cf135ab9-1111-65cd-1074-5259a7eb133d@safeandsoundit.co.uk>
 <59F8A47E.2000405@youngman.org.uk>
 <1f997b50-f271-a238-2d7e-1684a0c64e66@safeandsoundit.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1f997b50-f271-a238-2d7e-1684a0c64e66@safeandsoundit.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Crisp <jcrisp@safeandsoundit.co.uk>, linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On 31/10/17 17:42, John Crisp wrote:
>> This worries me. We have 5 drives, which would normally be enough to
>> > recreate the array - a quick "--force" and we're up and running. Except
>> > one drive is rebuilding, so we have one drive's worth of data scattered
>> > across two drives :-(
>> > 
> Oh yuck.....
> 
> 
>> > Examine tells us that sdd, sdg, and sdj have been partitioned. What does
>> > "fdisk -l" tell us about those drives? Assuming they have one large
>> > partition each, what does "--examine" tell us about sdd1, sdg1 and sdj1
>> > (assuming that's what the partitions are)?
> mdadm --examine was pasted at the bottom of my original post.
> 
> 
> cat /etc/fstab
> 
> # <file system> <mount point>   <type>  <options>       <dump>  <pass>
> /dev/mapper/xubuntu-vg__raider-root / ext4 errors=remount-ro 0 1
> # /boot was on /dev/sda1 during installation
> UUID=86b99e91-e21e-4381-97e3-9b38ea8dae1b /boot ext2 defaults 0 2
> /dev/mapper/xubuntu-vg__raider-swap_1 none swap sw 0 0
> UUID=b19a1b13-e650-4288-864a-b84a3a86edad /media/Data ext4 rw,noatime 0 0
> 
> 
> fdisk:
> 
> root@garage:~# fdisk -l /dev/sd[cdefghij]

OUCH!!!

Okay, this is getting scary, sorry. We need to find where the data on
disks sdd, sdg, and sdj has gone. And according to all the information
you've given me, we have an array that's been saving its data in thin
air. Obviously that's not true, it's gone somewhere, the question is where.

What's also noticeable, is that the three drives that have "vanished"
have all got an MBR. There's a whole bunch of possible explanations, but
I really don't have the experience or knowledge to make a call here.

Were those drives re-purposed from somewhere else? Could there have been
a blank partition table on them before you used them?

Is it possible somebody did a
# fdisk /dev/sdd
: write
and wrote a blank mbr to a drive that was already in the array?

Or it could be that these drives really did have a partition sdd1 etc,
and something's blown the partition table away (I remember a GPT case
where that happened ...)

I hate to say it, but I think you are now in the world of hexdump and
searching manually for a superblock on those three drives. See
https://raid.wiki.kernel.org/index.php/Advanced_data_recovery

It's possible - I wouldn't know - that the existence of the MBR stops
mdadm looking for a superblock that applies to the whole drive, which
could explain why those drives have disappeared.

Or it could be that the superblock is in a partition, and because the
MBR has been blanked mdadm is not looking for said partition.

In a v1.2 array, the superblock is offset 4K from the start of the
device (to stop things like a rouge fdisk overwriting it :-) so you need
to see if you can find one at about the 4K mark.

If you can, the experts here should be able to recover the array fairly
easily, but it's beyond my ability, sorry.

NB - If you did get the big new drive, I was suggesting you turn all
your eight raid devices into partitions on the new drive, so you would
only have one drive to worry about while recovering :-)

Cheers,
Wol
