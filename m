From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: Booting from raid1 -- md: invalid raid superblock magic on sdb1
Date: Sun, 27 Nov 2005 21:11:02 -0500
Message-ID: <05d301c5f3c0$fb6f6860$200a11ac@NCNF5131FTH>
References: <050501c5f2a4$fe72c560$200a11ac@NCNF5131FTH><054001c5f2bc$642a62c0$200a11ac@NCNF5131FTH><055901c5f30c$282ad520$200a11ac@NCNF5131FTH><058201c5f386$bf23d150$200a11ac@NCNF5131FTH> <17290.11404.619425.81197@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday November 27 2005 16:56:47, NeilBrown wrote:
> Yes, do_mounts_md assumes v0.90.
> The following patch will allow you to specify the version in the
> kernel parameters, something like
>    md=d0,v1.0,/dev/sda,/dev/sdb
>
> (though I haven't tested it).
> However I'm not at all convinced that I want to go down this path.
>

Nov 27 20:06:53 xenogenesis kernel: md: Skipping autodetection of RAID 
arrays. (raid=noautodetect)
Nov 27 20:06:53 xenogenesis kernel: md: Unknown device name: v1.0

I need to dig into this a bit more; but it didn't care for that syntax too 
much.

> It is not at all hard to create an initramfs which runs mdadm to do
> the right thing.  With mdadm-2.2 (to be released soonish), it will be
> even easier.

> In general I would rather steer away from do_mounts_md.c assembling
> root md arrays, and steer towards using mdadm in an initramfs.  That
> doesn't mean that I won't submit the following patch into a future
> kernel, but it does mean that I might not....

This could be my own ingorance of how initrd works; but I'm looking to boot 
completely from a raid1 mirror -- and have NO 'normal' partitions. Is this 
possible with initrd? I've been doing quite a bit of reading, and most of 
this is me being lead down the path of how crappy 'software assisted' 
hardware raids are. I have a TYAN S5350-1U board -- it came with the TARO 
SO-DIMM M8110 SATA raid controller... well, this controller is based off the 
Adaptec AIC-8110 chipset. From all my digging, short of the basic binary 
only drivers available from download this controller doesn't work for beans 
in Linux. So, I've defaulted to the onboard SATA controller.. and while it 
has a raid controller (6300ESB) it's one of 'software assisted raids' -- I 
saw the dmraid option; but the advice I found was that unless you are dual 
booting to another OS, it makes a lot more sense to use the software raid 
(md) -- I have a quite successful 28 disk raid5 software raid running here 
(many thanks to Neil, for his tweaks to mdadm and advice on recovering it 
each time failure occured) -- so I felt quite confident in md + mdadm. 
Essentially, the end goal -- is if either drive fails, the system should not 
go down. So, I invoked the paritioned MD route; and created it on top of a 
single large partition for each drive. I'm still working out bootloader 
bugs...

So, excuse the rambling -- but in a nutshell, will the following 
configuration work with initrd?

400GB --> single partition --> /dev/sda1    \
                                                                   |---  
/dev/md_d0 ---> 4 partitions
400GB --> single partition --> /dev/sdb1    /

(I hope my ascii drawing comes out in the list!)

Is that feasible with an initrd? Since I'm not intending to have any 
standard partitions.

-- David M. Strang 

