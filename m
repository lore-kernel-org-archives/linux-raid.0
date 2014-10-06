From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: UEFI and mdadm questions.
Date: Mon, 06 Oct 2014 08:14:59 +0200
Message-ID: <54323363.7020308@gmail.com>
References: <BLU436-SMTP10330CBEBC0CA1E27853BE498B80@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU436-SMTP10330CBEBC0CA1E27853BE498B80@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: "Wilson, Jonathan" <piercing_male@hotmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

On 10/01/2014 06:33 PM, Wilson, Jonathan wrote:
> From what I can tell with UEFI I need to set up a UEFI partition with a
> FAT format.
> 
> On my current BIOS system I have a Biosboot 1M, /boot Raid1 200M and /
> Raid 1 40G.
> 
> Obviously Grub installs to the mbr, and then installs a bit into
> Biosboot which can read raids, hence it can read and boot from /boot.
> 
> Further, from what I can tell, into the UEFI partition can go either a
> kernel & initramfs with UEFI support, or a "loader" that then loads the
> kernel.
> 
> What I am unsure about are... 
> 
> 1)  Can the loader/kernel understand md raid? so the / can be in a bog
> standard raid1 v1.2?
> 
> 2) I'm guessing I would no longer need the /boot as that would be
> replaced by what ever was in the UEFI partition?
> 
> 3) as my "/boot" is currently in a raid 1 my life is simple, should any
> changes occur they are replicated to the drives I have set up as /boot
> raid 1, and I installed the mbr portion of boot loader manually on each
> disk and tested pulling one, and then booting from another.. it
> worked :-)
> So I would like to keep things, if not simple, at least less likely to
> have problems because I forgot to install duplicates of the UEFI on all
> the disks... so can I use a .90v raid1 on the UEFI partition, then
> format it as fat... so that all copies of what ever is in the UEFI
> partition are replicated across the multiple raid1 disks, instead of
> having to remember to copy what ever is in there manually to ach disk?
> 

There was already a post on that subject you can find here:
http://comments.gmane.org/gmane.linux.raid/45611

It might answer some of your questions.

Bye.

