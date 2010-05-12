From: Neil Brown <neilb@suse.de>
Subject: Re: Doubt about mdadm - v2.6.7.1 - 15th October 2008
Date: Wed, 12 May 2010 11:03:35 +1000
Message-ID: <20100512110335.166b79bc@notabene.brown>
References: <AANLkTim3XpTGBR8n7gdcXSABvnQxFExWM2xNd8AarSa5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim3XpTGBR8n7gdcXSABvnQxFExWM2xNd8AarSa5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Light King <thelightking@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 11 May 2010 12:07:08 +0530
Light King <thelightking@gmail.com> wrote:

> hello  ,
> 
> i m using mdadm - v2.6.7.1 .  when I m creating a raid array of 4 disk
> using command
> 
> mdadm --create --chunk=64 --level=0 --raid-devices=4 /dev/md99
> /dev/sda /dev/sdb /dev/sdc /dev/sdd
> 
> 
> in dev directory of my PC I m getting md99 device and along with this
> md_d99 . So I m not able understand what is this md_d99 ? this thing
> was not happening previously in previous versions of mdadm .
> 

Does this extra "md_d99" appear when you create the array, or only when you
assemble it, or only after reboot?

What does
  ls -l /dev/md* 
show?

> 
> another issue if i reboot the PC also it shd keep active the md99
> array , but it is not happening . in cat /proc/mdstat only I can found
> md_d99 .

This sounds like the array is being assembled by udev issuing
   mdadm -I devname
commands, the somehow "mdadm -I" is getting confused about whether to create
a partitioned array or not (/dev/md99 cannot have partitions, /dev/md_d99
can).

Maybe try:

 mdadm -Ss
 mdadm -Ivv /dev/sda
 mdadm -Ivv /dev/sdb
 mdadm -Ivv /dev/sdc
 mdadm -Ivv /dev/sdd
 cat /proc/mdstat
then report the output of all of that.

All the config files you listed look OK.

NeilBrown



> 
> I created a array with the following command
> mdadm --create --chunk=64 --level=0 --raid-devices=4 /dev/md99
> /dev/sda /dev/sdb /dev/sdc /dev/sdd
> 
> before reboot the system in cat /proc/mdstat I used to get md99 but
> after reboot following things are coming ~~~~~~~~
> 
> 
> cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md_d99 : inactive sdb[0](S)
>       15646592 blocks
> 
> unused devices: <none>
> 
> 
> 
> cat /proc/cmdline
> BOOT_IMAGE=/boot/vmlinuz-2.6.31.9-scst
> root=UUID=778e7d82-4733-4de5-977b-268cdba8bdda ro
> 
> 
> 
> root@dmachine:~# cat /etc/mdadm/mdadm.conf
> # mdadm.conf
> #
> # Please refer to mdadm.conf(5) for information about this file.
> #
> 
> # by default, scan all partitions (/proc/partitions) for MD superblocks.
> # alternatively, specify devices to scan, using wildcards if desired.
> DEVICE partitions
> 
> # auto-create devices with Debian standard permissions
> CREATE owner=root group=disk mode=0660 auto=yes
> 
> # automatically tag new arrays as belonging to the local system
> HOMEHOST <system>
> 
> # instruct the monitoring daemon where to send mail alerts
> MAILADDR root
> 
> # definitions of existing MD arrays
> 
> # This file was auto-generated on Wed, 03 Feb 2010 10:47:50 -0500
> # by mkconf $Id$
> ARRAY /dev/md0 level=raid1 num-devices=2
> UUID=602a804e:91caebca:9492a6f6:c7fe0f79
> ARRAY /dev/md1 level=raid1 num-devices=2
> UUID=09d42156:0a8b8429:9492a6f6:c7fe0f79
> 
> 
> regds
> 
> Anshuman
> 
> 
> 
> 
> 
> 
> 
> the light king
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

