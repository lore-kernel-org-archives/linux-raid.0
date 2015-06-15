From: "Wilson, Jonathan" <piercing_male@hotmail.com>
Subject: Re: Migrating a RAID 5 from 4x2TB to 3x6TB ?
Date: Mon, 15 Jun 2015 11:46:12 +0100
Message-ID: <BLU436-SMTP134979C5D563F30AFDBD89898B80@phx.gbl>
References: <167089395.613.1433791723592.JavaMail.zimbra@wieser.fr>
	 <1056149272.1412.1433965061737.JavaMail.zimbra@wieser.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1056149272.1412.1433965061737.JavaMail.zimbra@wieser.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Pierre Wieser <pierre.wieser@gadz.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2015-06-10 at 21:37 +0200, Pierre Wieser wrote:
> Hi all,
> 
> > I currently have an almost full RAID 5 built with 4 x 2 TB disks.
> > I wonder if it would be possible to migrate it to a bigger RAID 5
> > with 3 x 6TB new disks.
> 
> Due to all suggestions, and I'd wish another time thank all contributions,
> I've spent some hours reading the mailing list archives, surfing the web
> with more appropiate keywords, and so on..
> 
> So, here what I now plan to do:
> 
> First, I hace cancelled my order for the new 6TB desktop-grade disks, 
> replacing it with 4TB WD RedPro, and one 6TB desktop-grade (see below its use)
> 
> As the full RAID5 array I planned to migrate is already my backup system,
> I cannot rely on a restore :(. So the first thing is to rsync the current
> array to the directly attached 6TB disk. I don't thing I have a free SATA 
> port on my motherboard, but at worst I will be able to use the one currently
> used for the DVD drive.
> 
> I've chosen to build new RAID10 arrays.
> I've moved away the RAID6 suggestion due to its known bad write performance,
> and also because I'm willing/able to put a bit more money to get better perfs.

First I am not an expert, the following is based on multiple web sites
so is kind of cobbled together and using your setup but based on my
system as it stands now.

I'm going to make some assumptions here... 
1) the motherboard can see and boot from 4TB drives instead of only
seeing 750G (approx) in the bios, if not you will need a smaller disk
for the boot/os. 
2) this will be a "bios" install/boot or UEFI with CSM to simulate a
bios install/boot
3) these will be the only disks in the system. 


> 
> The 4x4TB new disks will be partitioned as:

As this will be a clean install, make a 1M partition flagged as "bios
boot" (EF02 in gdisk) this will allow grub2 to install into the member
(as normal) and its larger next stage loader & raid "drivers/ability" to
be installed into the "bios boot" partition, do this for all 4 disks.
(see #a later)

> - 512MB to be a RAID1 array mounted as /boot

Of the 4 drives 512M partitions, create a 4 way raid1 for /boot
(grub2/config and the kernels & initiramfs will live in here) (see #b
later)

> - 8GB to be a RAID10 array used as swap

On the 4 disks, create 17G partitions then create a 4 disk raid10 far2
array with 64K chunk. This will give you a swap file of 34G in size
(well over provisioned, but doesn't hurt or impact performance). As its
likely swap access will be in small random amounts this means the disk
write size is not overly large, no point in writing/reading 512K chunks
(the current default) for a 4K page swap/memory access; raid10 is fast;
far2 from what I've read also improves the speed of read/writes in some
tests (I don't know why or if the tests I've seen mentioned on the web
are accurate for the type of access swap will cause but on my setup I
can get a dd speed of 582M read and 215M write from drives with a single
device speed of about 80-100M as a rough and ready speed test).

> - two 25 GB parts to be two RAID10 arrays used as root filesystem
>   (plus place for an alternate when upgrading the OS)

25G partition on all 4 disks in to a single raid10 far2 (default 512K
chunk) = 50G for "root"

Duplicate above for a second "root/install" (this might be useful for #b
later also)

> - the rest of the disk will be splitted in four equal parts (about 930 MB 
> I think), each of which being member of a separate data RAID10 array.

I would not bother creating 4 smaller partitions on each disk, nothing
will be gained except more complexity and may even reduce speeds due to
increasing seeks when data doesn't reside exactly on one raid group. LVM
can still sit on the top for flexibility later. You could also go for a
4 disk raid6 (which I have) which would give you the same amount of
storage space on creation but would then mean 1 extra disk=1 extra disks
worth of space, not half,as you add more. (I'm not sure about R/W
speeds, also while I think it can - I'm not sure if mdadm --grow works
on raid10)

> 
> I am conscious that this seems as a waste of space, and especially for the
> /boot partition. But this scheme will let me:
> a) have banalized disks: all disks have same rules, are partitioned identically

I have found with GPT/raid etc. that as time has gone on I have created
partitions with the same "number" as the md/X numbering, while not
needed it does mean I know "/dev/md/3" is made up of /dev/sd[a-d]3 so if
at some future point I add more disks and create a new array I do it by
creating partition number(s) "4" and array /dev/md/4 instead of having a
bunch of partition "1"s with a multitude of differing number mdadm
arrays which gives my brain a kick to remind me that "no you can't
delete that partition because it doesn't match the array number you are
doing stuff with".

> b) replace my system disk which is not part of any RAID system as of today,
> thus gaining actually both a SATA port for the RAID systems and more security
> for the boot and root filesystems

