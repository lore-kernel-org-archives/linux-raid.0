From: Phil Turmel <philip@turmel.org>
Subject: Re: SRaid with 13 Disks crashed
Date: Fri, 10 Jun 2011 07:48:44 -0400
Message-ID: <4DF2049C.1020201@turmel.org>
References: <20110610075257.298520@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110610075257.298520@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dragon <Sunghost@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Dragon,

On 06/10/2011 03:52 AM, Dragon wrote:
> I have nothing limited. It's all i get from the bash after excecute the script. i am not aware of using a fast -boot kernel, but i saw that it comes whit kernel version 2.6.28. i think after the raid crashes i upgrade to the last kernel version, because of having the newer mdamd, ext and what ever tools to recover the raid.

Newer kernels have the option to parallel probe.  You got a newer kernel.

> Am i right to use the --backup-file option, i must have a backup file ;)? i didnt have a file.

Your attempt to shrink the array from 13 back to 12 would have needed the file, and you didn't supply one.  mdadm almost certainly told you it wouldn't shrink the array.

> as far as i understand your advise, to recreate the raid and the order of the disks. you choose them by the output off mdadm -E wich gave the actuall number of the disk and the variation at disk sdd and sdn is because of  both shows the same number, right? i think i understand that. but why is disk "j" the last in the order. my output say that disk sdd is number 13, but as spare for sda....?
> here the stand after rebooting at the morning:

Yes, I'm using the "RaidDevice" column to determine which drive is which.  The drive names in the far right column are the original names, before your kernel changed.  They aren't important.  To reconstruct your 13-disk array, the devices from 0 to 12 must be listed in the create command in the correct order.  Two of your devices think they are spares, reporting "RaidDevice" > 12.  They must fit into the two slots that are reported as "faulty removed".

> fdisk  -l|grep sd
> Disk /dev/sdb: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sda: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdc: 20.4 GB, 20409532416 bytes
> /dev/sdc1   *           1        2372    19053058+  83  Linux
> /dev/sdc2            2373        2481      875542+   5  Extended
> /dev/sdc5            2373        2481      875511   82  Linux swap / Solaris
> Disk /dev/sdd: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sde: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdf: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdg: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdh: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdi: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdj: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdk: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdl: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdm: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdn: 1500.3 GB, 1500301910016 bytes

[...]

> ------
> in short:
> /dev/sda:
> this     4       8      176        4      active sync   /dev/sdl
> 
> /dev/sdb:
> this     5       8      192        5      active sync   /dev/sdm
> 
> /dev/sdd:
> this    13       8        0       13      spare   /dev/sda
> 
> /dev/sde:
> this     6       8       16        6      active sync   /dev/sdb
> 
> /dev/sdf:
> this     8       8       32        8      active sync   /dev/sdc
> 
> /dev/sdg:
> this     9       8       48        9      active sync   /dev/sdd
> 
> /dev/sdh:
> this    10       8       64       10      active sync   /dev/sde
> 
> /dev/sdi:
> this    11       8       80       11      active sync   /dev/sdf
> 
> /dev/sdj:
> this    12       8       96       12      active sync   /dev/sdg
> 
> /dev/sdk:
> this     0       8      112        0      active sync   /dev/sdh
> 
> /dev/sdl:     
> this     2       8      128        2      active sync   /dev/sdi
> 
> /dev/sdm:         
> this     3       8      144        3      active sync   /dev/sdj
> 
> /dev/sdn:      
> this    13       8      160       13      spare   /dev/sdk

Good to summarize, but ignore the names on the right.

> after that i would think the order confused because no disk is the right in the first line auf the position. but i would do this:
> 
> mdadm -C /dev/md0 -l 5 -n 13 -e 0.90 -c 64 --assume-clean /dev/sd{k,l,m,a,b,e,?d?,f,g,h,i,j,n} 
> or
> mdadm -C /dev/md0 -l 5 -n 13 -e 0.90 -c 64 --assume-clean /dev/sd{k,l,m,a,b,e,?n?,f,g,h,i,j,d} 

No.  The devices that know where they belong are 0,2,3,4,5,6,8,9,10,11,12.  That would be /dev/sd{k,*,l,m,a,b,e,*,f,g,h,i,j}.  The devices that report 13, /dev/sdd & /dev/sdn, must fit in to positions 1 & 7.  Two possibilities:

/dev/sd{k,d,l,m,a,b,e,n,f,g,h,i,j} or /dev/sd{k,n,l,m,a,b,e,d,f,g,h,i,j}

HTH,

Phil

