From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: How to grow RAID1 mirror on top of LVM?
Date: Thu, 13 Mar 2008 11:21:22 +0000
Message-ID: <25F8EF57-9606-4217-B2D4-2DD3D8E064C4@cam.ac.uk>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

We have Software RAID1 (MD) mirrors on top of LVM volumes so that we  
can grow the LVM volumes if we need one of the mirrors to grow and  
then use mdadm --grow to grow the mirror followed by using xfs_growfs  
to grow the xfs file system mounted on the mirror.  Thus we can extend  
the size of the mirrored file system without having to unmount it  
which is great.  This is what should happen in an ideal world anyway.

In reality it does not work.  )-:  This is perhaps because mdadm does  
not realize the underlying devices have grown (using lvextend) and  
therefore running:

mdadm --grow /dev/md3 --size max

Does not do anything.

And if I do:

mdadm /dev/md3 --fail /dev/vg/volume2
mdadm /dev/md3 --remove /dev/vg/volume2
mdadm /dev/md3 --add --write-mostly /dev/vg/volume2

This fails because MD complains that no superblocks are found on the  
array or something like that.  )-:  Perhaps it has noticed that the  
devices are bigger and now cannot find the MD super block as it is no  
longer at the end of the device or something like that, not sure.

The only working way I have found to do what we want is to --fail & -- 
remove one device, then grow it with lvextend, then add it back to the  
mirror.  BUT this causes a full resync because it does not detect that  
the device was part of the mirror before and no resync is thus  
needed.  Again, I assume because the MD superblock is now in the  
middle of the volume instead of at the end.

I then have to wait for the resync to finish and then I have to remove  
the other mirrored device with --fail & --remove, then lvextend that,  
and then I can add it back to the mirror which AGAIN triggers a full  
resync as before.

I then have to wait for the resync to finish and then I finally can  
grow the mirror using:

mdadm --grow /dev/md3 --size max

And it works this time.

As a small shortcut, I can do the mdadm --grow after the first resync  
is complete (see above), after breaking the mirror for the second  
time, then the md3 device is grown with just one member device.  Then  
I add the extended other mirror target to the array with --add and  
that then does a full resync on the already grown mirror.

So to grow a raid mirror takes ages because of the resync times when  
you have large arrays!

Is there a better way to do this?  I am hoping someone will tell me to  
use option blah to utility foo that will do this for me without having  
to break the mirror twice and resync each time.  (-;

If not, please consider this a feature request for mdadm.  (-:  It  
should have an option to detect that the underlying device has grown  
and thus write a new superblock  (or move the old one or whatever) at  
the end of the newly grown device instead of complaining that it does  
not exist.  Or something!  As it is, it is incredibly time consuming  
and inefficient.  )-:

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

