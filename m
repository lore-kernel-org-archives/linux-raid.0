From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID6 simply does not start as /dev/md8
Date: Sun, 10 Apr 2011 23:16:55 -0500
Message-ID: <0E.11.05159.1B082AD4@cdptpa-omtalb.mail.rr.com>
References: <4D9EC097.7010600@web.de>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D9EC097.7010600@web.de>
Sender: linux-raid-owner@vger.kernel.org
To: 'Yann Ormanns' <yann-ormanns@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Yann Ormanns
> Sent: Friday, April 08, 2011 3:00 AM
> To: linux-raid@vger.kernel.org
> Subject: RAID6 simply does not start as /dev/md8
> 
> Hello everybody,
> I've now been trying for over a week to get my RAID6 working.
> I have set up the array by partitioning all six disks (partition type:

	Why?  From your description, it sounds to me like md8 is built using
the whole disk on all 6 drives.  If so, there's really no need to partition
the drives.

> Linux (83)) and executing "mdadm -C /dev/md8 --level=6 --raid-devices=6
> /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1".
> 
> When the array had finished syncing, I rebooted. /proc/mdstat contained
> 	md126 : inactive sde1[4](S) sdd1[3](S)
> 	      3907025072 blocks super 1.2
> 
> 	md127 : inactive sdb1[1](S) sda1[0](S) sdc1[2](S) sdf1[5](S)
> 	      7814050144 blocks super 1.2
> 
> So I put the following lines into /etc/mdadm.conf (I had forgot this
> before):
> "DEVICE /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1
> ARRAY /dev/md8
> devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1,/dev/sde1,/dev/sdf1"

You should not need the "devices=..." entry, but I would include the name
and the UUID.  Here are the relevant parts of my mdadm.conf:

# by default, scan all partitions (/proc/partitions) for MD superblocks.
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

ARRAY /dev/md0 level=raid6 metadata=1.2 num-devices=14
UUID=5ff10d73:a096195f:7a646bba:a68986ca name=RAID-Server:0

ARRAY /dev/md1 level=raid1 metadata=0.90 num-devices=2
UUID=f0a63cae:10406a7a:fa72b0ce:3d8e1057

ARRAY /dev/md2 level=raid1 metadata=1.2 num-devices=2
UUID=4b466602:fb81286c:4ad8dc5c:ad0bd065 name=RAID-Server:2

ARRAY /dev/md3 level=raid1 metadata=1.2 num-devices=2
UUID=5bc11cda:e1b4065f:fbf2fca5:8b12e0ba name=RAID-Server:3

> So I rebooted again, now the array was started as follows:
> 
> 	Personalities : [raid1] [raid6] [raid5] [raid4]
> 	md8 : inactive sda1[0](S)
> 	      1953512536 blocks super 1.2
> 
> I found out, that the assembly was aborted due to the error, that
> /dev/sda1 has no superblock. It seems, as if the kernel would start the
> array while booting the system, so mdadm is unable to assemble it
> afterwards. If I stop and re-assemble the array, it works fine.

	I had similar problems with a name conflict, but that doesn't seem
to be the case here.

> Unfortunately, I have to keep "CONFIG_MD_AUTODETECT" enabled, because /
> and the whole system runs on a RAID1. But why does the kernel start the
> array, although the used partition type of the disks in my RAID6 is NOT
> "linux raid autodetect"?

	Mdadm builds any arrays local to the system at boot.  Why do you
have grief with the kernel starting the array?

> I simply want to start my RAID6 as /dev/md8.
> 
> I use mdadm-3.1.4 and linux-2.6.36-gentoo-r8. The superblocks seem to be
> correct - "mdadm -E /dev/sd[a,b,c,d,e,f]1 | grep Name" returns
>            Name : Atlas:8  (local to host Atlas)
>            Name : Atlas:8  (local to host Atlas)
>            Name : Atlas:8  (local to host Atlas)
>            Name : Atlas:8  (local to host Atlas)
>            Name : Atlas:8  (local to host Atlas)
>            Name : Atlas:8  (local to host Atlas)
> If I get this right, this array should be started as /dev/md8. However,
> it does not. I have tried several combinations of configurations ("linux
> raid autodetect" without using mdadm for assembly, "linux" together with
> mdadm, and so on), but without any success.
> Any help would be really apprectiated.
> 
> Best regards,
> Yann
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

