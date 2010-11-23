From: Mike Viau <viaum@sheridanc.on.ca>
Subject: RE: How to recreate a dmraid RAID array with mdadm
Date: Tue, 23 Nov 2010 11:07:13 -0500
Message-ID: <BAY148-w292469B105A527BFD32AA0EF3E0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, debian-user@lists.debian.org
List-Id: linux-raid.ids


> OnTue, 23 Nov 2010 10:11:29 +1100 <neilb@suse.de> wrote:>
> I see the problem now. And John Robinson was nearly there.
>
> The problem is that after assembling the container /dev/md/imsm,
> mdadm needs to assemble the RAID1, but doesn't find the
> container /dev/md/imsm to assemble it from.
> That is because of the
> DEVICE partitions
> line.
> A container is not a partition - it does not appear in /proc/partitions.
> You need
>
> DEVICE partitions containers
>
> which is the default if you don't have a DEVICE line (and I didn't have a
> device line in my testing).
>
> I think all the "wrong uuid" messages were because the device was busy (and
> so it didn't read a uuid), probably because you didn't "mdadm -Ss" first.
>
> So just remove the "DEVICE partitions" line, or add " containers" to it, and
> all should be happy.
>
> NeilBrown
>

Yes thank you, that seems to be the correct fix.

mdadm -Asvv

mdadm: looking for devices for further assembly
mdadm: no RAID superblock on /dev/dm-3
mdadm: /dev/dm-3 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-2
mdadm: /dev/dm-2 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-1
mdadm: /dev/dm-1 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-0
mdadm: /dev/dm-0 has wrong uuid.
mdadm: no RAID superblock on /dev/loop0
mdadm: /dev/loop0 has wrong uuid.
mdadm: cannot open device /dev/sdc7: Device or resource busy
mdadm: /dev/sdc7 has wrong uuid.
mdadm: cannot open device /dev/sdc6: Device or resource busy
mdadm: /dev/sdc6 has wrong uuid.
mdadm: cannot open device /dev/sdc5: Device or resource busy
mdadm: /dev/sdc5 has wrong uuid.
mdadm: no RAID superblock on /dev/sdc2
mdadm: /dev/sdc2 has wrong uuid.
mdadm: cannot open device /dev/sdc1: Device or resource busy
mdadm: /dev/sdc1 has wrong uuid.
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: /dev/sdc has wrong uuid.
mdadm: /dev/sdb is identified as a member of /dev/md/imsm0, slot -1.
mdadm: /dev/sda is identified as a member of /dev/md/imsm0, slot -1.
mdadm: added /dev/sda to /dev/md/imsm0 as -1
mdadm: added /dev/sdb to /dev/md/imsm0 as -1
mdadm: Container /dev/md/imsm0 has been assembled with 2 drives
mdadm: looking for devices for /dev/md/OneTB-RAID1-PV
mdadm: no recogniseable superblock on /dev/dm-3
mdadm/dev/dm-3 is not a container, and one is required.
mdadm: no recogniseable superblock on /dev/dm-2
mdadm/dev/dm-2 is not a container, and one is required.
mdadm: no recogniseable superblock on /dev/dm-1
mdadm/dev/dm-1 is not a container, and one is required.
mdadm: no recogniseable superblock on /dev/dm-0
mdadm/dev/dm-0 is not a container, and one is required.
mdadm: no recogniseable superblock on /dev/loop0
mdadm/dev/loop0 is not a container, and one is required.
mdadm: cannot open device /dev/sdc7: Device or resource busy
mdadm/dev/sdc7 is not a container, and one is required.
mdadm: cannot open device /dev/sdc6: Device or resource busy
mdadm/dev/sdc6 is not a container, and one is required.
mdadm: cannot open device /dev/sdc5: Device or resource busy
mdadm/dev/sdc5 is not a container, and one is required.
mdadm: no recogniseable superblock on /dev/sdc2
mdadm/dev/sdc2 is not a container, and one is required.
mdadm: cannot open device /dev/sdc1: Device or resource busy
mdadm/dev/sdc1 is not a container, and one is required.
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm/dev/sdc is not a container, and one is required.
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm/dev/sdb is not a container, and one is required.
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm/dev/sda is not a container, and one is required.
mdadm: looking in container /dev/md127
mdadm: found match on member /md127/0 in /dev/md127
mdadm: Started /dev/md/OneTB-RAID1-PV with 2 devices   <-- The line I was looking for


ls -al /dev/md/

total 0
drwxr-xr-x  2 root root   80 Nov 23 09:47 .
drwxr-xr-x 21 root root 3480 Nov 23 09:47 ..
lrwxrwxrwx  1 root root    8 Nov 23 09:47 imsm0 -> ../md127
lrwxrwxrwx  1 root root    8 Nov 23 09:47 OneTB-RAID1-PV -> ../md126


I filed a bug[1] as I was just going along with default configurations, to see what is said about it.

Thanks soo much for your help Neil :)

[1] - http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=604702
 		 	   		  