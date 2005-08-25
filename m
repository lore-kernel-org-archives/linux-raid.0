From: Tyler <pml@dtbb.net>
Subject: Re: raid1 boot issues
Date: Thu, 25 Aug 2005 02:14:49 -0700
Message-ID: <430D8C09.9000602@dtbb.net>
References: <200508251903.47194.mylists@blue-matrix.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200508251903.47194.mylists@blue-matrix.org>
Sender: linux-raid-owner@vger.kernel.org
To: Lewis Shobbrook <mylists@blue-matrix.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Fdisk it and set partitions to Raid Autodetect (0xfd) possibly?

Tyler.

Lewis Shobbrook wrote:

>Hi All,
>I have a problem attempting to boot a raid 1 system from lilo.  I have 
>succeeded at this many times in the past, but am completely stumped as to 
>what the issue is in this instance. I have the boot and root partitions 
>seperate on /dev/md0 & /dev/md1 respectively, both raid1.  
>The mdadm examination  for  the components is clean and the superblocks appear 
>as they ought.  I'm using Debian unstable with std. apt kernel-image.  The 
>correct modules are in place for the initrd.
>The boot partition fails to mount during  the boot process...
>fsck.ext3: invalid argument while trying to open /dev/md0
>The superblock can not be read or does not describe a correct ext2 
>filesystem.... omitted usual stuff...
>Root password for maintenance or Control-D to continue...
>
>The bizarre thing is that it appears perfectly clean, I've re-zero'd the 
>superblocks and completely recreated the device, but the result is always the 
>same.  
>mdrun loads /dev/md0 in a clean state straight away and it mounts 
>cleanly.  /dev/md1 is no problem. 
>mdadm -E of the components is clean, as is mdadm -d for the device.
>My fstab & mtab are the same as systems running the same kernel that work 
>fine.
>
>I found the system laying around from about 12 months ago which had originally 
>been set-up using raidtools.  I upgraded the system using dist-upgrade 
>installed mdadm; after zeroing all superblocks for both drives and component 
>partitions, I created the devices with the following ...
>
>mdadm -C /dev/md0 -l1 -n2 /dev/hda1 missing
>reformatted ext3 and restored the files before adding the missing devices and 
>resyncing.  
>I'm stumped!
>Anyone got any ideas?
>
>Cheers,
>
>Lewis
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>


-- 
No virus found in this outgoing message.
Checked by AVG Anti-Virus.
Version: 7.0.344 / Virus Database: 267.10.15/80 - Release Date: 8/23/2005

