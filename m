From: Luciano Chavez <lnx1138@us.ibm.com>
Subject: Re: Oops when starting md multipath on a 2.4 kernel
Date: Thu, 14 Jul 2005 11:20:43 -0500
Message-ID: <1121358044.7843.11.camel@localhost>
References: <42D546AB.6060101@moving-picture.com>
	 <42D5FCA4.10104@us.ibm.com>  <42D639DC.80608@moving-picture.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-HFLw+4FAqqpSxYl4X+ge"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42D639DC.80608@moving-picture.com>
Sender: linux-raid-owner@vger.kernel.org
To: James Pearson <james-p@moving-picture.com>
Cc: marcelo.tosatti@cyclades.com, Mike Tran <mhtran@us.ibm.com>, lmb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-HFLw+4FAqqpSxYl4X+ge
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

On Thu, 2005-07-14 at 11:09 +0100, James Pearson wrote:
> Mike Tran wrote:
> > James Pearson wrote:
> > 
> >> We have an existing system runing a 2.4.27 based kernel that uses md 
> >> multipath and external fibre channel arrays.
> >>
> >> We need to add more internal disks to the system, which means the 
> >> external drives change device names.
> >>
> >> When I tried to start the md multipath device using mdadm, the kernel 
> >> Oops'd. Removing the new internal disks and going back the original 
> >> setup, I can start the multipath device - as this machine is in 
> >> production, I can't do any more tests.
> >>
> >> However, I can reproduce the problem on test system by creating an md 
> >> multipath device on an external SCSI disk, using /dev/sda1, stopping 
> >> the multipath device, rmmod'ing the SCSI driver, pluging in a couple 
> >> of USB storage devices which become /dev/sda and /dev/sdb and then 
> >> modprobing the SCSI driver, so the original /dev/sda1 is now /dev/sdc1.
> >>
> >> When I run 'mdadm -A -s', I get the following Oops:
> >>
> >>  [events: 00000004]
> >> md: bind<sdc1,1>
> >> md: sdc1's event counter: 00000004
> >> md0: former device sda1 is unavailable, removing from array!
> >> md: unbind<sdc1,0>
> >> md: export_rdev(sdc1)
> >> md: RAID level -4 does not need chunksize! Continuing anyway.
> >> md: multipath personality registered as nr 7
> >> md0: max total readahead window set to 124k
> >> md0: 1 data-disks, max readahead per data-disk: 124k
> >> Unable to handle kernel NULL pointer dereference at virtual address 
> >> 00000040
> >>  printing eip:
> >> e096527e
> >> *pde = 00000000
> >> Oops: 0000
> >> CPU:    0
> >> EIP:    0010:[<e096527e>]    Not tainted
> >> EFLAGS: 00010246
> >> eax: deb62a94   ebx: 00000000   ecx: dd65b400   edx: 00000000
> >> esi: 0000001c   edi: deb62a94   ebp: 00000000   esp: dd5fbdbc
> >> ds: 0018   es: 0018   ss: 0018
> >> Process mdadm (pid: 1389, stackpage=dd5fb000)
> >> Stack: dd4c4000 dfa96000 c035ad00 00000000 00000286 dd4c4000 00000000 
> >> 00000000
> >>        deb62a94 dd5fbe5c dd4c6000 c02a6e10 dd65b400 c035ef1f 0000007c 
> >> 00000000
> >>        0000000a ffffffff 00000002 00002e2e c0118b49 00002e2e 00002e2e 
> >> 00000286
> >> Call Trace:    [<c02a6e10>] [<c0118b49>] [<c0118cc4>] [<c024a88c>] 
> >> [<c024abb6>]
> >>   [<c0118cc4>] [<c024907e>] [<c024b6f2>] [<c024c60c>] [<c014a326>] 
> >> [<c013c483>]
> >>   [<c013ca18>] [<c01375ac>] [<c013ca63>] [<c01439b6>] [<c01087c7>]
> >>
> >> Code: 8b 45 40 85 c0 0f 84 c2 01 00 00 6a 00 ff b4 24 cc 00 00 00
> >>
> >> Running through ksymoops gives:
> >>
> >> Unable to handle kernel NULL pointer dereference at virtual address 
> >> 00000040
> >> e096527e
> >> *pde = 00000000
> >> Oops: 0000
> >> CPU:    0
> >> EIP:    0010:[<e096527e>]    Not tainted
> >> Using defaults from ksymoops -t elf32-i386 -a i386
> >> EFLAGS: 00010246
> >> eax: deb62a94   ebx: 00000000   ecx: dd65b400   edx: 00000000
> >> esi: 0000001c   edi: deb62a94   ebp: 00000000   esp: dd5fbdbc
> >> ds: 0018   es: 0018   ss: 0018
> >> Process mdadm (pid: 1389, stackpage=dd5fb000)
> >> Stack: dd4c4000 dfa96000 c035ad00 00000000 00000286 dd4c4000 00000000 
> >> 00000000
> >>        deb62a94 dd5fbe5c dd4c6000 c02a6e10 dd65b400 c035ef1f 0000007c 
> >> 00000000
> >>        0000000a ffffffff 00000002 00002e2e c0118b49 00002e2e 00002e2e 
> >> 00000286
> >> Call Trace:    [<c02a6e10>] [<c0118b49>] [<c0118cc4>] [<c024a88c>] 
> >> [<c024abb6>]
> >>   [<c0118cc4>] [<c024907e>] [<c024b6f2>] [<c024c60c>] [<c014a326>] 
> >> [<c013c483>]
> >>   [<c013ca18>] [<c01375ac>] [<c013ca63>] [<c01439b6>] [<c01087c7>]
> >> Code: 8b 45 40 85 c0 0f 84 c2 01 00 00 6a 00 ff b4 24 cc 00 00 00
> >>
> >> >>EIP; e096527e <[multipath]multipath_run+2be/6c0>   <=====
> >> Trace; c02a6e10 <vsnprintf+2e0/450>
> >> Trace; c0118b49 <call_console_drivers+e9/f0>
> >> Trace; c0118cc4 <printk+104/110>
> >> Trace; c024a88c <device_size_calculation+19c/1f0>
> >> Trace; c024abb6 <do_md_run+2d6/360>
> >> Trace; c0118cc4 <printk+104/110>
> >> Trace; c024907e <bind_rdev_to_array+9e/b0>
> >> Trace; c024b6f2 <add_new_disk+132/290>
> >> Trace; c024c60c <md_ioctl+6fc/790>
> >> Trace; c014a326 <iput+236/240>
> >> Trace; c013c483 <bdput+93/a0>
> >> Trace; c013ca18 <blkdev_put+98/a0>
> >> Trace; c01375ac <fput+bc/e0>
> >> Trace; c013ca63 <blkdev_ioctl+23/30>
> >> Trace; c01439b6 <sys_ioctl+216/230>
> >> Trace; c01087c7 <system_call+33/38>
> >> Code;  e096527e <[multipath]multipath_run+2be/6c0>
> >> 00000000 <_EIP>:
> >> Code;  e096527e <[multipath]multipath_run+2be/6c0>   <=====
> >>    0:   8b 45 40                  mov    0x40(%ebp),%eax   <=====
> >> Code;  e0965281 <[multipath]multipath_run+2c1/6c0>
> >>    3:   85 c0                     test   %eax,%eax
> >> Code;  e0965283 <[multipath]multipath_run+2c3/6c0>
> >>    5:   0f 84 c2 01 00 00         je     1cd <_EIP+0x1cd> e096544b 
> >> <[multipath]m
> >> ultipath_run+48b/6c0>
> >> Code;  e0965289 <[multipath]multipath_run+2c9/6c0>
> >>    b:   6a 00                     push   $0x0
> >> Code;  e096528b <[multipath]multipath_run+2cb/6c0>
> >>    d:   ff b4 24 cc 00 00 00      pushl  0xcc(%esp,1)
> >>
> >> My /etc/mdadm.conf contains:
> >>
> >> DEVICE /dev/sd?1
> >> ARRAY /dev/md0 level=multipath num-devices=1
> >>   UUID=277e4ba5:6c23c087:e17c877c:da642955
> >>
> >>
> >> Should md multipath be able to handle changes like this with the 
> >> underlying devices?
> >>
> >>
> >> Thanks
> >>
> >> James Pearson
> >>
> > Hi James,
> > 
> > My co-worker and I just happened to run into this problem a few days 
> > ago. So, I would like to share with you what we know.
> > 
> > The device major/minor numbers no longer match up values recorded in the 
> > descriptor array in the md superblock. Because of the exception made in 
> > the current code, the descriptor entries are removed and although the 
> > real devices are present and accounted for, they are kicked out from the 
> > array. This leaves the array with zero devices. When multipath_run() is 
> > invoked, it blows up expecting to have had some disks.
> > 
> > Lars Marowsky-Brée suggested some patches for md multipath in 2002 but 
> > never made it to mainline 2.4 kernel:
> > http://marc.theaimsgroup.com/?l=linux-kernel&m=103355467608953&w=2
> > 
> > That patch is large and most of it is not requried for this particular 
> > problem.  The section that reinitializes the descriptor array from 
> > current rdevs for the case of multipath will resolve this issue of 
> > device names shift.
> > 
> > Lars, Is it ok with you if I compose a patch from your original patch 
> > and post it here?
> 
> Thanks - that patch applies OK to more recent 2.4 kernels and appears to 
> 'fix' this problem.
> 
> However, if you have a cut down patch that fixes just this problem, then 
> I would appreciate it if you could make it available.
> 
> Thanks
> 
> James Pearson
> 

