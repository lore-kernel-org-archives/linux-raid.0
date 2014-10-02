From: Anthonys Lists <antlists@youngman.org.uk>
Subject: Re: UEFI and mdadm questions.
Date: Thu, 02 Oct 2014 01:17:55 +0100
Message-ID: <542C99B3.6060809@youngman.org.uk>
References: <BLU436-SMTP10330CBEBC0CA1E27853BE498B80@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU436-SMTP10330CBEBC0CA1E27853BE498B80@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: "Wilson, Jonathan" <piercing_male@hotmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/10/2014 17:33, Wilson, Jonathan wrote:

I've just been struggling with exactly this trying to move my gentoo 
system on to raid ...
>  From what I can tell with UEFI I need to set up a UEFI partition with a
> FAT format.

I believe so, yes.
>
> On my current BIOS system I have a Biosboot 1M, /boot Raid1 200M and /
> Raid 1 40G.
>
> Obviously Grub installs to the mbr, and then installs a bit into
> Biosboot which can read raids, hence it can read and boot from /boot.

Is this grub1, or grub2? I gather grub1 actually CAN'T read raid, which 
is why you need to use raid version 0.9. Grub then thinks the disk is 
plain ext4 or whatever, and reads it fine. grub2 actually handles raid, 
and therefore is happy with newer raids like 1.2
>
> Further, from what I can tell, into the UEFI partition can go either a
> kernel & initramfs with UEFI support, or a "loader" that then loads the
> kernel.
>
> What I am unsure about are...
>
> 1)  Can the loader/kernel understand md raid? so the / can be in a bog
> standard raid1 v1.2?

Don't think so. Apparently the kernel can NOT put a raid array together 
so you have a catch-22 - the kernel needs the raid in order to start 
user-space, but it needs user-space in order to find the raid ... :-(

So you need an initramfs to solve the conundrum. And of course, grub1 
doesn't work with uefi :-(
>
> 2) I'm guessing I would no longer need the /boot as that would be
> replaced by what ever was in the UEFI partition?

You do need /boot - not least so grub2 can find its config file (that's 
not quite true, but close enough...)

>
> 3) as my "/boot" is currently in a raid 1 my life is simple, should any
> changes occur they are replicated to the drives I have set up as /boot
> raid 1, and I installed the mbr portion of boot loader manually on each
> disk and tested pulling one, and then booting from another.. it
> worked :-)

In the world of grub2/raid1.2 I wish things looked that simple. From my 
"badly burned novice" viewpoint, I don't think it is.

> So I would like to keep things, if not simple, at least less likely to
> have problems because I forgot to install duplicates of the UEFI on all
> the disks... so can I use a .90v raid1 on the UEFI partition, then
> format it as fat... so that all copies of what ever is in the UEFI
> partition are replicated across the multiple raid1 disks, instead of
> having to remember to copy what ever is in there manually to ach disk?

Interesting idea ... but I get the impression that once you've set up 
the uefi partition and got it working, you shouldn't normally ever need 
to go back to it. This is, I think, one of those cases you need to set 
up a crib sheet and not do anything without it, as you'll forget from 
one time to the next (which is why, I think, you want to use raid :-) 
Personally, I *wouldn't* want to use raid, on the assumption that I'm 
going to screw it up and  don't want a mirror trashing disk2 as I trash 
disk1.

Cheers,
Wol
