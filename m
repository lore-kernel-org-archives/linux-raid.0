From: "Christer Backstrom" <cbackstrom@chemist.com>
Subject: Re: Firewire RAID bootparameters?
Date: Sat, 13 Dec 2003 06:19:47 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031213111947.99239.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message -----
From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Date: Fri, 12 Dec 2003 14:19:52 -0500
To: Christer Bäckström <cbackstrom@chemist.com>
Subject: Re: Firewire RAID bootparameters?

> I'm not sure which distro you're running, but we needed a module to load
> before another one and I modified the linuxrc script in our initrd image
> to change the load order.
> 
> Red Hat (and probably other distros) initrd images have a script in the
> initrd image to load drivers.  You can loop mount the current image, add
> the modules you need, modify the script, and then copy it back into
> /boot.
> 
> The initrd image in Red Hat is gzipped so this is the procedure that I
> follow:
> 
> . *** MAKE A BACKUP COPY OF YOUR CURRENT INITRD AND BOOTLOADER CONF ***
> . cp /boot/initrd.img /tmp
> . cd /tmp
> . mv initrd.img initrd.img.gz
> . gunzip initrd.img 
> . mount -o loop initrd.img /mnt/cdrom
> . Copy any necessary modules to /mnt/cdrom/lib
> . Edit /mnt/cdrom/linuxrc and add a couple of lines to load your
> firewire module in the proper order.
> . umount /mnt/cdrom
> . gzip /tmp/initrd.img
> . cp /tmp/initrd.img.gz /boot/mynewinitrd.img
> 
> Then what I would do is make a new bootloader (LILO/GRUB) entry with all
> the same options except use your edited initrd image instead of the
> stock one.  That way you can test it, but still be able to boot with you
> known-good initrd image.
> 
> This is probably a big hack, but it worked for me :)

Yes, this is new information for me. I never considered (or knew how to) manipulate the initrd loading. I got two more mails saying about the same thing, but they weren't cc:ed to the list. (Thanks Joe Pruett and David Haring) This would enable me to put even my root-filesystem on the firewire drive. Very nice. In my case, as I only keep my /home on the raid1 mirror, it was even simpler. I looked into the initrd man page, and found  a reference to append "noinitrd" to lilo.conf, which stops loading of modules by initrd altogether. The rc.sysinit will then, in my case (Mandrake-9.2), load the modules in the right order. I stiil wonder if the loading sequence should not be different when loading compiled-in modules. Nowadays firewire and usb2 drives are fast and commonplace, and an excellent way of securing the regular harddrive. Especially on a laptop, where the regular drives are small a
 nd singular. To load the raid subsystem before these systems can't be right. I wonder if i
 t should not be changed? Anyways: Me happy. Thanks all for the help!

/Chris

> 
> Hope this helps,
> Andy.
> 
> 
> On Fri, 2003-12-12 at 07:45, Christer BÃ¤ckstrÃ¶m wrote:
> > Hi,
> > 
> > I've recently bought a 160Gb firewire drive and RAID1:ed it to mirror my 
> > main harddrive. Unfortunately, the md subsystem seems to load before the 
> > firewire in the kernel bootsequence, which mean I have to do some weird 
> > stuff to make it work. Basically, I compiled the md system as modules 
> > (with the SCSI patch to make it work a bit better), and hid the modules 
> > in a different directory, so they wouldn't load. I later load them in 
> > manually rc.sysinit. This work, but is a little clumsy. Is there a way 
> > to use append any boot-parameters to lilo to make the RAID subsystem 
> > load the firewire system? Or is there another solution? Thanks,
> > 
> > 
> > /Chris
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -- 
> 
> Regards,
> Andrew Rechenberg
> Infrastructure Team, Sherman Financial Group
> 
> 
-- 
___________________________________________________________
Sign-up for Ads Free at Mail.com
http://promo.mail.com/adsfreejump.htm