James,

Here is the reduced patch from the patch that Lars originally produced
that worked for us for that particular problem with the multipath disks
major/minor numbers shifting. Hopefully, Marcelo can review it and
consider it for inclusion in 2.4 mainline. Let us know if this works for
you. The credit, of couse, should still go to Lars. We simply picked out
the part that fixes that particular issue.

regards,
-- 
Luciano Chavez <lnx1138@us.ibm.com>
IBM

--=-HFLw+4FAqqpSxYl4X+ge
Content-Disposition: attachment; filename=mdmultipath-nofaulty-disks.patch
Content-Type: text/x-patch; name=mdmultipath-nofaulty-disks.patch; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

diff -urN kernel-2.4.21.old/drivers/md/md.c kernel-2.4.21/drivers/md/md.c
--- kernel-2.4.21.old/drivers/md/md.c	2005-07-13 10:08:40.000000000 -0500
+++ kernel-2.4.21/drivers/md/md.c	2005-07-14 10:23:28.000000000 -0500
@@ -1320,148 +1320,164 @@
 	memcpy (sb, freshest->sb, sizeof(*sb));
 
 	/*
-	 * at this point we have picked the 'best' superblock
-	 * from all available superblocks.
-	 * now we validate this superblock and kick out possibly
-	 * failed disks.
+	 * For multipathing, lots of things are different from "true"
+	 * RAIDs.
+	 * All rdev's could be read, so they are no longer faulty.
+	 * As there is just one sb, trying to find changed devices via the
+	 * this_disk pointer is useless too.
+	 *
+	 * lmb@suse.de, 2002-09-12
 	 */
