From: Michael Muratet <muratetm@gmail.com>
Subject: Re: Add disks and convert level 0 to level 5
Date: Wed, 17 Sep 2014 09:59:00 -0500
Message-ID: <535A7DC1-0953-41D6-B149-DB038D1631D2@gmail.com>
References: <loom.20140831T143354-68@post.gmane.org> <20140901083137.4772c8c5@notabene.brown> <8CF94689-0AD6-4B87-BC0C-815F794549E7@gmail.com> <20140911102719.053a5d5c@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140911102719.053a5d5c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Sep 10, 2014, at 7:27 PM, NeilBrown wrote:

> On Wed, 10 Sep 2014 11:15:24 -0500 Michael Muratet <muratetm@gmail.com> wrote:
> 
>> I have a two-disk RAID0 system that is working splendidly, thanks to the list for the help.
>> 
>> I managed to get my hands on more identical disks and since I have the disks and because I'm adding precious data, I'd like to add two more disks and grow to RAID5.
>> 
>> I have partitioned the two new drives to type 'fd', /dev/sde and /dev/sdf
>> 
>> I believe the command to accomplish the change is this:
>> 
>> mdadm /dev/md0 --grow --level=5 --add /dev/sde /dev/sdf
>> 
>> Following the old adage "measure twice, cut once", is this syntax correct? Is there any danger of data loss in such a conversion?
> 
> I recommend creating a few loop-back devices and experimenting.
> i.e.:
>  create some 100M files.
>  use "losetup" to turn them into block devices.
>  create an 2-device raid0
>  try converting it as you suggest.
> 
> You find it doesn't do quite what you expected, but should be easy to fix.

In case anyone wants to do a similar thing...

As predicted, it did not do as I expected. I have another identical server and disks and so I did the experiment there.

  980  sudo fdisk /dev/sdc
  981  sudo fdisk /dev/sdd
  982  sudo fdisk /dev/sde
  983  sudo fdisk /dev/sdf
  988  sudo partprobe /dev/sdc
  989  sudo partprobe /dev/sdd
  990  sudo partprobe /dev/sde
  991  sudo partprobe /dev/sdf
  995  sudo mdadm --create /dev/md0 --level=0 --raid-disk=2 /dev/sdc1 /dev/sdd1
  996  sudo mkfs -t ext3 /dev/md0
  997  sudo mount -t ext3 /dev/md0 /db

Same RAID0 system I created before. Now to grow

 1004  sudo mdadm /dev/md0 --grow --level=5 --add /dev/sde1 /dev/sdf1

Makes a RAID5 system, but sde1 was added as a spare

 1022  sudo mdadm --grow /dev/md0 --raid-devices=4

It's now a four disk RAID, but smaller than expected. It spread the original space over four drives, which I think is the documented behavior.

 1040  sudo umount /dev/md0
 1045  sudo e2fsck -f /dev/md0
 1046  sudo resize2fs -p /dev/md0
 1048  sudo mount -t ext3 /dev/md0 /db
 1049  df -h

/dev/md0                      2.7T  202M  2.6T   1% /db

which is what I wanted. I can't take my original system offline now, but when I can I will apply the same steps.

Thanks for the help

Cheers

Mike
> 
> Providing your new devices are reliable (as least read/write the entire drive
> once if you feel at all cautious) there is no particular danger of data loss.
> 
> NeilBrown
> 
> 
>> 
>> Thanks
>> 
>> Mike--
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

