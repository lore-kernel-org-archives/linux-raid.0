From: Gavin McCullagh <gmccullagh@gmail.com>
Subject: [slightly OT] expanding lvm volume group after growing raid5 array
Date: Thu, 19 Apr 2007 12:35:21 +0100
Message-ID: <20070419113521.GF23564@gmail.com>
Reply-To: Gavin McCullagh <gmccullagh@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