See my assumption 1, on my old P45DE core2/quad system linux can happily
see big drives (over 2TB I think is the limit) and use all the space as
one large partition or further divided, but the bios could only see a
smaller 750G amount so could not boot from my 3TB drives so while I did
all the partitioning mentioned in my replies (ready for when I upgraded
to newer hardware, which I have done) I needed a 1TB disk to hold the
"bios boot," "/boot," and "root" to be able to then see the larger
drives. (actually strictly speaking you could probably get away with
just "bios boot" and "/boot" on the smaller disk, and have /root on the
larger ones as grub2 loads the kernel file and initramfs from /boot...
I'm not 100% sure but I think grub2 can also see and understand larger
disks, so you might be able to install grub2 to the small disk (or flash
drive), which the bios can then boot from, which can then load the
kernel from the large disk's /boot raid.)

> c) also because I use to use LVM on top of RAID to get advantages of its
> flexibility (so several PVs which may or may not be aggregated later)
> Other suggestions include the use of smartctl tool. I've checked that the 
> daemon was already running. But I didn't use the '-x' option that I understand
> is hardly an option !
> 
> I plan to build these RAID devices out of CentOS 7 standard install process
> (I'm currently downloading a CentOS Live iso), thus presenting to the install
> some predefined partitions.
> 
> I expect about 5-10 days to get these orders delivered. So more news at this time :)
> 
> Thank you all for your help. I keep reading the list that I discovered for 
> the occasion...

(#a) After installing to sda and booting etc, you than then install grub
on to sd[b,c,d]. This means that should you lose sda, you can boot from
any of the remaining disks without having to worry about getting a
"live" cd or some such method of recovering the system. 

(#b) Should you upgrade to a UEFI motherboard and/or disable CSM remove
the array on the 4 disks (512M partitions), mark them as EF00 (EFI
System) in gdisk, format them all as fat32, install the boot loader
& /boot to disk sda2 to get a working system, replicate sda2 into
sd[b,c,d]2, to allow recovery should sda fail, and use efibootmgr to add
boot entries to NVRAM for disks b2,c2,d2. (I think grub install to each
disk under uefi should also add boot entries to the uefi NVRAM but UEFI
is much more of a pain than "bios" with stupid things such as forgetting
its entries if a disk is removed/replaced, so efibootmgr is a tool to
get used to)



> 
> Regards
> Pierre

Jon.

(all the above is based on my experience/hassles as an "end user/self
learner" and various web searches and posts on this list, so may be
totally different advice from what a systems administrator would give
for a work server set up with way more experience and knowledge of just
what works best, and why, especially system/raid performance which is an
art that an end user doesn't really have to worry about as "its fast
enough/it works ok" usually suffices.)

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


