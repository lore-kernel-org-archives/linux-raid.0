From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: Booting from raid1 -- md: invalid raid superblock magic on sdb1
Date: Sat, 26 Nov 2005 23:36:37 -0500
Message-ID: <055901c5f30c$282ad520$200a11ac@NCNF5131FTH>
References: <050501c5f2a4$fe72c560$200a11ac@NCNF5131FTH> <054001c5f2bc$642a62c0$200a11ac@NCNF5131FTH>
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

On Saturday 26 November 2005 14:03:35, David M. Strang wrote:
> On Saturday 26 November 2005 11:14:46, David M. Strang wrote:
> > sdb1 is a 400GB partition -- it is type FD.
> >
> > Disk /dev/sdb: 400.0 GB, 400088457216 bytes
> > 2 heads, 4 sectors/track, 97677846 cylinders
> > Units = cylinders of 8 * 512 = 4096 bytes
> >
> >    Device Boot      Start         End      Blocks   Id  System
> > /dev/sdb1               1    97677846   390711382   fd  Linux raid 
> > autodetect
> >
> OK, I've dumped the autodetect raid type. It seems it's pointless on v1.0 
> superblocks -- it was just generating an 'extra' error.
>
> Disk /dev/sdb: 400.0 GB, 400088457216 bytes
> 2 heads, 4 sectors/track, 97677846 cylinders
> Units = cylinders of 8 * 512 = 4096 bytes
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1               1    97677846   390711382   83  Linux
>
> > Here is my lilo.conf settings; I'm attempting to get it to mount md_d0 
> > when the kernel starts. I realize that automount (type FD) no longer 
> > functions with a version-1 superblock.
> >
> > #
> > # /etc/lilo.conf: lilo(8) configuration, see lilo.conf(5)
> > #
> >
> > lba32
> > install=text
> > boot=/dev/sda
> > map=/boot/System.map
> > image=/vmlinuz
> >         label=CRUX
> >         root=/dev/sda1
> >         read-only
> >         append="quiet md=d0,/dev/sdb1"
> >
> > # End of file
> >
> >
> > Without fail, every time the system boots -- I get the following 
> > message:
> >
> > md: invalid raid superblock magic on sdb1
> >
>
> This still persists. Are there some patches to the kernel or something 
> that I need for it to recognize v1.0 superblocks? I'm running Linux 
> v2.6.14.3
>
> As I mentioned before, mdadm can state the array w/o any issues at all...

Please forgive me for pinging you direct on this Neil; but I fear you are 
the only one who can answer it.

I am a bit considered by this in the startup log:

Nov 26 21:47:35 xenogenesis kernel: md: raid1 personality registered as nr 3
Nov 26 21:47:35 xenogenesis kernel: md: md driver 0.90.2 MAX_MD_DEVS=256, 
MD_SB_DISKS=27
Nov 26 21:47:35 xenogenesis kernel: md: bitmap version 3.39

While mdadm lets me start a v1.0 superblock; I fear that I missing some 
level of kernel patch.

Nov 26 21:47:35 xenogenesis kernel: md: Loading md_d0: /dev/sdb1
Nov 26 21:47:35 xenogenesis kernel: md: invalid raid superblock magic on 
sdb1
Nov 26 21:47:35 xenogenesis kernel: md: sdb1 has invalid sb, not importing!
Nov 26 21:47:35 xenogenesis kernel: md: md_import_device returned -22

-(root@xenogenesis)-(/usr/src/linux-2.6.14.3/drivers/md)- # mdadm -A 
/dev/md_d0 /dev/sdb1
mdadm: /dev/md_d0 has been started with 1 drive (out of 2).
-(root@xenogenesis)-(/usr/src/linux-2.6.14.3/drivers/md)- # mdadm --detail 
/dev/md_d0
/dev/md_d0:
        Version : 01.00.02
  Creation Time : Sat Nov 26 10:20:11 2005
     Raid Level : raid1
     Array Size : 390711372 (372.61 GiB 400.09 GB)

I've searched the linux-raid archive; but all the patches I see that might 
be relevent, have long been applied to the tree.

-- David M. Strang 

