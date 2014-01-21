From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: If separate md for /boot, OS, and /srv, must 'create' on disks
 with 3 partns?
Date: Tue, 21 Jan 2014 08:02:15 +0000
Message-ID: <BLU0-SMTP448236D742C629A9419C4D98A40@phx.gbl>
References: <52DC1BED.7070901@tesco.net> <52DC39A7.5020506@turmel.org>
	 <52DD5471.4070809@tesco.net> <52DD6B20.5030906@turmel.org>
	 <52DD73FC.7000801@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52DD73FC.7000801@tesco.net>
Sender: linux-raid-owner@vger.kernel.org
To: Ron Leach <ronleach@tesco.net>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 2014-01-20 at 19:07 +0000, Ron Leach wrote:
> On 20/01/2014 18:29, Phil Turmel wrote:
> >
> > Let me clarify:  /dev/md0 should be a v0.90 or v1.0 raid1 for /boot, no LVM.
>  >
>  > /dev/md1 is an LVM PV for the OS.
> 
> 
> Ok.  That means I need physical partitions for those, on each of the 
> drives.
> 
> Since I am using 3TB drives, I'll need to use a GPT which, if I 
> understand correctly, requires to reveal a dummy 'partition' to make 
> the BIOS think there is a boot sector thingy there.
> 
> So I'm assuming to pre-partition the physical devices this way:
> 
> /dev/sd[x]1 - 64k (? I'm checking the docs) empty, for BIOS to see

I've set mine to 1MB (bios boot, EF02 in gdisk) this means it aligns
nicely on the 1 MB partition as does its start position 2048 sectors on
a 512e drive.

> /dev/sd[x]2 - 128 MB /boot v0.90/v1.0 RAID1, /dev/md0

I'm not sure here, but I have no problems using a 1.2 metadata
partition... I think the reason it works is that the stuff in biosboot
contains everything needed to boot, the "boot" directory is not needed
with biosboot as its only a temp staging area used to build the boot
loader which is then copied to the biosboot... 

I would check this for yourself just to be sure; I recall I kept it as a
seperate partition due to a miss-understanding and/or it seemed the
"right way" at the time.

> /dev/sd[x]3 - remainder ~3 TB for LVM, v1.2 RAID1, /dev/md1
> 
> and then make the two RAID1s, and then create the LVM.
> 
> >
> >
> > Having root in an LVM allows strange things like relocating and/or
> > resizing it on the fly.  Particularly handy if physical access is difficult.
> >
> 
> Yes, it was that potential aspect that set me deciding to try your 
> approach.  Functional demands on our systems keep changing.
> 
> Much appreciated, Ron
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


