From: andy liebman <andyliebman@aol.com>
Subject: Re: Making bootable SATA RAID1 array in Mandriva 2006
Date: Wed, 16 Aug 2006 09:12:13 -0400
Message-ID: <44E319AD.6040603@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: bluca@comedia.it, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> 
>>I'm not sure I understand what you're saying about mounting /dev, /proc 
>>and /sys.
> 
> just run:
> mount --bind /dev /newroot/dev
> mount -t proc /proc /newroot/proc
> mount -t sysfs /sys /newroot/sys
> before chrooting
> 
> L.
> btw, be sure to add "auto=yes" to the ARRAY lines in /etc/mdadm.conf
> or you might find some arrays are not recognized after boot.
> 
> L.

Thank you Luca. That was helpful. I have a couple of other questions 
about Mandriva and mkinitrd. They probably don't belong on this list. 
But we're both here.

1)  I am running a custom-compiled 2.6.16.20 kernel on Mandriva 2006. 
When I run mkinitrd, I'm getting several messages "skip dups". Is that 
anything to be concerned about? I googled that and can't find anything.

2)  It seems the format of initrd's being made is cpio + gz. In other 
words, if I want to inspect the initrd, I cannot use the technique that 
I always used:

mkdir /tmp/initrd
cd initrd
cp /boot/newinitrd.img .
mv newinitrd.img newinitrd.ext2.gz
gunzip newinitrd.ext2.gz
mkdir mount
mount newinitrd.ext2 mount -o loop

That doesn't work anymore with the 2.6.16 kernel. Now I have to do:

mkdir /tmp/initrd
cd initrd
cp /boot/newinitrd.img .
mv newinitrd.img newinitrd.ext2.gz
gunzip newinitrd.ext2.gz
mkdir mount
cd mount
cpio -id < ../newinitrd.ext2


Does that make sense? Has the format changed for initrd's. I also 
noticed that the new initrds have a script called "init" instead of 
"linuxrc".

Andy
