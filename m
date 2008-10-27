From: Luca Berra <bluca@comedia.it>
Subject: Re: question on how to (correctly) build an initrd for a root disk
	on a RAID1
Date: Mon, 27 Oct 2008 08:16:13 +0100
Message-ID: <20081027071613.GA8197@maude.comedia.it>
References: <9f5edc120810261937w339f2919p4f7ce82fbcaf2149@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9f5edc120810261937w339f2919p4f7ce82fbcaf2149@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 26, 2008 at 10:37:17PM -0400, Joe Landman wrote:
>Hi folks:
>
>  We have been trying to build an operational initrd for a root drive
>on  software RAID1.
>
>  Basic specs:   2.6.23.14 kernel (though same issues with 2.6.27.2
>kernel), on Centos 5.2, pair of SATA drives using libata and other
>drivers, x86_64 architecture.
Custom built kernel or centos provided kernel?


>  Using mkinitrd --with=raid1 --with=libata --with=sd_mod ...
>
>  I am getting a kernel panic on switchroot, it can't find the root
>file system.  I did some googling, but could not find a similar
>example.
unfortunately the kernel panic is a consequence of a previous error,
someone willing to help you would need to know everithing that was
spitted between the 'starting red-hat nash' message and the kernel
panic.

>Do I need to create a specialized init script?  Is there an
usually no, redhat/centos initrd should be able to boot from a raid1

>example of this somewhere?  I did look at the Documentation/md.txt and
>tried the
>
>     md=0,sda1,sdb1 md=1,sda2,sdb2  md=2,sda3,sdb3
if you are using the centos kernel, raid is modular and this parameter
has no effect.
mkinitrd should use your /etc/mdadm.conf to discover how the array
should be laid out.

>  kernel boot time option, to no avail.  Persistent superblocks are
>on, and the devices have the right partition types.
partition types do not matter anymore.

>
>  Any suggestions?  More things to read?
is your fstab correct?
is your mdadm.conf correct?
are you loading the correct drivers for your hd controller?

mkinitrd is a shell script, if all else fails, run it with sh -x and
read the output.

L.
-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
