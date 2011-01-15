From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID for USB flash drives
Date: Sat, 15 Jan 2011 20:54:31 +0000
Message-ID: <4D320987.7020001@anonymous.org.uk>
References: <AANLkTi=kcbanFit5x27ccS_1RChxC=Dn+Hs4Ak+FbKsX@mail.gmail.com>	<4D237E70.6030104@anonymous.org.uk> <AANLkTi=cOHgdradDDOFTdZ_xOGMXv8qf_n6xxppGA12y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=cOHgdradDDOFTdZ_xOGMXv8qf_n6xxppGA12y@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hank Barta <hbarta@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/01/2011 23:25, Hank Barta wrote:
> On Tue, Jan 4, 2011 at 2:09 PM, John Robinson
> <john.robinson@anonymous.org.uk>  wrote:
>
>>
>> First up, booting. You'll have to boot off a bare device which may in fact
>> be a mirror over 2 or more sticks. Make that your first partition. I think
>> it's simpler to make it over all 4. Look up booting from RAID to find out
>> how.
>
> I should have read this more carefully. I performed a full install to
> a raid0 only to find it incapable of setting up grub. It simply told
> me there was a fatal error. :-/ It took me a bit more research before
> the reality of your comment sunk in. So I proceeded again and tried to
> use the first 100MB of each stick to create a 4 device raid1.

I'm sorry I wasn't clearer. Yes, I meant you needed a RAID-1 on small 
partitions across all 4 sticks for your /boot partition, just as you 
would need a RAID-1 across both your hard drives if you were installing 
on those. (I believe new grub can cope with other RAID levels but I 
don't have any experience with it.) You also need to have the partitions 
starting no earlier than sector 63, to give grub somewhere to put its 
filesystem-aware code.

> For some
> reason, the partitioning S/W (Ubuntu 10.04.1 server) didn't like that
> and just hung when it tried to discover the disks. Repeatedly. I
> finally worked around that by deleting the 100 MB partitions on three
> of the four drives and just using the first 100 MB on one of the
> drives for a /boot partition. I completed the installation but the
> system hung on boot. It just provides a blank screen. Experimenting
> with the installation USB drive, it seemed to me that I couldn't even
> boot that with all five thumb drives installed. I scaled back to
> installation three USB drives, install media on a fourth. I also
> figured out which slot I needed to put the install media in so as to
> boot. The BIOS - or perhaps some stage in the boot process - gets
> confused otherwise.
>
> I've booted a live CD and tried running grub-install from a chroot
> with the /boot and / file systems and the command concluded w/out any
> errors or warnings. But the system still will not boot. I'm not sure
> if this is a grub or a RAID problem or some combination.
>
> Is there something I need to include with grub when the root file
> system is on a RAID0?

I think you need your final boot media in the right place while you're 
running the installer. Booting off one USB stick (your installation 
drive) while trying to make another bootable is liable to go wrong, or 
at least give you a slightly incorrect mdadm.conf or make grub-install 
do the wrong thing. If you can, just plug in the 4 USB sticks you're 
installing on, and hook up a DVD-ROM drive via IDE or SATA to install from.

Even then, you could have trouble unless you make very sure grub-install 
installs on ALL FOUR of your destination USB sticks, because it's 
possible your BIOS will detect the USB sticks in a different order than 
the Linux kernel does. (I don't know that for sure but I wouldn't be 
surprised, I've seen it happen with hard drive interfaces.) grub-install 
should get it right as long as your RAID-1 /boot is spread across all 4 
USB sticks, as long as you're not using USB install media (as per 
previous para).

You will also need to make sure your initrd or initramfs includes the 
USB drivers if it doesn't do that automatically, as well as the 
usb-storage, scsi and md modules for your root filesystem, and just to 
be sure I'd include raid1.ko so it can potentially start /boot as well.

I may be being over-cautious with some of what I say above, but 
hopefully I've covered all the possibilities even if some are overkill, 
and your installer is likely getting more right than I'm giving it 
credit for. Anyway, once again, good luck!

Cheers,

John.
