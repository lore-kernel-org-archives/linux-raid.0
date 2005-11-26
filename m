From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: Booting from raid1 -- md: invalid raid superblock magic on sdb1
Date: Sat, 26 Nov 2005 14:05:39 -0500
Message-ID: <054001c5f2bc$642a62c0$200a11ac@NCNF5131FTH>
References: <050501c5f2a4$fe72c560$200a11ac@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 26 November 2005 11:14:46, David M. Strang wrote:
> sdb1 is a 400GB partition -- it is type FD.
>
> Disk /dev/sdb: 400.0 GB, 400088457216 bytes
> 2 heads, 4 sectors/track, 97677846 cylinders
> Units = cylinders of 8 * 512 = 4096 bytes
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1               1    97677846   390711382   fd  Linux raid 
> autodetect
>

OK, I've dumped the autodetect raid type. It seems it's pointless on v1.0 
superblocks -- it was just generating an 'extra' error.

Disk /dev/sdb: 400.0 GB, 400088457216 bytes
2 heads, 4 sectors/track, 97677846 cylinders
Units = cylinders of 8 * 512 = 4096 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1    97677846   390711382   83  Linux


> Here is my lilo.conf settings; I'm attempting to get it to mount md_d0 
> when the kernel starts. I realize that automount (type FD) no longer 
> functions with a version-1 superblock.
>
> #
> # /etc/lilo.conf: lilo(8) configuration, see lilo.conf(5)
> #
>
> lba32
> install=text
> boot=/dev/sda
> map=/boot/System.map
> image=/vmlinuz
>         label=CRUX
>         root=/dev/sda1
>         read-only
>         append="quiet md=d0,/dev/sdb1"
>
> # End of file
>
>
> Without fail, every time the system boots -- I get the following message:
>
> md: invalid raid superblock magic on sdb1
>

This still persists. Are there some patches to the kernel or something that 
I need for it to recognize v1.0 superblocks? I'm running Linux v2.6.14.3

As I mentioned before, mdadm can state the array w/o any issues at all...

-- David M. Strang 

