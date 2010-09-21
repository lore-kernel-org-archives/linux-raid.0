From: Neil Brown <neilb@suse.de>
Subject: Re: Debian kernel stanza after aptitude kernel upgrade
Date: Wed, 22 Sep 2010 06:29:46 +1000
Message-ID: <20100922062946.7e56d1d1@notabene>
References: <30D96C04B1444C569D53B7790707D718@DesktopManie>
	<4C98CCCD.80101@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C98CCCD.80101@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@seoss.co.uk>
Cc: "A. Krijgsman" <a.krijgsman@draftsman.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 21 Sep 2010 16:18:37 +0100
Tim Small <tim@seoss.co.uk> wrote:

> On 21/09/10 11:39, A. Krijgsman wrote:
> > Stupid me! I didn't check the menu.lst of my grub, and apperantly 
> > aptitude rebuilded the initrd for the new kernel.
> > The sysadmin I got the server managed to het the md device back online 
> > and I can now access my server again trough ssh.
> 
> Once you've installed the extra disk, I think you need to stick the 
> output of
> 
> mdadm --examine --scan
> 
> into /etc/mdadm/mdadm.conf

It is generally better to use 
    mdadm --detail --scan

for generating mdadm.conf as it is more likely to get the device names
right.  And when doing this by hand, always review the output to make sure it
looks right.

NeilBrown


> 
> and then run
> 
> update-initramfs -k all -u
> 
> This isn't particularly well documented, so feel free to update the 
> documentation and submit a patch ;o).  You shouldn't need to hard-code 
> the loading of raid1 etc. in /etc/modules.
> 
> 
> 
> A good quick-and-dirty hack to check that a machine will reboot 
> correctly is to use qemu or kvm.  The below should be fine, but to be on 
> the safeside, create a user which has readonly access to the raw hard 
> drive devices, and run the following as that user:
> 
> qemu -snapshot -hda /dev/sda -hdb /dev/sdb -m 64 -net none
> 
> The "-snapshot" will make the VM use copy-on-write version of the real 
> block devices.  The real OS will continue to update the block devices 
> "underneath" the qemu, so the VM will get confused easily, but it's good 
> enough as a check check to the question "will it reboot?".
> 
> 
> >
> > #My menu.list for grub:
> 
> Err, if that's all of it, then I'd guess you're not using the debian 
> mechanisms to manage it?  I'd probably switch back to using the Debian 
> management stuff, it handles adding new kernels etc. fairly well.
> 
> 
> 
> > Since Grub loads the initrd-image from one of the two disks, if one 
> > fails, it won't boot the md root device anyway right?
> > Is it that whel /dev/sda fails, /dev/sdb becomes /dev/sda? (or must I 
> > state that hd1 becomes hd0 when hd0 has failed?)
> 
> This is a bit of a pain with grub1 - grub2 handles it a bit better.  
> With all BIOSes I've seen, if the first disk dies, the second disk 
> becomes BIOS disk 0x80 (i.e. (hd0) in grub).  The workaround is to run 
> grub-install twice, telling grub that hd0 is sdb the second time by 
> manually editing /boot/grub/device.map  Once grub has loaded the kernel 
> and initrd into RAM, then the md code should stand a reasonable chance 
> of working out which drive is OK.
> 
> 
> Tim.
> 
> > This because I would prefere a stanza that always boots up in degraded 
> > mode, rather then in a panic kernel mode ;-)
> > I have seen stanza's containing both disksk within one stanza, don't 
> > know if this is old or still supported?
> >
> > Thanks for your time to read and hopefully reply!
> >
> > Regards,
> > Armand
> > -- 
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

