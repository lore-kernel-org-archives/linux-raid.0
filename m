From: Boniforti Flavio <boniforti@provincia.verbania.it>
Subject: Re: Software RAID-1: step-by-step help needed...
Date: Tue, 10 Aug 2004 13:10:43 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4118AD33.8000803@provincia.verbania.it>
References: <41188A95.5000608@provincia.verbania.it> <Pine.LNX.4.56.0408100948230.1665@lion.drogon.net> <411892D0.8050701@provincia.verbania.it> <Pine.LNX.4.56.0408101021030.1665@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0408101021030.1665@lion.drogon.net>
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Gordon Henderson wrote:

> OK - this is a very intersting and highly debatable subject!

[cut]

Well, I didn't mention at all what my server will have to do: it's 
simply a squid-proxy and will have apache installed (with PHP and 
mySQL), but just for small "intranet" applications (more "testing" like)...
This is why I was about to apply following partition scheme:

/dev/sda1 - 20 GB (Primary, ext3)
/dev/sda2 -  1 GB (Primary, SWAP)
/dev/sda5 - 52 GB (Logical, ext3)

I will install / onto sda1 and /var onto sda5, what do you think?

[snip]

> Some Linux distros will create a smaller /boot partition. I understand
> this was required in the bad old days when the BIOIS could only address
> 1024 cylinders, so you had to make sure the kernel image was inside that
> limit. These days with a modern BIOS it's not required (although others
> will have other probably good reasons for using it anyway)

I don't know if I should bother with a separate /boot partition, because 
actually every Debian boots off >1024 cyl...

[cut]

>>I already installed it (as a test) following the instructions found at:
>>http://www.inittab.de/manuals/debootstrap.html
> 
> 
> Er - thats a rather "intersting" way to install Debian - I use the
> standard Woody CD set..

Yes, but I have to install it that way, because the original Woody discs 
  don't contain a working driver for my SCSI Controller. :(

>>I guess the hardest task will be configuring RAID, as the system works
>>with the above procedure...
> 
> 
> OK. So with Debian, I basic, but minimal system on the first drive, not
> touching the 2nd drive at all during this process... I'll usually compile
> up a custome kernel at this point to make sure the IDE controllers have
> DMA, if nothing else.

I will install the system with the above mentioned "alien" procedure, 
then I would like to *first* activate RAID-1 (maybe it could need to 
recompile?) and then boot off RAID and see that everything works...

> Then with the 2nd drive, partition it to be identical to the first disk,
> then follow through the runes on the HowTo for mirroring the disks.

I already partitioned both disks the same way (booting with System 
Rescue CD and using cfdisk).

> You can do it 2 ways - either create a mirror set with 1 disk, the other
> being degraded immediately, then raidhotadd it, or create them step by
> step, temporarily relocating each partition as you go. (Eg into the swap
> partition, after you turn swap off!) I use the latter method.
> 
> First, move root to another partition:
> 
> Eg. mkfs /dev/hda2 (swap partition), mount /dev/hda2 /mnt ; cd / ;
> find . -xdev | cpio -pm /mnt
> 
> This is the hard part - cd /mnt, edit /mnt/etc/fstab and /mnt/etc/lilo to
> reflect the fact that root is now on /dev/hda2, (make sure swap isn't
> going to be mounted!) run lilo -r /mnt and reboot. Hopefully the system
> will now boot with /dev/hda2 being root.
> 
> I don't know madm, so (because I've been doing it this way for the past 6
> years) I then edit an /etc/raidtab to create a raid1 with /dev/hda1 and
> /dev/hdc1, mkraid it, mkfs it, mount it under /mnt and copy root back into
> it as before, edit /mnt/etc/lilo.conf and /mnt/etc/fstab to make it
> mounted under /dev/md0. The key lines in lilo.conf are then:
> 
>   boot=/dev/md0
>   root=/dev/md0
>   raid-extra-boot=/dev/hda,/dev/hdc
> 
> and run lilo -r /mnt
> 
> (of-course, substitute /dev/sdX for hdX if you are using SCSI)
> 
> finally, use cfdisk to set the partition type to fd for /dev/hda1 and
> /dev/hdc1 and reboot...
> 
> If this works you'll then have root under /dev/md0 and therefore under
> RAID1... Then you just repeat this for the other partitions - copy them
> into a spare partition (eg the swap one), create an entry in /etc/raditab
> for them, mkraid/mkfs/mount/copy/ edit /etc/fstab, cfdisk the partition
> types and off you go. Finally make the swap partition RAID1, run mkswap on
> it, and re-enable it in the fstab.

I don't actually understand what you are doing hereby... I mean: doesn't 
it suffice to start RAID and it handles the "mirroring" and all the 
stuff? Just following the HOW TO wouldn't be enough?

> It's tedious, but it doesn't really take that long if you just install a
> bare minimal system to start with, then raid the lot, then use dselect or
> tasksel to install all the other applications you need.
> 
> One other tip if you are using ext3 is to tune2fs -i0 -c0 /dev/hdaX after
> the mkfs -t ext3 ... to make sure it's not force checked after so many
> days/mounts.

That's another "black hole" in my knowledge: what is this thing above?!?

> Enjoy...
> 
> Gordon

Thank you very much for your time and your explanations...

-- 
-----------------------------------
Boniforti Flavio
Provincia del Verbano-Cusio-Ossola
Ufficio Informatica

Tecnoparco del Lago Maggiore
Via dell'Industria, 25
28924 Verbania
-----------------------------------
