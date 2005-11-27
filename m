From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: Booting from raid1 -- md: invalid raid superblock magic on sdb1
Date: Sun, 27 Nov 2005 14:14:10 -0500
Message-ID: <058201c5f386$bf23d150$200a11ac@NCNF5131FTH>
References: <050501c5f2a4$fe72c560$200a11ac@NCNF5131FTH> <054001c5f2bc$642a62c0$200a11ac@NCNF5131FTH> <055901c5f30c$282ad520$200a11ac@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Saturday 26 November 2005 23:32:51, David M. Strang wrote
> Please forgive me for pinging you direct on this Neil; but I fear you are 
> the only one who can answer it.
>
> I am a bit considered by this in the startup log:
>
> Nov 26 21:47:35 xenogenesis kernel: md: raid1 personality registered as nr 
> 3
> Nov 26 21:47:35 xenogenesis kernel: md: md driver 0.90.2 MAX_MD_DEVS=256, 
> MD_SB_DISKS=27
> Nov 26 21:47:35 xenogenesis kernel: md: bitmap version 3.39
>
> While mdadm lets me start a v1.0 superblock; I fear that I missing some 
> level of kernel patch.
>
> Nov 26 21:47:35 xenogenesis kernel: md: Loading md_d0: /dev/sdb1
> Nov 26 21:47:35 xenogenesis kernel: md: invalid raid superblock magic on 
> sdb1
> Nov 26 21:47:35 xenogenesis kernel: md: sdb1 has invalid sb, not 
> importing!
> Nov 26 21:47:35 xenogenesis kernel: md: md_import_device returned -22

Just a quick update; I've been putting forth some due diligence on this --  
and it appears basically, that do_mounts_md.c is an antique. I've added a 
small debug line to md.c under md_import_device; and then also traced thru 
the do_mounts_md.c code; and basically the crux of the situation is 
do_mounts_md.c doesn't evaluate the superblock of the device and set 
SET_ARRAY_INFO for persistent superblocks. So, everything defaults to the 
legacy superblock type. (Superblock v0.90.x)

-- David M. Strang



