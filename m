From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: root filesystem copy ro raid
Date: Mon, 17 Feb 2003 07:47:09 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D636@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Lewis Shobbrook' <lshobbrook@fasttrack.net.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lewis,

Here's what I use for that.

Andy

   # Script 8 to copy Linux files to mounted tree
   todir=/mnt/b
   notf=/tmp/dirnot.tmp
   cat - <<%%% >$notf
tmp
proc
mnt
boot
lost+found
%%%
   dirs=`ls / |grep -vf $notf`
   cd /
   # Copy each directory in the list
   # could use "find . -print | cpio -pdumv" if grep -v extra stuff. 
   for d in $dirs
   do
       echo "Copying $d to $todir/$d..."
       cp -a $d $todir
   done
   # Do /tmp, /proc, /mnt, and /boot specially
   echo "Creating $todir/tmp, mnt, proc..."
   mkdir -p $todir/tmp  
   chmod 777 $todir/tmp
   chmod +t $todir/tmp
   mkdir -p $todir/proc
   # makes /mnt directories like cdrom and floppy
   for i in `ls -l /mnt |grep "^dr" |cut -c57-80`
   do
       mkdir -p $todir/mnt/$i
   done
   echo "Copying boot to $todir/boot..."
   cp -f /boot/* $todir/boot 2>/dev/null
   # This will usually give an "omitting lost+found" stderr message.   
   # end script 8


-----Original Message-----
From: Lewis Shobbrook [mailto:lshobbrook@fasttrack.net.au] 
Sent: Monday, February 17, 2003 12:39 AM
To: linux-raid@vger.kernel.org
Subject: root filesystem copy ro raid


I'm surprised to find such little info on copying an existing filesystem
onto a new raid partition.  
The howto's use cp -a or pipe to cpio -pm .
I've tried both methods, but here we have the problem of symbolic links
and hardlinks not being copied, which when you have an elaborate system
that you'd like to migrate across to raid, doesn't cut the mustard. 
Has anyone tried or succeeded with any alternate methods?  Are there any
utilities such as parted to copy the whole lot.  
I'm not sure how apps such as parted work, but as /dev/mdX is formatted
with mke2fs, as is most root filesystem, I'd like to hope that with a
raid aware kernel and the root filesystem unmounted it could be copied
directly eg.  /dev/hda1 => /dev/mdX.

Apologies if this topic has been visited before, I couldn't find any
reference to it in the archives...


Lewis

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
