From: "Daniel Korstad" <dan@korstad.net>
Subject: FW: [slightly OT] expanding lvm volume group after growing raid5 array
Date: Thu, 19 Apr 2007 10:21:27 -0500
Message-ID: <1391903588.1176996087946.JavaMail.root@gateway.korstad.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have used lv with my past raid sets and it is very nice, adds some flexibility.  

I have also done a RAID5 reshape that was in an lv.  Unfortunately, at the time I had an older LVM version that did not support pvresize.  So I was stuck with a larger RAID set and my lv would not take advantage of it.

I think I needed LVM version 2.02.06 to solve that and get the pvresize feature. If you are running a relatively new disto that won't be an issue any more.  I think I had FC3 or 4.
 
To get the extra space over to your filesystem, there are a couple steps in between that you need to do with the LVs.

You need to pvresize the physical volume, than the volume group will have a larger capacity than resize/reallocate the new capacity to the logical volume, than you can resize your file system inside the logical volume.


----- Inline Message Follows -----
To: linux-raid@vger.kernel.org
From: Gavin McCullagh
Subject: [slightly OT] expanding lvm volume group after growing raid5 array


Hi Folks,

I recently upgraded all four disks of a RAID5 array and then used "mdadm
--grow" to grow the raid array into the new bigger partitions available to
it and ran resize2fs.  Lovely.  

However, I've just tried this again on a similar machine and have grown the
array.  However, I've just noticed that the RAID5 array has an lvm volume
group on it with two logical volumes on that.  So now, I'd like to grow the
volume group so I can grow one of the logical volumes and grow the
filesystem therein.

I realise this is the raid group but has anyone come across how to do this?

Gavin

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
