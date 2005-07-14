From: "bart@ardistech.com" <bart@ardistech.com>
Subject: Re: How to auto rebuild array?
Date: Thu, 14 Jul 2005 08:54:28 +0200
Message-ID: <42D60C24.AF0C2931@ardistech.com>
References: <42D3C998.3F84EF1C@ardistech.com> <42D567F7.7010408@ruisantos.com>
Reply-To: bart@ardistech.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rui Santos <rsantos@ruisantos.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Rui,

>     Is that a RAID1 ou RAID5?
> 
It's a RAID5, but the problem also happends on RAID1.

>     Can you give the output of these commands?
> 
>     mdadm --misc -D /dev/md3
>     mdadm --misc -E /dev/hda4
>     mdadm --misc -E /dev/hdb4
>     mdadm --misc -E /dev/hde4
>     mdadm --misc -E /dev/hdf4
> 
>     One other thing. Are you sure that all you raid partitions are
> marked 0xfd ?
> 
There are 0xfd partitions with persistent superblock.

>     Also attach you mdadm.conf/raidconf file, if you have any...
> 
I don't use a /etc/mdadm/mdadm.conf file, the raid is started during kernel
boot with raid autodetect. That's when the 'kicking non-fresh drive' print
occurs. When this happened 'mdadm --detail' will not display the kicked disk
in the list of array disks anymore, also the mdadm deamon only will get the
name of the array that's degraded, not the name of the kicked device :(

I made a script that runs after reboot as fix, it will hott-add the kicked
disks back to the array. It seems to fix the problem.

Regards,
		Bart


-----------------------------------------------------
#! /bin/bash

DEVLIST=`ls /dev/hd??`
for dev in $DEVLIST; do
	 result=`mdadm --query $dev | grep mismatch`
	 if [ -n "$result" ]; then
		raid=/dev/`echo $result | awk 'BEGIN {FS="[ .]"} {print $9}'`
		echo $raid needs $dev added
		mdadm --add $raid $dev
	 fi
done
-----------------------------------------------------




> >
> >I have the problem that after a power failure I get the message:
> >
> >Jul 12 15:29:17 kernel: md: created md3
> >Jul 12 15:29:17 kernel: md: bind<hda4>
> >Jul 12 15:29:17 kernel: md: bind<hdb4>
> >Jul 12 15:29:17 kernel: md: bind<hde4>
> >Jul 12 15:29:17 kernel: md: bind<hdf4>
> >Jul 12 15:29:17 kernel: md: running: <hdf4><hde4><hdb4><hda4>
> >Jul 12 15:29:17 kernel: md: kicking non-fresh hde4 from array!
> >Jul 12 15:29:17 kernel: md: unbind<hde4>
> >
> >I understand that hde4 is not 'fresh' and the array need to be rebuild
> >but I only can do that with 'mdadm --add /dev/md3 /dev/hde4'. I would
> >like to have it turned into a hot-spare, in which case a rebuild would
> >start automatic.
> >
> >This application runs unattended, so there is nobody there to enter
> >mdadm commands.... How can I make the rebuild starting automatic
> >(like a hardware raidcard does)?
> >
