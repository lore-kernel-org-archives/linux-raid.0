From: Mike Accetta <maccetta-bounce@laurelnetworks.com>
Subject: Partitioned arrays initially missing from /proc/partitions
Date: Fri, 01 Dec 2006 15:53:13 -0500
Message-ID: <45709639.70104@laurelnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In setting up a partitioned array as the boot disk and using a nash 
initrd to find the root file system by volume label, I see a delay in 
the appearance of the /dev/md_d0p partitions in /proc/partitions.  When 
the mdadm --assemble command completes, only /dev/md_d0 is visible. 
Since the raid partitions are not visible after the assemble, the volume 
label search will not consult them in looking for the root volume and 
the boot gets aborted. When I run a similar assemble command while up 
multi-user in a friendlier debug environment I see the same effect and 
observe that pretty much any access of /dev/md_d0 has the side effect of 
then making the /dev/md_d0p partitions visible in /proc/partitions.

I tried a few experiments changing the --assemble code in mdadm.  If I 
open() and close() /dev/md_d0 after assembly *before* closing the file 
descriptor which the assemble step used to assemble the array, there is 
no effect.  Even doing a BLKRRPART ioctl call on the assembly fd or the 
newly opened fd have no effect.  The kernel prints "unknown partition" 
diagnostics on the console.  However, if the assembly fd is first 
close()'d, a simple open() of /dev/md_d0 and immediate close() of that 
fd has the side effect of making the /dev/md_d0p partitions visible and 
one sees the console disk partitioning confirmation from the kernel as well.

Adding the open()/close() after assembly within mdadm solves my problem, 
but I thought I'd raise the issue on the list as it seems there is a bug 
somewhere.  I see in the kernel md driver that the RUN_ARRAY ioctl() 
calls do_md_run() which calls md_probe() which calls add_disk() and I 
gather that this would normally have the side effect of making the 
partitions visible.  However, my experiments at user level seem to imply 
that the array isn't completely usable until the assembly file 
descriptor is closed, even on return from the ioctl(), and hence the 
kernel add_disk() isn't having the desired partitioning side effect at 
the point it is being invoked.

This is all with kernel 2.6.18 and mdadm 2.3.1
-- 
Mike Accetta

ECI Telecom Ltd.
Data Networking Division (previously Laurel Networks)