-	ITERATE_RDEV(mddev,rdev,tmp) {
-		/*
-		 * Kick all non-fresh devices
-		 */
-		__u64 ev1, ev2;
-		ev1 = md_event(rdev->sb);
-		ev2 = md_event(sb);
-		++ev1;
-		if (ev1 < ev2) {
-			printk(KERN_WARNING "md: kicking non-fresh %s from array!\n",
-						partition_name(rdev->dev));
-			kick_rdev_from_array(rdev);
-			continue;
-		}
-	}
 
-	/*
-	 * Fix up changed device names ... but only if this disk has a
-	 * recent update time. Use faulty checksum ones too.
-	 */
-	if (mddev->sb->level != -4)
-	ITERATE_RDEV(mddev,rdev,tmp) {
-		__u64 ev1, ev2, ev3;
-		if (rdev->faulty || rdev->alias_device) {
-			MD_BUG();
-			goto abort;
-		}
-		ev1 = md_event(rdev->sb);
-		ev2 = md_event(sb);
-		ev3 = ev2;
-		--ev3;
-		if ((rdev->dev != rdev->old_dev) &&
-			((ev1 == ev2) || (ev1 == ev3))) {
+	if (sb->level == -4) {
+		int desc_nr = 0;
+
+		/* ... and initialize from the current rdevs instead */
+		ITERATE_RDEV(mddev,rdev,tmp) {
 			mdp_disk_t *desc;
 
-			printk(KERN_WARNING "md: device name has changed from %s to %s since last import!\n",
-			       partition_name(rdev->old_dev), partition_name(rdev->dev));
-			if (rdev->desc_nr == -1) {
-				MD_BUG();
-				goto abort;
-			}
+			rdev->desc_nr=desc_nr;
+
 			desc = &sb->disks[rdev->desc_nr];
-			if (rdev->old_dev != MKDEV(desc->major, desc->minor)) {
-				MD_BUG();
-				goto abort;
-			}
-			desc->major = MAJOR(rdev->dev);
-			desc->minor = MINOR(rdev->dev);
-			desc = &rdev->sb->this_disk;
+
+			desc->number = desc_nr;
 			desc->major = MAJOR(rdev->dev);
 			desc->minor = MINOR(rdev->dev);
-		}
-	}
+			desc->raid_disk = desc_nr;
 
-	/*
-	 * Remove unavailable and faulty devices ...
-	 *
-	 * note that if an array becomes completely unrunnable due to
-	 * missing devices, we do not write the superblock back, so the
-	 * administrator has a chance to fix things up. The removal thus
-	 * only happens if it's nonfatal to the contents of the array.
-	 */
-	for (i = 0; i < MD_SB_DISKS; i++) {
-		int found;
-		mdp_disk_t *desc;
-		kdev_t dev;
+			/* We could read from it, so it isn't faulty
+			 * any longer */
+			if (disk_faulty(desc))
+				mark_disk_spare(desc);
 
-		desc = sb->disks + i;
-		dev = MKDEV(desc->major, desc->minor);
+			memcpy(&rdev->sb->this_disk,desc,sizeof(*desc));
+
+			desc_nr++;
+		}
 
+		/* Kick out all old info about disks we used to have,
+		 * if any */
+		for (i = desc_nr; i < MD_SB_DISKS; i++)
+			memset(&(sb->disks[i]),0,sizeof(mdp_disk_t));
+	} else {
 		/*
-		 * We kick faulty devices/descriptors immediately.
-		 *
-		 * Note: multipath devices are a special case.  Since we
-		 * were able to read the superblock on the path, we don't
-		 * care if it was previously marked as faulty, it's up now
-		 * so enable it.
+		 * at this point we have picked the 'best' superblock
+		 * from all available superblocks.
+		 * now we validate this superblock and kick out possibly
+		 * failed disks.
 		 */
-		if (disk_faulty(desc) && mddev->sb->level != -4) {
-			found = 0;
-			ITERATE_RDEV(mddev,rdev,tmp) {
-				if (rdev->desc_nr != desc->number)
-					continue;
-				printk(KERN_WARNING "md%d: kicking faulty %s!\n",
-					mdidx(mddev),partition_name(rdev->dev));
-				kick_rdev_from_array(rdev);
-				found = 1;
-				break;
-			}
-			if (!found) {
-				if (dev == MKDEV(0,0))
-					continue;
-				printk(KERN_WARNING "md%d: removing former faulty %s!\n",
-					mdidx(mddev), partition_name(dev));
-			}
-			remove_descriptor(desc, sb);
-			continue;
-		} else if (disk_faulty(desc)) {
+		ITERATE_RDEV(mddev,rdev,tmp) {
 			/*
-			 * multipath entry marked as faulty, unfaulty it
+			 * Kick all non-fresh devices
 			 */
-			rdev = find_rdev(mddev, dev);
-			if(rdev)
-				mark_disk_spare(desc);
-			else
-				remove_descriptor(desc, sb);
+			__u64 ev1, ev2;
+			ev1 = md_event(rdev->sb);
+			ev2 = md_event(sb);
+			++ev1;
+			if (ev1 < ev2) {
+				printk(KERN_WARNING "md: kicking non-fresh %s from array!\n",
+							partition_name(rdev->dev));
+				kick_rdev_from_array(rdev);
+				continue;
+			}
 		}
 
-		if (dev == MKDEV(0,0))
-			continue;
 		/*
-		 * Is this device present in the rdev ring?
+		 * Fix up changed device names ... but only if this disk has a
+		 * recent update time. Use faulty checksum ones too.
 		 */
-		found = 0;
 		ITERATE_RDEV(mddev,rdev,tmp) {
+			__u64 ev1, ev2, ev3;
+			if (rdev->faulty || rdev->alias_device) {
+				MD_BUG();
+				goto abort;
+			}
+			ev1 = md_event(rdev->sb);
+			ev2 = md_event(sb);
+			ev3 = ev2;
+			--ev3;
+			if ((rdev->dev != rdev->old_dev) &&
+				((ev1 == ev2) || (ev1 == ev3))) {
+				mdp_disk_t *desc;
+
+				printk(KERN_WARNING "md: device name has changed from %s to %s since last import!\n",
+				       partition_name(rdev->old_dev), partition_name(rdev->dev));
+				if (rdev->desc_nr == -1) {
+					MD_BUG();
+					goto abort;
+				}
+				desc = &sb->disks[rdev->desc_nr];
+				if (rdev->old_dev != MKDEV(desc->major, desc->minor)) {
+					MD_BUG();
+					goto abort;
+				}
+				desc->major = MAJOR(rdev->dev);
+				desc->minor = MINOR(rdev->dev);
+				desc = &rdev->sb->this_disk;
+				desc->major = MAJOR(rdev->dev);
+				desc->minor = MINOR(rdev->dev);
+			}
+		}
+
+		/*
+		 * Remove unavailable and faulty devices ...
+		 *
+		 * note that if an array becomes completely unrunnable due to
+		 * missing devices, we do not write the superblock back, so the
+		 * administrator has a chance to fix things up. The removal thus
+		 * only happens if it's nonfatal to the contents of the array.
+		 */
+		for (i = 0; i < MD_SB_DISKS; i++) {
+			int found;
+			mdp_disk_t *desc;
+			kdev_t dev;
+
+			desc = sb->disks + i;
+			dev = MKDEV(desc->major, desc->minor);
+
 			/*
-			 * Multi-path IO special-case: since we have no
-			 * this_disk descriptor at auto-detect time,
-			 * we cannot check rdev->number.
-			 * We can check the device though.
+			 * We kick faulty devices/descriptors immediately.
 			 */
-			if ((sb->level == -4) && (rdev->dev ==
-					MKDEV(desc->major,desc->minor))) {
-				found = 1;
-				break;
+			if (disk_faulty(desc)) {
+				found = 0;
+				ITERATE_RDEV(mddev,rdev,tmp) {
+					if (rdev->desc_nr != desc->number)
+						continue;
+					printk(KERN_WARNING "md%d: kicking faulty %s!\n",
+						mdidx(mddev),partition_name(rdev->dev));
+					kick_rdev_from_array(rdev);
+					found = 1;
+					break;
+				}
+				if (!found) {
+					if (dev == MKDEV(0,0))
+						continue;
+					printk(KERN_WARNING "md%d: removing former faulty %s!\n",
+						mdidx(mddev), partition_name(dev));
+				}
+				remove_descriptor(desc, sb);
+				continue;
 			}
-			if (rdev->desc_nr == desc->number) {
-				found = 1;
-				break;
+
+			if (dev == MKDEV(0,0))
+				continue;
+			/*
+			 * Is this device present in the rdev ring?
+			 */
+			found = 0;
+			ITERATE_RDEV(mddev,rdev,tmp) {
+				if (rdev->desc_nr == desc->number) {
+					found = 1;
+					break;
+				}
 			}
-		}
-		if (found)
-			continue;
+			if (found)
+				continue;
 
-		printk(KERN_WARNING "md%d: former device %s is unavailable, removing from array!\n",
-		       mdidx(mddev), partition_name(dev));
-		remove_descriptor(desc, sb);
+			printk(KERN_WARNING "md%d: former device %s is unavailable, removing from array!\n",
+			       mdidx(mddev), partition_name(dev));
+			remove_descriptor(desc, sb);
+		}
 	}
 
 	/*

--=-HFLw+4FAqqpSxYl4X+ge--

