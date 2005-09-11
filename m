From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm: which device set as source to mirror?
Date: Mon, 12 Sep 2005 09:39:59 +1000
Message-ID: <17188.49231.219902.105709@cse.unsw.edu.au>
References: <1126458858.6042.6.camel@r40>
	<17188.44497.481437.390441@cse.unsw.edu.au>
	<1126480029.5932.6.camel@r40>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Changsen Xu on Sunday September 11
Sender: linux-raid-owner@vger.kernel.org
To: Changsen Xu <xucs007@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday September 11, xucs007@yahoo.com wrote:
> Thanks for your quick response.
> 
> It won't matter if I want to use 2 blank partitions to build RAID1;
> 
> But now I wish to use mdadm to backup my /home partition, which
> already has tons of files on it;

You probably don't want to do that.  Normally a raid1 array created by
mdadm is slightly smaller than the original device, to allow room for
some metadata.  If you create a raid1 using a device with an existing
filesystem, you will probably corrupt that filesystem - though it may
be possible to 'resize' it a few hundred Kilobytes smaller first.

> 
> If mdadm happens to choose the other blank partition as source
> to do mirroring, all my data on /home will be lost;

If this really is something you want to do (e.g. you do shrink the
filesystem first, or you use --build to make an array without metadata
(not recommended unless you really know what you are doing)), then
the thing to do is create the array with only one active device, and
one 'missing' device.  Thus the data on the active device will have to
be the data using in the array.  Then you hot-add the drive that you
want data to be copied on to. 
When you hot-add a spare to an array, you can be certain that data
will be copied ONTO it, not OFF OF it.

However the recommended approach is to create a degraded array using
the new drive, make a filesystem there-on, copy the data, and once you
are sure the data is safe, add the original drive as a spare to the
new array. 
e.g. assuming sda1 has your /home and sdb1 is the same size:

  mdadm --create /dev/md1 --level=1 -n2 missing /dev/sdb1
  mkfs /dev/md1
  mount /dev/md1 /mnt
  cp -a /home /mnt
  # convince yourself that the copy was successful
  umount /mnt
  umount /home
  mount /dev/md1 /home
  # convince yourself again that /home is good
  mdadm /dev/md1 --add /dev/sda1

  # update /etc/fstab and /etc/mdadm.conf as required

> 
> Hardware RAID always allows me to choose which partition/drive
> to be used as source.

Probably because customers ask for it and hardware manufacturers think
it is good to give customers what they want.
I prefer to tell customers what they need :-)

NeilBrown
