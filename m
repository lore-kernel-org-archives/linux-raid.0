From: "Vince W." <listacct1@lvwnet.com>
Subject: Re: grub-install to mdp-style RAID1 array?
Date: Sun, 26 Mar 2006 11:40:04 -0500
Message-ID: <4426C3E4.1070304@lvwnet.com>
References: <44269E72.209@lvwnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44269E72.209@lvwnet.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Vince W. wrote:
> 
> The command I used to create the array was:
> 
> # mdadm --create /dev/mdpraid --auto=mdp --level=1 --raid-devices=2 
> /dev/hdi /dev/hdk
 >
 > running interactive grub shell:
> 
>     GNU GRUB  version 0.95  (640K lower / 3072K upper memory)
> 
>  [ Minimal BASH-like line editing is supported.  For the first word, TAB
>    lists possible command completions.  Anywhere else TAB lists the 
> possible
>    completions of a device/filename.]
> 
> grub> device (hd0) /dev/mdpraid
> 
> grub> root (hd0,  <- tab completion attempt to see what it will say:
>  Possible partitions are:
>    Partition num: 0,  Filesystem type is ext2fs, partition type 0x83
>    Partition num: 1,  Filesystem type unknown, partition type 0x82
>    Partition num: 2,  Filesystem type is ext2fs, partition type 0x83
> 
> grub> root (hd0,0)
>  Filesystem type is ext2fs, partition type 0x83
> 
> grub> setup
> 
> Error 11: Unrecognized device string
> 

Uh, turns out I wasn't using the right syntax....

typing this instead worked:

grub> setup (hd0)

I can now boot from the partitioned MD device.  woo-hoo!

Now to see if I can pull the 1st drive and boot from the 2nd drive in 
the array.

Vince
